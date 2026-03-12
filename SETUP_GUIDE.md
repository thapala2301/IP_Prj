# SETUP GUIDE — Attendance Add-Ons Output Node
# Step-by-step instructions for getting everything running from scratch.
# Follow in order. Each step has a clear expected outcome so you know it worked.


# PART 1 — ARDUINO SETUP
Do this on a laptop with Arduino IDE installed, before touching the PYNQ.

STEP 1 — Install Arduino IDE
  Download from: https://www.arduino.cc/en/software
  Install and open it.

  Expected outcome: Arduino IDE opens with no errors.

────────────────────────────────────────────────────────────────────────────────

STEP 2 — Open the sketch
  File → Open → navigate to door_mechanism.ino → open it.

  Expected outcome: The sketch loads in the editor.

────────────────────────────────────────────────────────────────────────────────

STEP 3 — Select the board
  Tools → Board → Arduino AVR Boards → Arduino Uno

  Expected outcome: "Arduino Uno" appears in the bottom status bar.

────────────────────────────────────────────────────────────────────────────────

STEP 4 — Plug in the Arduino
  Connect Arduino Uno to your laptop via USB A-to-B cable.

  Expected outcome: A new port appears under Tools → Port
  (e.g. COM3 on Windows, /dev/ttyUSB0 on Linux/Mac)

────────────────────────────────────────────────────────────────────────────────

STEP 5 — Select the port
  Tools → Port → select the port that appeared in Step 4.

────────────────────────────────────────────────────────────────────────────────

STEP 6 — Upload the sketch
  Click the Upload button (→ arrow icon, top left).
  Wait for "Done uploading" in the status bar.

  Expected outcome: You hear TWO short beeps from the buzzer.
  This confirms the Arduino booted and the buzzer is wired correctly.

  If you hear nothing: check buzzer wiring (see wiring_diagram.txt).
  If upload fails: check the correct port is selected in Step 5.

────────────────────────────────────────────────────────────────────────────────

STEP 7 — Wire servo and buzzer to Arduino
  Follow wiring_diagram.txt exactly. Summary:

    Servo signal (orange/yellow wire) → Arduino Pin 6
    Servo VCC (red wire)              → Arduino 5V
    Servo GND (brown/black wire)      → Arduino GND

    Active buzzer (+)                 → Arduino Pin 7
    Active buzzer (-)                 → Arduino GND

  After wiring, unplug and replug the Arduino USB.
  Expected outcome: Two short beeps again (boot confirmation).
  Servo should twitch slightly on power-up — this is normal.

  ⚠ If servo causes Arduino to reset or jitter:
    Power the servo from an external 5V supply instead of the Arduino 5V pin.
    Servo signal wire stays on Pin 6. Share GND between Arduino and supply.
    See wiring_diagram.txt for detail.

────────────────────────────────────────────────────────────────────────────────

STEP 8 — Keep Arduino plugged in via USB
  The same USB cable that uploaded the sketch will now carry serial data
  from the PYNQ. Plug the Arduino into the PYNQ's USB-A port.

  Expected outcome: Arduino powers on (two beeps) from PYNQ's USB.


# PART 2 — PYNQ SETUP
Do this in the PYNQ Jupyter Notebook interface (open in browser).

STEP 9 — Open Jupyter on the PYNQ
  Connect to PYNQ over network and open Jupyter in your browser.
  Default address is usually: http://192.168.2.99 or http://pynq.local
  Default password: xilinx

  Expected outcome: Jupyter file browser loads.

────────────────────────────────────────────────────────────────────────────────

STEP 10 — Upload files to PYNQ
  In the Jupyter file browser, click Upload (top right) and upload:
    · smart_node_v9.py

  Expected outcome: smart_node_v9.py appears in the file browser.

────────────────────────────────────────────────────────────────────────────────

STEP 11 — Install pyserial (one time only)
  In Jupyter, click New → Notebook → Python 3.
  In the first cell, run:

    !pip install pyserial

  Expected outcome: Output ends with "Successfully installed pyserial-x.x"
  If already installed: "Requirement already satisfied" — also fine.

────────────────────────────────────────────────────────────────────────────────

STEP 12 — Enable Jupyter widgets (one time only)
  In the same or a new cell, run:

    !jupyter nbextension enable --py widgetsnbextension --sys-prefix

  Expected outcome: Output says "Enabling notebook extension..."
  Then RESTART THE KERNEL: Kernel → Restart.

────────────────────────────────────────────────────────────────────────────────

STEP 13 — Find the Arduino port
  With Arduino plugged into PYNQ via USB, run in a cell:

    import subprocess
    print(subprocess.run(['ls', '/dev/ttyUSB*'], capture_output=True, text=True).stdout)
    print(subprocess.run(['ls', '/dev/ttyACM*'], capture_output=True, text=True).stdout)

  Expected outcome: One line appears, e.g. /dev/ttyUSB0 or /dev/ttyACM0

  If nothing appears: try unplugging and replugging the Arduino, run again.
  The new entry that appears is your port.

────────────────────────────────────────────────────────────────────────────────

STEP 14 — Update ARDUINO_PORT in smart_node_v9.py
  Open smart_node_v9.py in Jupyter (click it in the file browser).
  Find this line near the top (Section 1):

    ARDUINO_PORT = "/dev/ttyUSB0"

  Change the value to match what you found in Step 13.
  Save the file: Ctrl+S.

────────────────────────────────────────────────────────────────────────────────

STEP 15 — Configure VIP and flagged names (before first real use)
  Still in smart_node_v9.py, find these two lines in Section 1:

    VIP_NAMES     = []
    FLAGGED_NAMES = []

  Fill them with the name stems from Shashank's known_faces/ directory.
  The stem is the filename without the extension.
  Example: if Shashank has "prof_smith.jpg" → add "prof_smith"

    VIP_NAMES     = ["prof_smith", "dr_jones"]
    FLAGGED_NAMES = ["banned_user"]

  Anyone not in either list who matches → Standard access.
  Anyone who doesn't match at all → Denied.

  Save the file.

────────────────────────────────────────────────────────────────────────────────

STEP 16 — Run the system
  Open smart_node_v9.py in Jupyter.
  Select all the code (Ctrl+A) and run it (Shift+Enter, or Run → Run All).

  Expected outcome (in order):
    1. PYNQ RGB LED cycles through all 7 colours (green, blue, yellow, red,
       cyan, magenta, white) — boot sequence confirming LED works
    2. Dashboard appears in the cell output below
    3. Dashboard shows: Arduino ✅ Connected
    4. Event log shows: "SYSTEM: Boot sequence complete ✓"

  If dashboard doesn't appear: run Step 12 again and restart kernel.
  If Arduino shows ❌ Not connected: check Step 13-14, rerun.

────────────────────────────────────────────────────────────────────────────────

STEP 17 — Test manually before handing to Marcus
  With the system running, test each button:

    ✅ Authorize Standard  → green LED lights, servo rotates, 1 beep
    🔵 Authorize VIP       → blue LED lights, servo rotates, 2 rising beeps
    🟡 Authorize Guest     → yellow LED lights, servo rotates, soft beep
    🔴 Simulate DENY       → red LED strobes, servo stays, 3 descending beeps
    🔷 Simulate Pending    → cyan LED pulses, servo stays, 3 slow pulse beeps
    ⚠️ Simulate Flagged    → magenta LED flashes, servo stays, double-beep ×4
    ⚪ Supervisor Override → white LED lights, servo rotates, long beep
    🚨 Manual Alarm        → red strobe, 10-pulse rapid alarm on buzzer

  If a button does nothing: see TROUBLESHOOTING below.

────────────────────────────────────────────────────────────────────────────────

STEP 18 — Hand off to Marcus
  Tell Marcus:

    "Call handle_recognition_result(name, level) from your AWS code.
     Valid levels: standard, vip, guest, denied, pending, flagged, override.
     Optionally pass frame=img if you want face captures on denied/flagged."

  That's it. Marcus imports nothing. He just calls that function.

────────────────────────────────────────────────────────────────────────────────

STEP 19 — Shutting down
  Press BTN3 on the PYNQ board.

  Expected outcome:
    · All LEDs turn off
    · Servo returns to closed position
    · Event log shows "SYSTEM: Shut down cleanly"
    · daily_report.txt is written automatically



# OPTIONAL — ADDING PHYSICAL LIGHT SENSOR (LDR)
Do this if you want real ambient light detection instead of time-of-day.


STEP A — Wire the LDR to PMODA
  You need: 1x LDR, 1x 10kΩ resistor.

  PMODA 3.3V ──── LDR ──┬──── PMODA Analog In (pin 1)
                         │
                        10kΩ
                         │
  PMODA GND  ────────────┘

STEP B — Uncomment 3 lines in smart_node_v9.py
  Find the OPTION A block in Section 2 and uncomment:

    from pynq.lib import Pmod_ADC
    _pmod_adc = Pmod_ADC(base.PMODA)
    LIGHT_SENSOR_AVAILABLE = True

STEP C — Calibrate the threshold
  Run in a separate cell:

    from pynq.lib import Pmod_ADC
    from pynq.overlays.base import BaseOverlay
    import time
    base = BaseOverlay("base.bit")
    s = Pmod_ADC(base.PMODA)
    for _ in range(10):
        print(s.read())
        time.sleep(1)

  Note the value in a bright room, then cover the LDR and note the dark value.
  Set NIGHT_THRESHOLD_V in smart_node_v9.py to a number between the two.


# TROUBLESHOOTING

Problem: Dashboard doesn't appear at all
  → Run: !jupyter nbextension enable --py widgetsnbextension --sys-prefix
  → Restart kernel, run script again.

Problem: Arduino shows ❌ Not connected
  → Check Arduino is plugged into PYNQ USB port
  → Run ls /dev/ttyUSB* in a cell and confirm ARDUINO_PORT matches
  → Check pyserial is installed: !pip install pyserial

Problem: Buttons do nothing
  → The main loop must be running before buttons work
  → Make sure you ran the full script (not just part of it)
  → Try running the full cell again from scratch with Kernel → Restart

Problem: Servo not moving
  → Check wiring: signal to Pin 6, VCC to 5V, GND to GND
  → Try the servo on a different 5V supply if it resets the Arduino

Problem: No buzzer sound
  → Confirm you are using an ACTIVE buzzer (has a small PCB board on top)
  → Check wiring: (+) to Pin 7, (-) to GND
  → Passive buzzers will not work with this sketch

Problem: Port changes every time Arduino is plugged in
  → Run ls /dev/ttyUSB* each session to check, update ARDUINO_PORT if needed
  → Or create a udev rule to give the Arduino a fixed port name (ask Archit)

