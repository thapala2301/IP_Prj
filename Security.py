# =============================================================================
# ATTENDANCE ADD-ONS 
# =============================================================================
# Physical response node for face recognition attendance system.
# Receives access decisions from AWS and drives:
#   · PYNQ-Z2 RGB LED (7 states, distinct colour + flash patterns)
#   · Arduino Uno servo (physical door) + buzzer (audio feedback)
#   · Live Jupyter dashboard with session stats, history, event log
#   · Day/night mode via time-of-day (LDR swap-in ready)
#   · Auto-escalation, cooldown, lockdown, heartbeat monitoring
#
# ENTRY POINT (Marcus calls this):
#   handle_recognition_result(name, clearance_level, frame=None)
#
# SETUP:
#   pip install pyserial
#   jupyter nbextension enable --py widgetsnbextension --sys-prefix
#   Update ARDUINO_PORT below, then run this file in Jupyter.
# =============================================================================

import json
import subprocess
import time
import threading
import datetime
import ipywidgets as widgets
from IPython.display import display, clear_output
from pynq.overlays.base import BaseOverlay
from collections import deque

try:
    import serial
    SERIAL_AVAILABLE = True
except ImportError:
    SERIAL_AVAILABLE = False
    print("[WARNING] pyserial not installed — run: pip install pyserial")

# =============================================================================
# SECTION 1 — TUNEABLE CONSTANTS
# Edit these values to tune behaviour. Do not edit logic below.
# =============================================================================

# --- Serial ---
ARDUINO_PORT            = "/dev/ttyUSB0"  # run: ls /dev/ttyUSB* or ls /dev/ttyACM*
ARDUINO_BAUDRATE        = 9600
ARDUINO_TIMEOUT_S       = 2

# --- Light / day-night ---
NIGHT_START_HOUR        = 20   # 8pm — start of night mode (time-of-day fallback)
NIGHT_END_HOUR          = 8    # 8am — end of night mode
NIGHT_THRESHOLD_V       = 0.5  # Voltage below which = night (physical LDR only)

# --- Access behaviour ---
ACCESS_COOLDOWN_S       = 30   # Same person blocked for this many seconds after entry
BTN_DEBOUNCE_S          = 2.0  # Min gap between physical PYNQ button presses
CONSEC_UNKNOWN_LIMIT    = 3    # Unknown denials in a row before auto-alarm
DENIAL_STREAK_LIMIT     = 5    # Denials in DENIAL_STREAK_WINDOW_S before sustained alarm
DENIAL_STREAK_WINDOW_S  = 120  # Rolling window for denial streak check (seconds)
ARDUINO_PING_INTERVAL_S = 30   # Seconds between Arduino heartbeat pings

# --- Logging / display ---
LOG_FILE                = "attendance_log.txt"
REPORT_FILE             = "daily_report.txt"
MAX_LOG_DISPLAY         = 12
MAX_HISTORY_DISPLAY     = 20

# --- Access level definitions ---
# Confirmed RGB LED colour map for this PYNQ board:
# 0=off  1=blue  2=green  3=cyan  4=red  5=magenta  6=yellow  7=white
#
# serial_cmd: single char sent to Arduino Uno over USB serial
ACCESS_LEVELS = {
    "standard": {"color": 2, "label": "Standard", "duration": 3, "cmd": "G"},  # green
    "vip":      {"color": 1, "label": "VIP",      "duration": 3, "cmd": "V"},  # blue
    "guest":    {"color": 6, "label": "Guest",    "duration": 3, "cmd": "U"},  # yellow
    "denied":   {"color": 4, "label": "DENIED",   "duration": 1, "cmd": "D"},  # red strobe
    "pending":  {"color": 3, "label": "Pending",  "duration": 5, "cmd": "P"},  # cyan pulse
    "flagged":  {"color": 5, "label": "Flagged",  "duration": 4, "cmd": "F"},  # magenta flash
    "override": {"color": 7, "label": "Override", "duration": 3, "cmd": "O"},  # white
}

# --- Face recognition name lists ---
# Match stems of filenames in Shashank's known_faces/ directory
# e.g. "prof_smith.jpg" → "prof_smith"
VIP_NAMES     = []   # → blue LED + door opens + 2 rising beeps + fast-tracked
FLAGGED_NAMES = []   # → magenta flash + alarm beeps + always saves face image

# =============================================================================
# SECTION 2 — HARDWARE SETUP
# =============================================================================

base     = BaseOverlay("base.bit")
LED_MAP  = [base.leds[i] for i in range(4)]
LOCK_LED = base.rgbleds[4]

# --- Light sensor ---
# Currently: time-of-day fallback. Night = NIGHT_START_HOUR to NIGHT_END_HOUR.
#
# TO ENABLE PHYSICAL LDR (at meetup):
#   1. Plug LDR into PMODA header (voltage divider with 10kΩ to GND)
#   2. Uncomment the three lines in OPTION A below
#   3. Calibrate NIGHT_THRESHOLD_V by printing read_light() in bright vs dark room

LIGHT_SENSOR_AVAILABLE = False
_pmod_adc              = None

# OPTION A — Pmod ADC on PMODA (uncomment when LDR is connected):
# from pynq.lib import Pmod_ADC
# _pmod_adc = Pmod_ADC(base.PMODA)
# LIGHT_SENSOR_AVAILABLE = True

def read_light() -> float:
    """
    Returns light reading as float.
    Physical sensor: voltage 0.0–3.3V (low = dark).
    Fallback: 0.1 at night, 2.0 during day.
    """
    if _pmod_adc:
        return _pmod_adc.read()[0]
    hour = datetime.datetime.now().hour
    return 0.1 if (hour < NIGHT_END_HOUR or hour >= NIGHT_START_HOUR) else 2.0

def is_night() -> bool:
    if LIGHT_SENSOR_AVAILABLE:
        return read_light() < NIGHT_THRESHOLD_V
    hour = datetime.datetime.now().hour
    return hour < NIGHT_END_HOUR or hour >= NIGHT_START_HOUR

# --- Arduino ---
arduino = None

def _connect_arduino():
    global arduino
    if not SERIAL_AVAILABLE:
        return
    try:
        arduino = serial.Serial(ARDUINO_PORT, ARDUINO_BAUDRATE, timeout=ARDUINO_TIMEOUT_S)
        time.sleep(2)  # Arduino resets on connect — wait for boot
        print(f"[ARDUINO] Connected on {ARDUINO_PORT}")
    except Exception as e:
        arduino = None
        print(f"[ARDUINO] Not connected ({e}) — buzzer/servo disabled, PYNQ LED still active")

def _send(cmd: str) -> bool:
    """Send single-char command to Arduino. Silent if not connected."""
    if arduino is None:
        return False
    try:
        arduino.write(cmd.encode())
        arduino.flush()
        return True
    except Exception as e:
        log_event(f"ARDUINO ERROR: '{cmd}' — {e}")
        return False

# =============================================================================
# SECTION 3 — SHARED STATE
# =============================================================================

shutdown_event  = threading.Event()
lockdown_active = threading.Event()

state = {
    "last_btn0":            0.0,
    "last_btn1":            0.0,
    "last_btn2":            0.0,
    "access_cooldowns":     {},
    "consecutive_unknowns": 0,
    "denial_timestamps":    deque(),
    "access_history":       deque(maxlen=MAX_HISTORY_DISPLAY),
    "hourly_counts":        {},        # hour (int) → count, for access rate display
    "session_counts": {
        "standard": 0, "vip": 0, "guest": 0, "denied": 0,
        "pending":  0, "flagged": 0, "override": 0, "alarm": 0,
    },
    "arduino_ok":    False,
    "active_threads": [],
}

# =============================================================================
# SECTION 4 — DASHBOARD WIDGETS
# =============================================================================

header        = widgets.HTML("<h2>🐒 Attendance Add-Ons — V9.0</h2>")
status_label  = widgets.HTML("<b>Status:</b> <span style='color:green'>MONITORING</span>")
mode_label    = widgets.HTML("<b>Env:</b> ☀️ Day")
arduino_label = widgets.HTML("<b>Arduino:</b> <span style='color:gray'>--</span>")
rate_label    = widgets.HTML("<b>Rate:</b> --")
lockdown_label= widgets.HTML("")
session_label = widgets.HTML("<b>Session:</b> loading...")

history_widget = widgets.Textarea(
    value="", placeholder="Named access history...",
    layout=widgets.Layout(width="100%", height="130px")
)
log_widget = widgets.Textarea(
    value="", placeholder="System event log...",
    layout=widgets.Layout(width="100%", height="130px")
)

# Access grant buttons
btn_std      = widgets.Button(description="✅ Authorize Standard", button_style='success')
btn_vip      = widgets.Button(description="🔵 Authorize VIP",      button_style='')
btn_guest    = widgets.Button(description="🟡 Authorize Guest",     button_style='warning')
# Special state buttons
btn_pending  = widgets.Button(description="🔷 Simulate Pending",   button_style='')
btn_flagged  = widgets.Button(description="⚠️ Simulate Flagged",   button_style='')
btn_override = widgets.Button(description="⚪ Supervisor Override", button_style='')
# Security buttons
btn_denied   = widgets.Button(description="🔴 Simulate DENY",      button_style='danger')
btn_alarm    = widgets.Button(description="🚨 MANUAL ALARM",       button_style='danger')
btn_lockdown = widgets.Button(description="🔒 NIGHT LOCKDOWN",     button_style='danger')
btn_unlock   = widgets.Button(description="🔓 Lift Lockdown",      button_style='warning')

btn_vip.style.button_color      = '#003080'; btn_vip.style.text_color      = 'white'
btn_pending.style.button_color  = '#008080'; btn_pending.style.text_color  = 'white'
btn_flagged.style.button_color  = '#8B008B'; btn_flagged.style.text_color  = 'white'
btn_override.style.button_color = '#444444'; btn_override.style.text_color = 'white'
btn_lockdown.style.button_color = '#1a1a1a'; btn_lockdown.style.text_color = 'white'

guide = widgets.HTML("""
<div style='border:1px solid #ccc;padding:10px;background:#f9f9f9;font-size:12px;line-height:1.65'>
  <b>📋 ACCESS LEVELS</b><br>
  🟢 Standard — green LED · servo opens · 1 beep<br>
  🔵 VIP — blue LED · servo opens · rising 2-beep · <i>fast-tracked (no pending wait)</i><br>
  🟡 Guest — yellow LED · servo opens · soft beep<br>
  🔴 Denied — red strobe · door shut · 3 descending beeps<br>
  🔷 Pending — cyan pulse · door shut · slow pulse beep · <i>fires automatically while AWS decides</i><br>
  🟣 Flagged — magenta double-flash · door shut · alarm pattern · always saves face image<br>
  ⚪ Override — white LED · servo opens · long beep · bypasses lockdown<br><br>

  <b>⚡ AUTO-ESCALATION</b><br>
  3 consecutive unknown denials → sustained alarm<br>
  5 denials in 2 min → sustained alarm + security alert<br>
  Same person within 30s → cooldown block (anti-tailgate)<br><br>

  <b>🔒 LOCKDOWN</b> — refuses all access except Override. Lift with 🔓 button.<br><br>

  <b>🌙 DAY/NIGHT</b> — night (8pm–8am): denied/flagged also saves Archit's face frame.<br><br>

  <b>📟 PHYSICAL BUTTONS</b> — BTN0=Standard · BTN1=VIP · BTN2=Guest · BTN3=Shutdown
</div>
""")

dashboard = widgets.VBox([
    header, guide,
    widgets.HBox([status_label, mode_label, arduino_label, rate_label]),
    widgets.HBox([lockdown_label]),
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
# SECTION 5 — LOGGING & DISPLAY
# =============================================================================

def log_event(message: str):
    """Write timestamped event to file and live log widget (newest first)."""
    ts   = time.strftime('%Y-%m-%d %H:%M:%S')
    line = f"[{ts}] {message}"
    with open(LOG_FILE, "a") as f:
        f.write(line + "\n")
    current = log_widget.value.split("\n") if log_widget.value.strip() else []
    current.insert(0, line)
    log_widget.value = "\n".join(current[:MAX_LOG_DISPLAY])


def log_access_history(name: str, level_key: str):
    """Add named entry to scrollable history widget. Skips test/unknown names."""
    skip = {"Unknown", "Scanning...", "NO_MATCH", ""}
    if name in skip or name.startswith("Dashboard") or name.startswith("BTN"):
        return
    ts    = time.strftime('%H:%M:%S')
    label = ACCESS_LEVELS.get(level_key, {}).get("label", level_key.upper())
    state["access_history"].appendleft(f"[{ts}]  {name:<20} {label}")
    history_widget.value = "\n".join(state["access_history"])

    # Track hourly access rate
    hour = datetime.datetime.now().hour
    state["hourly_counts"][hour] = state["hourly_counts"].get(hour, 0) + 1


def update_session_label():
    s = state["session_counts"]
    session_label.value = (
        f"<b>Session:</b> ✅{s['standard']} 🔵{s['vip']} 🟡{s['guest']} "
        f"🔴{s['denied']} 🔷{s['pending']} 🟣{s['flagged']} "
        f"⚪{s['override']} 🚨{s['alarm']}"
    )


def update_status_bar():
    """Refresh mode, Arduino status, and live access rate label."""
    # Day/night
    night = is_night()
    hour  = datetime.datetime.now().hour
    if LIGHT_SENSOR_AVAILABLE:
        lux = read_light()
        mode_label.value = f"<b>Env:</b> {'🌙 Night' if night else '☀️ Day'} | {lux:.2f}V"
    else:
        mode_label.value = f"<b>Env:</b> {'🌙 Night' if night else '☀️ Day'} | 🕐 {hour:02d}:xx"

    # Arduino
    col = "green" if state["arduino_ok"] else "orange"
    txt = "✅ Connected" if state["arduino_ok"] else "⚠️ Not connected"
    arduino_label.value = f"<b>Arduino:</b> <span style='color:{col}'>{txt}</span>"

    # Access rate — entries this hour
    count = state["hourly_counts"].get(hour, 0)
    rate_label.value = f"<b>This hour:</b> {count} entr{'y' if count==1 else 'ies'}"

    # Heartbeat on LED3
    LED_MAP[3].on() if int(time.time()) % 2 == 0 else LED_MAP[3].off()


def generate_daily_report():
    """Append session summary to REPORT_FILE."""
    s     = state["session_counts"]
    total = sum(s.values())
    now   = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    lines = [
        f"DAILY ACCESS REPORT — {now}",
        "=" * 50,
        f"Total events : {total}",
        f"Standard     : {s['standard']}",
        f"VIP          : {s['vip']}",
        f"Guest        : {s['guest']}",
        f"Denied       : {s['denied']}",
        f"Flagged      : {s['flagged']}",
        f"Override     : {s['override']}",
        f"Alarms       : {s['alarm']}",
        "",
        "NAMED ACCESS HISTORY:",
        "-" * 40,
    ] + (list(state["access_history"]) or ["(none)"])
    with open(REPORT_FILE, "a") as f:
        f.write("\n".join(lines) + "\n\n")
    log_event(f"REPORT: Written to {REPORT_FILE}")

# =============================================================================
# SECTION 6 — HARDWARE RESPONSE
# =============================================================================

def flash_alarm(flashes: int = 6):
    """Red strobe on PYNQ RGB LED. Shutdown-safe."""
    for _ in range(flashes):
        if shutdown_event.is_set(): break
        LOCK_LED.write(4); time.sleep(0.08)
        if shutdown_event.is_set(): break
        LOCK_LED.write(0); time.sleep(0.08)


def led_boot_sequence():
    """Cycle all 7 colours on startup — visual hardware self-check."""
    log_event("SYSTEM: Boot sequence — checking all LED colours")
    for code in [2, 1, 6, 4, 3, 5, 7]:
        if shutdown_event.is_set(): break
        LOCK_LED.write(code)
        time.sleep(0.35)
    LOCK_LED.write(0)
    log_event("SYSTEM: Boot sequence complete ✓")


def save_frame(frame, reason: str) -> str:
    """Save face frame image. Only called when Archit passes a frame in."""
    try:
        import cv2
        ts       = time.strftime("%Y%m%d_%H%M%S")
        filename = f"capture_{reason}_{ts}.jpg"
        cv2.imwrite(filename, frame)
        return filename
    except Exception as e:
        log_event(f"CAPTURE ERROR: {e}")
        return ""

# =============================================================================
# SECTION 7 — ACCESS CONTROL LOGIC
# =============================================================================

def _check_cooldown(name: str) -> bool:
    """Block re-entry within ACCESS_COOLDOWN_S. Returns True if allowed."""
    if not name or name in ("Unknown", "Scanning...") or name.startswith(("Dashboard", "BTN")):
        return True
    now  = time.time()
    last = state["access_cooldowns"].get(name, 0)
    if now - last < ACCESS_COOLDOWN_S:
        remaining = int(ACCESS_COOLDOWN_S - (now - last))
        log_event(f"COOLDOWN: {name} blocked — {remaining}s remaining")
        status_label.value = (
            f"<b>Status:</b> <span style='color:orange'>⏱ COOLDOWN — {name} ({remaining}s)</span>"
        )
        _send("D")
        time.sleep(1)
        if not lockdown_active.is_set():
            status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"
        return False
    return True


def _track_denials(name: str, is_denial: bool):
    """
    Update consecutive-unknown and denial-streak counters.
    Fires alarm automatically if thresholds are breached.
    """
    now = time.time()

    if is_denial:
        # Consecutive unknown check
        if name in ("Unknown", "NO_MATCH", ""):
            state["consecutive_unknowns"] += 1
            if state["consecutive_unknowns"] >= CONSEC_UNKNOWN_LIMIT:
                log_event(
                    f"SECURITY ALERT: {CONSEC_UNKNOWN_LIMIT} consecutive unknown "
                    f"denials — alarm triggered"
                )
                _fire_alarm()
                state["consecutive_unknowns"] = 0
        else:
            state["consecutive_unknowns"] = 0

        # Denial streak check
        state["denial_timestamps"].append(now)
        cutoff = now - DENIAL_STREAK_WINDOW_S
        while state["denial_timestamps"] and state["denial_timestamps"][0] < cutoff:
            state["denial_timestamps"].popleft()
        if len(state["denial_timestamps"]) >= DENIAL_STREAK_LIMIT:
            log_event(
                f"SECURITY ALERT: {DENIAL_STREAK_LIMIT} denials in "
                f"{DENIAL_STREAK_WINDOW_S}s — sustained alarm triggered"
            )
            _fire_alarm()
            state["denial_timestamps"].clear()
    else:
        # Successful access — reset consecutive unknown counter
        state["consecutive_unknowns"] = 0


def _fire_alarm():
    """Trigger full alarm — PYNQ strobe + Arduino + session count."""
    state["session_counts"]["alarm"] += 1
    update_session_label()
    _send("A")
    t = threading.Thread(target=flash_alarm, args=(12,), daemon=False)
    state["active_threads"].append(t)
    t.start()


def trigger_access(level_key: str, name: str = "Unknown", frame=None):
    """
    Central access handler.
    Drives PYNQ RGB LED + sends serial command to Arduino on every event.
    """
    if shutdown_event.is_set():
        return

    # Lockdown check — only override bypasses
    if lockdown_active.is_set() and level_key != "override":
        log_event(f"LOCKDOWN: {name} blocked")
        status_label.value = "<b>Status:</b> <span style='color:red'>🔒 LOCKDOWN — ACCESS BLOCKED</span>"
        _send("L")
        flash_alarm(flashes=3)
        time.sleep(1)
        status_label.value = "<b>Status:</b> <span style='color:red'>🔒 LOCKDOWN ACTIVE</span>"
        return

    # Cooldown check for granted levels
    if level_key in ("standard", "vip", "guest", "override"):
        if not _check_cooldown(name):
            return

    level    = ACCESS_LEVELS[level_key]
    color    = level["color"]
    label    = level["label"]
    duration = level["duration"]
    cmd      = level["cmd"]

    # Log, history, counter
    log_event(f"ACCESS [{label}]: {name}")
    log_access_history(name, level_key)
    state["session_counts"][level_key] += 1
    update_session_label()

    # Store cooldown timestamp
    if name and name not in ("Unknown", "Scanning...") and not name.startswith(("Dashboard", "BTN")):
        state["access_cooldowns"][name] = time.time()

    # Send to Arduino
    _send(cmd)

    # ── PYNQ LED behaviour ──────────────────────────────────────────────────

    if level_key == "denied":
        status_label.value = f"<b>Status:</b> <span style='color:red'>🔴 DENIED — {name}</span>"
        _track_denials(name, is_denial=True)
        if frame is not None and is_night():
            fname = save_frame(frame, "denied")
            if fname: log_event(f"CAPTURE: Night denial → {fname}")
        flash_alarm(flashes=4)

    elif level_key == "pending":
        status_label.value = f"<b>Status:</b> <span style='color:darkcyan'>🔷 VERIFYING — {name}</span>"
        for _ in range(duration * 10):
            if shutdown_event.is_set(): break
            LOCK_LED.write(color) if int(time.time() * 2) % 2 == 0 else LOCK_LED.write(0)
            time.sleep(0.1)
        LOCK_LED.write(0)

    elif level_key == "flagged":
        status_label.value = f"<b>Status:</b> <span style='color:purple'>⚠️ FLAGGED — {name}</span>"
        _track_denials(name, is_denial=True)
        for _ in range(3):
            if shutdown_event.is_set(): break
            LOCK_LED.write(color); time.sleep(0.15)
            LOCK_LED.write(0);     time.sleep(0.10)
            LOCK_LED.write(color); time.sleep(0.15)
            LOCK_LED.write(0);     time.sleep(0.50)
        if frame is not None:
            fname = save_frame(frame, "flagged")
            if fname: log_event(f"CAPTURE: Flagged → {fname}")

    else:
        # standard / vip / guest / override — door opens
        colors = {"override": "gray", "vip": "blue", "standard": "green", "guest": "goldenrod"}
        col_str = colors.get(level_key, "blue")
        status_label.value = (
            f"<b>Status:</b> <span style='color:{col_str}'>🔓 {label.upper()} — {name}</span>"
        )
        LOCK_LED.write(color)
        for _ in range(duration * 10):
            if shutdown_event.is_set(): break
            time.sleep(0.1)
        LOCK_LED.write(0)
        _track_denials(name, is_denial=False)

    if not shutdown_event.is_set() and not lockdown_active.is_set():
        status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"

# =============================================================================
# SECTION 8 — PUBLIC INTEGRATION HOOKS
# =============================================================================

def handle_recognition_result(name: str, clearance_level: str, frame=None):
    """
    ╔══════════════════════════════════════════════════════════════╗
    ║              MAIN INTEGRATION HOOK — call from AWS           ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  Args:                                                       ║
    ║    name            str  — person's name, or "Unknown"        ║
    ║    clearance_level str  — one of:                            ║
    ║                          "standard" "vip"  "guest"           ║
    ║                          "denied"   "pending"                ║
    ║                          "flagged"  "override"               ║
    ║    frame           ndarray (optional)                        ║
    ║                    Archit's face image — used for capture    ║
    ║                    on denied/flagged. Pass None if n/a.      ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  Examples:                                                   ║
    ║    handle_recognition_result("prof_smith", "vip")            ║
    ║    handle_recognition_result("Unknown", "denied")            ║
    ║    handle_recognition_result("", "pending")   # mid-process  ║
    ║    handle_recognition_result("jane", "denied", frame=img)    ║
    ╚══════════════════════════════════════════════════════════════╝
    """
    t = threading.Thread(
        target=trigger_access,
        args=(clearance_level, name, frame),
        daemon=False
    )
    state["active_threads"].append(t)
    t.start()


def _map_to_level(name: str, status: str) -> str:
    """Map Shashank's match_face.py output to an access level string."""
    if status != "MATCH" or name in ("NO_MATCH", ""):
        return "denied"
    if name in FLAGGED_NAMES: return "flagged"
    if name in VIP_NAMES:     return "vip"
    return "standard"


def process_face_image(image_path: str, frame=None) -> None:
    """
    Shashank bridge.
    Call from Archit's pipeline when a face image is ready to check.
    Fires pending immediately, runs match_face.py, then triggers full response.

    Args:
        image_path : path to face image file
        frame      : optional ndarray from Archit for night capture
    """
    if shutdown_event.is_set():
        return

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
        log_event("RECOGNITION ERROR: match_face.py timed out after 15s")
        handle_recognition_result("Unknown", "denied", frame)
        return
    except Exception as e:
        log_event(f"RECOGNITION ERROR: {e}")
        handle_recognition_result("Unknown", "denied", frame)
        return

    status   = output.get("status", "NO_MATCH")
    name     = output.get("match_label", "Unknown")
    distance = output.get("match_distance")
    level    = _map_to_level(name, status)
    dist_str = f" (dist={distance:.3f})" if distance is not None else ""
    log_event(f"RECOGNITION: {name} → {level.upper()}{dist_str}")
    handle_recognition_result(name, level, frame)

# =============================================================================
# SECTION 9 — BUTTON CALLBACKS
# =============================================================================

def _btn_std(b):      trigger_access("standard", "Dashboard")
def _btn_vip(b):      trigger_access("vip",      "Dashboard")
def _btn_guest(b):    trigger_access("guest",    "Dashboard")
def _btn_denied(b):   trigger_access("denied",   "Dashboard")
def _btn_pending(b):  trigger_access("pending",  "Dashboard")
def _btn_flagged(b):  trigger_access("flagged",  "Dashboard")
def _btn_override(b): trigger_access("override", "Dashboard")

def _btn_alarm(b):
    if shutdown_event.is_set(): return
    log_event("ALARM: Manual trigger")
    _fire_alarm()

def _btn_lockdown(b):
    lockdown_active.set()
    log_event("LOCKDOWN: ACTIVATED")
    lockdown_label.value = "<span style='color:red;font-weight:bold'>🔒 LOCKDOWN ACTIVE</span>"
    status_label.value   = "<b>Status:</b> <span style='color:red'>🔒 LOCKDOWN ACTIVE</span>"
    _send("L")
    t = threading.Thread(target=flash_alarm, args=(6,), daemon=False)
    state["active_threads"].append(t); t.start()

def _btn_unlock(b):
    lockdown_active.clear()
    log_event("LOCKDOWN: LIFTED")
    lockdown_label.value = ""
    status_label.value   = "<b>Status:</b> <span style='color:green'>MONITORING</span>"

btn_std.on_click(_btn_std);       btn_vip.on_click(_btn_vip)
btn_guest.on_click(_btn_guest);   btn_denied.on_click(_btn_denied)
btn_pending.on_click(_btn_pending); btn_flagged.on_click(_btn_flagged)
btn_override.on_click(_btn_override); btn_alarm.on_click(_btn_alarm)
btn_lockdown.on_click(_btn_lockdown); btn_unlock.on_click(_btn_unlock)

# =============================================================================
# SECTION 10 — BACKGROUND THREADS
# =============================================================================

def _heartbeat_loop():
    """Ping Arduino every ARDUINO_PING_INTERVAL_S. Warn on no response."""
    while not shutdown_event.is_set():
        time.sleep(ARDUINO_PING_INTERVAL_S)
        if shutdown_event.is_set() or arduino is None: continue
        try:
            arduino.write(b"?"); arduino.flush()
            time.sleep(0.3)
            if arduino.in_waiting > 0:
                resp = arduino.read(arduino.in_waiting).decode(errors="ignore")
                state["arduino_ok"] = "K" in resp
            else:
                state["arduino_ok"] = False
                log_event("ARDUINO WARNING: No heartbeat response")
            update_status_bar()
        except Exception as e:
            state["arduino_ok"] = False
            log_event(f"ARDUINO WARNING: {e}")
            update_status_bar()


def _midnight_report_loop():
    """Auto-generate daily report at midnight."""
    while not shutdown_event.is_set():
        now      = datetime.datetime.now()
        tomorrow = (now + datetime.timedelta(days=1)).replace(
            hour=0, minute=0, second=5, microsecond=0)
        secs = (tomorrow - now).total_seconds()
        slept = 0
        while slept < secs and not shutdown_event.is_set():
            time.sleep(min(60, secs - slept)); slept += 60
        if not shutdown_event.is_set():
            generate_daily_report()


def _status_update_loop():
    """Refresh status bar labels every 5 seconds."""
    while not shutdown_event.is_set():
        time.sleep(5)
        if shutdown_event.is_set(): break
        try:
            update_status_bar()
        except Exception:
            pass

# =============================================================================
# SECTION 11 — MAIN LOOP & STARTUP
# =============================================================================

def _main_loop():
    """Polls physical PYNQ buttons. Runs in background thread."""
    log_event("SYSTEM: Node started — V9.0")
    led_boot_sequence()
    status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"
    update_session_label()
    update_status_bar()
    print("\n[READY] Dashboard live. Press BTN3 on PYNQ to exit.\n")

    try:
        while base.buttons[3].read() == 0 and not shutdown_event.is_set():
            time.sleep(0.05)  # 20 Hz poll
            now = time.time()

            if base.buttons[0].read() == 1 and (now - state["last_btn0"]) > BTN_DEBOUNCE_S:
                state["last_btn0"] = now
                t = threading.Thread(target=trigger_access, args=("standard", "BTN0"), daemon=False)
                state["active_threads"].append(t); t.start()

            if base.buttons[1].read() == 1 and (now - state["last_btn1"]) > BTN_DEBOUNCE_S:
                state["last_btn1"] = now
                t = threading.Thread(target=trigger_access, args=("vip", "BTN1"), daemon=False)
                state["active_threads"].append(t); t.start()

            if base.buttons[2].read() == 1 and (now - state["last_btn2"]) > BTN_DEBOUNCE_S:
                state["last_btn2"] = now
                t = threading.Thread(target=trigger_access, args=("guest", "BTN2"), daemon=False)
                state["active_threads"].append(t); t.start()

    finally:
        shutdown_event.set()
        generate_daily_report()
        for t in state["active_threads"]:
            t.join(timeout=1.5)
        LOCK_LED.write(0)
        for l in LED_MAP: l.off()
        if arduino:
            try: arduino.close()
            except: pass
        log_event("SYSTEM: Shut down cleanly")
        status_label.value = "<b>Status:</b> <span style='color:red'>⛔ OFFLINE</span>"
        print(f"[SHUTDOWN] Log: '{LOG_FILE}' | Report: '{REPORT_FILE}'")


def start_system():
    _connect_arduino()
    state["arduino_ok"] = arduino is not None

    with out:
        clear_output(wait=True)
        display(dashboard)
    display(out)
    time.sleep(1.0)

    for target, name in [
        (_main_loop,           "main"),
        (_heartbeat_loop,      "heartbeat"),
        (_midnight_report_loop,"midnight"),
        (_status_update_loop,  "status"),
    ]:
        t = threading.Thread(target=target, daemon=False, name=name)
        state["active_threads"].append(t)
        t.start()


start_system()
