#!/usr/bin/env python3
"""
PYNQ OUTPUT NODE - Physical Response Layer
Thanus's component for the face recognition attendance system

Pipeline Position:
Archit (FPGA) → Shashank (Face Rec) → Marcus (AWS) → YOU ARE HERE → Physical Outputs

This module:
1. LISTENS for decisions from Marcus via serial/USB (from his AWS script)
2. CONTROLS: PYNQ RGB LED (7 colors), Servo (door), Buzzer (audio feedback)
3. HANDLES: Day/night mode, auto-escalation, cooldowns, logging
4. PROVIDES: Live Jupyter dashboard with session stats

Integration with Marcus:
- Marcus calls: handle_recognition_result(name, clearance_level, frame=None)
- Your code does the rest automatically

All 7 access states have distinct LED + servo + buzzer patterns:
┌──────────┬─────────┬──────────────┬─────────────┬─────────────────┐
│ Level    │ LED     │ Servo        │ Buzzer      │ Use Case        │
├──────────┼─────────┼──────────────┼─────────────┼─────────────────┤
│ standard │ Green   │ Opens 3s     │ 1 short     │ Regular access  │
│ vip      │ Blue    │ Opens 3s     │ Rising 2    │ Priority access │
│ guest    │ Yellow  │ Opens 3s     │ Soft 1      │ Temporary       │
│ denied   │ Red     │ Stays shut   │ 3 descending│ Access denied   │
│ pending  │ Cyan    │ Stays shut   │ Slow pulse  │ Processing      │
│ flagged  │ Magenta │ Stays shut   │ Double alarm│ Security alert  │
│ override │ White   │ Opens 3s     │ Long 1      │ Bypass lockdown │
└──────────┴─────────┴──────────────┴─────────────┴─────────────────┘
"""

import json
import time
import threading
import datetime
import subprocess
from collections import deque
from pathlib import Path

# =============================================================================
# SECTION 1 - PYNQ HARDWARE SETUP
# =============================================================================

try:
    from pynq.overlays.base import BaseOverlay
    from pynq.lib import Pmod_ADC
    from IPython.display import display, clear_output
    import ipywidgets as widgets
    PYNQ_AVAILABLE = True
    
    print("[PYNQ] Loading base overlay...")
    base = BaseOverlay("base.bit")
    
    # RGB LED (index 4 is the RGB LED on PYNQ-Z2)
    rgb_led = base.rgbleds[4]
    
    # Physical buttons (BTN0, BTN1, BTN2, BTN3)
    buttons = base.buttons
    
    # Plain LEDs for status indicators
    led_heartbeat = base.leds[3]  # Blinks to show system alive
    led_status = base.leds[0]      # Status indicator
    
    print("[PYNQ] Hardware initialized successfully")
    
except ImportError:
    print("[WARNING] Running in simulation mode (no PYNQ hardware)")
    PYNQ_AVAILABLE = False
    base = None
    rgb_led = None
    buttons = None
    led_heartbeat = None
    led_status = None

# =============================================================================
# SECTION 2 - SERIAL COMMUNICATION (with Arduino for servo/buzzer)
# =============================================================================

try:
    import serial
    import serial.tools.list_ports
    SERIAL_AVAILABLE = True
except ImportError:
    SERIAL_AVAILABLE = False
    print("[WARNING] pyserial not installed - run: pip install pyserial")

# =============================================================================
# SECTION 3 - TUNEABLE CONSTANTS (Edit these to tune behavior)
# =============================================================================

# --- Serial Port Configuration ---
# Find your Arduino port: run this in Jupyter:
# !ls /dev/ttyUSB*  or  !ls /dev/ttyACM*
ARDUINO_PORT = "/dev/ttyUSB0"  # Change this to match your setup
ARDUINO_BAUDRATE = 9600
ARDUINO_TIMEOUT = 2

# --- Access Control Settings ---
ACCESS_COOLDOWN_S = 30      # Seconds before same person can re-enter
BTN_DEBOUNCE_S = 2.0        # Min time between physical button presses
CONSEC_UNKNOWN_LIMIT = 3    # Unknown denials in a row before alarm
DENIAL_STREAK_LIMIT = 5     # Denials in window before sustained alarm
DENIAL_STREAK_WINDOW_S = 120  # Rolling window for denial streak (2 minutes)

# --- Day/Night Mode (for enhanced security) ---
# Archit will send this via the name|level format
# Example: "prof_smith|vip|night\n" or "Unknown|denied|day\n"
# If not provided, use time-based fallback
NIGHT_START_HOUR = 20  # 8pm
NIGHT_END_HOUR = 8     # 8am

# --- File Paths ---
LOG_FILE = "attendance_log.txt"
REPORT_FILE = "daily_report.txt"
CAPTURE_DIR = Path("captures")
CAPTURE_DIR.mkdir(exist_ok=True)

# --- RGB LED Color Map (Empirically verified on PYNQ-Z2) ---
# Write these values to rgb_led.write(code)
LED_COLORS = {
    "off": 0,      # Off
    "blue": 1,     # VIP
    "green": 2,    # Standard
    "cyan": 3,     # Pending
    "red": 4,      # Denied / Alarm
    "magenta": 5,  # Flagged
    "yellow": 6,   # Guest
    "white": 7,    # Override
}

# --- Access Level Definitions ---
# Maps each level to: color, servo command, buzzer pattern, duration
ACCESS_LEVELS = {
    "standard": {
        "color": "green",
        "cmd": "G",  # Sent to Arduino
        "duration": 3,
        "servo": "open",
        "buzzer": "short"
    },
    "vip": {
        "color": "blue",
        "cmd": "V",
        "duration": 3,
        "servo": "open",
        "buzzer": "rising2"
    },
    "guest": {
        "color": "yellow",
        "cmd": "U",
        "duration": 3,
        "servo": "open",
        "buzzer": "soft"
    },
    "denied": {
        "color": "red",
        "cmd": "D",
        "duration": 1,
        "servo": "closed",
        "buzzer": "descending3"
    },
    "pending": {
        "color": "cyan",
        "cmd": "P",
        "duration": 5,
        "servo": "closed",
        "buzzer": "slow3"
    },
    "flagged": {
        "color": "magenta",
        "cmd": "F",
        "duration": 4,
        "servo": "closed",
        "buzzer": "double_alarm"
    },
    "override": {
        "color": "white",
        "cmd": "O",
        "duration": 3,
        "servo": "open",
        "buzzer": "long"
    },
    "alarm": {
        "color": "red",
        "cmd": "A",
        "duration": 0,
        "servo": "closed",
        "buzzer": "rapid"
    },
    "lockdown": {
        "color": "red",
        "cmd": "L",
        "duration": 0,
        "servo": "closed",
        "buzzer": "siren"
    }
}

# =============================================================================
# SECTION 4 - SHARED STATE
# =============================================================================

shutdown_event = threading.Event()
lockdown_active = threading.Event()

state = {
    # Timestamps for button debounce
    "last_btn0": 0.0,
    "last_btn1": 0.0,
    "last_btn2": 0.0,
    
    # Access tracking
    "access_cooldowns": {},        # name -> last_access_time
    "consecutive_unknowns": 0,
    "denial_timestamps": deque(maxlen=100),
    
    # Session statistics
    "session_counts": {
        "standard": 0, "vip": 0, "guest": 0, "denied": 0,
        "pending": 0, "flagged": 0, "override": 0, "alarm": 0
    },
    
    # History for display
    "access_history": deque(maxlen=20),
    
    # Hardware status
    "arduino_connected": False,
    "current_mode": "day",  # or "night"
    
    # Background threads
    "active_threads": [],
    
    # Serial port
    "arduino": None
}

# =============================================================================
# SECTION 5 - ARDUINO COMMUNICATION
# =============================================================================

def connect_arduino():
    """Establish serial connection to Arduino (controls servo + buzzer)."""
    if not SERIAL_AVAILABLE:
        print("[ARDUINO] pyserial not available")
        return None
    
    try:
        # Try to auto-detect port if not specified
        port = ARDUINO_PORT
        if port == "auto":
            ports = serial.tools.list_ports.comports()
            for p in ports:
                if "Arduino" in p.description or "USB" in p.description:
                    port = p.device
                    break
        
        arduino = serial.Serial(
            port=port,
            baudrate=ARDUINO_BAUDRATE,
            timeout=ARDUINO_TIMEOUT
        )
        time.sleep(2)  # Wait for Arduino reset
        print(f"[ARDUINO] Connected on {port}")
        state["arduino_connected"] = True
        return arduino
    except Exception as e:
        print(f"[ARDUINO] Not connected: {e}")
        print("[ARDUINO] Running in LED-only mode")
        state["arduino_connected"] = False
        return None

def send_to_arduino(cmd: str) -> bool:
    """Send single character command to Arduino."""
    arduino = state.get("arduino")
    if arduino and state["arduino_connected"]:
        try:
            arduino.write(cmd.encode())
            arduino.flush()
            return True
        except Exception as e:
            print(f"[ARDUINO] Send failed: {e}")
            state["arduino_connected"] = False
    return False

def arduino_heartbeat_loop():
    """Periodically check if Arduino is still alive."""
    while not shutdown_event.is_set():
        time.sleep(30)  # Check every 30 seconds
        
        if state["arduino_connected"]:
            try:
                # Send ping
                state["arduino"].write(b"?")
                time.sleep(0.2)
                
                # Check for response
                if state["arduino"].in_waiting > 0:
                    resp = state["arduino"].read().decode()
                    if resp == "K":
                        # All good
                        pass
                    else:
                        print("[ARDUINO] Unexpected response")
                else:
                    print("[ARDUINO] No heartbeat response")
                    state["arduino_connected"] = False
            except:
                state["arduino_connected"] = False
                print("[ARDUINO] Connection lost")

# =============================================================================
# SECTION 6 - DAY/NIGHT MODE DETECTION
# =============================================================================

def is_night() -> bool:
    """
    Determine if it's currently night mode.
    Archit can override this by sending 'night' or 'day' in the command.
    """
    # Check if we have an explicit mode from Archit
    if "explicit_mode" in state:
        return state["explicit_mode"] == "night"
    
    # Fallback to time-based
    hour = datetime.datetime.now().hour
    return hour < NIGHT_END_HOUR or hour >= NIGHT_START_HOUR

def set_mode_from_command(command: str):
    """Parse mode from Archit's command (name|level|mode)."""
    parts = command.strip().split('|')
    if len(parts) >= 3:
        mode = parts[2].lower()
        if mode in ['day', 'night']:
            state["explicit_mode"] = mode
            print(f"[MODE] Set to {mode.upper()} from Archit")
            return True
    return False

# =============================================================================
# SECTION 7 - PYNQ LED CONTROL
# =============================================================================

def set_led_color(color_name: str):
    """Set RGB LED to specified color."""
    if PYNQ_AVAILABLE and rgb_led:
        code = LED_COLORS.get(color_name, 0)
        rgb_led.write(code)

def led_off():
    """Turn off RGB LED."""
    if PYNQ_AVAILABLE and rgb_led:
        rgb_led.write(0)

def flash_led(color_name: str, flashes: int = 4, duration: float = 0.1):
    """Flash LED rapidly."""
    for _ in range(flashes):
        if shutdown_event.is_set():
            break
        set_led_color(color_name)
        time.sleep(duration)
        led_off()
        time.sleep(duration)

def led_boot_sequence():
    """Visual self-check on startup."""
    print("[LED] Boot sequence - testing all colors")
    colors = ["green", "blue", "yellow", "red", "cyan", "magenta", "white"]
    for color in colors:
        if shutdown_event.is_set():
            break
        set_led_color(color)
        time.sleep(0.3)
    led_off()
    print("[LED] Boot sequence complete")

def led_pattern_pulse(color_name: str, duration: int):
    """Slow pulsing pattern (used for pending state)."""
    end_time = time.time() + duration
    while time.time() < end_time and not shutdown_event.is_set():
        set_led_color(color_name)
        time.sleep(0.5)
        led_off()
        time.sleep(0.5)

def led_pattern_double_flash(color_name: str, duration: int):
    """Double-flash pattern (used for flagged state)."""
    end_time = time.time() + duration
    while time.time() < end_time and not shutdown_event.is_set():
        for _ in range(2):
            set_led_color(color_name)
            time.sleep(0.15)
            led_off()
            time.sleep(0.1)
        time.sleep(0.5)

# =============================================================================
# SECTION 8 - ACCESS CONTROL LOGIC
# =============================================================================

def check_cooldown(name: str) -> bool:
    """Prevent same person from re-entering too quickly."""
    if not name or name in ["Unknown", "NO_MATCH", "Scanning..."]:
        return True
    
    now = time.time()
    last = state["access_cooldowns"].get(name, 0)
    
    if now - last < ACCESS_COOLDOWN_S:
        remaining = int(ACCESS_COOLDOWN_S - (now - last))
        print(f"[COOLDOWN] {name} blocked - {remaining}s remaining")
        # Trigger denied response with cooldown message
        trigger_access("denied", name, cooldown=True)
        return False
    
    return True

def track_security_events(name: str, level: str):
    """Monitor for security threats and trigger alarms."""
    now = time.time()
    
    if level == "denied":
        # Track consecutive unknowns
        if name in ["Unknown", "NO_MATCH", ""]:
            state["consecutive_unknowns"] += 1
            if state["consecutive_unknowns"] >= CONSEC_UNKNOWN_LIMIT:
                print(f"[SECURITY] {CONSEC_UNKNOWN_LIMIT} consecutive unknowns - ALARM")
                trigger_alarm()
                state["consecutive_unknowns"] = 0
        else:
            state["consecutive_unknowns"] = 0
        
        # Track denial streak
        state["denial_timestamps"].append(now)
        # Remove old entries
        cutoff = now - DENIAL_STREAK_WINDOW_S
        while state["denial_timestamps"] and state["denial_timestamps"][0] < cutoff:
            state["denial_timestamps"].popleft()
        
        if len(state["denial_timestamps"]) >= DENIAL_STREAK_LIMIT:
            print(f"[SECURITY] {DENIAL_STREAK_LIMIT} denials in {DENIAL_STREAK_WINDOW_S}s - ALARM")
            trigger_alarm()
            state["denial_timestamps"].clear()
    else:
        # Successful access resets unknown counter
        state["consecutive_unknowns"] = 0

def trigger_alarm():
    """Trigger full security alarm."""
    print("[ALARM] SECURITY ALERT TRIGGERED")
    state["session_counts"]["alarm"] += 1
    
    # Send to Arduino
    send_to_arduino("A")
    
    # Flash LED rapidly
    flash_led("red", flashes=12, duration=0.07)
    
    # Log event
    log_event("SECURITY ALARM triggered")

def trigger_access(level: str, name: str = "Unknown", cooldown: bool = False):
    """
    Core function to trigger physical outputs based on access level.
    Called by handle_recognition_result() from Marcus.
    """
    if shutdown_event.is_set():
        return
    
    # Check lockdown (except override)
    if lockdown_active.is_set() and level != "override":
        print(f"[LOCKDOWN] Blocked {name} - {level}")
        send_to_arduino("L")
        flash_led("red", flashes=6)
        log_event(f"LOCKDOWN BLOCK: {name} - {level}")
        return
    
    # Get level config
    config = ACCESS_LEVELS.get(level, ACCESS_LEVELS["denied"])
    
    # Log the event
    log_msg = f"ACCESS: {name} - {level.upper()}"
    if cooldown:
        log_msg += " (COOLDOWN BLOCK)"
    print(f"[{log_msg}]")
    
    # Update statistics
    state["session_counts"][level] = state["session_counts"].get(level, 0) + 1
    
    # Add to history (skip test names)
    if name not in ["Unknown", "Dashboard", "BTN0", "BTN1", "BTN2", "Scanning..."]:
        timestamp = datetime.datetime.now().strftime("%H:%M:%S")
        state["access_history"].appendleft(f"[{timestamp}] {name:<20} {level.upper()}")
    
    # Update cooldown for successful access
    if level in ["standard", "vip", "guest", "override"] and not cooldown:
        if name and name not in ["Unknown", "Scanning..."]:
            state["access_cooldowns"][name] = time.time()
    
    # Track security events
    if not cooldown:
        track_security_events(name, level)
    
    # Send command to Arduino
    send_to_arduino(config["cmd"])
    
    # Handle PYNQ LED patterns
    if level == "denied":
        flash_led(config["color"], flashes=4)
    elif level == "pending":
        led_pattern_pulse(config["color"], config["duration"])
    elif level == "flagged":
        led_pattern_double_flash(config["color"], config["duration"])
    elif level in ["alarm", "lockdown"]:
        flash_led(config["color"], flashes=10)
    else:
        # Standard, VIP, Guest, Override - steady LED
        set_led_color(config["color"])
        time.sleep(config["duration"])
        led_off()
    
    # Save capture at night if this is a security event
    if level in ["denied", "flagged"] and is_night() and not cooldown:
        print(f"[NIGHT MODE] {level} event - would save capture")

def handle_recognition_result(name: str, level: str, frame=None):
    """
    ╔══════════════════════════════════════════════════════════════╗
    ║              MAIN INTEGRATION HOOK - CALL FROM MARCUS       ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  Args:                                                       ║
    ║    name  str - Person's name or "Unknown"                    ║
    ║    level str - One of: standard, vip, guest, denied,        ║
    ║                      pending, flagged, override             ║
    ║    frame ndarray - Optional face image from Archit          ║
    ╚══════════════════════════════════════════════════════════════╝
    """
    # Check cooldown for grant levels
    if level in ["standard", "vip", "guest", "override"]:
        if not check_cooldown(name):
            return
    
    # Spawn thread to handle access (non-blocking for Marcus)
    t = threading.Thread(
        target=trigger_access,
        args=(level, name),
        daemon=False
    )
    state["active_threads"].append(t)
    t.start()

# =============================================================================
# SECTION 9 - PARSING COMMANDS FROM ARCHIT (via serial)
# =============================================================================

def parse_archit_command(line: str):
    """
    Parse commands from Archit's FPGA.
    Format: "name|level|mode\n"
    Example: "prof_smith|vip|night\n"
    Example: "Unknown|denied|day\n"
    """
    line = line.strip()
    if not line:
        return
    
    print(f"[ARCHIT] Received: {line}")
    
    # Parse the pipe-delimited format
    parts = line.split('|')
    
    if len(parts) >= 2:
        name = parts[0]
        level = parts[1].lower()
        
        # Check for mode override (optional)
        if len(parts) >= 3:
            mode = parts[2].lower()
            if mode in ['day', 'night']:
                state["explicit_mode"] = mode
                print(f"[MODE] Set to {mode.upper()} from Archit")
        
        # Trigger the access
        handle_recognition_result(name, level)
    else:
        print(f"[ERROR] Invalid format from Archit: {line}")

def listen_to_archit_loop():
    """
    Background thread that listens for commands from Archit's FPGA.
    Archit sends: "name|level|mode\n" over serial
    """
    # Connect to Archit's serial output
    # This could be USB serial or TCP socket depending on setup
    archit_port = "/dev/ttyUSB1"  # Adjust as needed
    archit_baud = 9600
    
    try:
        archit_serial = serial.Serial(
            port=archit_port,
            baudrate=archit_baud,
            timeout=1
        )
        print(f"[ARCHIT] Listening on {archit_port}")
        
        buffer = ""
        while not shutdown_event.is_set():
            if archit_serial.in_waiting > 0:
                data = archit_serial.read(archit_serial.in_waiting).decode()
                buffer += data
                
                # Process complete lines
                while '\n' in buffer:
                    line, buffer = buffer.split('\n', 1)
                    parse_archit_command(line)
            
            time.sleep(0.1)
            
    except Exception as e:
        print(f"[ARCHIT] Connection error: {e}")
        print("[ARCHIT] Will use simulation mode")

# =============================================================================
# SECTION 10 - LOGGING FUNCTIONS
# =============================================================================

def log_event(message: str):
    """Write timestamped event to log file."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_line = f"[{timestamp}] {message}"
    
    # Write to file
    with open(LOG_FILE, "a") as f:
        f.write(log_line + "\n")
    
    # Also print to console
    print(log_line)

def generate_daily_report():
    """Generate end-of-day report."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open(REPORT_FILE, "w") as f:
        f.write("="*50 + "\n")
        f.write(f"DAILY ACCESS REPORT - {timestamp}\n")
        f.write("="*50 + "\n\n")
        
        f.write("SESSION STATISTICS:\n")
        for level, count in state["session_counts"].items():
            f.write(f"  {level.upper():10}: {count}\n")
        
        f.write("\nACCESS HISTORY:\n")
        for entry in state["access_history"]:
            f.write(f"  {entry}\n")
        
        f.write("\n" + "="*50 + "\n")
    
    log_event(f"Daily report generated: {REPORT_FILE}")

# =============================================================================
# SECTION 11 - DASHBOARD WIDGETS (Jupyter)
# =============================================================================

def create_dashboard():
    """Create interactive Jupyter dashboard."""
    if not PYNQ_AVAILABLE:
        print("[DASHBOARD] Not available in simulation mode")
        return
    
    # Create widgets
    header = widgets.HTML("<h2>🐒 ATTENDANCE OUTPUT NODE - Thanus</h2>")
    
    # Status row
    status_label = widgets.HTML("<b>Status:</b> <span style='color:green'>MONITORING</span>")
    mode_label = widgets.HTML(f"<b>Mode:</b> {'🌙 NIGHT' if is_night() else '☀️ DAY'}")
    arduino_label = widgets.HTML(f"<b>Arduino:</b> {'✅' if state['arduino_connected'] else '❌'}")
    
    # Statistics
    stats = widgets.HTML(self._get_stats_html())
    
    # Access history
    history = widgets.Textarea(
        value="\n".join(state["access_history"]),
        description="History:",
        layout=widgets.Layout(width="100%", height="150px")
    )
    
    # Control buttons
    btn_std = widgets.Button(description="✅ Standard", button_style='success')
    btn_vip = widgets.Button(description="🔵 VIP", button_style='info')
    btn_guest = widgets.Button(description="🟡 Guest", button_style='warning')
    btn_denied = widgets.Button(description="🔴 Denied", button_style='danger')
    btn_pending = widgets.Button(description="🔷 Pending")
    btn_flagged = widgets.Button(description="🟣 Flagged")
    btn_override = widgets.Button(description="⚪ Override")
    btn_alarm = widgets.Button(description="🚨 ALARM", button_style='danger')
    btn_lockdown = widgets.Button(description="🔒 Lockdown", button_style='danger')
    
    # Style special buttons
    btn_pending.style.button_color = '#008080'
    btn_pending.style.text_color = 'white'
    btn_flagged.style.button_color = '#8B008B'
    btn_flagged.style.text_color = 'white'
    btn_override.style.button_color = '#444444'
    btn_override.style.text_color = 'white'
    
    # Wire up buttons
    btn_std.on_click(lambda b: handle_recognition_result("Dashboard", "standard"))
    btn_vip.on_click(lambda b: handle_recognition_result("Dashboard", "vip"))
    btn_guest.on_click(lambda b: handle_recognition_result("Dashboard", "guest"))
    btn_denied.on_click(lambda b: handle_recognition_result("Dashboard", "denied"))
    btn_pending.on_click(lambda b: handle_recognition_result("Dashboard", "pending"))
    btn_flagged.on_click(lambda b: handle_recognition_result("Dashboard", "flagged"))
    btn_override.on_click(lambda b: handle_recognition_result("Dashboard", "override"))
    btn_alarm.on_click(lambda b: trigger_alarm())
    
    def toggle_lockdown(b):
        if lockdown_active.is_set():
            lockdown_active.clear()
            btn_lockdown.description = "🔒 Lockdown"
            btn_lockdown.button_style = 'danger'
        else:
            lockdown_active.set()
            btn_lockdown.description = "🔓 Unlock"
            btn_lockdown.button_style = 'success'
            send_to_arduino("L")
            flash_led("red", flashes=6)
    
    btn_lockdown.on_click(toggle_lockdown)
    
    # Layout
    dashboard = widgets.VBox([
        header,
        widgets.HBox([status_label, mode_label, arduino_label]),
        stats,
        widgets.HTML("<b>Access Controls:</b>"),
        widgets.HBox([btn_std, btn_vip, btn_guest]),
        widgets.HBox([btn_pending, btn_flagged, btn_override]),
        widgets.HBox([btn_denied, btn_alarm, btn_lockdown]),
        widgets.HTML("<b>Access History:</b>"),
        history
    ])
    
    return dashboard

def _get_stats_html(self):
    """Generate HTML for statistics display."""
    s = state["session_counts"]
    total = sum(s.values())
    return f"""
    <div style='border:1px solid #ccc; padding:10px; margin:10px 0'>
        <b>Session Statistics:</b><br>
        Total: {total} | 
        ✅ {s['standard']} | 🔵 {s['vip']} | 🟡 {s['guest']} |
        🔴 {s['denied']} | 🔷 {s['pending']} | 🟣 {s['flagged']} |
        ⚪ {s['override']} | 🚨 {s['alarm']}
    </div>
    """

# =============================================================================
# SECTION 12 - PHYSICAL BUTTON HANDLING
# =============================================================================

def button_monitor_loop():
    """Monitor physical PYNQ buttons (BTN0, BTN1, BTN2, BTN3)."""
    while not shutdown_event.is_set() and PYNQ_AVAILABLE and buttons:
        time.sleep(0.05)  # 20Hz poll
        
        now = time.time()
        
        # BTN0 - Standard access
        if buttons[0].read() == 1 and (now - state["last_btn0"]) > BTN_DEBOUNCE_S:
            state["last_btn0"] = now
            handle_recognition_result("BTN0", "standard")
        
        # BTN1 - VIP access
        if buttons[1].read() == 1 and (now - state["last_btn1"]) > BTN_DEBOUNCE_S:
            state["last_btn1"] = now
            handle_recognition_result("BTN1", "vip")
        
        # BTN2 - Guest access
        if buttons[2].read() == 1 and (now - state["last_btn2"]) > BTN_DEBOUNCE_S:
            state["last_btn2"] = now
            handle_recognition_result("BTN2", "guest")
        
        # BTN3 - Shutdown
        if buttons[3].read() == 1:
            print("[BUTTON] BTN3 pressed - shutting down...")
            shutdown_event.set()
            break

# =============================================================================
# SECTION 13 - HEARTBEAT INDICATOR
# =============================================================================

def heartbeat_loop():
    """Blink LED 3 to show system is alive."""
    while not shutdown_event.is_set():
        if PYNQ_AVAILABLE and led_heartbeat:
            led_heartbeat.on()
            time.sleep(0.5)
            led_heartbeat.off()
            time.sleep(0.5)
        else:
            time.sleep(1)

# =============================================================================
# SECTION 14 - SYSTEM STARTUP
# =============================================================================

def start_system():
    """Initialize and start all system components."""
    print("\n" + "="*60)
    print("ATTENDANCE OUTPUT NODE - Thanus")
    print("Physical Response Layer for Face Recognition System")
    print("="*60 + "\n")
    
    # 1. Connect to Arduino (servo + buzzer)
    print("[1/6] Connecting to Arduino...")
    arduino = connect_arduino()
    state["arduino"] = arduino
    
    # 2. Run LED boot sequence
    print("[2/6] Running LED self-test...")
    led_boot_sequence()
    
    # 3. Send boot signal to Arduino
    if arduino:
        send_to_arduino("B")  # Boot complete
    
    # 4. Start background threads
    print("[3/6] Starting background threads...")
    
    # Thread to listen to Archit's commands
    archit_thread = threading.Thread(target=listen_to_archit_loop, daemon=False)
    archit_thread.start()
    state["active_threads"].append(archit_thread)
    
    # Thread for physical buttons
    button_thread = threading.Thread(target=button_monitor_loop, daemon=False)
    button_thread.start()
    state["active_threads"].append(button_thread)
    
    # Thread for Arduino heartbeat
    heartbeat_arduino = threading.Thread(target=arduino_heartbeat_loop, daemon=False)
    heartbeat_arduino.start()
    state["active_threads"].append(heartbeat_arduino)
    
    # Thread for LED heartbeat
    heartbeat_led = threading.Thread(target=heartbeat_loop, daemon=False)
    heartbeat_led.start()
    state["active_threads"].append(heartbeat_led)
    
    # 5. Create dashboard
    print("[4/6] Creating dashboard...")
    if PYNQ_AVAILABLE:
        dashboard = create_dashboard()
        if dashboard:
            from IPython.display import display
            display(dashboard)
    
    # 6. Log startup
    print("[5/6] Initializing logging...")
    log_event("SYSTEM STARTED - Output Node v1.0")
    
    print("[6/6] System ready!\n")
    print("Waiting for commands from Archit's FPGA...")
    print("Or use dashboard buttons to test manually\n")

def shutdown():
    """Clean shutdown of all components."""
    print("\n[SHUTDOWN] Cleaning up...")
    
    # Signal all threads to stop
    shutdown_event.set()
    
    # Turn off all LEDs
    if PYNQ_AVAILABLE:
        led_off()
        if led_heartbeat:
            led_heartbeat.off()
        if led_status:
            led_status.off()
    
    # Close Arduino connection
    if state["arduino"]:
        try:
            state["arduino"].close()
            print("[SHUTDOWN] Arduino disconnected")
        except:
            pass
    
    # Wait for threads to finish
    for thread in state["active_threads"]:
        thread.join(timeout=2)
    
    # Generate final report
    generate_daily_report()
    
    print("[SHUTDOWN] Complete")

# =============================================================================
# SECTION 15 - MAIN ENTRY POINT
# =============================================================================

if __name__ == "__main__" or "get_ipython" in globals():
    try:
        start_system()
        
        # Keep running in Jupyter
        import IPython
        ipython = IPython.get_ipython()
        if ipython:
            print("\n" + "="*60)
            print("System running. Available commands:")
            print("  shutdown()     - Clean shutdown")
            print("  test_access()  - Run test sequence")
            print("  status()       - Show current status")
            print("="*60 + "\n")
            
            def test_access():
                """Test all access levels."""
                levels = ["standard", "vip", "guest", "denied", "pending", "flagged", "override"]
                for level in levels:
                    print(f"\nTesting: {level}")
                    handle_recognition_result("TEST", level
