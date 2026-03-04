# 🐒 Attendance Add-Ons — Output Node

> **Module owner:** Thanus  
> **Platform:** PYNQ · Jupyter Notebook (classic)  
> **Role in pipeline:** Hardware response layer — handles everything that happens *after* a face is identified

---

## What This Script Does

Sits at the end of the group's face recognition attendance pipeline. Once a face has been identified, this module decides what happens next: which LED fires, what gets logged, whether a photo is saved, and how the system responds differently based on time of day.

Fully self-contained and demonstrable without the rest of the pipeline connected — all access states can be triggered manually via the dashboard.

---

## Architecture

```
X (camera) → Y (face recog) → AWS (identity) → Thanus (this module)
                                                             ↓
                                                    LED response
                                                    Event logging
                                                    Intruder capture
                                                    Door unlock simulation
```

The main camera loop runs in a **background thread** (`_main_loop`), keeping Jupyter's kernel thread free so dashboard button clicks actually execute.

A `shutdown_event` flag coordinates clean exit — pressing BTN3 signals every thread to stop, waits up to 1.5s for them to finish, then clears all hardware.

---

## Access States

| State | LED | Colour | Behaviour |
|-------|-----|--------|-----------|
| `standard` | 🟢 | Green | Steady 3s — known user, full access |
| `vip` | 🔵 | Blue | Steady 3s — high clearance |
| `guest` | 🟡 | Yellow | Steady 3s — temporary access |
| `denied` | 🔴 | Red | 4-flash strobe · night mode saves face image |
| `pending` | 🩵 | Cyan | Slow pulse 5s — face detected, awaiting result |
| `flagged` | 🟣 | Magenta | Double-flash ×3 · always saves face image |
| `override` | ⚪ | White | Steady 3s — supervisor manual grant |

---

## Key Features

### 🌙 Environment-Aware Security
Baseline brightness captured on startup via rolling average that drifts slowly with natural light changes.

- **Day mode** (lux ≥ 50) — standard operation
- **Night mode** (lux < 50) — brightness spikes auto-capture intruder images + fire alarm. Denied access at night also saves a face image automatically.

### 💤 Power Save
Drops to 2 FPS and pauses video feed after 15s idle. Wakes instantly on motion.

### 📊 Live Dashboard
- Webcam feed, live lux reading, day/night mode indicator
- Session counters for all 7 access states
- Live event log — last 12 entries newest-first, also written to `attendance_log.txt`

### 🔘 Physical Buttons (PYNQ board)
| Button | Action |
|--------|--------|
| BTN0 | Authorize Standard |
| BTN1 | Authorize VIP |
| BTN3 | Clean shutdown |

All debounced at 2s cooldown.

---

## Integration Points

### X — video input
```python
process_face_image("/path/to/captured_face.jpg")
```
Fires cyan LED immediately for visual feedback, runs face recognition, maps result, triggers full response. One call — everything else handled internally.

### Y / AWS — direct hook
```python
handle_recognition_result("prof_smith", "vip")
handle_recognition_result("Unknown", "denied")

# Full list of valid clearance levels:
# "standard" | "vip" | "guest" | "denied" | "pending" | "flagged" | "override"
```

### Z — face recognition bridge
`process_face_image()` calls `match_face.py` as a subprocess with `--json`, parses the output, and maps it to access levels.

To configure clearance, edit the two lists at the top of the file:
```python
VIP_NAMES     = ["prof_smith", "dr_jones"]  # → blue LED
FLAGGED_NAMES = ["banned_user"]             # → magenta flash + always captured
# Anyone else who matches → standard (green)
# No match → denied (red strobe)
```

---

## Files

```
smart_node_v6.py               ← main system, run this in Jupyter
diagnostics/
  cell1_overlay.py             ← PYNQ overlay loads
  cell2_plain_led.py           ← plain LEDs respond
  cell3_rgb_led.py             ← RGB LED colour cycle
  cell4_widget_render.py       ← widgets render
  cell5_button_callback.py     ← button callbacks fire
  cell6_button_led_nosleep.py  ← callbacks write to hardware
  cell7_button_led_sleep.py    ← callbacks work with sleep
  cell8_physical_buttons.py    ← physical BTN0/BTN1 register
  cell9_webcam.py              ← webcam captures frames
  cell10_integration.py        ← full end-to-end test
attendance_log.txt             ← auto-generated on first run
intruder_*.jpg                 ← auto-saved night/flagged captures
```

---

## Confirmed LED Colour Map (this board)

| Code | Colour |
|------|--------|
| 0 | Off |
| 1 | Blue |
| 2 | Green |
| 3 | Cyan |
| 4 | Red |
| 5 | Magenta |
| 6 | Yellow |
| 7 | White |

---

## Dependencies

```
pynq · opencv-python · numpy · ipywidgets
```

> If the dashboard doesn't appear on first run:
> ```python
> !jupyter nbextension enable --py widgetsnbextension --sys-prefix
> # Then restart the kernel
> ```
