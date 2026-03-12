# CELL 8 — Physical PYNQ button test
# Expected: prints a line each time BTN0 or BTN1 is pressed within 10 seconds
# Press the physical buttons on the board after running this cell
# If nothing prints: physical buttons are not reading correctly

print("Polling for 10 seconds — press BTN0 or BTN1 on the board now...")
detected = []
start = time.time()

while time.time() - start < 10:
    if base.buttons[0].read() == 1:
        detected.append("BTN0")
        print(f"  ✅ Detected BTN0 at t={time.time()-start:.1f}s")
        time.sleep(0.3)
    if base.buttons[1].read() == 1:
        detected.append("BTN1")
        print(f"  ✅ Detected BTN1 at t={time.time()-start:.1f}s")
        time.sleep(0.3)

if detected:
    print(f"✅ CELL 8 PASSED — {len(detected)} press(es) detected: {detected}")
else:
    print("❌ CELL 8 FAILED — no button presses detected in 10s")
