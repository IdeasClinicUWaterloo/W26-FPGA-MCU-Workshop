int potPin = A0;     // Analog input pin for potentiometer
int ledPin = 9;      // PWM-capable pin for LED
int potValue = 0;    // To store raw potentiometer reading
int ledValue = 0;    // To store mapped brightness

void setup() {
  pinMode(ledPin, OUTPUT);
}

void loop() {
  potValue = analogRead(potPin);           // Read potentiometer (0–1023)
  ledValue = map(potValue, 0, 1023, 0, 255); // Map to PWM range (0–255)
  analogWrite(ledPin, ledValue);           // Set LED brightness
}