import cv2
import numpy as np
import time
import threading
import ipywidgets as widgets
from IPython.display import display
from pynq.overlays.base import BaseOverlay

# --- 1. HARDWARE & UI SETUP ---
base = BaseOverlay("base.bit")
LED_MAP = [base.leds[i] for i in range(4)]
LOCK_LED = base.rgbleds[4]

# RESOLUTION SLIM-DOWN: 160x120 is the "Sweet Spot" for no-lag PYNQ streaming
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 160)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 120)

# --- 2. THE UI DASHBOARD ---
image_widget = widgets.Image(format='jpeg', width=320, height=240) # Displayed larger, but source is small
header = widgets.HTML("<h2>🛡️ SMART NODE: COMMAND CENTER V5.0</h2>")
instruct = widgets.HTML("""
<div style='border: 1px solid #ccc; padding: 10px; background-color: #f9f9f9;'>
    <b>SYSTEM GUIDE:</b><br>
    🟢 <b>Standard:</b> Access for known users (Green LED)<br>
    🔵 <b>VIP:</b> High-clearance access (Blue LED)<br>
    🟡 <b>Guest:</b> Temporary entry (Yellow LED)<br>
    🔴 <b>Alarm:</b> Manual strobe & Photo capture<br>
    ⏹️ <b>STOP:</b> Use <b>Physical Button 3</b> on the PYNQ to shut down.
</div>
""")
status_label = widgets.HTML("<b>Status:</b> <span style='color:green'>MONITORING</span>")
mode_label = widgets.HTML("<b>Env:</b> Day Mode")

# Control Buttons
btn_std = widgets.Button(description="Authorize Standard", button_style='success')
btn_vip = widgets.Button(description="Authorize VIP", button_style='info')
btn_guest = widgets.Button(description="Authorize Guest", button_style='warning')
btn_alarm = widgets.Button(description="MANUAL ALARM", button_style='danger')

# Layout
dashboard = widgets.VBox([header, instruct, status_label, mode_label, widgets.HBox([btn_std, btn_vip, btn_guest, btn_alarm]), image_widget])

# --- 3. SYSTEM FUNCTIONS ---

def log_event(message):
    with open("attendance_log.txt", "a") as f:
        f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}\n")

def trigger_access(color, label, name):
    log_event(f"ACCESS: {label} ({name})")
    status_label.value = f"<b>Status:</b> <span style='color:blue'>OPENING FOR {label.upper()}</span>"
    LOCK_LED.write(color)
    time.sleep(3)
    LOCK_LED.write(0)
    status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"

# BUTTON CALLBACKS (Now properly linked)
btn_std.on_click(lambda b: threading.Thread(target=trigger_access, args=(2, "Standard", "User")).start())
btn_vip.on_click(lambda b: threading.Thread(target=trigger_access, args=(4, "VIP", "Prof. Smith")).start())
btn_guest.on_click(lambda b: threading.Thread(target=trigger_access, args=(3, "Guest", "Visitor")).start())
btn_alarm.on_click(lambda b: log_event("MANUAL ALARM TRIGGERED"))

# --- 4. THE OPTIMIZED MAIN LOOP ---

def start_system():
    display(dashboard)
    ret, frame = cap.read()
    baseline = np.mean(cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY))
    last_motion = time.time()
    
    print("\n[READY] Use Dashboard buttons or Physical BTN0/BTN1. Press BTN3 to Exit.")

    try:
        while base.buttons[3].read() == 0:
            ret, frame = cap.read()
            if not ret: break
            
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            bright = np.mean(gray)
            is_night = bright < 50

            # UI Refresh (Optimized)
            _, jpeg = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 70])
            image_widget.value = jpeg.tobytes()
            mode_label.value = f"<b>Env:</b> {'Night' if is_night else 'Day'} | <b>Lux:</b> {int(bright)}"

            # 1. Power Save (Idle check)
            if time.time() - last_motion > 15:
                time.sleep(0.5) # Drop to 2 FPS
                status_label.value = "<b>Status:</b> <span style='color:gray'>POWER SAVE</span>"
            else:
                status_label.value = "<b>Status:</b> <span style='color:green'>MONITORING</span>"

            # 2. Hardware Feedback (Light Meter & Heartbeat)
            for i in range(3):
                LED_MAP[i].on() if i <= (bright/85) else LED_MAP[i].off()
            if int(time.time()) % 2 == 0: LED_MAP[3].on()
            else: LED_MAP[3].off()

            # 3. Night Intruder (Auto-Capture)
            if is_night and abs(bright - baseline) > (baseline * 0.25):
                ts = time.strftime("%H%M%S")
                cv2.imwrite(f"intruder_{ts}.jpg", frame)
                log_event(f"SECURITY: Night Motion Detected. Image saved.")
                # Flash Alarm
                for _ in range(5): LOCK_LED.write(1); time.sleep(0.05); LOCK_LED.write(0)
                last_motion = time.time()

            # 4. Physical Overrides
            if base.buttons[0].read() == 1: threading.Thread(target=trigger_access, args=(2, "Standard", "BTN0")).start()
            if base.buttons[1].read() == 1: threading.Thread(target=trigger_access, args=(4, "VIP", "BTN1")).start()

            # Update motion baseline
            if abs(bright - baseline) > 10: last_motion = time.time()

    finally:
        cap.release()
        LOCK_LED.write(0)
        [l.off() for l in LED_MAP]
        status_label.value = "<b>Status:</b> <span style='color:red'>OFFLINE</span>"

start_system()
