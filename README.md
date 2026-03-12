# 🐒 Attendance Add-Ons — Output Node
**Platform:** PYNQ + Arduino Uno

---

## Overview

This is the **physical response layer** of the group's face recognition attendance system. It sits at the very end of the pipeline — once Marcus's AWS server has identified a person and made an access decision, this module handles everything that happens next.

That means: the correct LED fires on the PYNQ board, the servo rotates to physically simulate a door opening or staying shut, the buzzer plays a distinct audio pattern for each access type, everything gets logged locally, and the Jupyter dashboard updates in real time.

The module is **fully self-contained and demonstrable right now** without the rest of the pipeline connected. All seven access states can be triggered manually via dashboard buttons. When Marcus is ready to integrate, he calls one function and everything works automatically.

---

## Pipeline Position

```
Archit              Shashank            Marcus               Thanus
─────────────────   ─────────────────   ──────────────────   ────────────────────────────
FPGA camera input → Face recognition → AWS identity +     → handle_recognition_result()
Captures clean       Matches face        decision +                    ↓
cropped face         against database    SQL logging            PYNQ RGB LED (7 states)
image                                                           Arduino servo (door open/close)
                                                               Arduino buzzer (audio patterns)
                                                               Local backup log
                                                               Live Jupyter dashboard
                                                               Auto-escalation & security logic
```

### Marcus — integration is one function call

```python
# Fire this from your AWS handler once a decision is returned
handle_recognition_result(name, clearance_level, frame=None)

# Examples:
handle_recognition_result("prof_smith", "vip")
handle_recognition_result("Unknown", "denied")
handle_recognition_result("", "pending")              # fire this BEFORE AWS responds
handle_recognition_result("jane", "denied", frame=img) # pass Archit's frame for night capture
```

That's it. Everything else — LED, servo, buzzer, logging, escalation — fires automatically.

---

## Repository Structure

```
📁 output-node/
│
├── smart_node_v9.py            ← MAIN SYSTEM — run this on PYNQ in Jupyter
├── door_mechanism.ino          ← Arduino sketch — upload once via Arduino IDE
├── wiring_diagram.txt          ← Full wiring + breadboard layout (servo + buzzer)
├── README.md                   ← This file
├── SETUP_GUIDE.md              ← Step-by-step instructions from scratch to running
├── CODE_BREAKDOWN.md           ← Plain-English explanation of every part of the code
│
└── 📁 diagnostics/             ← Run these to verify hardware before demo day
    ├── cell1_overlay.py        ← PYNQ overlay loads correctly
    ├── cell2_plain_led.py      ← Plain LEDs 0–3 respond
    ├── cell3_rgb_led.py        ← RGB LED cycles all 7 colours
    ├── cell4_widget_render.py  ← Jupyter widgets render in browser
    ├── cell5_button_callback.py    ← Dashboard button callbacks fire
    ├── cell6_button_led_nosleep.py ← Callbacks can write to hardware
    ├── cell7_button_led_sleep.py   ← Callbacks work with time.sleep
    ├── cell8_physical_buttons.py   ← Physical BTN0/1/2 register presses
    └── cell10_integration.py       ← Full end-to-end pipeline test
```

---

## Hardware

| Component | Purpose | Notes |
|-----------|---------|-------|
| PYNQ-Z2 board | Main compute + RGB LED + physical buttons | All visual feedback is here |
| Arduino Uno | Servo controller + buzzer | Connected via USB — no separate power needed |
| USB A→B cable | PYNQ ↔ Arduino serial link + power | One cable handles both |
| Servo motor (SG90 or MG90S) | Physical door simulation | Rotates 0°→90° on grant, returns after 3s |
| Active buzzer | Distinct audio per access level | Must be **active** type — passive won't work |
| LDR + 10kΩ resistor *(optional)* | Ambient light sensor for day/night mode | Time-of-day used until available |

> **Why no LEDs on the Arduino?**  
> The PYNQ RGB LED already handles all visual feedback with 7 distinct colours and flash patterns. Adding LEDs on the Arduino would duplicate what the PYNQ already does. The Arduino owns audio and physical door — the PYNQ owns visuals.

> **Servo power note:** If the servo causes the Arduino to reset during a demo, it is drawing more current than the USB port can supply. Power the servo from an external 5V supply, sharing GND with the Arduino. Signal wire stays on Pin 6. See `wiring_diagram.txt`.

---

## Access States

Seven access states, each with a completely distinct PYNQ LED pattern, servo behaviour, and buzzer signature. Designed to be identifiable by sight or sound alone.

| State | PYNQ LED | Colour | LED Pattern | Servo | Buzzer |
|-------|----------|--------|-------------|-------|--------|
| `standard` | 🟢 | Green | Steady 3s | Opens 3s | 1 short beep |
| `vip` | 🔵 | Blue | Steady 3s — **fast-tracked** | Opens 3s | Rising 2-beep (short then long) |
| `guest` | 🟡 | Yellow | Steady 3s | Opens 3s | Soft single beep |
| `denied` | 🔴 | Red | 4-flash strobe | Stays shut | 3 descending beeps |
| `pending` | 🔷 | Cyan | Slow pulse 5s | Stays shut | 3 slow evenly-spaced pulses |
| `flagged` | 🟣 | Magenta | Double-flash ×3 | Stays shut | Double-burst alarm ×4 |
| `override` | ⚪ | White | Steady 3s | Opens 3s | Long single authority beep |

**Buzzer design rationale:** each pattern has a different feel. VIP rises (elevated), denied descends (rejected), pending pulses evenly (waiting), flagged bursts urgently (alert). You can tell what happened without looking at the screen.

---

## Features

### 🚪 Physical Door Mechanism
PYNQ sends a single character over USB serial to the Arduino on every access event. The Arduino sketch matches the character to a handler, plays the buzzer pattern, and rotates the servo 90° if access is granted — holding for 3 seconds before closing. Denied/pending/flagged states play their audio and do not open the door.

### 🔵 VIP Fast-Track
VIP access bypasses the cyan pending state entirely and goes straight to immediate response — blue LED + door open + rising 2-beep. Every other access level shows pending first while AWS processes. This creates a visible hierarchy in the system during a demo.

### 🌙 Day / Night Mode
Currently uses time-of-day (night = 8pm–8am). The system clock on the PYNQ determines the mode. Dashboard always shows current mode and time.

When a physical LDR is available, swap in 3 uncommented lines (see below) and calibrate one threshold value — everything else is automatic.

Night mode effects:
- **Denied** + face frame passed from Archit → saves capture image automatically
- **Flagged** → always saves capture image regardless of day or night

### ⚡ Auto-Escalation
Two independent escalation systems run at all times:

**Consecutive unknown escalation** — if `CONSEC_UNKNOWN_LIMIT` (default 3) unknown people are denied in a row, a sustained alarm fires automatically on both PYNQ and Arduino. Resets when anyone is granted access.

**Denial streak escalation** — if `DENIAL_STREAK_LIMIT` (default 5) denials happen within any rolling `DENIAL_STREAK_WINDOW_S` (default 120 seconds) window, a sustained alarm fires. Resets after firing. Catches brute-force attempts even if the person changes identity.

### ⏱️ Anti-Tailgate Cooldown
Same named person cannot re-trigger access within `ACCESS_COOLDOWN_S` (default 30) seconds. If they try, they get a denied flash, a dashboard message showing remaining cooldown time, and the event is logged. Unknown/test names are exempt.

### 🔒 Night Lockdown Mode
Dashboard button refuses all access regardless of clearance level until manually lifted. Only `override` bypasses it. Fires lockdown siren pattern on Arduino. Useful for securing the system during a break in a demo or for overnight simulation.

### 🔔 Arduino Heartbeat Monitor
Every `ARDUINO_PING_INTERVAL_S` (default 30) seconds, PYNQ sends `?` to the Arduino. The sketch responds with `K`. If no response is received, a hardware warning appears on the dashboard. Prevents the team finding out the USB cable was knocked loose only when the next access event fails to produce any sound.

### 📊 Live Access Rate
Dashboard shows how many named entries have occurred in the current hour, updated every 5 seconds. Useful for showing the system is working across multiple events during a demo.

### 💡 LED Boot Sequence
On startup, the PYNQ RGB LED cycles through all 7 colours before entering monitoring mode. Visual hardware self-check before any real access event. Arduino also plays a double-beep on boot. Both confirm the hardware is wired and working.

### 📋 Daily Access Report
Auto-generates `daily_report.txt` at midnight and on every clean shutdown. Includes counts for all seven access types plus the full named access history for that session. Useful for showing the system has been running and recording across a full demo period.

### 💾 Local Backup Log
Every event written to `attendance_log.txt` with timestamps, independently of Marcus's AWS/SQL logging. Persistent across sessions — appends, never overwrites.

### 📟 Physical PYNQ Buttons
| Button | Action | Notes |
|--------|--------|-------|
| BTN0 | Standard access | Same as clicking green dashboard button |
| BTN1 | VIP access | Same as clicking blue dashboard button |
| BTN2 | Guest access | Same as clicking yellow dashboard button |
| BTN3 | Clean shutdown | Saves report, clears LEDs, closes serial |

All debounced at `BTN_DEBOUNCE_S` (default 2 seconds) to prevent repeat triggers.

### 🛡️ Graceful Degradation
If Arduino is not connected, the system runs in LED-only mode automatically — PYNQ RGB LED still fires all 7 states, logging still works, dashboard still functions. No code changes or error handling needed from the team. The Arduino label on the dashboard shows ⚠️ Not connected so the state is always visible.

---

## Setup Summary

Full step-by-step instructions with expected outcomes and troubleshooting are in `SETUP_GUIDE.md`. Quick version:

```
1. Upload door_mechanism.ino to Arduino via Arduino IDE
   → Hear two short beeps confirming boot

2. Wire servo and buzzer to Arduino (see wiring_diagram.txt)
   Servo: signal→Pin6, VCC→5V, GND→GND
   Buzzer: (+)→Pin7, (-)→GND

3. Plug Arduino into PYNQ via USB A→B cable

4. On PYNQ, run in Jupyter:
   !pip install pyserial
   !jupyter nbextension enable --py widgetsnbextension --sys-prefix
   # Restart kernel

5. Find port:
   import subprocess
   print(subprocess.run(['ls','/dev/ttyUSB*'],capture_output=True,text=True).stdout)

6. Update ARDUINO_PORT in smart_node_v9.py to match

7. Set VIP_NAMES and FLAGGED_NAMES to match Shashank's known_faces/ filenames

8. Run smart_node_v9.py in Jupyter — watch boot sequence, check dashboard
```

---

## Connecting Physical Light Sensor (When Available)

Currently using time-of-day. When LDR is available, uncomment 3 lines in Section 2 of `smart_node_v9.py`:

```python
# OPTION A block — remove the # from these three lines:
from pynq.lib import Pmod_ADC
_pmod_adc = Pmod_ADC(base.PMODA)
LIGHT_SENSOR_AVAILABLE = True
```

Then calibrate by running in a separate cell:

```python
from pynq.lib import Pmod_ADC
from pynq.overlays.base import BaseOverlay
import time
base = BaseOverlay("base.bit")
s = Pmod_ADC(base.PMODA)
for _ in range(10):
    print(s.read())   # note bright room value
    time.sleep(1)
# Cover sensor with hand — note dark value
# Set NIGHT_THRESHOLD_V in smart_node_v9.py to a value between the two
```

Wiring: LDR and 10kΩ resistor as a voltage divider into PMODA. See `wiring_diagram.txt` for the full diagram.

---

## Integration Reference

### Marcus / AWS
```python
handle_recognition_result(
    name,              # str  — person's name e.g. "prof_smith", or "Unknown"
    clearance_level,   # str  — one of the 7 levels listed below
    frame=None         # ndarray (optional) — Archit's face image
                       # pass this for auto-capture on denied/flagged at night
)

# Valid clearance levels and what happens:
#
# "standard"  →  green LED steady 3s · servo opens · 1 beep
# "vip"       →  blue LED steady 3s · servo opens · rising 2-beep · FAST-TRACKED
# "guest"     →  yellow LED steady 3s · servo opens · soft beep
# "denied"    →  red strobe · door shut · 3 descending beeps
# "pending"   →  cyan pulse 5s · door shut · slow pulses  ← fire BEFORE AWS result
# "flagged"   →  magenta double-flash · door shut · alarm pattern · saves face image
# "override"  →  white LED steady 3s · servo opens · long beep · bypasses lockdown
```

### Recommended call pattern
```python
# Step 1 — as soon as face is detected (before AWS responds)
handle_recognition_result("", "pending")

# Step 2 — once AWS returns the decision
handle_recognition_result("prof_smith", "vip")
```

### Shashank / face recognition (via Archit's pipeline)
```python
# Call this with the image path when a face frame is ready
process_face_image("/path/to/face.jpg", frame=img)
# Fires pending immediately, runs match_face.py, handles the rest
```

### Configuring name lists
```python
# In Section 1 of smart_node_v9.py
# Use filename stems from Shashank's known_faces/ directory

VIP_NAMES     = ["prof_smith", "dr_jones"]   # blue LED + fast-track + rising 2-beep
FLAGGED_NAMES = ["banned_user"]              # magenta flash + alarm + always captures

# All other known matches  → standard (green)
# No match                 → denied (red strobe)
```

---

## Tunable Constants

All in Section 1 of `smart_node_v9.py`. Edit values here — never touch the logic below.

| Constant | Default | What it controls |
|----------|---------|-----------------|
| `ARDUINO_PORT` | `/dev/ttyUSB0` | USB port for Arduino serial connection |
| `ARDUINO_BAUDRATE` | `9600` | Serial baud rate — must match Arduino sketch |
| `NIGHT_START_HOUR` | `20` | Hour night mode begins (8pm) |
| `NIGHT_END_HOUR` | `8` | Hour night mode ends (8am) |
| `NIGHT_THRESHOLD_V` | `0.5` | LDR voltage for night detection (physical sensor only) |
| `ACCESS_COOLDOWN_S` | `30` | Anti-tailgate: seconds before same person can re-enter |
| `BTN_DEBOUNCE_S` | `2.0` | Physical button minimum gap (seconds) |
| `CONSEC_UNKNOWN_LIMIT` | `3` | Unknown denials in a row before auto-alarm |
| `DENIAL_STREAK_LIMIT` | `5` | Denials in window before sustained alarm |
| `DENIAL_STREAK_WINDOW_S` | `120` | Rolling window for denial streak check (seconds) |
| `ARDUINO_PING_INTERVAL_S` | `30` | Seconds between Arduino heartbeat checks |
| `MAX_LOG_DISPLAY` | `12` | Lines shown in live event log widget |
| `MAX_HISTORY_DISPLAY` | `20` | Lines shown in named access history widget |

---

## Confirmed PYNQ-Z2 RGB LED Colour Map

Empirically verified on this board — do not assume these match other PYNQ boards.

| Code | Colour | Used for |
|------|--------|---------|
| 0 | Off | Default / reset |
| 1 | Blue | VIP |
| 2 | Green | Standard |
| 3 | Cyan | Pending |
| 4 | Red | Denied / Alarm |
| 5 | Magenta | Flagged |
| 6 | Yellow | Guest |
| 7 | White | Override |

---

## Arduino Serial Command Reference

| Char | Triggered by | Servo | Buzzer pattern |
|------|-------------|-------|----------------|
| `G` | Standard | Opens 3s | 1 short beep (120ms) |
| `V` | VIP | Opens 3s | Rising 2-beep: 80ms then 200ms |
| `U` | Guest | Opens 3s | Soft single beep (60ms) |
| `D` | Denied / cooldown block | Stays shut | 3 descending: 180ms → 120ms → 60ms |
| `P` | Pending | Stays shut | 3 slow pulses: 60ms × 3, 450ms gap |
| `F` | Flagged | Stays shut | Double-burst alarm × 4 |
| `O` | Override | Opens 3s | Long authority beep (600ms) |
| `A` | Alarm (auto or manual) | Stays shut | 10 rapid pulses (70ms each) |
| `L` | Lockdown activated | Stays shut | Long-short siren × 3 |
| `?` | Heartbeat ping | — | Responds `K` (no audio) |

## Dependencies

```
PYNQ (Python):   pyserial · ipywidgets
                 (pynq itself is pre-installed on the board)

Arduino IDE:     Servo.h  — built into Arduino IDE, no install required
```

---

## Further Reading

| Document | Purpose |
|----------|---------|
| `SETUP_GUIDE.md` | 19-step guide from unboxing to running, with expected outcomes and troubleshooting |
| `CODE_BREAKDOWN.md` | Plain-English explanation of every section of the code and why decisions were made |
| `wiring_diagram.txt` | Full wiring detail, breadboard layout, and LDR instructions |
