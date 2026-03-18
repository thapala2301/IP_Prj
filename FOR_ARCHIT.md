# For Archit

## You don't need to touch my code

My node sits at the end of the pipeline after Marcus. Once Marcus calls it, everything physical happens automatically — LED, servo, door, buzzer, logging.

## Pipeline recap

```
You (FPGA + camera) → Shashank (face rec) → Marcus (AWS decision) → My node (physical output)
```

## What my node does

- **Green LED + door opens** → person is granted access
- **Red LED strobe** → person is denied
- **Cyan LED pulse** → processing (pending)
- **Alarm** → fires automatically if 3 denials in a row, or 5 denials in 2 minutes
- Logs every event to `attendance_log.txt`
- Night mode (8pm–8am): saves a face capture image on denied results

## What you need to know for your part

Nothing changes on your end. Your camera feed goes to Shashank, Shashank goes to Marcus, Marcus calls my function. You don't interact with my node directly.

If you want to test the physical outputs independently (without the full pipeline), BTN0 on the PYNQ = granted, BTN1 = denied.

## Files in this repo

| File | What it is |
|---|---|
| `smart_node.py` | Runs on the PYNQ — handles LED, logging, security escalation |
| `door_mechanism.ino` | Runs on the Arduino — handles servo (door) and buzzer |
| `README.md` | Full setup and test instructions |
