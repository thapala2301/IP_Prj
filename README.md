# IP_Prj

Attendance Add-Ons — Output Node Summary
What this script is: The hardware response layer of a group face recognition attendance system, running on a PYNQ-Z2 board via Jupyter Notebook. It handles everything that happens after a face is identified — LEDs, logging, security responses, and environmental awareness.

Architecture
The main camera loop runs in a background thread (_main_loop), keeping Jupyter's kernel thread free so dashboard button clicks actually execute. A shutdown_event flag coordinates clean exit across all threads — pressing BTN3 signals every thread to stop, waits up to 1.5s for them to finish, then clears all hardware.

Access States (7 total)
StateLEDBehaviourStandard🟢 GreenSteady 3sVIP🔵 BlueSteady 3sGuest🟡 YellowSteady 3sDenied🔴 Red4-flash strobe + night capturePending🩵 CyanSlow pulse 5s — face detected, awaiting resultFlagged🟣 MagentaDouble-flash ×3 + always saves face imageOverride⚪ WhiteSteady 3s — supervisor manual grant

Key Features
Environment-aware security — baseline brightness set on startup with a rolling average that drifts slowly over time. Below lux 50 = night mode: brightness spikes auto-capture intruder images and fire the alarm. Denied access at night also captures a face image automatically.
Power save — drops to 2 FPS and pauses video feed after 15s idle, wakes instantly on motion.
Live dashboard — webcam feed, lux reading, day/night mode, session counters for all 7 access states, live event log (last 12 entries, newest first), also written to attendance_log.txt.
Physical buttons — BTN0 = Standard, BTN1 = VIP, BTN3 = clean shutdown. All debounced at 2s.

Integration Points
For X (video input):
pythonprocess_face_image("/path/to/captured_face.jpg")
Fires cyan LED immediately, runs face recognition, maps result, triggers response. One call, everything else is handled.
For AWS (direct hook):
pythonhandle_recognition_result("prof_smith", "vip")
handle_recognition_result("Unknown", "denied")
For Y (face recognition): process_face_image() calls match_face.py as a subprocess with --json, parses the output, and maps it to access levels via VIP_NAMES and FLAGGED_NAMES lists at the top of the file — edit those lists to configure who gets what clearance.
