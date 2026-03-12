# CELL 10 — Full integration test
# Replicates exactly what the main system does when you press a button:
# widget callback → log → LED write → sleep → LED off → status update
#
# Expected: pressing the button lights LED green for 2s, updates label, writes to log file
# If Cells 1-9 all passed but this fails:
#   restart the kernel and run ONLY this cell — the main system may still be running
#   and holding resources

LOCK_LED = base.rgbleds[4]
final_label = widgets.HTML("<i>Not tested yet — press the button</i>")

def full_test(b):
    final_label.value = "<span style='color:orange'>⏳ Writing GREEN for 2s...</span>"
    LOCK_LED.write(2)
    time.sleep(2)
    LOCK_LED.write(0)
    with open("diagnostic_log.txt", "a") as f:
        f.write(f"[{time.strftime('%H:%M:%S')}] CELL 10 full integration test passed\n")
    final_label.value = "<span style='color:green'><b>✅ CELL 10 PASSED — full pipeline works. Main system buttons should work.</b></span>"

b_full = widgets.Button(description="Run Full Test", button_style='success')
b_full.on_click(full_test)

display(widgets.VBox([
    widgets.HTML("<b>CELL 10 — Full integration (widget + LED + sleep + log)</b>"),
    b_full,
    final_label
]))
