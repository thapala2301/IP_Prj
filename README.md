# 🐒 Attendance Add-Ons — Output Node

> **Platform:** PYNQ + Arduino Uno  
> **Role:** Physical response layer — receives access decisions, drives hardware

---

## What This Module Does

Sits at the end of the face recognition attendance pipeline. Once Marcus's AWS server returns an identity decision, this module handles everything that happens physically: the correct LED fires on the PYNQ, the door servo opens or stays shut, the buzzer plays a distinct audio pattern, and all events are logged.

Fully self-contained — all access states can be triggered manually via dashboard buttons without the rest of the pipeline connected. When Marcus integrates, he calls one function.

---

## Pipeline Position

```
Archit          Shashank           Marcus              Thanus
────────────    ───────────────    ─────────────────   ─────────────────────────
FPGA camera  →  Face recognition → AWS identity    →   handle_recognition_result()
Captures         matches face       decision +               ↓
clean face       against database   logging/SQL          PYNQ RGB LED
image                                                    Arduino servo (door)
                                                         Arduino buzzer (audio)
                                                         Local backup log
                                                         Live Jupyter dashboard
```

**Marcus's integration — one call:**
```python
handle_recognition_result("prof_smith", "vip")
handle_recognition_result("Unknown", "denied")
handle_recognition_result("", "pending")              # fire while AWS is still deciding
handle_recognition_result("jane", "denied", frame=img) # pass Archit's frame for capture
```

---

## Hardware

| Component | Purpose | Notes |
|-----------|---------|-------|
| PYNQ-Z2 | Compute + RGB LED + buttons | All visual feedback lives here |
| Arduino Uno | Servo + buzzer controller | No LEDs — PYNQ handles visuals |
| USB A→B cable | PYNQ ↔ Arduino serial + power | One cable does both |
| Servo motor (SG90/MG90S) | Physical door mechanism | |
| Active buzzer | Audio feedback per access level | Must be **active** type |
| LDR + 10kΩ resistor *(optional)* | Physical light sensor | Time-of-day used until available |

> No external LEDs on the Arduino — the PYNQ RGB LED already handles all visual feedback. Adding Arduino LEDs would just duplicate what's already there.

---

## Repository Structure

```
📁 output-node/
│
├── smart_node_v9.py          ← MAIN SYSTEM — run this on PYNQ in Jupyter
├── door_mechanism.ino        ← Arduino sketch — upload via Arduino IDE
├── wiring_diagram.txt        ← Full wiring + breadboard layout
├── README.md                 ← This file
│
└── 📁 diagnostics/
    ├── cell1_overlay.py          ← PYNQ overlay loads
    ├── cell2_plain_led.py        ← Plain LEDs respond
    ├── cell3_rgb_led.py          ← RGB LED colour cycle
    ├── cell4_widget_render.py    ← Jupyter widgets render
    ├── cell5_button_callback.py  ← Button callbacks fire
    ├── cell6_button_led_nosleep.py ← Callbacks write to hardware
    ├── cell7_button_led_sleep.py   ← Callbacks work with sleep
    ├── cell8_physical_buttons.py   ← Physical BTN0/1/2 register
    └── cell10_integration.py       ← Full end-to-end test
```

---

## Access States

| State | PYNQ LED | Colour | Servo | Buzzer Pattern |
|-------|----------|--------|-------|----------------|
| `standard` | 🟢 | Green | Open 3s | 1 short beep |
| `vip` | 🔵 | Blue | Open 3s — **fast-tracked** | Rising 2-beep |
| `guest` | 🟡 | Yellow | Open 3s | Soft single beep |
| `denied` | 🔴 | Red strobe | Shut | 3 descending beeps |
| `pending` | 🔷 | Cyan pulse | Shut | 3 slow pulse beeps |
| `flagged` | 🟣 | Magenta double-flash | Shut | Double-beep alarm ×4 |
| `override` | ⚪ | White | Open 3s | Long authority beep |

Each buzzer pattern is intentionally distinct — identifiable by sound alone without looking at the screen.

---

## Features

### 🚪 Physical Door Mechanism
PYNQ sends a single character over USB serial to the Arduino. Access granted states (Standard / VIP / Guest / Override) rotate the servo 90° to simulate door unlock, hold for 3 seconds, then close. All other states keep the door shut with a distinct audio pattern.

### 🔵 VIP Fast-Track
VIP access bypasses the pending (cyan) state entirely — goes straight to blue LED and door open. Useful for demos where you want to show the contrast between standard flow (pending → result) and VIP (instant response).

### 🌙 Day / Night Mode
Currently time-of-day based (night = 8pm–8am). When a physical LDR is available, uncomment 3 lines in the config block at the top of `smart_node_v9.py`. Night mode effects:
- Denied access with a face frame passed → saves capture image automatically
- Flagged access → always saves capture image (day or night)

### ⚡ Auto-Escalation
- **3 consecutive unknown denials** → automatic sustained alarm (PYNQ strobe + Arduino 10-pulse)
- **5 denials in any 2-minute window** → sustained alarm + security alert logged

### ⏱️ Anti-Tailgate Cooldown
Same named person cannot re-trigger access within 30 seconds. Gets a denied flash and a dashboard message showing remaining cooldown time. Prevents someone holding the door and waving people through.

### 🔒 Night Lockdown Mode
Dashboard button refuses **all** access regardless of clearance until lifted. Only `override` bypasses it. Fires lockdown siren pattern on Arduino.

### 🔔 Arduino Heartbeat
Every 30 seconds PYNQ pings the Arduino (`?` → Arduino responds `K`). No response logs a hardware warning on the dashboard. Lets the team know immediately if the USB drops during a demo.

### 📊 Live Access Rate
Dashboard shows how many named entries have occurred in the current hour, updating every 5 seconds. Useful metric for a demo.

### 💡 LED Boot Sequence
On startup, cycles through all 7 LED colours. Visual hardware self-check before the first real access event. Arduino also plays a startup double-beep confirming it booted.

### 📋 Daily Report
Auto-generates `daily_report.txt` at midnight and on every clean shutdown. Includes per-level counts and full named access history.

### 💾 Local Backup Log
Every event written to `attendance_log.txt` with timestamps, regardless of Marcus's AWS logging. Persistent across sessions.

### 📟 Physical PYNQ Buttons
| Button | Action |
|--------|--------|
| BTN0 | Standard access |
| BTN1 | VIP access |
| BTN2 | Guest access |
| BTN3 | Clean shutdown |

All debounced at 2 seconds.

---

## Setup Instructions

### 1 — Install dependencies on PYNQ
```python
# Run in a Jupyter cell — one time only
!pip install pyserial
!jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Restart kernel after this
```

### 2 — Upload Arduino sketch
1. Open `door_mechanism.ino` in Arduino IDE
2. **Tools → Board → Arduino Uno**
3. Select the correct port
4. Click Upload
5. You should hear two short beeps confirming it booted

### 3 — Find Arduino port on PYNQ
```python
# Run in Jupyter with Arduino plugged in
import subprocess
print(subprocess.run(['ls', '/dev/ttyUSB*'], capture_output=True, text=True).stdout)
print(subprocess.run(['ls', '/dev/ttyACM*'], capture_output=True, text=True).stdout)
# Common: /dev/ttyUSB0 or /dev/ttyACM0
```

### 4 — Update port
```python
# Near top of smart_node_v9.py
ARDUINO_PORT = "/dev/ttyUSB0"   # ← change to your port
```

### 5 — Wire Arduino
```
Servo signal  → Pin 6    Servo VCC → 5V    Servo GND → GND
Buzzer (+)    → Pin 7    Buzzer (-) → GND
```
Full detail in `wiring_diagram.txt`.

### 6 — Run
Copy `smart_node_v9.py` to PYNQ via the Jupyter file browser, open it, paste into a cell and run. Boot sequence fires, dashboard appears.

---

## Connecting Physical Light Sensor (When Available)

Plug LDR into PMODA, then uncomment these 3 lines near the top of `smart_node_v9.py`:

```python
from pynq.lib import Pmod_ADC
_pmod_adc = Pmod_ADC(base.PMODA)
LIGHT_SENSOR_AVAILABLE = True
```

Calibrate `NIGHT_THRESHOLD_V` by running this in a separate cell:
```python
from pynq.lib import Pmod_ADC
from pynq.overlays.base import BaseOverlay
import time
base = BaseOverlay("base.bit")
s = Pmod_ADC(base.PMODA)
for _ in range(10):
    print(s.read())
    time.sleep(1)
# Note bright room value vs dark room value
# Set NIGHT_THRESHOLD_V between them
```

---

## Integration Reference

### Marcus / AWS
```python
handle_recognition_result(
    name,             # str  — e.g. "prof_smith", or "Unknown"
    clearance_level,  # str  — see table below
    frame=None        # ndarray (optional) — Archit's face image
)

# clearance_level options:
#   "standard"  →  green LED, door opens, 1 beep
#   "vip"       →  blue LED, door opens, rising 2-beep, FAST-TRACKED
#   "guest"     →  yellow LED, door opens, soft beep
#   "denied"    →  red strobe, door shut, 3 descending beeps
#   "pending"   →  cyan pulse, door shut, slow beeps  ← fire BEFORE AWS responds
#   "flagged"   →  magenta flash, door shut, alarm, saves face image
#   "override"  →  white LED, door opens, long beep
```

### Shashank / face recognition
`process_face_image(path, frame=None)` — calls `match_face.py`, fires pending first, then triggers full response.

### Configure VIP and flagged names
```python
# At top of smart_node_v9.py — match stems of Shashank's known_faces/ filenames
VIP_NAMES     = ["prof_smith", "dr_jones"]
FLAGGED_NAMES = ["banned_user"]
# All other matches → standard
# No match → denied
```

---

## Tunable Constants

All at the top of `smart_node_v9.py`:

| Constant | Default | Controls |
|----------|---------|---------|
| `ARDUINO_PORT` | `/dev/ttyUSB0` | USB port for Arduino |
| `NIGHT_START_HOUR` | `20` | Hour night mode begins (8pm) |
| `NIGHT_END_HOUR` | `8` | Hour night mode ends (8am) |
| `NIGHT_THRESHOLD_V` | `0.5` | LDR voltage for night (physical sensor only) |
| `ACCESS_COOLDOWN_S` | `30` | Anti-tailgate cooldown per person |
| `BTN_DEBOUNCE_S` | `2.0` | Physical button cooldown |
| `CONSEC_UNKNOWN_LIMIT` | `3` | Unknown denials before auto-alarm |
| `DENIAL_STREAK_LIMIT` | `5` | Denials in window before alarm |
| `DENIAL_STREAK_WINDOW_S` | `120` | Rolling window for streak check |
| `ARDUINO_PING_INTERVAL_S` | `30` | Heartbeat check frequency |

---

## Confirmed PYNQ-Z2 RGB LED Colour Map

| Code | Colour | Used for |
|------|--------|---------|
| 0 | Off | Reset state |
| 1 | Blue | VIP |
| 2 | Green | Standard |
| 3 | Cyan | Pending |
| 4 | Red | Denied / Alarm |
| 5 | Magenta | Flagged |
| 6 | Yellow | Guest |
| 7 | White | Override |

---

## Dependencies

```
PYNQ Python:  pyserial · ipywidgets  (pynq already installed on board)
Arduino IDE:  Servo.h  (built into Arduino IDE — no install needed)
```
