# CELL 3 — Raw RGB LED colour cycle (no widgets, no threads)
# Expected: RGB LED cycles green → blue → yellow → red → off (1 second each)
# If this fails: PYNQ rgbleds not accessible — hardware issue

LOCK_LED = base.rgbleds[4]

for color, name in [(2, "GREEN"), (4, "BLUE"), (3, "YELLOW"), (1, "RED")]:
    print(f"  Writing {name} (code {color})...")
    LOCK_LED.write(color)
    time.sleep(1)

LOCK_LED.write(0)
print("✅ CELL 3 PASSED — RGB LED cycled all colours")
