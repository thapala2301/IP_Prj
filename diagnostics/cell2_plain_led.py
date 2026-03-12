# CELL 2 — Raw plain LED blink (no widgets, no threads)
# Expected: LED0 on the board blinks on/off 3 times
# If this fails: PYNQ leds are not accessible — hardware issue

LED_MAP = [base.leds[i] for i in range(4)]

for i in range(3):
    LED_MAP[0].on()
    time.sleep(0.4)
    LED_MAP[0].off()
    time.sleep(0.4)

print("✅ CELL 2 PASSED — LED0 blinked 3 times")
