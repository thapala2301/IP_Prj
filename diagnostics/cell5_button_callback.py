# CELL 5 — Widget button callback test (no hardware)
# Expected: clicking the button updates the text below it with a click count
# If button does nothing at all: widget callbacks are broken in your Jupyter setup

click_label = widgets.HTML("<i>Not clicked yet...</i>")
click_count = [0]

def on_click(b):
    click_count[0] += 1
    click_label.value = f"<span style='color:green'><b>✅ CELL 5 PASSED — Button clicked {click_count[0]} time(s)</b></span>"

btn = widgets.Button(description="Click Me", button_style='success')
btn.on_click(on_click)
display(widgets.VBox([btn, click_label]))
