/*
 * ============================================================================
 * ATTENDANCE ADD-ONS — Arduino Door Mechanism V9.0
 * ============================================================================
 *
 * Receives single-character commands from PYNQ-Z2 over USB serial.
 * Controls SERVO (door lock) and BUZZER (audio feedback) only.
 * Visual feedback is handled entirely by the PYNQ RGB LED — no LEDs needed.
 *
 * WIRING:
 *   Servo signal wire    → Pin 6  (PWM)
 *   Servo VCC (red)      → 5V
 *   Servo GND (brown)    → GND
 *
 *   Active buzzer (+)    → Pin 7
 *   Active buzzer (-)    → GND
 *
 *   NOTE: Use an ACTIVE buzzer (beeps on HIGH). Passive buzzers need PWM tone.
 *   NOTE: If servo causes Arduino to reset during demo, power it from an
 *         external 5V supply sharing GND with the Arduino — USB power is
 *         sometimes insufficient for servo draw.
 *
 * COMMAND MAP (sent from PYNQ):
 *   G = Standard granted  → door opens · 1 short beep
 *   V = VIP granted       → door opens · rising 2-beep pattern
 *   U = Guest granted     → door opens · soft single beep
 *   D = Denied            → door stays shut · 3 descending sharp beeps
 *   P = Pending/scanning  → door stays shut · 3 slow pulse beeps
 *   F = Flagged           → door stays shut · urgent double-beep alarm ×4
 *   O = Override          → door opens · long authority beep
 *   A = Alarm             → door stays shut · 10-pulse rapid alarm
 *   L = Lockdown          → door stays shut · alternating long-short siren ×3
 *   ? = Heartbeat ping    → responds 'K' (PYNQ checks Arduino is alive)
 * ============================================================================
 */

#include <Servo.h>

const int SERVO_PIN    = 6;
const int BUZZER_PIN   = 7;
const int DOOR_CLOSED  = 0;
const int DOOR_OPEN    = 90;
const int DOOR_HOLD_MS = 3000;

Servo doorServo;

// ============================================================================
// SETUP
// ============================================================================
void setup() {
  Serial.begin(9600);
  doorServo.attach(SERVO_PIN);
  doorServo.write(DOOR_CLOSED);
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);
  // Startup double-beep: confirms Arduino booted and is ready
  beep(80); delay(100); beep(80);
}

// ============================================================================
// HELPERS
// ============================================================================
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

// ============================================================================
// ACCESS HANDLERS
// Each has a distinct audio signature so they're identifiable by sound alone.
// ============================================================================

void handleStandard() {
  beep(120);       // 1 clean short beep
  openDoor();
}

void handleVIP() {
  beep(80);        // Rising 2-beep pattern — feels elevated vs standard
  delay(60);
  beep(200);
  openDoor();
}

void handleGuest() {
  beep(60);        // Softer, shorter — temporary/lesser access feel
  openDoor();
}

void handleDenied() {
  beep(180); delay(80);   // 3 descending beeps — gets shorter each time
  beep(120); delay(80);
  beep(60);
  delay(300);
  // No openDoor()
}

void handlePending() {
  for (int i = 0; i < 3; i++) {  // 3 slow evenly-spaced pulses — processing feel
    beep(60);
    delay(450);
  }
  // No openDoor()
}

void handleFlagged() {
  for (int i = 0; i < 4; i++) {  // Urgent double-beep ×4 — alert pattern
    beep(80); delay(60);
    beep(80); delay(300);
  }
  // No openDoor()
}

void handleOverride() {
  beep(600);       // Long single authority beep — firm and deliberate
  openDoor();
}

void handleAlarm() {
  for (int i = 0; i < 10; i++) {  // 10 rapid pulses — continuous urgency
    beep(70);
    delay(70);
  }
  // No openDoor()
}

void handleLockdown() {
  for (int i = 0; i < 3; i++) {  // Long-short siren ×3 — distinct from alarm
    beep(400); delay(100);
    beep(100); delay(100);
  }
  // No openDoor()
}

// ============================================================================
// MAIN LOOP
// ============================================================================
void loop() {
  if (Serial.available() > 0) {
    char cmd = Serial.read();
    switch (cmd) {
      case 'G': handleStandard(); break;
      case 'V': handleVIP();      break;
      case 'U': handleGuest();    break;
      case 'D': handleDenied();   break;
      case 'P': handlePending();  break;
      case 'F': handleFlagged();  break;
      case 'O': handleOverride(); break;
      case 'A': handleAlarm();    break;
      case 'L': handleLockdown(); break;
      case '?': Serial.write('K'); break;  // Heartbeat ping response
      default:  break;
    }
  }
}
