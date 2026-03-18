# For Marcus

My output node is ready. You need to do one thing:

## Call this from your AWS script

```python
from smart_node import handle_recognition_result

handle_recognition_result("pending")    # optional — call this while AWS is processing, fires cyan LED
handle_recognition_result("granted")    # person is in the system → green LED, door opens, beep
handle_recognition_result("denied")     # person is not in the system → red strobe, door stays shut

# If you want night mode face captures saved on denied, pass the frame:
handle_recognition_result("denied", frame=img)
```

## That's literally it

Don't import anything else. No config needed on your end. The node handles LED, servo, buzzer, logging, and security escalation all automatically from that one call.

`smart_node.py` needs to already be running on the PYNQ before your script calls it.
