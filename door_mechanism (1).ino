/*
 * ATTENDANCE — Arduino Door Mechanism
 * Thanus's output node
 *
 * Receives single-char commands from PYNQ over USB serial.
 * Controls SERVO (door) and BUZZER only.
 * All LED colour logic lives on the PYNQ side.
 *
 * WIRING:
 *   Servo signal  → Pin 6  (PWM)
 *   Servo VCC     → 5V
 *   Servo GND     → GND
 *   Buzzer (+)    → Pin 7
 *   Buzzer (-)    → GND
 *   Use an ACTIVE buzzer (beeps on HIGH, not passive/PWM type)
 *
 * COMMAND MAP:
 *   G = Granted   → door opens, 1 clean beep
 *   D = Denied    → door shut,  3 descending beeps
 *   P = Pending   → door shut,  3 slow pulses
 *   A = Alarm     → door shut,  10 rapid pulses
 *   L = Lockdown  → door shut,  long-short siren x3
 *   B = Boot      → door shut,  2 quick beeps (startup confirm)
 *   ? = Heartbeat → responds 'K'
 */

#include <Servo.h>

const int SERVO_PIN    = 6;
const int BUZZER_PIN   = 7;
const int DOOR_CLOSED  = 0;
const int DOOR_OPEN    = 90;
const int DOOR_HOLD_MS = 3000;   // how long door stays open (ms)

Servo doorServo;

// ── setup ────────────────────────────────────────────────────────────────────

void setup() {
  Serial.begin(9600);
  doorServo.attach(SERVO_PIN);
  doorServo.write(DOOR_CLOSED);
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);
  handleBoot();
}

// ── helpers ──────────────────────────────────────────────────────────────────

void beep(int ms) {
  digitalWrite(BUZZER_PIN, HIGH);
  delay(ms);
  digitalWrite(BUZZER_PIN, LOW);
}

void openDoor() {
  doorServo.write(DOOR_OPEN);
  delay(DOOR_HOLD_MS);
  doorServo.write(DOOR_CLOSED);
}

// ── handlers ─────────────────────────────────────────────────────────────────

void handleBoot() {
  // Two quick beeps — confirms Arduino is alive and ready
  beep(80); delay(100); beep(80);
}

void handleGranted() {
  beep(150);   // single clean beep
  openDoor();
}

void handleDenied() {
  // Three descending beeps — gets shorter, feels like rejection
  beep(200); delay(80);
  beep(130); delay(80);
  beep(60);
}

void handlePending() {
  // Three slow evenly-spaced pulses — processing / wait feel
  for (int i = 0; i < 3; i++) {
    beep(60);
    delay(500);
  }
}

void handleAlarm() {
  // 10 rapid pulses — maximum urgency
  for (int i = 0; i < 10; i++) {
    beep(70);
    delay(70);
  }
}

void handleLockdown() {
  // Long-short siren x3 — distinct from alarm pattern
  for (int i = 0; i < 3; i++) {
    beep(400); delay(100);
    beep(100); delay(100);
  }
}

// ── main loop ────────────────────────────────────────────────────────────────

void loop() {
  if (Serial.available() > 0) {
    char cmd = Serial.read();
    switch (cmd) {
      case 'G': handleGranted();  break;
      case 'D': handleDenied();   break;
      case 'P': handlePending();  break;
      case 'A': handleAlarm();    break;
      case 'L': handleLockdown(); break;
      case 'B': handleBoot();     break;
      case '?': Serial.write('K'); break;  // heartbeat ping response
      default:  break;
    }
  }
}
