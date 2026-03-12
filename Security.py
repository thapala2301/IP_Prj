# --- JUPYTER WIDGET CHECK ---
# If the dashboard never appears, run this in a separate cell first:
#   !jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Then restart the kernel and re-run.
#
# --- ARDUINO SETUP ---
#   pip install pyserial
#   Connect Arduino via USB. Find port: ls /dev/ttyUSB* or ls /dev/ttyACM*
#   Update ARDUINO_PORT below.
#
# --- LIGHT SENSOR SETUP ---
#   Wire LDR to PYNQ PMODA header (see wiring_diagram.txt for details)
#   Uses pynq.lib.arduino.grove_light or analog read via XADC

import json
import subprocess
import time
import threading
import datetime
import collections
import ipywidgets as widgets
from IPython.display import display, clear_output
from pynq.overlays.base import BaseOverlay
from collections import deque

try:
    import serial
    SERIAL_AVAILABLE = True
except ImportError:
    SERIAL_AVAILABLE = False
    print("[WARNING] pyserial not installed. Run: pip install pyserial")

# =============================================================================
# ATTENDANCE ADD-ONS — V8.0
# Physical response node. Receives decisions from Marcus/AWS and drives:
#   PYNQ RGB LED · Arduino servo/buzzer/LEDs · Light sensor · Dashboard
# Entry point: handle_recognition_result(name, level, frame=None)
# =============================================================================

# --- TUNEABLE CONSTANTS ---
NIGHT_THRESHOLD         = 0.5    # Light sensor voltage below which = night mode
                                 # Only used when physical sensor connected (Pmod ADC)
                                 # Calibrate: print read_light_sensor() in bright vs dark room
                                 # Time-of-day fallback ignores this value
BTN_DEBOUNCE_S          = 2.0    # Min seconds between physical button presses
ACCESS_COOLDOWN_S       = 30     # Same person can't re-trigger access within this window
DENIAL_STREAK_WINDOW_S  = 120    # Seconds window for consecutive denial alarm
DENIAL_STREAK_LIMIT     = 5      # Denials within window before sustained alarm
CONSEC_UNKNOWN_LIMIT    = 3      # Unknown denials in a row before auto-escalate to alarm
ARDUINO_PING_INTERVAL_S = 30     # Seconds between Arduino heartbeat pings
LOG_FILE                = "attendance_log.txt"
REPORT_FILE             = "daily_report.txt"
MAX_LOG_DISPLAY         = 12     # Lines in live log widget
MAX_HISTORY_DISPLAY     = 20     # Lines in access history widget

# --- ARDUINO SERIAL CONFIG ---
ARDUINO_PORT     = "/dev/ttyUSB0"   # Update to match your system
ARDUINO_BAUDRATE = 9600
ARDUINO_TIMEOUT  = 2

# --- ACCESS LEVELS ---
# Confirmed RGB LED colour map for this PYNQ board:
# 0=off, 1=blue, 2=green, 3=cyan, 4=red, 5=magenta, 6=yellow, 7=white
ACCESS_LEVELS = {
    "standard": {"color": 2, "label": "Standard", "led_duration": 3, "serial_cmd": "G"},
    "vip":      {"color": 1, "label": "VIP",      "led_duration": 3, "serial_cmd": "V"},
    "guest":    {"color": 6, "label": "Guest",    "led_duration": 3, "serial_cmd": "U"},
    "denied":   {"color": 4, "label": "DENIED",   "led_duration": 1, "serial_cmd": "D"},
    "pending":  {"color": 3, "label": "Pending",  "led_duration": 5, "serial_cmd": "P"},
    "flagged":  {"color": 5, "label": "Flagged",  "led_duration": 4, "serial_cmd": "F"},
    "override": {"color": 7, "label": "Override", "led_duration": 3, "serial_cmd": "O"},
}

# --- FACE RECOGNITION CONFIG ---
VIP_NAMES         = []   # e.g. ["prof_smith"] → blue LED, fast-track (no pending)
FLAGGED_NAMES     = []   # e.g. ["banned_user"] → magenta + always captures frame

# =============================================================================
# 1. HARDWARE SETUP
# =============================================================================
base     = BaseOverlay("base.bit")
LED_MAP  = [base.leds[i] for i in range(4)]
LOCK_LED = base.rgbleds[4]

# --- Light sensor setup ---
# Current mode: time-of-day fallback (no physical sensor connected yet)
# Night mode = 8pm to 8am
#
# TO SWAP IN PHYSICAL SENSOR when LDR is available at meetup:
#   1. Plug LDR into PMODA
#   2. Uncomment the Pmod_ADC block below
#   3. Comment out the time-of-day block
#   4. Calibrate NIGHT_THRESHOLD by printing read_light_sensor() values
#      in a bright room vs a dark room to find the right cutoff

LIGHT_SENSOR_AVAILABLE = False
_pmod_adc = None

# --- OPTION A: Pmod ADC (uncomment when LDR is plugged into PMODA) ---
# try:
#     from pynq.lib import Pmod_ADC
#     _pmod_adc = Pmod_ADC(base.PMODA)
#     LIGHT_SENSOR_AVAILABLE = True
#     print("[LIGHT SENSOR] Pmod ADC on PMODA — ready")
# except Exception as e:
#     print(f"[LIGHT SENSOR] Pmod ADC not available: {e}")

# --- OPTION B: Arduino analog A0 (uncomment if sensor on Arduino header) ---
# try:
#     from pynq.lib.arduino import Arduino_Analog
#     _arduino_analog = Arduino_Analog(base.ARDUINO, [0])
#     LIGHT_SENSOR_AVAILABLE = True
#     print("[LIGHT SENSOR] Arduino A0 — ready")
# except Exception as e:
#     print(f"[LIGHT SENSOR] Arduino analog not available: {e}")

import datetime

def read_light_sensor():
    """
    Read light level.
    Currently: returns simulated value based on time of day.
    When physical sensor connected: returns raw ADC float (0.0 - 3.3V).
    """
    # --- Physical sensor read (uncomment with OPTION A above) ---
    # if _pmod_adc:
    #     return _pmod_adc.read()[0]

    # --- Physical sensor read (uncomment with OPTION B above) ---
    # if _arduino_analog:
    #     return _arduino_analog.read()[0]

    # --- Time-of-day fallback ---
    hour = datetime.datetime.now().hour
    # Return 0.1 at night (low light), 2.0 during day (bright)
    return 0.1 if (hour < 8 or hour >= 20) else 2.0

def is_night() -> bool:
    """
    Return True if it is night time.
    With physical sensor: compares voltage to NIGHT_THRESHOLD.
    Without sensor: uses time of day (night = 8pm to 8am).
    """
    val = read_light_sensor()
    if LIGHT_SENSOR_AVAILABLE:
        # Physical sensor — NIGHT_THRESHOLD is a voltage (e.g. 0.5V)
        # Calibrate by printing read_light_sensor() in bright vs dark room
        return val < NIGHT_THRESHOLD
    else:
        # Time-of-day fallback
        hour = datetime.datetime.now().hour
        return hour < 8 or hour >= 20

# --- Arduino serial connection ---
arduino = None

def _connect_arduino():
    global arduino
    if not SERIAL_AVAILABLE:
        return
    try:
        arduino = serial.Serial(ARDUINO_PORT, ARDUINO_BAUDRATE, timeout=ARDUINO_TIMEOUT)
        time.sleep(2)
        print(f"[ARDUINO] Connected on {ARDUINO_PORT}")
    except Exception as e:
        arduino = None
        print(f"[ARDUINO] Not connected: {e} — LED-only mode")

def _send_arduino(cmd: str) -> bool:
    """Send command to Arduino. Returns True on success."""
    if arduino is None:
        return False
    try:
        arduino.write(cmd.encode())
        arduino.flush()
        return True
    except Exception as e:
        log_event(f"ARDUINO ERROR: '{cmd}' failed — {e}")
        return False

# =============================================================================
# 2. SHARED STATE
# =============================================================================
shutdown_event  = threading.Event()
lockdown_active = threading.Event()  # Night lockdown mode

state = {
    # Timing / debounce
    "last_btn0":             0.0,
    "last_btn1":             0.0,
    "last_arduino_ping":     0.0,

    # Access tracking
    "access_cooldowns":      {},        # name → last access timestamp
    "consecutive_unknowns":  0,         # unknown denial streak counter
    "denial_timestamps":     deque(),   # timestamps of recent denials for streak detection
    "access_history":        deque(maxlen=MAX_HISTORY_DISPLAY),  # named access log

    # Session counts
    "session_counts": {
        "standard": 0, "vip": 0, "guest": 0, "denied": 0,
        "pending": 0, "flagged": 0, "override": 0, "alarm": 0,
    },

    # Hardware status
    "arduino_ok":       False,
    "light_sensor_ok":  LIGHT_SENSOR_AVAILABLE,

    # Thread tracking
    "active_threads":   [],
}

# =============================================================================
# 3. UI DASHBOARD
# =============================================================================
header = widgets.HTML("<h2>🐒 Attendance Add-Ons — V8.0</h2>")

# Status row
status_label   = widgets.HTML("<b>Status:</b> <span style='color:green'>MONITORING</span>")
mode_label     = widgets.HTML("<b>Env:</b> ☀️ Day")
arduino_label  = widgets.HTML("<b>Arduino:</b> <span style='color:gray'>--</span>")
sensor_label   = widgets.HTML("<b>Light:</b> <span style='color:gray'>--</span>")
lockdown_label = widgets.HTML("")

# Session counter
session_label = widgets.HTML("<b>Session:</b> loading...")

# Access history (scrollable, separate from event log)
history_widget = widgets.Textarea(
    value="",
    placeholder="Named access history will appear here...",
    layout=widgets.Layout(width="100%", height="140px")
)

# Event log
log_widget = widgets.Textarea(
    value="",
    placeholder="System event log...",
    layout=widgets.Layout(width="100%", height="140px")
)

# Buttons — row 1: access grants
btn_std      = widgets.Button(description="✅ Authorize Standard", button_style='success')
btn_vip      = widgets.Button(description="🔵 Authorize VIP",      button_style='')
btn_guest    = widgets.Button(description="🟡 Authorize Guest",     button_style='warning')

# Buttons — row 2: special states
btn_pending  = widgets.Button(description="🔷 Simulate Pending",   button_style='')
btn_flagged  = widgets.Button(description="⚠️ Simulate Flagged",   button_style='')
btn_override = widgets.Button(description="⚪ Supervisor Override", button_style='')

# Buttons — row 3: denial + alarm + lockdown
btn_denied   = widgets.Button(description="🔴 Simulate DENY",      button_style='danger')
btn_alarm    = widgets.Button(description="🚨 MANUAL ALARM",       button_style='danger')
btn_lockdown = widgets.Button(description="🔒 NIGHT LOCKDOWN",     button_style='danger')
btn_unlock   = widgets.Button(description="🔓 Lift Lockdown",      button_style='warning')

# Button custom colours
btn_vip.style.button_color      = '#003080';  btn_vip.style.text_color      = 'white'
btn_pending.style.button_color  = '#008080';  btn_pending.style.text_color  = 'white'
btn_flagged.style.button_color  = '#8B008B';  btn_flagged.style.text_color  = 'white'
btn_override.style.button_color = '#444444';  btn_override.style.text_color = 'white'
btn_lockdown.style.button_color = '#1a1a1a';  btn_lockdown.style.text_color = 'white'

instruct = widgets.HTML("""
<div style='border:1px solid #ccc; padding:12px; background:#f9f9f9; font-size:12px; line-height:1.6'>
    <b style='font-size:13px'>📋 ACCESS LEVELS</b><br>
    🟢 Standard · 🔵 VIP (fast-tracked, no pending) · 🟡 Guest · 🔴 Denied · 🔷 Pending · 🟣 Flagged · ⚪ Override<br><br>

    <b style='font-size:13px'>🚪 ARDUINO DOOR</b><br>
    Granted (Std/VIP/Guest/Override) → servo opens 3s + buzzer + green LED<br>
    Denied/Flagged → door shut + alarm beeps + red LED<br>
    Pending → door shut + slow pulse beep<br><br>

    <b style='font-size:13px'>💡 LIGHT SENSOR</b><br>
    Night mode (lux below threshold) → denied/flagged also saves face image from Archit's frame.<br>
    Day mode → standard operation only.<br><br>

    <b style='font-size:13px'>🔒 NIGHT LOCKDOWN</b><br>
    Refuses ALL access regardless of level. White strobe on Arduino. Lift with 🔓 button.<br><br>

    <b style='font-size:13px'>⚡ AUTO-ESCALATION</b><br>
    3 consecutive unknown denials → auto alarm.<br>
    5 denials in 2 minutes → sustained alarm + security alert logged.<br>
    Same person re-entering within 30s → blocked (anti-tailgate).<br><br>

    <b style='font-size:13px'>📁 PHYSICAL BUTTONS</b><br>
    BTN0 = Standard · BTN1 = VIP · BTN3 = shutdown (2s debounce)
</div>
""")

dashboard = widgets.VBox([
    header,
    instruct,
    widgets.HBox([status_label, mode_label]),
    widgets.HBox([arduino_label, sensor_label, lockdown_label]),
    session_label,
    widgets.HTML("<b>Access Controls:</b>"),
    widgets.HBox([btn_std, btn_vip, btn_guest]),
    widgets.HBox([btn_pending, btn_flagged, btn_override]),
    widgets.HBox([btn_denied, btn_alarm, btn_lockdown, btn_unlock]),
    widgets.HTML("<b>Named Access History:</b>"),
    history_widget,
    widgets.HTML("<b>System Event Log:</b>"),
    log_widget,
])

out = widgets.Output()

# =============================================================================
# 4. LOGGING & DISPLAY HELPERS
# =============================================================================

def log_event(message: str):
    """Write timestamped event to file and live log widget."""
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    line = f"[{timestamp}] {message}"
    with open(LOG_FILE, "a") as f:
        f.write(line + "\n")
    current = log_widget.value.split("\n") if log_widget.value.strip() else []
    current.insert(0, line)
    log_widget.value = "\n".join(current[:MAX_LOG_DISPLAY])


def log_access_history(name: str, level: str):
    """Push a named access event to the history widget."""
    if name in ("Unknown", "Scanning...", "Dashboard-Deny",
                "Dashboard-Pending", "Dashboard-Flagged"):
        return
    timestamp = time.strftime('%H:%M:%S')
    level_info = ACCESS_LEVELS.get(level, {})
    label = level_info.get("label", level.upper())
    entry = f"[{timestamp}] {name} — {label}"
    state["access_history"].appendleft(entry)
    history_widget.value = "\n".join(state["access_history"])


def update_session_label():
    s = state["session_counts"]
    session_label.value = (
        f"<b>Session:</b> "
        f"✅ Std:{s['standard']} | 🔵 VIP:{s['vip']} | 🟡 Guest:{s['guest']} | "
        f"🔴 Denied:{s['denied']} | 🔷 Pending:{s['pending']} | "
        f"🟣 Flagged:{s['flagged']} | ⚪ Override:{s['override']} | "
        f"🚨 Alarm:{s['alarm']}"
    )


def update_hardware_labels():
    """Refresh Arduino and light sensor status indicators."""
    ard = "✅ Connected" if state["arduino_ok"] else "❌ Not connected"
    ard_col = "green" if state["arduino_ok"] else "red"
    arduino_label.value = f"<b>Arduino:</b> <span style='color:{ard_col}'>{ard}</span>"

    if state["light_sensor_ok"]:
        lux = read_light_sensor()
        night = lux < NIGHT_THRESHOLD
        mode_label.value = f"<b>Env:</b> {'🌙 Night' if night else '☀️ Day'} | Lux: {lux:.2f}V"
        sensor_label.value = f"<b>Light sensor:</b> <span style='color:green'>✅ {lux:.2f}V</span>"
    else:
        night = is_night()
        hour  = datetime.datetime.now().hour
        mode_label.value = f"<b>Env:</b> {'🌙 Night' if night else '☀️ Day'} | 🕐 {hour:02d}:00"
        sensor_label.value = "<b>Light:</b> <span style='color:orange'>⏰ Time-based (8pm–8am)</span>"


def generate_daily_report():
    """Write a daily summary report to REPORT_FILE."""
    s = state["session_counts"]
    total = sum(s.values())
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    lines = [
        f"DAILY ACCESS REPORT — generated {now}",
        "=" * 50,
        f"Total events:   {total}",
        f"Standard:       {s['standard']}",
        f"VIP:            {s['vip']}",
        f"Guest:          {s['guest']}",
        f"Denied:         {s['denied']}",
        f"Flagged:        {s['flagged']}",
        f"Override:       {s['override']}",
        f"Alarms:         {s['alarm']}",
        "",
        "NAMED ACCESS HISTORY (this session):",
        "-" * 40,
    ]
    lines += list(state["access_history"]) or ["(none)"]
    with open(REPORT_FILE, "a") as f:
        f.write("\n".join(lines) + "\n\n")
    log_event(f"REPORT: Daily summary written to {REPORT_FILE}")

# =============================================================================
# 5. HARDWARE RESPONSE FUNCTIONS
# =============================================================================

def flash_alarm(flashes=6):
    """Red strobe on PYNQ RGB LED."""
    for _ in range(flashes):
        if shutdown_event.is_set(): break
        LOCK_LED.write(4); time.sleep(0.08)
        if shutdown_event.is_set(): break
        LOCK_LED.write(0); time.sleep(0.08)


def led_boot_sequence():
    """
    Cycle all 7 LED colours on startup to confirm hardware is working.
    Gives the team visual confirmation before the first real access event.
    """
    log_event("SYSTEM: LED boot sequence starting")
    for code, name in [(2,"GREEN"),(1,"BLUE"),(6,"YELLOW"),(4,"RED"),
                       (3,"CYAN"),(5,"MAGENTA"),(7,"WHITE")]:
        if shutdown_event.is_set(): break
        LOCK_LED.write(code)
        time.sleep(0.4)
    LOCK_LED.write(0)
    log_event("SYSTEM: LED boot sequence complete — all colours OK")


def save_frame(frame, reason: str) -> str:
    """Save a frame image with timestamp. Returns filename."""
    try:
        import cv2
        ts = time.strftime("%Y%m%d_%H%M%S")
        filename = f"capture_{reason}_{ts}.jpg"
        cv2.imwrite(filename, frame)
        return filename
    except Exception as e:
        log_event(f"CAPTURE ERROR: {e}")
        return ""

# =============================================================================
# 6. ACCESS CONTROL LOGIC
# =============================================================================

def _check_cooldown(name: str) -> bool:
    """
    Return True if person is allowed through (cooldown elapsed or unknown).
    Blocks same named person re-entering within ACCESS_COOLDOWN_S seconds.
    """
    if name in ("Unknown", "Scanning...", "") or name.startswith("Dashboard"):
        return True  # don't apply cooldown to unnamed/test triggers
    now = time.time()
    last = state["access_cooldowns"].get(name, 0)
    if now - last < ACCESS_COOLDOWN_S:
        remaining = int(ACCESS_COOLDOWN_S - (now - last))
        log_event(f"COOLDOWN: {name} blocked — {remaining}s remaining")
        status_label.value = (
            f"<b>Status:</b> <span style='color:orange'>"
            f"⏱ COOLDOWN — {name} ({remaining}s)</span>"
        )
        _send_arduino("D")  # denied flash on Arduino
        time.sleep(1)
        status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"
        return False
    return True


def _update_denial_tracking(name: str, level_key: str):
    """Track consecutive unknowns and denial streaks for auto-escalation."""
    now = time.time()

    if level_key == "denied":
        # Consecutive unknown tracker
        if name in ("Unknown", "NO_MATCH"):
            state["consecutive_unknowns"] += 1
            if state["consecutive_unknowns"] >= CONSEC_UNKNOWN_LIMIT:
                log_event(f"SECURITY ALERT: {CONSEC_UNKNOWN_LIMIT} consecutive unknown denials — escalating to alarm")
                state["session_counts"]["alarm"] += 1
                update_session_label()
                _send_arduino("A")
                t = threading.Thread(target=flash_alarm, args=(10,), daemon=False)
                state["active_threads"].append(t)
                t.start()
                state["consecutive_unknowns"] = 0
        else:
            state["consecutive_unknowns"] = 0

        # Denial streak tracker
        state["denial_timestamps"].append(now)
        cutoff = now - DENIAL_STREAK_WINDOW_S
        while state["denial_timestamps"] and state["denial_timestamps"][0] < cutoff:
            state["denial_timestamps"].popleft()
        if len(state["denial_timestamps"]) >= DENIAL_STREAK_LIMIT:
            log_event(
                f"SECURITY ALERT: {DENIAL_STREAK_LIMIT} denials in "
                f"{DENIAL_STREAK_WINDOW_S}s — sustained alarm triggered"
            )
            state["session_counts"]["alarm"] += 1
            update_session_label()
            _send_arduino("A")
            t = threading.Thread(target=flash_alarm, args=(12,), daemon=False)
            state["active_threads"].append(t)
            t.start()
            state["denial_timestamps"].clear()
    else:
        state["consecutive_unknowns"] = 0


def trigger_access(level_key: str, name: str = "Unknown", frame=None):
    """
    Central access handler — drives PYNQ LED + Arduino on every access event.
    Called directly from button callbacks or via handle_recognition_result().
    """
    if shutdown_event.is_set():
        return

    # --- Night lockdown check ---
    if lockdown_active.is_set() and level_key not in ("override", "alarm"):
        log_event(f"LOCKDOWN: {name} blocked — night lockdown active")
        status_label.value = "<b>Status:</b> <span style='color:red'>🔒 LOCKDOWN ACTIVE — ACCESS BLOCKED</span>"
        _send_arduino("W")  # white strobe lockdown signal
        flash_alarm(flashes=3)
        time.sleep(1)
        status_label.value = "<b>Status:</b> <span style='color:red'>🔒 LOCKDOWN ACTIVE</span>"
        return

    # --- VIP fast-track: skip pending entirely ---
    # (VIP goes straight to response, no cyan waiting state)

    # --- Access cooldown check ---
    if level_key in ("standard", "vip", "guest", "override"):
        if not _check_cooldown(name):
            return

    level      = ACCESS_LEVELS[level_key]
    color      = level["color"]
    label      = level["label"]
    duration   = level["led_duration"]
    serial_cmd = level["serial_cmd"]

    log_event(f"ACCESS [{label}]: {name}")
    log_access_history(name, level_key)
    state["session_counts"][level_key] += 1
    update_session_label()

    # Record access time for cooldown
    if name not in ("Unknown", "Scanning...") and not name.startswith("Dashboard"):
        state["access_cooldowns"][name] = time.time()

    # --- Send to Arduino ---
    _send_arduino(serial_cmd)

    # --- PYNQ LED + status per level ---
    if level_key == "denied":
        status_label.value = f"<b>Status:</b> <span style='color:red'>🔴 DENIED — {name}</span>"
        _update_denial_tracking(name, level_key)
        # Night mode: save frame if Archit passed one
        if frame is not None and is_night():
            fname = save_frame(frame, "denied")
            if fname:
                log_event(f"CAPTURE: Night denial image saved → {fname}")
        flash_alarm(flashes=4)

    elif level_key == "pending":
        status_label.value = f"<b>Status:</b> <span style='color:darkcyan'>🔷 VERIFYING — {name}</span>"
        for _ in range(int(duration * 10)):
            if shutdown_event.is_set(): break
            LOCK_LED.write(color) if int(time.time() * 2) % 2 == 0 else LOCK_LED.write(0)
            time.sleep(0.1)
        LOCK_LED.write(0)

    elif level_key == "flagged":
        status_label.value = f"<b>Status:</b> <span style='color:purple'>⚠️ FLAGGED — {name} — REVIEW REQUIRED</span>"
        _update_denial_tracking(name, "denied")  # flagged counts toward denial streak
        for _ in range(3):
            if shutdown_event.is_set(): break
            LOCK_LED.write(color); time.sleep(0.15)
            LOCK_LED.write(0);     time.sleep(0.10)
            LOCK_LED.write(color); time.sleep(0.15)
            LOCK_LED.write(0);     time.sleep(0.50)
        # Always save frame for flagged — day or night
        if frame is not None:
            fname = save_frame(frame, "flagged")
            if fname:
                log_event(f"CAPTURE: Flagged person image saved → {fname}")

    elif level_key == "override":
        status_label.value = f"<b>Status:</b> <span style='color:gray'>⚪ OVERRIDE — {name}</span>"
        LOCK_LED.write(color)
        for _ in range(int(duration * 10)):
            if shutdown_event.is_set(): break
            time.sleep(0.1)
        LOCK_LED.write(0)

    else:
        # standard / vip / guest
        status_label.value = f"<b>Status:</b> <span style='color:blue'>🔓 OPENING — {label.upper()} — {name}</span>"
        LOCK_LED.write(color)
        for _ in range(int(duration * 10)):
            if shutdown_event.is_set(): break
            time.sleep(0.1)
        LOCK_LED.write(0)
        _update_denial_tracking(name, level_key)  # reset denial streak on successful access

    if not shutdown_event.is_set() and not lockdown_active.is_set():
        status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"

# =============================================================================
# 7. PUBLIC INTEGRATION HOOKS
# =============================================================================

def handle_recognition_result(name: str, clearance_level: str, frame=None):
    """
    ┌──────────────────────────────────────────────────────────────┐
    │                MAIN INTEGRATION HOOK                         │
    │  Call this from Marcus/AWS once a recognition decision       │
    │  has been made. Drives all hardware responses automatically. │
    │                                                              │
    │  Args:                                                       │
    │    name (str):            Person's name or "Unknown"         │
    │    clearance_level (str): "standard" | "vip" | "guest"       │
    │                           "denied"   | "pending"             │
    │                           "flagged"  | "override"            │
    │    frame (ndarray):       Optional — face image from Archit  │
    │                           Used for night capture on denied/  │
    │                           flagged. Pass None if unavailable. │
    │                                                              │
    │  Examples:                                                   │
    │    handle_recognition_result("prof_smith", "vip")            │
    │    handle_recognition_result("Unknown", "denied")            │
    │    handle_recognition_result("", "pending")  # while AWS     │
    │    handle_recognition_result("jane", "denied", frame=img)    │
    └──────────────────────────────────────────────────────────────┘
    """
    # VIP fast-track — skip pending state entirely
    if clearance_level == "vip":
        t = threading.Thread(
            target=trigger_access,
            args=("vip", name, frame),
            daemon=False
        )
        state["active_threads"].append(t)
        t.start()
        return

    t = threading.Thread(
        target=trigger_access,
        args=(clearance_level, name, frame),
        daemon=False
    )
    state["active_threads"].append(t)
    t.start()


def _map_recognition_to_level(name: str, status: str) -> str:
    """Map match_face.py output to an access level."""
    if status != "MATCH" or name == "NO_MATCH":
        return "denied"
    if name in FLAGGED_NAMES:
        return "flagged"
    if name in VIP_NAMES:
        return "vip"
    return "standard"


def process_face_image(image_path: str, frame=None) -> None:
    """
    Shashank bridge — call from Archit's pipeline with a face image path.
    Fires pending immediately, runs match_face.py, then triggers full response.
    frame: optional ndarray from Archit for capture on denied/flagged.
    """
    if shutdown_event.is_set():
        return

    # Fire pending immediately — visual feedback while recognition runs
    handle_recognition_result("Scanning...", "pending")

    try:
        result = subprocess.run(
            ["python3", "match_face.py",
             "--input", str(image_path),
             "--known_dir", "known_faces",
             "--json"],
            capture_output=True, text=True, timeout=15,
        )
        if result.returncode != 0:
            log_event(f"RECOGNITION ERROR: {result.stderr.strip()}")
            handle_recognition_result("Unknown", "denied", frame)
            return
        output = json.loads(result.stdout.strip())
    except subprocess.TimeoutExpired:
        log_event("RECOGNITION ERROR: match_face.py timed out")
        handle_recognition_result("Unknown", "denied", frame)
        return
    except Exception as e:
        log_event(f"RECOGNITION ERROR: {e}")
        handle_recognition_result("Unknown", "denied", frame)
        return

    status   = output.get("status", "NO_MATCH")
    name     = output.get("match_label", "Unknown")
    distance = output.get("match_distance")
    level    = _map_recognition_to_level(name, status)
    dist_str = f" (dist={distance:.3f})" if distance is not None else ""
    log_event(f"RECOGNITION: {name} → {level.upper()}{dist_str}")
    handle_recognition_result(name, level, frame)

# =============================================================================
# 8. BUTTON CALLBACKS
# =============================================================================

def _btn_std(b):      trigger_access("standard", "Dashboard-Std")
def _btn_vip(b):      trigger_access("vip",      "Dashboard-VIP")
def _btn_guest(b):    trigger_access("guest",    "Dashboard-Guest")
def _btn_denied(b):   trigger_access("denied",   "Dashboard-Deny")
def _btn_pending(b):  trigger_access("pending",  "Dashboard-Pending")
def _btn_flagged(b):  trigger_access("flagged",  "Dashboard-Flagged")
def _btn_override(b): trigger_access("override", "Dashboard-Override")

def _btn_alarm(b):
    if shutdown_event.is_set(): return
    log_event("ALARM: Manual trigger")
    state["session_counts"]["alarm"] += 1
    update_session_label()
    _send_arduino("A")
    t = threading.Thread(target=flash_alarm, args=(10,), daemon=False)
    state["active_threads"].append(t)
    t.start()

def _btn_lockdown(b):
    lockdown_active.set()
    log_event("LOCKDOWN: Night lockdown ACTIVATED")
    lockdown_label.value = "<span style='color:red; font-weight:bold'>🔒 LOCKDOWN ACTIVE</span>"
    status_label.value = "<b>Status:</b> <span style='color:red'>🔒 LOCKDOWN ACTIVE</span>"
    _send_arduino("W")
    flash_alarm(flashes=6)

def _btn_unlock(b):
    lockdown_active.clear()
    log_event("LOCKDOWN: Night lockdown LIFTED")
    lockdown_label.value = ""
    status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"

btn_std.on_click(_btn_std)
btn_vip.on_click(_btn_vip)
btn_guest.on_click(_btn_guest)
btn_denied.on_click(_btn_denied)
btn_pending.on_click(_btn_pending)
btn_flagged.on_click(_btn_flagged)
btn_override.on_click(_btn_override)
btn_alarm.on_click(_btn_alarm)
btn_lockdown.on_click(_btn_lockdown)
btn_unlock.on_click(_btn_unlock)

# =============================================================================
# 9. BACKGROUND TASKS
# =============================================================================

def _arduino_heartbeat_loop():
    """
    Ping Arduino every ARDUINO_PING_INTERVAL_S seconds.
    Logs a warning if no response — lets team know hardware is disconnected.
    """
    while not shutdown_event.is_set():
        time.sleep(ARDUINO_PING_INTERVAL_S)
        if shutdown_event.is_set(): break
        if arduino is None:
            continue
        try:
            arduino.write(b"?")
            arduino.flush()
            # Arduino sketch responds to '?' with 'K'
            time.sleep(0.3)
            if arduino.in_waiting > 0:
                resp = arduino.read(arduino.in_waiting).decode(errors="ignore")
                if "K" in resp:
                    state["arduino_ok"] = True
                    update_hardware_labels()
                    continue
            # No response
            state["arduino_ok"] = False
            log_event("ARDUINO WARNING: No heartbeat response — check connection")
            update_hardware_labels()
        except Exception as e:
            state["arduino_ok"] = False
            log_event(f"ARDUINO WARNING: Heartbeat failed — {e}")
            update_hardware_labels()


def _midnight_report_loop():
    """Generate daily report at midnight each day."""
    while not shutdown_event.is_set():
        now = datetime.datetime.now()
        # Sleep until next midnight
        tomorrow = (now + datetime.timedelta(days=1)).replace(
            hour=0, minute=0, second=5, microsecond=0
        )
        sleep_secs = (tomorrow - now).total_seconds()
        # Check shutdown every 60s instead of sleeping the full duration
        slept = 0
        while slept < sleep_secs and not shutdown_event.is_set():
            time.sleep(min(60, sleep_secs - slept))
            slept += 60
        if not shutdown_event.is_set():
            generate_daily_report()


def _sensor_update_loop():
    """Update light sensor reading and hardware status labels every 5 seconds."""
    while not shutdown_event.is_set():
        time.sleep(5)
        if shutdown_event.is_set(): break
        try:
            update_hardware_labels()
            # Update heartbeat LED (LED3) and light bar (LED0-2) from sensor
            if LIGHT_SENSOR_AVAILABLE:
                lux = read_light_sensor()
                for i in range(3):
                    LED_MAP[i].on() if i < int(lux / 400) else LED_MAP[i].off()
            LED_MAP[3].on() if int(time.time()) % 2 == 0 else LED_MAP[3].off()
        except Exception:
            pass

# =============================================================================
# 10. MAIN LOOP & STARTUP
# =============================================================================

def _main_loop():
    """Background thread — physical button polling."""
    log_event("SYSTEM: Node started")

    # Boot LED sequence
    led_boot_sequence()

    # Update status
    status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"
    update_session_label()
    update_hardware_labels()
    print("\n[READY] Dashboard live. Press BTN3 on PYNQ to exit.\n")

    try:
        while base.buttons[3].read() == 0 and not shutdown_event.is_set():
            time.sleep(0.05)  # 20Hz poll — lightweight, just watching buttons

            now = time.time()

            # Physical button overrides (debounced)
            if base.buttons[0].read() == 1 and (now - state["last_btn0"]) > BTN_DEBOUNCE_S:
                state["last_btn0"] = now
                t = threading.Thread(
                    target=trigger_access, args=("standard", "BTN0"), daemon=False)
                state["active_threads"].append(t); t.start()

            if base.buttons[1].read() == 1 and (now - state["last_btn1"]) > BTN_DEBOUNCE_S:
                state["last_btn1"] = now
                t = threading.Thread(
                    target=trigger_access, args=("vip", "BTN1"), daemon=False)
                state["active_threads"].append(t); t.start()

    finally:
        shutdown_event.set()
        generate_daily_report()
        for t in state["active_threads"]:
            t.join(timeout=1.5)
        LOCK_LED.write(0)
        for l in LED_MAP: l.off()
        if arduino is not None:
            try: arduino.close()
            except: pass
        log_event("SYSTEM: Node shut down cleanly")
        status_label.value = "<b>Status:</b> <span style='color:red'>⛔ OFFLINE</span>"
        print(f"[SHUTDOWN] System offline. Log: '{LOG_FILE}' | Report: '{REPORT_FILE}'")


def start_system():
    _connect_arduino()
    state["arduino_ok"] = arduino is not None

    with out:
        clear_output(wait=True)
        display(dashboard)
    display(out)
    time.sleep(1.0)

    # Launch background threads
    threads = [
        threading.Thread(target=_main_loop,              daemon=False, name="main_loop"),
        threading.Thread(target=_arduino_heartbeat_loop, daemon=False, name="arduino_heartbeat"),
        threading.Thread(target=_midnight_report_loop,   daemon=False, name="midnight_report"),
        threading.Thread(target=_sensor_update_loop,     daemon=False, name="sensor_update"),
    ]
    for t in threads:
        state["active_threads"].append(t)
        t.start()


start_system()
