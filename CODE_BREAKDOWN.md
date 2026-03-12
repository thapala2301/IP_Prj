# CODE BREAKDOWN — Attendance Add-Ons Output Node
# What the code actually does, section by section.


THE BIG PICTURE
The script does one job: receive a decision from Marcus's AWS server and make
something happen physically — LED lights up, door opens, buzzer beeps.

The entire public interface is one function:

    handle_recognition_result("prof_smith", "vip")

Marcus calls that. Everything else fires automatically.

Here is the flow from that call to physical hardware:

    Marcus calls handle_recognition_result()
              ↓
         spawns a thread
              ↓
         trigger_access() runs
              ↓
         ┌─────────────────────────────────┐
         │  PYNQ RGB LED fires             │  ← colour depends on access level
         │  _send() writes to serial port  │  ← single character to Arduino
         └─────────────────────────────────┘
                        ↓
              Arduino receives character
              Arduino sketch runs handler
              Servo rotates (if granted)
              Buzzer plays pattern


SECTION 1 — TUNEABLE CONSTANTS

These are all the numbers in the system that you might want to adjust.
They live at the top of the file so you never have to dig into the logic.

    ARDUINO_PORT = "/dev/ttyUSB0"
    → The USB port the Arduino is plugged into on the PYNQ.
      Run 'ls /dev/ttyUSB*' to find the right value for your setup.

    NIGHT_START_HOUR = 20
    NIGHT_END_HOUR = 8
    → Night mode runs from 8pm to 8am. Change these if you want different hours.
      Night mode makes denied/flagged events save a face capture image.

    ACCESS_COOLDOWN_S = 30
    → After someone is granted access, they can't trigger it again for 30 seconds.
      Prevents tailgating (holding the door open and waving people through).

    CONSEC_UNKNOWN_LIMIT = 3
    → If 3 unknown people in a row are denied, an alarm fires automatically.

    DENIAL_STREAK_LIMIT = 5
    DENIAL_STREAK_WINDOW_S = 120
    → If 5 denials happen within any 2-minute period, sustained alarm fires.
      This catches a brute-force attempt even if the person keeps changing.

    ACCESS_LEVELS = { ... }
    → Maps each access level name to its LED colour code, duration, and the
      character that gets sent to the Arduino.
      Example: "vip" → colour 1 (blue), 3 seconds, sends "V" to Arduino.

    VIP_NAMES = []
    FLAGGED_NAMES = []
    → Names that get elevated/restricted treatment.
      These must match the filename stems in Shashank's known_faces/ folder.


SECTION 2 — HARDWARE SETUP

    BaseOverlay("base.bit")
    → Loads the FPGA bitfile. This configures the PYNQ hardware — without it,
      none of the LEDs or buttons work. Must happen before anything else.

    LED_MAP = [base.leds[i] for i in range(4)]
    → The four plain green LEDs on the PYNQ board. LED 3 blinks as a heartbeat
      so you can see the system is alive at a glance.

    LOCK_LED = base.rgbleds[4]
    → The RGB LED that shows access state (green, blue, red, etc.).
      Writing a number to it changes the colour: LOCK_LED.write(2) = green.

    read_light() and is_night()
    → Currently uses time-of-day (8pm–8am = night). When a physical LDR sensor
      is plugged into PMODA, uncomment 3 lines and this uses real voltage instead.

    _connect_arduino()
    → Opens a serial connection to the Arduino over USB. If it can't connect
      (Arduino not plugged in, wrong port, etc.) it sets arduino = None and
      the system continues without it — PYNQ LED still works fine.

    _send(cmd)
    → Sends one character to the Arduino. For example _send("G") triggers the
      standard access handler on the Arduino side. Silent if not connected.


SECTION 3 — SHARED STATE

    state = { ... }
    → A dictionary that all parts of the code read from and write to.
      It holds things like: when each button was last pressed (for debounce),
      who was last granted access and when (for cooldown), the session counts,
      and the list of running background threads.

    shutdown_event = threading.Event()
    → A flag that every thread checks. When BTN3 is pressed, this gets set.
      Every loop and sleep in the code checks it and exits cleanly if set.
      This is how the system shuts down without leaving LEDs stuck on.

    lockdown_active = threading.Event()
    → Same pattern but for night lockdown. When set, trigger_access() blocks
      all access attempts (except override) before doing anything else.



SECTION 4 — DASHBOARD WIDGETS

The dashboard is built using ipywidgets — a library that lets you create
interactive UI elements inside Jupyter Notebook.

    widgets.HTML(...)
    → Displays formatted text. Used for the header, status labels, and the
      system guide. You can update the text at runtime by setting .value.

    widgets.Button(...)
    → Clickable button. Each button has an .on_click() callback wired to a
      function that calls trigger_access() with the right level.

    widgets.Textarea(...)
    → Scrollable text area. Used for the event log and access history.
      New entries are prepended to the top so newest is always visible.

    widgets.VBox / HBox
    → Layout containers. VBox stacks things vertically, HBox places them
      side by side. Used to arrange the dashboard in rows.

    out = widgets.Output()
    → A container that wraps the whole dashboard. Required for classic
      Jupyter Notebook to reliably render widgets — without it the dashboard
      can silently fail to appear.



SECTION 5 — LOGGING & DISPLAY

    log_event(message)
    → Two things happen simultaneously:
      1. The message is written to attendance_log.txt with a timestamp
      2. The message is prepended to the live log widget in the dashboard
      Every significant thing the system does calls this.

    log_access_history(name, level_key)
    → Separate from the event log. Only records named people (not test
      button presses, unknowns, or system messages). Goes into the history
      widget and also updates the hourly access rate counter.

    update_session_label()
    → Refreshes the session counter row on the dashboard showing how many
      of each access type have occurred since startup.

    update_status_bar()
    → Refreshes the mode (day/night), Arduino connection status, and
      entries-per-hour count. Called by the background sensor loop every 5s.

    generate_daily_report()
    → Writes a summary to daily_report.txt. Called at midnight automatically
      and also at every clean shutdown. Includes all session counts and the
      full named access history.



SECTION 6 — HARDWARE RESPONSE


    flash_alarm(flashes)
    → Rapidly turns LOCK_LED red on and off. Checks shutdown_event between
      each flash so it stops immediately if the system is shutting down.

    led_boot_sequence()
    → On startup, cycles through all 7 LED colours in sequence (green, blue,
      yellow, red, cyan, magenta, white). This visually confirms the RGB LED
      hardware is working before any real access event happens.

    save_frame(frame, reason)
    → Saves a face image passed in from Archit's camera as a JPEG file.
      Filename format: capture_denied_20260312_143022.jpg
      Only called when a frame is actually passed in — never touches a camera.



SECTION 7 — ACCESS CONTROL LOGIC

    _check_cooldown(name)
    → Looks up when this person last accessed. If it's been less than
      ACCESS_COOLDOWN_S seconds, blocks them and shows a countdown on the
      dashboard. Returns True (allowed) or False (blocked).

    _track_denials(name, is_denial)
    → Called after every access event. Maintains two counters:
      
      1. consecutive_unknowns — increments when an unknown person is denied.
         Resets to zero when anyone is granted access or a named person is denied.
         Hits CONSEC_UNKNOWN_LIMIT → fires _fire_alarm().
      
      2. denial_timestamps — a queue of timestamps of all recent denials.
         Old entries (outside DENIAL_STREAK_WINDOW_S) are removed each time.
         Queue length hits DENIAL_STREAK_LIMIT → fires _fire_alarm().

    _fire_alarm()
    → Increments the alarm counter, sends "A" to Arduino, starts a flash_alarm
      thread. Separated into its own function so it can be called from multiple
      places (denial tracking, lockdown, manual button) without code duplication.

    trigger_access(level_key, name, frame)
    → The core function. Everything routes through here.
      Order of operations:
        1. Check shutdown_event — bail immediately if shutting down
        2. Check lockdown — block if active (unless override)
        3. Check cooldown — block if same person too soon
        4. Log the event, update history and counters
        5. Send serial command to Arduino
        6. Drive PYNQ LED with the right colour and pattern for this level
        7. Reset status label to MONITORING when done



SECTION 8 — PUBLIC INTEGRATION HOOKS

    handle_recognition_result(name, clearance_level, frame=None)
    → The one function Marcus calls. Spawns a new thread to run trigger_access()
      so it doesn't block Marcus's code while the LED and servo do their thing.
      
      Threading here is important — without it, Marcus's AWS code would have to
      wait 3 seconds for the door LED to finish before continuing.

    _map_to_level(name, status)
    → Translates Shashank's match_face.py output format into our level strings.
      Rules in priority order:
        No match or status != MATCH → "denied"
        Name in FLAGGED_NAMES       → "flagged"
        Name in VIP_NAMES           → "vip"
        Anything else               → "standard"

    process_face_image(image_path, frame)
    → The bridge to Shashank's face recognition script. Archit calls this
      when a face image is ready. It:
        1. Immediately fires "pending" (cyan LED) so there's instant feedback
        2. Runs match_face.py as a subprocess and captures the JSON output
        3. Parses the result and calls handle_recognition_result()
      If the script times out or crashes, it fails safe to "denied".


SECTION 9 — BUTTON CALLBACKS

Each dashboard button is wired to a small function that calls trigger_access()
with the appropriate level. The 'b' parameter is the button object that Jupyter
passes automatically — we don't use it, but it must be in the signature.

    _btn_alarm(b)
    → Slightly different from the others — calls _fire_alarm() directly rather
      than going through trigger_access(), because an alarm is not an access
      event and shouldn't go through cooldown or lockdown checks.

    _btn_lockdown(b)
    → Sets the lockdown_active event, updates the dashboard label, sends "L"
      to Arduino (lockdown siren), and flashes the PYNQ LED red.

    _btn_unlock(b)
    → Clears the lockdown_active event and restores MONITORING status.


SECTION 10 — BACKGROUND THREADS

The system runs four threads in parallel once started:

    _main_loop (thread: "main")
    → Polls the three physical PYNQ buttons (BTN0/1/2) at 20Hz.
      Checks BTN3 in the while condition — when pressed, the loop exits
      and the finally block runs the clean shutdown sequence.
      Also the thread that, on exit, joins all other threads and clears hardware.

    _heartbeat_loop (thread: "heartbeat")  
    → Every 30 seconds sends "?" to the Arduino and waits for "K" back.
      If no response, logs a warning and updates the dashboard label.
      This lets the team know immediately if the USB cable gets knocked loose
      during a demo rather than finding out when the next access event fails.

    _midnight_report_loop (thread: "midnight")
    → Sleeps until midnight, generates daily report, sleeps until next midnight.
      Checks shutdown_event in 60-second intervals so it exits cleanly.

    _status_update_loop (thread: "status")
    → Refreshes the status bar (day/night mode, Arduino status, access rate)
      every 5 seconds. Also blinks LED 3 as a heartbeat indicator.

Why background threads?
    Classic Jupyter Notebook has one kernel thread. If the main loop ran in the
    kernel thread, button clicks could never execute because the kernel would be
    stuck in the loop. By moving everything to background threads, the kernel
    stays free and button callbacks fire instantly when clicked.


SECTION 11 — STARTUP

    start_system()
    → Called once at the bottom of the file. Does four things in order:
      1. Tries to connect to Arduino (_connect_arduino)
      2. Renders the dashboard inside the Output widget
      3. Waits 1 second for Jupyter to finish rendering before threads start
      4. Launches all four background threads

    The 1-second wait is important — if threads start writing to widgets
    before Jupyter has finished rendering them, the dashboard can go blank.


ARDUINO SKETCH SUMMARY (door_mechanism.ino)

The Arduino sketch is simple by design. It does one thing in a loop:

    void loop() {
        if there is a byte waiting on serial:
            read it
            run the matching handler
    }

Each handler function does two things: plays a buzzer pattern, and optionally
rotates the servo. The servo is always returned to DOOR_CLOSED (0°) after
DOOR_HOLD_MS milliseconds (3 seconds by default).

The buzzer patterns are designed to be distinct by feel:
    Standard  — neutral, clean single beep
    VIP       — rising (short then longer) — feels elevated
    Guest     — short and soft — lesser temporary access feel
    Denied    — descending (gets shorter each beep) — feels like rejection
    Pending   — evenly spaced slow pulses — feels like waiting/processing
    Flagged   — double-burst alarm repeated — urgent attention
    Override  — single long firm beep — authority feel
    Alarm     — rapid continuous pulses — maximum urgency
    Lockdown  — alternating long-short siren — distinct from alarm

The heartbeat handler responds to "?" with "K" so the PYNQ can verify the
Arduino is still alive without triggering any audio or movement.


HOW DAY/NIGHT MODE WORKS

Currently: time-of-day. The system checks the hour from the PYNQ clock.
    Hour < 8 (before 8am) or Hour >= 20 (from 8pm) = night mode

In night mode, two things change:
    1. Denied access + face frame passed in → face image saved automatically
    2. Flagged access → face image always saved (regardless of day/night)

When a physical LDR is added:
    read_light() returns a voltage (0.0–3.3V).
    Low voltage = dark room = night mode.
    Threshold is set by NIGHT_THRESHOLD_V and calibrated manually.


HOW THREADING SAFETY WORKS
Multiple things can happen at the same time (button clicked while Arduino
heartbeat is running, etc.). Two mechanisms keep this safe:

    shutdown_event
    → A threading.Event(). Set once when BTN3 is pressed.
      Every function that loops or sleeps checks this before each iteration.
      This means clean shutdown always happens promptly — nothing stays stuck.

    daemon=False on threads
    → Non-daemon threads must finish before Python exits.
      This ensures access events that are mid-execution (servo holding, LED on)
      complete properly rather than being killed abruptly on shutdown.
      The finally block joins all threads with a 1.5s timeout to bound the wait.

