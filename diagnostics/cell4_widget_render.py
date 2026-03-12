# CELL 4 — Widget rendering test (no hardware)
# Expected: a green label appears below this cell saying "WIDGETS WORK"
# If nothing appears: widgetsnbextension is not enabled
# Fix: run this in a new cell first, then restart kernel:
#   !jupyter nbextension enable --py widgetsnbextension --sys-prefix

label = widgets.HTML("<span style='color:green; font-size:16px'><b>✅ CELL 4 PASSED — WIDGETS WORK</b></span>")
display(label)
