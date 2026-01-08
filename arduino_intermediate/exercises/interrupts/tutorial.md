# Interrupts Tutorial

Interrupts are methods of pausing code that is currently running to execute a short function before returning to the main code in the loop() section. If an interrupt is triggered, the original code will not resume until the interrupt is completed. Timer overflows are a type of interrupt. Interrupts constantly monitor the state of the pin they are attached to and will activate immediately when their condition is met.  

Suppose we want to trigger an interrupt upon pressing a button. As soon as the pin the button is attached to changes, we want to trigger a function called buttonInterrupt().  

**IMPORTANT:** If in the future you implement an interrupt which modifies a variable (perhaps one you're using to track the state of a game of Pong), ensure that that variable is declared using **volatile**.


This code can be pasted into the starter.ino file to demonstrate how button interrupts work. After you understand how they work, you can use this method to add interrupt functionality to the skeleton. 


### Includes
````arduino
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
````


### Definitions 
````arduino
// This code will wait for a button press to turn the built in LED off for a short duration
int BTN_PAUSE = 2;
void buttonInterrupt(){
    // This is the code that will be executed after triggering the interrupt
	digitalWrite(LED_BUILTIN, LOW);
}
````

### Setup Code
````arduino
pinMode(LED_BUILTIN, OUTPUT);
pinMode(BTN_PAUSE, INPUT_PULLUP);

// INPUT_PULLDOWN will by default set the pin low when the button is not pressed, and high when it is

attachInterrupt(digitalPinToInterrupt(BTN_PAUSE), buttonInterrupt, CHANGE);

/* attachInterrupt takes 3 values; digitalPinToInterrupt(pin) declares which pin to attach the interupt. 
The 2nd value is the interrupt function which must return void. The final value is the interrupt configuration. 
CHANGE will trigger the interrupt when the interruptPin changes state. 
FALLING will trigger when the pin changes from 1 to 0 – RISING will trigger when the state changes from 0 to 1. */
````

### Loop Code
````arduino 
digitalWrite(LED_BUILTIN, HIGH);
delay(1000);
````

After you’ve confirmed the interrupt works and turns off the LED temporarily, remove the delay(1000) statement from loop().
When creating the function buttonInterrupt() or any interrupt function, do not use loops or delays. The interrupt must be short and quick so as to return to the main loop of the code as quickly as possible.  In Pong, we will be using an interrupt to create a pause button. The pause button will interrupt the main game loop and enter the game into a pause state, where it will wait for a second button press to continue back to the main game. 
