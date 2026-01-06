// int potPin = A0;     // Analog input pin for potentiometer
// int ledPin = 9;      // PWM-capable pin for LED
// int potValue = 0;    // To store raw potentiometer reading
// int ledValue = 0;    // To store mapped brightness

// void setup() {
//   pinMode(ledPin, OUTPUT);
// }

// void loop() {
//   potValue = analogRead(potPin);           // Read potentiometer (0–1023)
//   ledValue = map(potValue, 0, 1023, 0, 255); // Map to PWM range (0–255)
//   analogWrite(ledPin, ledValue);           // Set LED brightness
// }

int ledPin = 9;      // LED connected to digital pin 9
int ledPin2 = 3;
int analogPin = A0;  // potentiometer connected to analog pin A0
int val = 0;         // variable to store the read value

void setup() {
  pinMode(ledPin, OUTPUT);  // sets the pin as output
  pinMode(ledPin2, OUTPUT);  // sets the pin as output
}

void loop() {
  val = analogRead(analogPin);  // read the input pin
  analogWrite(ledPin, val / 4); 
  analogWrite(ledPin2, 255 - (val / 4)); 
// analogRead values go from 0 to 1023, analogWrite values from 0 to 255
}
