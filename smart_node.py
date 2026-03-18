#!/usr/bin/env python3
"""
PYNQ OUTPUT NODE
Thanus — Physical Response Layer

Pipeline: Archit (FPGA) → Shashank (Face Rec) → Marcus (AWS) → YOU ARE HERE

Marcus calls ONE function:
    handle_recognition_result("granted")
    handle_recognition_result("denied")
    handle_recognition_result("pending")   ← optional, fires while processing

Valid levels: granted, denied, pending, alarm, lockdown
"""

import time
import threading
import datetime
from collections import deque
from pathlib import Path

# =============================================================================
# PYNQ HARDWARE
# =============================================================================

try:
    from pynq.overlays.base import BaseOverlay
    from IPython.display import display
    import ipywidgets as widgets
    PYNQ_AVAILABLE = True

    print("[PYNQ] Loading base overlay...")
    base          = BaseOverlay("base.bit")
    rgb_led       = base.rgbleds[4]   # RGB LED on PYNQ-Z2
    buttons       = base.buttons      # BTN0-BTN3
    led_heartbeat = base.leds[3]      # blinks to show system alive
    print("[PYNQ] Hardware ready")

except ImportError:
    print("[WARNING] Simulation mode — no PYNQ hardware detected")
    PYNQ_AVAILABLE = False
    base = rgb_led = buttons = led_heartbeat = None

# =============================================================================
# SERIAL (Arduino)
# =============================================================================

try:
    import serial
    SERIAL_AVAILABLE = True
except ImportError:
    SERIAL_AVAILABLE = False
    print("[WARNING] pyserial missing — run: pip install pyserial")

# =============================================================================
# TUNEABLE CONSTANTS
# =============================================================================

ARDUINO_PORT     = "/dev/ttyUSB0"   # find with: ls /dev/ttyUSB*
ARDUINO_BAUDRATE = 9600
ARDUINO_TIMEOUT  = 2

BTN_DEBOUNCE_S   = 2.0

# Security escalation
CONSEC_DENIED_LIMIT    = 3    # denials in a row → alarm
DENIAL_STREAK_LIMIT    = 5    # denials in rolling window → alarm
DENIAL_STREAK_WINDOW_S = 120  # window length in seconds (2 min)

# Night mode: saves frame captures on denied if a frame is passed in
NIGHT_START_HOUR = 20
NIGHT_END_HOUR   = 8

LOG_FILE    = "attendance_log.txt"
CAPTURE_DIR = Path("captures")
CAPTURE_DIR.mkdir(exist_ok=True)

# =============================================================================
# LED COLOUR CODES  (PYNQ-Z2 verified)
# =============================================================================

LED = {
    "off":     0,
    "blue":    1,
    "green":   2,
    "cyan":    3,
    "red":     4,
    "magenta": 5,
    "yellow":  6,
    "white":   7,
}

# =============================================================================
# ACCESS LEVEL DEFINITIONS
# cmd = single char sent to Arduino
# =============================================================================

LEVELS = {
    "granted":  {"color": "green", "cmd": "G", "duration": 3, "door": "open"},
    "denied":   {"color": "red",   "cmd": "D", "duration": 1, "door": "shut"},
    "pending":  {"color": "cyan",  "cmd": "P", "duration": 5, "door": "shut"},
    "alarm":    {"color": "red",   "cmd": "A", "duration": 0, "door": "shut"},
    "lockdown": {"color": "red",   "cmd": "L", "duration": 0, "door": "shut"},
}

# =============================================================================
# SHARED STATE
# =============================================================================

shutdown_event  = threading.Event()
lockdown_active = threading.Event()

state = {
    "last_btn0": 0.0,
    "last_btn1": 0.0,

    "consecutive_denials": 0,
    "denial_timestamps":   deque(maxlen=100),

    "counts":         {k: 0 for k in LEVELS},
    "access_history": deque(maxlen=20),

    "arduino_connected": False,
    "arduino":           None,
    "active_threads":    [],
}

# =============================================================================
# ARDUINO
# =============================================================================

def connect_arduino():
    if not SERIAL_AVAILABLE:
        return None
    try:
        ard = serial.Serial(
            port=ARDUINO_PORT,
            baudrate=ARDUINO_BAUDRATE,
            timeout=ARDUINO_TIMEOUT
        )
        time.sleep(2)
        state["arduino_connected"] = True
        print(f"[ARDUINO] Connected on {ARDUINO_PORT}")
        return ard
    except Exception as e:
        print(f"[ARDUINO] Not connected: {e}")
        state["arduino_connected"] = False
        return None

def send_to_arduino(cmd: str):
    ard = state.get("arduino")
    if ard and state["arduino_connected"]:
        try:
            ard.write(cmd.encode())
            ard.flush()
        except Exception:
            state["arduino_connected"] = False

def arduino_heartbeat_loop():
    """Pings Arduino every 30s to confirm it's still alive."""
    while not shutdown_event.is_set():
        time.sleep(30)
        if state["arduino_connected"]:
            try:
                state["arduino"].write(b"?")
                time.sleep(0.2)
                if state["arduino"].in_waiting > 0:
                    if state["arduino"].read().decode() != "K":
                        state["arduino_connected"] = False
                        print("[ARDUINO] Lost connection")
            except Exception:
                state["arduino_connected"] = False
                print("[ARDUINO] Lost connection")

# =============================================================================
# LED HELPERS
# =============================================================================

def set_led(color: str):
    if PYNQ_AVAILABLE and rgb_led:
        rgb_led.write(LED.get(color, 0))

def led_off():
    if PYNQ_AVAILABLE and rgb_led:
        rgb_led.write(0)

def flash_led(color: str, flashes: int = 6, interval: float = 0.1):
    for _ in range(flashes):
        if shutdown_event.is_set():
            break
        set_led(color);  time.sleep(interval)
        led_off();       time.sleep(interval)

def led_pulse(color: str, duration: int):
    """Slow on/off pulse for pending state."""
    end = time.time() + duration
    while time.time() < end and not shutdown_event.is_set():
        set_led(color); time.sleep(0.5)
        led_off();      time.sleep(0.5)

def led_boot_sequence():
    print("[LED] Boot self-test...")
    for color in ["green", "cyan", "red", "white"]:
        if shutdown_event.is_set():
            break
        set_led(color); time.sleep(0.25)
    led_off()
    print("[LED] Done")

# =============================================================================
# DAY / NIGHT
# =============================================================================

def is_night() -> bool:
    hour = datetime.datetime.now().hour
    return hour < NIGHT_END_HOUR or hour >= NIGHT_START_HOUR

# =============================================================================
# LOGGING
# =============================================================================

def log_event(message: str):
    ts   = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {message}"
    print(line)
    with open(LOG_FILE, "a") as f:
        f.write(line + "\n")

# =============================================================================
# SECURITY ESCALATION
# =============================================================================

def track_security_events(level: str):
    now = time.time()

    if level == "denied":
        state["consecutive_denials"] += 1
        if state["consecutive_denials"] >= CONSEC_DENIED_LIMIT:
            log_event(f"SECURITY: {CONSEC_DENIED_LIMIT} denials in a row — alarm")
            trigger_alarm()
            state["consecutive_denials"] = 0

        state["denial_timestamps"].append(now)
        cutoff = now - DENIAL_STREAK_WINDOW_S
        while state["denial_timestamps"] and state["denial_timestamps"][0] < cutoff:
            state["denial_timestamps"].popleft()
        if len(state["denial_timestamps"]) >= DENIAL_STREAK_LIMIT:
            log_event(f"SECURITY: {DENIAL_STREAK_LIMIT} denials in {DENIAL_STREAK_WINDOW_S}s — alarm")
            trigger_alarm()
            state["denial_timestamps"].clear()
    else:
        state["consecutive_denials"] = 0

def trigger_alarm():
    state["counts"]["alarm"] += 1
    send_to_arduino("A")
    flash_led("red", flashes=12, interval=0.07)
    log_event("ALARM triggered")

# =============================================================================
# CORE TRIGGER
# =============================================================================

def _do_trigger(level: str, frame=None):
    """Drives physical outputs. Always runs in its own thread."""
    if shutdown_event.is_set():
        return

    if lockdown_active.is_set() and level not in ("alarm", "lockdown"):
        send_to_arduino("L")
        flash_led("red", flashes=6)
        log_event("LOCKDOWN BLOCK")
        return

    cfg = LEVELS.get(level, LEVELS["denied"])

    state["counts"][level] += 1
    ts = datetime.datetime.now().strftime("%H:%M:%S")
    state["access_history"].appendleft(f"[{ts}] {level.upper()}")

    if level in ("granted", "denied"):
        track_security_events(level)

    # Night mode: save face capture on denied if frame provided
    if level == "denied" and is_night() and frame is not None:
        try:
            import cv2
            ts_file = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            path = CAPTURE_DIR / f"denied_{ts_file}.jpg"
            cv2.imwrite(str(path), frame)
            log_event(f"NIGHT CAPTURE saved: {path}")
        except Exception:
            pass

    log_event(f"ACCESS: {level.upper()}")
    send_to_arduino(cfg["cmd"])

    if level == "denied":
        flash_led("red", flashes=4, interval=0.1)
    elif level == "pending":
        led_pulse("cyan", cfg["duration"])
    elif level in ("alarm", "lockdown"):
        flash_led("red", flashes=10, interval=0.07)
    else:
        set_led(cfg["color"])
        time.sleep(cfg["duration"])
        led_off()

# =============================================================================
# PUBLIC API  ← Marcus calls this
# =============================================================================

def handle_recognition_result(level: str, frame=None):
    """
    ┌──────────────────────────────────────────────┐
    │  CALL THIS FROM MARCUS                       │
    │  level : "granted", "denied", or "pending"  │
    │  frame : optional OpenCV img (night capture) │
    └──────────────────────────────────────────────┘
    """
    t = threading.Thread(
        target=_do_trigger,
        args=(level,),
        kwargs={"frame": frame},
        daemon=True
    )
    t.start()

# =============================================================================
# BACKGROUND THREADS
# =============================================================================

def button_monitor_loop():
    while not shutdown_event.is_set() and PYNQ_AVAILABLE and buttons:
        time.sleep(0.05)
        now = time.time()

        # BTN0 — simulate granted
        if buttons[0].read() == 1 and (now - state["last_btn0"]) > BTN_DEBOUNCE_S:
            state["last_btn0"] = now
            handle_recognition_result("granted")

        # BTN1 — simulate denied
        if buttons[1].read() == 1 and (now - state["last_btn1"]) > BTN_DEBOUNCE_S:
            state["last_btn1"] = now
            handle_recognition_result("denied")

        # BTN3 — shutdown
        if buttons[3].read() == 1:
            print("[BTN3] Shutdown triggered")
            shutdown()
            break

def heartbeat_loop():
    while not shutdown_event.is_set():
        if PYNQ_AVAILABLE and led_heartbeat:
            led_heartbeat.on();  time.sleep(0.5)
            led_heartbeat.off(); time.sleep(0.5)
        else:
            time.sleep(1)

# =============================================================================
# SYSTEM START / STOP
# =============================================================================

def start_system():
    print("\n" + "=" * 50)
    print("ATTENDANCE OUTPUT NODE — Thanus")
    print("=" * 50 + "\n")

    state["arduino"] = connect_arduino()
    led_boot_sequence()

    if state["arduino"]:
        send_to_arduino("B")

    threads = [
        threading.Thread(target=button_monitor_loop,    daemon=True, name="buttons"),
        threading.Thread(target=arduino_heartbeat_loop, daemon=True, name="ard_hb"),
        threading.Thread(target=heartbeat_loop,         daemon=True, name="led_hb"),
    ]
    for t in threads:
        t.start()
        state["active_threads"].append(t)

    log_event("SYSTEM STARTED")
    print("\nReady. Waiting for Marcus...\n")
    print('  handle_recognition_result("granted")')
    print('  handle_recognition_result("denied")')
    print('  handle_recognition_result("pending")')

def shutdown():
    print("\n[SHUTDOWN] Cleaning up...")
    shutdown_event.set()
    led_off()
    if PYNQ_AVAILABLE and led_heartbeat:
        led_heartbeat.off()
    if state["arduino"]:
        try:
            state["arduino"].close()
        except Exception:
            pass
    log_event("SYSTEM SHUTDOWN")
    print("[SHUTDOWN] Done")

# =============================================================================
# TEST HELPER
# =============================================================================

def test_all():
    """Run through all states. Call from Jupyter to verify hardware."""
    for level in ["pending", "granted", "denied"]:
        print(f"\n--- Testing: {level} ---")
        handle_recognition_result(level)
        time.sleep(4)
    print("\nTest complete.")

# =============================================================================
# ENTRY POINT
# =============================================================================

if __name__ == "__main__" or "get_ipython" in globals():
    start_system()
