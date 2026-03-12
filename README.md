# 🐒 Attendance Add-Ons — Output Node

> **Platform:** PYNQ board + Arduino Uno  
> **Role in pipeline:** Physical response layer — receives access decisions and drives hardware

---

## Overview

This is the **output/response node** of the group's face recognition attendance system. It sits at the very end of the pipeline. Once Marcus's AWS server has made an identity decision, this module handles everything that happens physically: the correct LED fires, the door servo opens or stays shut, the buzzer plays an audio pattern, events are logged, and the system responds differently based on time of day.

The module is **fully self-contained and runnable right now** — all access states can be triggered manually via dashboard buttons without the rest of the pipeline connected. When Marcus is ready to integrate, he calls one function and everything works automatically.

---

## Where This Fits in the Pipeline

```
Archit          Shashank           Marcus              Thanus
────────────    ───────────────    ─────────────────   ──────────────────────────
FPGA camera  →  Face recognition → AWS identity    →   handle_recognition_result()
Captures         Matches face       decision +              ↓
clean face       against database   logging/SQL         PYNQ RGB LED
image                                                   Arduino servo (door)
                                                        Arduino buzzer (audio)
                                                        Arduino LEDs
                                                        Local backup log
                                                        Live Jupyter dashboard
```

**Marcus's integration is one function call:**
```python
handle_recognition_result("prof_smith", "vip")
handle_recognition_result("Unknown", "denied")
handle_recognition_result("", "pending")        # while AWS is still processing
handle_recognition_result("jane", "denied", frame=img)  # pass Archit's frame for capture
```

---

## Hardware Required

| Component | Purpose | Notes |
|-----------|---------|-------|
| PYNQ-board | Main compute + RGB LED + buttons | Already have |
| Arduino Uno | Physical door mechanism controller | Needs to be sourced |
| USB A→B cable | PYNQ ↔ Arduino serial link | Powers Arduino too |
| Servo motor (SG90/MG90S) | Door open/close simulation | Common hobby servo |
| Active buzzer | Audio feedback per access level | Must be **active** type |
| Green LED + 220Ω resistor | Physical access granted indicator | |
| Red LED + 220Ω resistor | Physical denial/alarm indicator | |
| LDR + 10kΩ resistor *(optional)* | Physical light sensor for day/night | Time-of-day used until available |

> **Note:** If Arduino or LDR are not available, the system runs gracefully without them — PYNQ LEDs still fire, time-of-day handles day/night mode, everything logs normally.

---

## Repository Structure

```
📁 output-node/
│
├── smart_node_v8.py          ← MAIN SYSTEM — run this on PYNQ in Jupyter
├── door_mechanism.ino        ← Arduino sketch — upload via Arduino IDE
├── wiring_diagram.txt        ← Full wiring instructions + breadboard layout
├── README.md                 ← This file
│
└── 📁 diagnostics/           ← Run these to verify hardware before demo
    ├── cell1_overlay.py      ← PYNQ overlay loads correctly
    ├── cell2_plain_led.py    ← Plain LEDs 0-3 respond
    ├── cell3_rgb_led.py      ← RGB LED cycles all 7 colours
    ├── cell4_widget_render.py← Jupyter widgets render
    ├── cell5_button_callback.py  ← Dashboard button callbacks fire
    ├── cell6_button_led_nosleep.py ← Callbacks write to hardware
    ├── cell7_button_led_sleep.py   ← Callbacks work with time.sleep
    ├── cell8_physical_buttons.py   ← Physical BTN0/BTN1 register presses
    ├── cell9_webcam.py       ← Webcam captures frames (if needed)
    └── cell10_integration.py ← Full end-to-end pipeline test
```

---

## Access States

Seven access states, each with a distinct PYNQ LED colour, Arduino behaviour, and audio pattern:

| State | PYNQ LED | Colour | Servo | Buzzer | Arduino LEDs |
|-------|----------|--------|-------|--------|--------------|
| `standard` | 🟢 | Green | Open 3s | 1 short beep | Green on |
| `vip` | 🔵 | Blue | Open 3s — **fast-tracked, no pending** | 2 beeps | Green on |
| `guest` | 🟡 | Yellow | Open 3s | 1 quiet beep | Green on |
| `denied` | 🔴 | Red strobe | Shut | 3 sharp beeps | Red on |
| `pending` | 🔷 | Cyan pulse | Shut | 3 slow pulses | None |
| `flagged` | 🟣 | Magenta double-flash | Shut | Double-beep alarm ×4 | Red strobe |
| `override` | ⚪ | White | Open 3s | 1 long beep | Green + Red |

---

## Features

### 🚪 Physical Door Mechanism
Arduino Uno receives single-character serial commands from PYNQ over USB. Granted access (Standard / VIP / Guest / Override) rotates servo 90° to simulate door unlock, holds for 3 seconds, then closes. All other states keep the door shut with distinct audio patterns to distinguish them.

### 🌙 Day / Night Mode
Currently uses **time-of-day** (night = 8pm–8am, day = 8am–8pm). When a physical LDR sensor is plugged into PMODA at the meetup, swap in three uncommented lines at the top of `smart_node_v8.py` and calibrate `NIGHT_THRESHOLD`. No other changes needed.

Night mode effects:
- Denied access with a face frame passed in → automatically saves a capture image
- Flagged access → always saves capture image regardless of day/night

### ⚡ Auto-Escalation
- **3 consecutive unknown denials** → automatic sustained alarm fires on both PYNQ and Arduino
- **5 denials in any 2-minute window** → sustained alarm + security alert logged

### ⏱️ Access Cooldown (Anti-Tailgate)
Same named person cannot re-trigger access within 30 seconds. Denied flash + log on attempt. Prevents someone holding the door open and waving people through.

### 🔒 Night Lockdown Mode
Manual button on dashboard refuses **all** access regardless of clearance level until lifted. White strobe fires on Arduino. Override-level access bypasses lockdown.

### 🔵 VIP Fast-Track
VIP access bypasses the pending (cyan) state entirely — goes straight to blue LED + door open. Useful for demo: VIP gets instant response, standard users show the full pipeline flow.

### 🔔 Arduino Heartbeat Ping
Every 30 seconds PYNQ sends a ping character to Arduino. If no response is received, a hardware warning appears on the dashboard. Lets the team know immediately if the USB connection drops during a demo.

### 📊 Live Dashboard
- Session counters for all 7 access states
- Separate named access history scroll (last 20 entries)
- System event log (last 12 entries, newest first)
- Arduino connection status indicator
- Day/Night mode + time display
- 10 manual trigger buttons

### 💡 LED Boot Sequence
On startup, cycles through all 7 LED colours to confirm hardware is working before the first real access event hits.

### 📋 Daily Report
Auto-generates a summary to `daily_report.txt` at midnight and on clean shutdown. Includes total counts for all access types and the full named access history for that session.

### 💾 Local Backup Log
All events written to `attendance_log.txt` regardless of Marcus's AWS logging. Timestamped, persistent across sessions.

### 📁 Physical PYNQ Buttons
| Button | Action |
|--------|--------|
| BTN0 | Authorize Standard access |
| BTN1 | Authorize VIP access |
| BTN3 | Clean shutdown |

All debounced at 2 seconds to prevent repeat triggers from holding.

---

## Setup Instructions

### Step 1 — Install dependencies on PYNQ
Run in a Jupyter cell (one time only):
```python
!pip install pyserial
!jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Restart kernel after running this
```

### Step 2 — Upload Arduino sketch
1. Open `door_mechanism.ino` in **Arduino IDE** on a laptop
2. Select board: **Tools → Board → Arduino Uno**
3. Select the correct COM/USB port
4. Click **Upload**
5. Once uploaded, plug Arduino into PYNQ via USB A→B cable

### Step 3 — Find Arduino port on PYNQ
Run in a Jupyter cell with Arduino plugged in:
```python
import subprocess
print(subprocess.run(['ls', '/dev/ttyUSB*'], capture_output=True, text=True).stdout)
print(subprocess.run(['ls', '/dev/ttyACM*'], capture_output=True, text=True).stdout)
```
Common values: `/dev/ttyUSB0` or `/dev/ttyACM0`

### Step 4 — Update port in smart_node_v8.py
```python
ARDUINO_PORT = "/dev/ttyUSB0"   # ← change to match your port
```

### Step 5 — Wire up Arduino components
See `wiring_diagram.txt` for full details. Summary:
```
Servo signal  → Arduino Pin 6   Servo VCC → 5V   Servo GND → GND
Buzzer (+)    → Arduino Pin 7   Buzzer (-) → GND
Green LED (+) → 220Ω → Pin 8   Green LED (-) → GND
Red LED (+)   → 220Ω → Pin 9   Red LED (-)   → GND
```

### Step 6 — Run the system
Copy `smart_node_v8.py` to PYNQ via the Jupyter file browser (drag and drop), open it, paste contents into a cell and run. Dashboard appears, boot sequence fires, system enters monitoring mode.

---

## Connecting Physical Light Sensor (When Available)

When LDR is available at the meetup, plug into PMODA and uncomment 3 lines in `smart_node_v8.py`:

```python
# Find this block near the top of the file and uncomment:
from pynq.lib import Pmod_ADC
_pmod_adc = Pmod_ADC(base.PMODA)
LIGHT_SENSOR_AVAILABLE = True
```

Then calibrate the threshold:
```python
# Run in a separate cell — bright room then cover sensor with hand
from pynq.lib import Pmod_ADC
from pynq.overlays.base import BaseOverlay
base = BaseOverlay("base.bit")
s = Pmod_ADC(base.PMODA)
import time
for _ in range(10):
    print(s.read())
    time.sleep(1)
# Note bright value and dark value, set NIGHT_THRESHOLD between them
```

---

## Integration Reference for Marcus

```python
# ─────────────────────────────────────────────────────────────
# CALL THIS from your AWS handler once a decision is made
# ─────────────────────────────────────────────────────────────

handle_recognition_result(
    name,             # str  — person's name e.g. "prof_smith", or "Unknown"
    clearance_level,  # str  — one of the 7 levels below
    frame=None        # ndarray (optional) — Archit's face frame for night capture
)

# Valid clearance levels:
#   "standard"  →  green LED, door opens, 1 beep
#   "vip"       →  blue LED, door opens, 2 beeps, FAST-TRACKED (no pending wait)
#   "guest"     →  yellow LED, door opens, 1 beep
#   "denied"    →  red strobe, door shut, 3 beeps
#   "pending"   →  cyan pulse, door shut, slow beeps  ← fire this BEFORE AWS responds
#   "flagged"   →  magenta flash, door shut, alarm beeps, saves face image
#   "override"  →  white LED, door opens, long beep

# Recommended flow:
#   1. Archit detects face → call handle_recognition_result("", "pending")
#   2. AWS processes → call handle_recognition_result("prof_smith", "vip")
```

---

## Configuring VIP and Flagged Names

Edit these two lists at the top of `smart_node_v8.py` to match the name stems from Shashank's `known_faces/` directory (filename without extension):

```python
VIP_NAMES     = ["prof_aura", "dr_nonchalant"]   # → blue LED + door opens + 2 beeps
FLAGGED_NAMES = ["banned_user"]              # → magenta flash + alarm + always captured

# Anyone else who matches known faces → standard (green)
# No match at all → denied (red strobe)
```

---

## Confirmed PYNQ-Z2 RGB LED Colour Map

| Code | Colour | Used for |
|------|--------|---------|
| 0 | Off | Default/reset state |
| 1 | Blue | VIP |
| 2 | Green | Standard |
| 3 | Cyan | Pending |
| 4 | Red | Denied / Alarm |
| 5 | Magenta | Flagged |
| 6 | Yellow | Guest |
| 7 | White | Override |

---

## Arduino Serial Command Reference

| Char | Access Level | Servo | Buzzer | LEDs |
|------|-------------|-------|--------|------|
| `G` | Standard | Open 3s | 1 short beep | Green |
| `V` | VIP | Open 3s | 2 short beeps | Green |
| `U` | Guest | Open 3s | 1 quiet beep | Green |
| `D` | Denied | Shut | 3 sharp beeps | Red |
| `P` | Pending | Shut | 3 slow pulses | None |
| `F` | Flagged | Shut | Double-beep ×4 | Red strobe |
| `O` | Override | Open 3s | 1 long beep | Green + Red |
| `A` | Alarm | Shut | 10 rapid beeps | Red strobe |
| `W` | Lockdown | Shut | Long alarm tone | Green/Red alternate |
| `?` | Heartbeat ping | — | — | — (responds `K`) |

---

## Tunable Constants

All at the top of `smart_node_v8.py` — edit these, not the logic:

| Constant | Default | What it controls |
|----------|---------|-----------------|
| `NIGHT_THRESHOLD` | `0.5` | LDR voltage below which = night (physical sensor only) |
| `BTN_DEBOUNCE_S` | `2.0` | Min seconds between physical button presses |
| `ACCESS_COOLDOWN_S` | `30` | Seconds before same person can re-enter |
| `DENIAL_STREAK_WINDOW_S` | `120` | Time window for streak alarm (seconds) |
| `DENIAL_STREAK_LIMIT` | `5` | Denials in window before sustained alarm |
| `CONSEC_UNKNOWN_LIMIT` | `3` | Unknown denials in a row before alarm |
| `ARDUINO_PING_INTERVAL_S` | `30` | Seconds between Arduino heartbeat checks |
| `ARDUINO_PORT` | `/dev/ttyUSB0` | USB port for Arduino |
| `ARDUINO_BAUDRATE` | `9600` | Serial baud rate (must match Arduino sketch) |

---


## Dependencies

```
PYNQ:     pynq · ipywidgets · pyserial
Arduino:  Servo.h (built into Arduino IDE — no install needed)
```

> **Servo power note:** If the servo causes the Arduino to reset or jitter during demo,
> it's drawing too much current from USB. Power the servo from an external 5V supply,
> sharing GND with the Arduino. See wiring_diagram.txt for details.
