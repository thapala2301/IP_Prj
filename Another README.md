# Output Node — Thanus
### Physical Response Layer · Face Recognition Attendance System

---

## Pipeline Position

```
Archit (FPGA) → Shashank (Face Rec) → Marcus (AWS) → THIS NODE → Physical Outputs
```

---

## What This Does

Receives a single function call from Marcus and drives all physical outputs:

| Decision | LED | Door | Buzzer |
|---|---|---|---|
| `pending` | Cyan pulse | Shut | 3 slow pulses |
| `granted` | Green steady (3s) | Opens 3s | 1 clean beep |
| `denied` | Red strobe | Shut | 3 descending beeps |
| `alarm` *(auto)* | Red rapid flash | Shut | 10 rapid pulses |

**Security escalation fires automatically** — no manual trigger needed:
- 3 denials in a row → alarm
- 5 denials within 2 minutes → alarm

**Night mode** (8pm–8am): if a frame image is passed in on a denied result, the face is saved to `/captures/`.

Every event is timestamped and logged to `attendance_log.txt`.

Physical buttons on the PYNQ board work standalone:
- **BTN0** → simulate granted
- **BTN1** → simulate denied  
- **BTN3** → clean shutdown

---

## Files

| File | What it is |
|---|---|
| `smart_node.py` | Main Python script — runs on the PYNQ in Jupyter |
| `door_mechanism.ino` | Arduino sketch — controls servo + buzzer |

---

## Hardware Wiring

**Arduino → Servo**
```
Servo signal (orange/yellow) → Arduino Pin 6
Servo VCC (red)              → Arduino 5V
Servo GND (brown/black)      → Arduino GND
```

**Arduino → Buzzer**
```
Buzzer (+) → Arduino Pin 7
Buzzer (-) → Arduino GND
```
> Must be an **active** buzzer (has a small circuit board on it). Passive buzzers won't work.

> If the servo causes the Arduino to reset during demo, power the servo from an external 5V supply sharing GND with the Arduino — USB power is sometimes insufficient.

---

## Setup — Arduino (do this first, needs Arduino IDE on a laptop)

1. Open Arduino IDE → File → Open → `door_mechanism.ino`
2. Tools → Board → Arduino AVR Boards → **Arduino Uno**
3. Plug Arduino into laptop via USB
4. Tools → Port → select the port that appears
5. Click **Upload** (→ arrow). Wait for "Done uploading"
6. ✅ You should hear **two short beeps** — confirms Arduino is alive and wired correctly
7. Wire servo and buzzer as above
8. Unplug from laptop, plug into **PYNQ's USB-A port** — two beeps again = good

---

## Setup — PYNQ (do this in Jupyter)

**Step 1 — Upload files**

Upload `smart_node.py` via the Jupyter file browser.

**Step 2 — Install dependencies** *(one time only)*

```python
!pip install pyserial
!jupyter nbextension enable --py widgetsnbextension --sys-prefix
```
Then: **Kernel → Restart**

**Step 3 — Find Arduino port**

```python
import subprocess
print(subprocess.run(['ls', '/dev/ttyUSB*'], capture_output=True, text=True).stdout)
print(subprocess.run(['ls', '/dev/ttyACM*'], capture_output=True, text=True).stdout)
```

**Step 4 — Set port in smart_node.py**

Open `smart_node.py`, find this line near the top and update if needed:
```python
ARDUINO_PORT = "/dev/ttyUSB0"
```

**Step 5 — Run the system**

```python
exec(open("smart_node.py").read())
```

✅ LED cycles green → cyan → red → white (boot self-test), then prints `Ready. Waiting for Marcus...`

---

## Testing (run these in Jupyter after startup)

**Test 1 — Full hardware walkthrough**
```python
test_all()
```
Expected: cyan pulse (5s) → green steady (3s) → red strobe. Buzzer on each. Door opens on granted.

**Test 2 — Individual states**
```python
handle_recognition_result("granted")
handle_recognition_result("denied")
handle_recognition_result("pending")
```

**Test 3 — Security escalation**
```python
import time
for i in range(3):
    print(f"Denial {i+1}")
    handle_recognition_result("denied")
    time.sleep(2)
# 3rd denial triggers alarm automatically
```

**Test 4 — Full pipeline simulation**
```python
import time
handle_recognition_result("pending")   # processing...
time.sleep(2)
handle_recognition_result("granted")   # result: in the system
time.sleep(4)
handle_recognition_result("denied")    # result: not in the system
```

**Test 5 — Arduino only (isolate serial comms)**
```python
send_to_arduino("G")   # open door + beep
time.sleep(4)
send_to_arduino("D")   # denial beeps
time.sleep(2)
send_to_arduino("A")   # alarm
```

---

## Integration — For Marcus

Import and call one function from your AWS script:

```python
from smart_node import handle_recognition_result

# While face rec is processing (optional but good UX):
handle_recognition_result("pending")

# Once you get the result back:
handle_recognition_result("granted")   # person is in the system
handle_recognition_result("denied")    # person is not in the system

# Optional — pass the frame for night mode face capture on denied:
handle_recognition_result("denied", frame=img)
```

That's it. Don't import anything else. Everything else is automatic.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Dashboard doesn't appear | Re-run `!jupyter nbextension enable --py widgetsnbextension --sys-prefix`, restart kernel |
| Arduino shows not connected | Check port with `ls /dev/ttyUSB*`, update `ARDUINO_PORT` in smart_node.py |
| No buzzer sound | Confirm active buzzer (not passive), check Pin 7 → (+), GND → (−) |
| Servo not moving | Check signal → Pin 6, VCC → 5V, GND → GND. Try external 5V supply if Arduino resets |
| Port changes every session | Run `ls /dev/ttyUSB*` each time to check, update `ARDUINO_PORT` |
