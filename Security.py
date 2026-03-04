import cv2
import numpy as np
import time
from pynq.overlays.base import BaseOverlay

# --- 1. HARDWARE INITIALIZATION ---
base = BaseOverlay("base.bit")
LED_MAP = [base.leds[i] for i in range(4)]
LOCK_LED = base.rgbleds[4] # Using RGB LED as the 'Door Lock' proxy

# Camera Setup (Lower res for faster processing on ARM)
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 160) 
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 120)

# --- 2. THE UTILITY FUNCTIONS ---

def log_event(message):
    """Timestamped database logging."""
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    with open("attendance_log.txt", "a") as f:
        f.write(f"[{timestamp}] {message}\n")

def handle_access_granted():
    """Unlocks the door and logs success."""
    print("\n[SUCCESS] Authorized Entry Detected.")
    log_event("SUCCESS: Door Unlocked for User")
    LOCK_LED.write(4) # Green Light
    time.sleep(3)     # Door remains open
    LOCK_LED.write(0) # Re-lock

def handle_security_alert(frame, reason="Intruder"):
    """Fires alarm, captures photo, and logs alert."""
    print(f"\n[ALARM] {reason.upper()}! Capturing evidence...")
    ts = time.strftime("%H%M%S")
    filename = f"intruder_{ts}.jpg"
    
    cv2.imwrite(filename, frame)
    log_event(f"ALARM: {reason} - Image saved as {filename}")
    
    # Physical Strobe Alarm (FPGA-driven timing)
    for _ in range(15):
        LOCK_LED.write(1); time.sleep(0.05) # Red
        LOCK_LED.write(0); time.sleep(0.05)

# --- 3. THE MAIN AUTOMATED ENGINE ---

def start_security_node():
    print("=== PYNQ SECURITY NODE V3.0 ONLINE ===")
    print("Calibrating background light... Stay still.")
    
    # Get an initial lighting baseline
    ret, frame = cap.read()
    if not ret: return
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    baseline_brightness = np.mean(gray)
    
    log_event("NODE REBOOT: System monitoring active")
    
    try:
        while base.buttons[3].read() == 0: # BTN3 is Emergency Stop
            ret, frame = cap.read()
            if not ret: break
            
            # A. REAL-TIME ENVIRONMENT SENSING
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            current_brightness = np.mean(gray)
            
            # Identify Night vs Day
            is_night = current_brightness < 60
            
            # B. THE "SMART TRIGGER" (Detecting a Person in the Dark)
            # If light changes by more than 20%, it's a person/shadow
            light_delta = abs(current_brightness - baseline_brightness)
            if is_night and light_delta > (baseline_brightness * 0.20):
                handle_security_alert(frame, reason="Motion in Dark")
                # Reset baseline to avoid looping the alarm
                baseline_brightness = current_brightness
                time.sleep(1)

            # C. MANUAL TEAM HANDSHAKE (Simulated AWS/Face Result)
            if base.buttons[0].read() == 1: # Team says: Match!
                handle_access_granted()
            elif base.buttons[1].read() == 1: # Team says: No Match!
                handle_security_alert(frame, reason="Access Denied")

            # D. VISUAL IDLE FEEDBACK (The 'Light Meter')
            encoded = int(current_brightness / 64)
            for i in range(4):
                LED_MAP[i].on() if i <= encoded else LED_MAP[i].off()

            status = "NIGHT" if is_night else "DAY"
            print(f"Monitoring... [{status}] Light: {current_brightness:.1f} ", end='\r')

    except Exception as e:
        print(f"\nSystem Error: {e}")
    finally:
        log_event("NODE SHUTDOWN: Monitoring stopped")
        cap.release()
        LOCK_LED.write(0)
        [l.off() for l in LED_MAP]
        print("\nNode Securely Offline.")

# --- 4. EXECUTION ---
if __name__ == "__main__":
    start_security_node()
