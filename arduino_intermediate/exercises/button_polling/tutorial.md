# Button Polling Tutorial

Button polling is the primary method of user input we will use for Pong. Suppose we want to determine when a button is pressed. Wire one end of the button to ground and the other to a digital pin as in Figure 1.  

To test that the button is working, add the code below to your existing project. This code will turn the on-board LED on when the button is pressed. 

This code can be pasted into a new sketch to demonstrate button polling. Once you understand the process, you can add polling functionality to the skeleton. 


### Includes
````arduino
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
````

### Definitions
````arduino
const int BTN_P1 = 4;
bool lastBtnP1 = HIGH;
````


### Setup Code
````arduino
pinMode(BTN_P1, INPUT_PULLUP);
pinMode(LED_BUILTIN, OUTPUT);
// Declares our button1Pin as an input
// INPUT_PULLUP will by default set our pin to HIGH and will be set LOW when the button is pressed
````

### Loop Code
````arduino 
bool btnP1 = digitalRead(BTN_P1);
// digitalRead() takes in the button input
// LED_BUILT_IN is the LED built into every Arduino Board. It can also be accessed by digitalPin 13

delay(15);

if (btnP1 == LOW && lastBtnP1 == HIGH){ 
    digitalWrite(LED_BUILTIN,HIGH);
} else {
    digitalWrite(LED_BUILTIN,LOW);
}
lastBtnP1 = btnP1;
````

This code will compare the state of the button to the state on the previous loop. This is called edge detection and will detect change. The button is default high thanks to the pullup resistor and therefore will be read LOW when pressed. 

## Challenge
Add code to your project to read the state of button 2. Test that you can control the on-board LED with button 2 as well. After you complete this challenge, comment the code for writing to LED_BUILTIN based on the buttons.

---

|Back: [Exercise 1: connecting to the display](../button_polling/tutorial.md) | [Top](../../README.md) |Next: [Exercise 3: interrupts](exercises/interrupts/tutorial.md)|
|---|---|---|
