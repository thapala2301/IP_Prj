# CELL 1 — Basic imports and overlay load
# Expected: prints "Overlay loaded OK" with no errors
# If this fails: base.bit is missing or PYNQ install is broken

from pynq.overlays.base import BaseOverlay
import time
import ipywidgets as widgets
from IPython.display import display, clear_output

base = BaseOverlay("base.bit")
print("✅ CELL 1 PASSED — Overlay loaded OK")
