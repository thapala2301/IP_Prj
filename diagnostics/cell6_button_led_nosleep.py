# CELL 6 — Widget button → direct hardware write (NO sleep)
# Expected: pressing GREEN lights the RGB LED green instantly
#           pressing BLUE lights it blue instantly
#           pressing OFF turns it off
# If Cell 5 passed but this does nothing: hardware writes from widget callbacks are blocked

LOCK_LED = base.rgbleds[4]
hw_label = widgets.HTML("<i>Press a button — LED should respond instantly</i>")

def write_green(b):
    LOCK_LED.write(2)
    hw_label.value = "<span style='color:green'><b>Wrote GREEN — did the LED light?</b></span>"

def write_blue(b):
    LOCK_LED.write(4)
    hw_label.value = "<span style='color:blue'><b>Wrote BLUE — did the LED light?</b></span>"

def write_off(b):
    LOCK_LED.write(0)
    hw_label.value = "<span style='color:gray'><b>LED OFF</b></span>"

b_green = widgets.Button(description="GREEN", button_style='success')
b_blue  = widgets.Button(description="BLUE",  button_style='info')
b_off   = widgets.Button(description="OFF",   button_style='')

b_green.on_click(write_green)
b_blue.on_click(write_blue)
b_off.on_click(write_off)

display(widgets.VBox([
    widgets.HTML("<b>CELL 6 — Button → direct LED write (no sleep)</b>"),
    widgets.HBox([b_green, b_blue, b_off]),
    hw_label
]))
