# CELL 7 — Widget button → hardware write WITH sleep
# Expected: pressing the button lights LED green for 2 seconds then turns off
# If Cell 6 passed but this freezes or does nothing:
#   time.sleep() inside widget callbacks is blocking Jupyter's event loop
#   This is the known root cause of the main system buttons not working
#   Tell Thanus so the main code can be fixed to use a timer instead of sleep

LOCK_LED = base.rgbleds[4]
sleep_label = widgets.HTML("<i>Press button — LED should light for 2 seconds then off</i>")

def write_with_sleep(b):
    sleep_label.value = "<span style='color:orange'>⏳ LED on... waiting 2s...</span>"
    LOCK_LED.write(2)
    time.sleep(2)
    LOCK_LED.write(0)
    sleep_label.value = "<span style='color:green'><b>✅ CELL 7 PASSED — sleep inside callback works fine</b></span>"

b_sleep = widgets.Button(description="Light for 2s", button_style='warning')
b_sleep.on_click(write_with_sleep)

display(widgets.VBox([
    widgets.HTML("<b>CELL 7 — Button → LED write with time.sleep()</b>"),
    b_sleep,
    sleep_label
]))
