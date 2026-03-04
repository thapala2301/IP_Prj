# IP_Prj
Quick Start: PYNQ-Z1 Security Node
1. Preparation

Connect a USB Webcam to the PYNQ-Z1.

Ensure the room has standard lighting (check the Green LEDs; they should be partially lit).

2. System Controls
| Input | Action | Hardware Result |
| :--- | :--- | :--- |
| BTN 0 | Simulate "Face Match" | RGB LED turns GREEN (Door Unlocks) |
| BTN 1 | Simulate "Unknown Person" | RGB LED strobes RED (Alarm) |
| BTN 3 | EMERGENCY STOP | Shuts down Camera & LEDs Safely |

3. Automated Features

Day/Night Sensing: The system automatically switches security profiles based on room brightness.

The "Night Tripwire": In NIGHT mode, any sudden shadow or movement will auto-trigger the alarm and capture a photo.

Attendance Logging: Every event (Success or Alarm) is recorded with a timestamp in attendance_log.txt.

4. Viewing Results

Photos: Look for intruder_XXXX.jpg in the file sidebar for security evidence.

The Log: Open attendance_log.txt to view the full history of entry attempts.
