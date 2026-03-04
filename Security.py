# --- JUPYTER WIDGET CHECK ---
# If the dashboard never appears, run this in a separate cell first:
#   !jupyter nbextension enable --py widgetsnbextension
# Then restart the kernel and re-run.

import cv2
import json
import subprocess
import numpy as np
import time
import threading
import ipywidgets as widgets
from IPython.display import display, clear_output
from pynq.overlays.base import BaseOverlay
from collections import deque

# =============================================================================
# ATTENDANCE ADD-ONS — V6.0
# Self-contained output node — camera brightness, LED feedback, access control,
# intruder detection, logging. AWS/face-recognition hookable via handle_recognition_result().
# =============================================================================

# --- TUNEABLE CONSTANTS (edit these, not the logic) ---
NIGHT_THRESHOLD       = 50      # Mean pixel brightness below which = night mode
MOTION_SENSITIVITY    = 0.25    # Fraction of baseline change that triggers alert
IDLE_TIMEOUT_S        = 15      # Seconds of no activity before power save kicks in
BTN_DEBOUNCE_S        = 2.0     # Minimum seconds between physical button triggers
CAMERA_WARMUP_FRAMES  = 20      # Frames to discard before setting baseline
BASELINE_ALPHA        = 0.02    # Rolling average speed (0=frozen, 1=instant)
FPS_CAP               = 30      # Max frames per second in active mode
POWER_SAVE_FPS        = 2       # FPS when idle
INTRUDER_COOLDOWN_S   = 10      # Minimum seconds between intruder captures
LOG_FILE              = "attendance_log.txt"
MAX_LOG_DISPLAY       = 12      # Lines shown in live log widget

# --- ACCESS LEVELS ---
# Confirmed RGB LED colour map for this PYNQ board:
# 0=off, 1=blue, 2=green, 3=cyan, 4=red, 5=magenta, 6=yellow, 7=white
ACCESS_LEVELS = {
    "standard": {"color": 2, "label": "Standard", "led_duration": 3},  # green  — known user, full access
    "vip":      {"color": 1, "label": "VIP",      "led_duration": 3},  # blue   — high clearance
    "guest":    {"color": 6, "label": "Guest",    "led_duration": 3},  # yellow — temporary access
    "denied":   {"color": 4, "label": "DENIED",   "led_duration": 1},  # red    — no access, strobe
    "pending":  {"color": 3, "label": "Pending",  "led_duration": 5},  # cyan   — face detected, awaiting AWS result
    "flagged":  {"color": 5, "label": "Flagged",  "led_duration": 4},  # magenta — known but on watchlist, needs review
    "override": {"color": 7, "label": "Override", "led_duration": 3},  # white  — supervisor manual override
}

# --- FACE RECOGNITION INTEGRATION CONFIG ---
# These lists are used by the Shashank bridge to map recognised names to access levels.
# Edit these to match the names used as filenames in Shashank's known_faces/ directory
# (i.e. the stem of the image file, e.g. "prof_smith.jpg" → "prof_smith")

VIP_NAMES     = []   # e.g. ["prof_smith", "dr_jones"] — get blue LED
FLAGGED_NAMES = []   # e.g. ["banned_user"]             — get magenta double-flash + always captured

# Path to Shashank's match_face.py script — update this to the actual path on your system
MATCH_FACE_SCRIPT = "match_face.py"

# Path to Shashank's known_faces directory
KNOWN_FACES_DIR = "known_faces"

# =============================================================================
# 1. HARDWARE SETUP
# =============================================================================
base     = BaseOverlay("base.bit")
LED_MAP  = [base.leds[i] for i in range(4)]
LOCK_LED = base.rgbleds[4]

cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH,  160)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 120)

# =============================================================================
# 2. SHARED STATE
# =============================================================================
shutdown_event = threading.Event()  # Set on exit — all threads check this and abort immediately

state = {
    "last_motion":        time.time(),
    "last_btn0":          0.0,
    "last_btn1":          0.0,
    "last_intruder":      0.0,
    "brightness_history": deque(maxlen=30),
    "session_counts":     {"standard": 0, "vip": 0, "guest": 0, "denied": 0, "intruder": 0, "pending": 0, "flagged": 0, "override": 0},
    "active_threads":     [],
}

# =============================================================================
# 3. UI DASHBOARD
# =============================================================================
image_widget  = widgets.Image(format='jpeg', width=320, height=240)
header        = widgets.HTML("<h2>🐒 Attendance Add-Ons</h2>")

instruct = widgets.HTML("""
<div style='border:1px solid #ccc; padding:12px; background:#f9f9f9; font-size:13px; line-height:1.7'>

    <b style='font-size:14px'>📋 SYSTEM GUIDE — Access Levels</b><br>
    🟢 <b>Standard:</b> Recognised user with standard clearance. Green LED lights for 3 seconds (door open).<br>
    🔵 <b>VIP:</b>      High-clearance user (e.g. staff, professors). Blue LED lights for 3 seconds.<br>
    🟡 <b>Guest:</b>    Temporary or visitor access. Yellow LED lights for 3 seconds.<br>
    🔴 <b>Denied:</b>   Unrecognised or unauthorised person. Red LED strobes. If it is night-time, a photo is automatically saved.<br>
    🚨 <b>Manual Alarm:</b> Force-triggers a red strobe + logs the event. Use for testing or emergencies.<br>
    ⏹️  <b>STOP:</b>    Press <b>Physical Button 3</b> on the PYNQ board to shut down cleanly.<br>

    <hr style='margin:8px 0'>

    <b style='font-size:14px'>🖱️ DASHBOARD BUTTONS — What they do</b><br>
    The coloured buttons (Authorize Standard / VIP / Guest / Simulate DENY) are <b>manual triggers</b> —
    clicking them simulates what will eventually happen automatically when AWS returns a face recognition result.
    Right now they let you test each access level and see the LED + log response without needing the full pipeline connected.<br><br>
    <b>✅ Authorize Standard</b> → green LED (3s), logs standard entry.<br>
    <b>🔵 Authorize VIP</b>      → dark blue LED (3s), logs VIP entry.<br>
    <b>🟡 Authorize Guest</b>    → yellow LED (3s), logs guest entry.<br>
    <b>🔴 Simulate DENY</b>      → red strobe flash, logs denial. Night mode also saves a face capture.<br>
    <b>🔄 Simulate Pending</b>   → cyan pulsing LED (5s), simulates face detected but AWS not yet responded.<br>
    <b>⚠️ Simulate Flagged</b>   → magenta double-flash pattern, always saves a face capture. Person needs human review.<br>
    <b>⚪ Supervisor Override</b> → white LED (3s), logs a manual supervisor-level access grant.<br>
    <b>🚨 Manual Alarm</b>       → 10-flash red strobe, logs alarm. Use for testing or emergencies.<br>

    <hr style='margin:8px 0'>

    <b style='font-size:14px'>💡 ENVIRONMENT & SENSORS — How brightness works</b><br>
    On startup the system reads a <b>baseline brightness</b> from the webcam feed (after a short warm-up so the camera exposure stabilises).
    This baseline slowly drifts over time to account for natural lighting changes throughout the day — so it always knows what "normal" looks like.<br><br>
    <b>☀️ Day Mode</b> (Lux ≥ 50): Standard operation. Access events work normally. Motion spikes are ignored for security purposes.<br>
    <b>🌙 Night Mode</b> (Lux &lt; 50): Heightened security. Any sudden brightness spike (e.g. someone entering a dark room) triggers an automatic photo capture and alarm flash.
    Denied access attempts at night also save a face image automatically.<br><br>
    The <b>LED bar (LEDs 0–2)</b> shows live room brightness — more LEDs on = brighter room.<br>
    <b>LED 3</b> blinks at 1Hz as a heartbeat to confirm the system is running.<br>

    <hr style='margin:8px 0'>

    <b style='font-size:14px'>💤 POWER SAVE MODE</b><br>
    If no motion is detected for 15 seconds the system drops to 2 FPS and pauses the video feed to reduce CPU load.
    Any movement or brightness change wakes it back up instantly.<br>

    <hr style='margin:8px 0'>

    <b style='font-size:14px'>📁 PHYSICAL BUTTONS (PYNQ Board)</b><br>
    <b>BTN 0:</b> Manually authorize Standard access (same as clicking the green button above).<br>
    <b>BTN 1:</b> Manually authorize VIP access.<br>
    <b>BTN 3:</b> Shut down the system cleanly — releases the camera and turns off all LEDs.<br>
    Buttons are debounced (2 second cooldown) so holding them won't spam events.<br>

</div>
""")

status_label  = widgets.HTML("<b>Status:</b> <span style='color:green'>MONITORING</span>")
mode_label    = widgets.HTML("<b>Env:</b> Day | <b>Lux:</b> --")
session_label = widgets.HTML("<b>Session:</b> loading...")
log_widget    = widgets.Textarea(
    value="",
    placeholder="Event log will appear here...",
    layout=widgets.Layout(width="100%", height="160px")
)

btn_std      = widgets.Button(description="✅ Authorize Standard",  button_style='success')
btn_vip      = widgets.Button(description="🔵 Authorize VIP",         button_style='')
btn_guest    = widgets.Button(description="🟡 Authorize Guest",        button_style='warning')
btn_denied   = widgets.Button(description="🔴 Simulate DENY",         button_style='danger')
btn_pending  = widgets.Button(description="🔄 Simulate Pending",      button_style='')
btn_flagged  = widgets.Button(description="⚠️ Simulate Flagged",      button_style='')
btn_override = widgets.Button(description="⚪ Supervisor Override",    button_style='')
btn_alarm    = widgets.Button(description="🚨 MANUAL ALARM",          button_style='danger')

# Custom styles — dark blue for VIP, cyan for pending, magenta for flagged, white/gray for override
btn_vip.style.button_color      = '#003080'
btn_vip.style.text_color        = 'white'
btn_pending.style.button_color  = '#008080'
btn_pending.style.text_color    = 'white'
btn_flagged.style.button_color  = '#8B008B'
btn_flagged.style.text_color    = 'white'
btn_override.style.button_color = '#444444'
btn_override.style.text_color   = 'white'

dashboard = widgets.VBox([
    header,
    instruct,
    widgets.HBox([status_label, mode_label]),
    session_label,
    widgets.HTML("<b>Access Controls:</b>"),
    widgets.HBox([btn_std, btn_vip, btn_guest]),
    widgets.HBox([btn_pending, btn_flagged, btn_override]),
    widgets.HBox([btn_denied, btn_alarm]),
    image_widget,
    widgets.HTML("<b>Live Event Log:</b>"),
    log_widget,
])

# Wrap in Output widget — required for reliable rendering in classic Jupyter Notebook.
# Without this the whole dashboard can silently fail to appear.
out = widgets.Output()

# =============================================================================
# 4. CORE FUNCTIONS
# =============================================================================

def log_event(message):
    """Write to file and push to live dashboard log (newest entry at top)."""
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    line = f"[{timestamp}] {message}"
    with open(LOG_FILE, "a") as f:
        f.write(line + "\n")
    current = log_widget.value.split("\n") if log_widget.value.strip() else []
    current.insert(0, line)
    log_widget.value = "\n".join(current[:MAX_LOG_DISPLAY])


def update_session_label():
    s = state["session_counts"]
    session_label.value = (
        f"<b>Session:</b> "
        f"✅ Std:{s['standard']} | "
        f"🔵 VIP:{s['vip']} | "
        f"🟡 Guest:{s['guest']} | "
        f"🔴 Denied:{s['denied']} | "
        f"🔵 Pending:{s['pending']} | "
        f"🟣 Flagged:{s['flagged']} | "
        f"⚪ Override:{s['override']} | "
        f"🚨 Intruder:{s['intruder']}"
    )


def flash_alarm(flashes=6):
    """Red strobe on LOCK_LED. Aborts immediately if shutdown is triggered."""
    for _ in range(flashes):
        if shutdown_event.is_set():
            break
        LOCK_LED.write(1)
        time.sleep(0.08)
        if shutdown_event.is_set():
            break
        LOCK_LED.write(0)
        time.sleep(0.08)


def capture_intruder(frame, reason="Motion"):
    """Save intruder image with timestamp, respecting cooldown period."""
    now = time.time()
    if now - state["last_intruder"] < INTRUDER_COOLDOWN_S:
        return
    state["last_intruder"] = now
    ts       = time.strftime("%Y%m%d_%H%M%S")
    filename = f"intruder_{ts}.jpg"
    cv2.imwrite(filename, frame)
    state["session_counts"]["intruder"] += 1
    log_event(f"SECURITY [{reason}]: Image saved → {filename}")
    update_session_label()


def _is_night_from_frame(frame):
    return float(np.mean(cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY))) < NIGHT_THRESHOLD


def trigger_access(level_key, name="Unknown", frame=None):
    """
    Central access handler. Called directly from button callbacks (no threading).

    level_key : 'standard' | 'vip' | 'guest' | 'denied'
    name      : display name for logs
    frame     : current camera frame (used for night denial capture)

    >>> AWS HOOK: once Archit's pipeline is ready, call handle_recognition_result()
        which routes here. No changes needed in this function.
    """
    if shutdown_event.is_set():
        return

    level    = ACCESS_LEVELS[level_key]
    color    = level["color"]
    label    = level["label"]
    duration = level["led_duration"]

    log_event(f"ACCESS [{label}]: {name}")
    state["session_counts"][level_key] += 1
    update_session_label()

    if level_key == "denied":
        status_label.value = f"<b>Status:</b> <span style='color:red'>🔴 ACCESS DENIED — {name}</span>"
        if frame is not None and _is_night_from_frame(frame):
            capture_intruder(frame, reason=f"Night Denial ({name})")
        flash_alarm(flashes=4)
    else:
        status_label.value = f"<b>Status:</b> <span style='color:blue'>🔓 OPENING FOR {label.upper()} — {name}</span>"
        LOCK_LED.write(color)
        for _ in range(int(duration * 10)):
            if shutdown_event.is_set():
                break
            time.sleep(0.1)
        LOCK_LED.write(0)

    if not shutdown_event.is_set():
        status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"


def handle_recognition_result(name, clearance_level):
    """
    ┌──────────────────────────────────────────────────────────┐
    │              FACE RECOGNITION HOOK                       │
    │  Called automatically by the bridge below,               │
    │  or manually by whoever when AWS returns a result.       │ 
    │                                                          │
    │  Args:                                                   │
    │    name (str): Recognised person's name or "Unknown"     │
    │    clearance_level (str): "standard" | "vip"             │
    │                           "guest"    | "denied"          │
    │                           "pending"  | "flagged"         │
    │                           "override"                     │
    │                                                          │
    │  Example:                                                │
    │    handle_recognition_result("prof_smith", "vip")        │
    │    handle_recognition_result("Unknown", "denied")        │
    └──────────────────────────────────────────────────────────┘
    """
    t = threading.Thread(
        target=trigger_access,
        args=(clearance_level, name),
        daemon=False
    )
    state["active_threads"].append(t)
    t.start()


def _map_recognition_to_level(name: str, status: str) -> str:
    """
    Map match_face output to one of our access level keys.

    Rules (in priority order):
      1. No match → denied
      2. Name on FLAGGED_NAMES → flagged (regardless of match confidence)
      3. Name on VIP_NAMES → vip
      4. Any other match → standard
    """
    if status != "MATCH" or name == "NO_MATCH":
        return "denied"
    if name in FLAGGED_NAMES:
        return "flagged"
    if name in VIP_NAMES:
        return "vip"
    return "standard"


def process_face_image(image_path: str) -> None:
    """
    ┌──────────────────────────────────────────────────────────┐
    │           BRIDGE — MAIN INTEGRATION POINT                │
    │                                                          │
    │  Called by video pipeline when a face frame              │
    │  is ready to check. This function:                       │
    │    1. Fires pending (cyan) LED immediately               │
    │    2. Runs match_face.py on the image                    │
    │    3. Maps the result to an access level                 │
    │    4. Calls handle_recognition_result() with outcome     │
    │                                                          │
    │  Args:                                                   │
    │    image_path (str): path to the face image to check     │
    │                                                          │
    │  Example (from code):                                    │
    │    process_face_image("/tmp/captured_face.jpg")          │
    └──────────────────────────────────────────────────────────┘
    """
    if shutdown_event.is_set():
        return

    # Step 1: Fire pending (cyan) immediately so there's instant visual feedback
    # while the face recognition runs in the background
    handle_recognition_result("Scanning...", "pending")

    # Step 2: Run match_face.py as a subprocess, capture JSON output
    try:
        result = subprocess.run(
            [
                "python3", MATCH_FACE_SCRIPT,
                "--input", str(image_path),
                "--known_dir", KNOWN_FACES_DIR,
                "--json",
            ],
            capture_output=True,
            text=True,
            timeout=15,  # 15s max — if face_recognition hangs, don't block forever
        )

        if result.returncode != 0:
            log_event(f"RECOGNITION ERROR: script exited {result.returncode} — {result.stderr.strip()}")
            handle_recognition_result("Unknown", "denied")
            return

        output = json.loads(result.stdout.strip())

    except subprocess.TimeoutExpired:
        log_event("RECOGNITION ERROR: match_face.py timed out after 15s")
        handle_recognition_result("Unknown", "denied")
        return
    except json.JSONDecodeError as e:
        log_event(f"RECOGNITION ERROR: could not parse JSON output — {e}")
        handle_recognition_result("Unknown", "denied")
        return
    except Exception as e:
        log_event(f"RECOGNITION ERROR: {e}")
        handle_recognition_result("Unknown", "denied")
        return

    # Step 3: Map result to access level
    status     = output.get("status", "NO_MATCH")
    name       = output.get("match_label", "Unknown")
    distance   = output.get("match_distance")
    level      = _map_recognition_to_level(name, status)

    dist_str = f" (dist={distance:.3f})" if distance is not None else ""
    log_event(f"RECOGNITION: {name} → {level.upper()}{dist_str}")

    # Step 4: Fire the actual access response
    handle_recognition_result(name, level)


# =============================================================================
# 5. BUTTON CALLBACKS — called directly, no threading
# Button callbacks in classic Jupyter Notebook cannot reliably spawn threads.
# trigger_access is called synchronously here — the 3s LED hold will briefly
# pause the UI (expected), then resume. Physical PYNQ buttons still use threads
# since they run inside the main loop which handles that context fine.
# =============================================================================

def _btn_std(b):      trigger_access("standard", "Dashboard-Std")
def _btn_vip(b):      trigger_access("vip",      "Dashboard-VIP")
def _btn_guest(b):    trigger_access("guest",    "Dashboard-Guest")
def _btn_denied(b):   trigger_access("denied",   "Dashboard-Deny")
def _btn_pending(b):  trigger_access("pending",  "Dashboard-Pending")
def _btn_flagged(b):  trigger_access("flagged",  "Dashboard-Flagged")
def _btn_override(b): trigger_access("override", "Dashboard-Override")

def _btn_alarm(b):
    if shutdown_event.is_set():
        return
    log_event("ALARM: Manual trigger")
    flash_alarm(flashes=10)

btn_std.on_click(_btn_std)
btn_vip.on_click(_btn_vip)
btn_guest.on_click(_btn_guest)
btn_denied.on_click(_btn_denied)
btn_pending.on_click(_btn_pending)
btn_flagged.on_click(_btn_flagged)
btn_override.on_click(_btn_override)
btn_alarm.on_click(_btn_alarm)

# =============================================================================
# 6. MAIN LOOP
# =============================================================================

def _main_loop():
    """Runs in a background thread so the kernel stays free for widget button callbacks."""

    log_event("SYSTEM: Node started")

    # --- Camera warm-up: discard early frames so exposure stabilises ---
    status_label.value = "<b>Status:</b> <span style='color:orange'>⏳ WARMING UP...</span>"
    for _ in range(CAMERA_WARMUP_FRAMES):
        cap.read()

    ret, frame = cap.read()
    if not ret:
        log_event("ERROR: Camera unavailable at startup")
        return

    baseline = float(np.mean(cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)))
    log_event(f"SYSTEM: Baseline brightness set → {baseline:.1f}")

    last_frame_time = time.time()

    print("\n[READY] Dashboard live. Press BTN3 on PYNQ to exit.\n")

    try:
        while base.buttons[3].read() == 0 and not shutdown_event.is_set():

            # --- FPS cap (drops to POWER_SAVE_FPS when idle) ---
            now     = time.time()
            is_idle = (now - state["last_motion"]) > IDLE_TIMEOUT_S
            target_interval = 1.0 / (POWER_SAVE_FPS if is_idle else FPS_CAP)
            elapsed = now - last_frame_time
            if elapsed < target_interval:
                time.sleep(target_interval - elapsed)
            last_frame_time = time.time()

            # --- Grab frame ---
            ret, frame = cap.read()
            if not ret:
                break

            gray     = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            bright   = float(np.mean(gray))
            is_night = bright < NIGHT_THRESHOLD

            # --- Rolling baseline (slow drift, immune to sudden spikes) ---
            baseline = (1 - BASELINE_ALPHA) * baseline + BASELINE_ALPHA * bright
            state["brightness_history"].append(bright)

            # --- UI: Video feed (skip during power save) ---
            if not is_idle:
                _, jpeg = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 70])
                image_widget.value = jpeg.tobytes()

            # --- UI: Mode and status labels ---
            env_str  = "🌙 Night" if is_night else "☀️ Day"
            save_str = " | 💤 POWER SAVE" if is_idle else ""
            mode_label.value = f"<b>Env:</b> {env_str} | <b>Lux:</b> {int(bright)}{save_str}"

            if is_idle:
                status_label.value = "<b>Status:</b> <span style='color:gray'>💤 POWER SAVE</span>"
            # (Non-idle status is set by trigger_access or stays as MONITORING)

            # --- LED: Brightness bar (LEDs 0–2) ---
            for i in range(3):
                LED_MAP[i].on() if i < int(bright / 85) else LED_MAP[i].off()

            # --- LED: Heartbeat on LED 3 (1 Hz) ---
            LED_MAP[3].on() if int(time.time()) % 2 == 0 else LED_MAP[3].off()

            # --- Night intruder detection (brightness spike against rolling baseline) ---
            delta = abs(bright - baseline)
            if is_night and delta > (baseline * MOTION_SENSITIVITY):
                capture_intruder(frame, reason="Night Motion")
                t = threading.Thread(target=flash_alarm, args=(5,), daemon=False)
                state["active_threads"].append(t)
                t.start()
                state["last_motion"] = time.time()

            # --- Motion tracking (any notable change = activity, resets idle timer) ---
            if delta > 10:
                state["last_motion"] = time.time()

            # --- Physical button overrides (debounced) ---
            now = time.time()
            if base.buttons[0].read() == 1 and (now - state["last_btn0"]) > BTN_DEBOUNCE_S:
                state["last_btn0"] = now
                t = threading.Thread(target=trigger_access, args=("standard", "BTN0", frame), daemon=False)
                state["active_threads"].append(t)
                t.start()

            if base.buttons[1].read() == 1 and (now - state["last_btn1"]) > BTN_DEBOUNCE_S:
                state["last_btn1"] = now
                t = threading.Thread(target=trigger_access, args=("vip", "BTN1", frame), daemon=False)
                state["active_threads"].append(t)
                t.start()

    finally:
        # Signal all threads to stop what they're doing
        shutdown_event.set()

        # Wait up to 1.5s for any active access thread to notice the flag and exit
        for t in state["active_threads"]:
            t.join(timeout=1.5)

        # Now forcefully clear everything — no threads can write after this
        cap.release()
        LOCK_LED.write(0)
        for l in LED_MAP:
            l.off()
        log_event("SYSTEM: Node shut down cleanly")
        status_label.value = "<b>Status:</b> <span style='color:red'>⛔ OFFLINE</span>"
        print(f"[SHUTDOWN] System offline. Log saved to '{LOG_FILE}'")


def start_system():
    # Display dashboard — Output widget gives classic Jupyter a stable render handle
    with out:
        clear_output(wait=True)
        display(dashboard)
    display(out)

    # Give Jupyter time to render before the loop starts writing to widgets
    time.sleep(1.0)

    # Launch main loop in background thread — this is the key fix that lets
    # widget button callbacks actually execute while the loop is running
    loop_thread = threading.Thread(target=_main_loop, daemon=False)
    state["active_threads"].append(loop_thread)
    loop_thread.start()


start_system()
