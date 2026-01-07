# Arduino Intermediate Activity

### Authors: 
Chris Rennick, Fareed Rasheed, Hailey Doleweerd, Orion Bruckman, Nancy Nelson



## 1 Microcontrollers 
Microcontrollers are small one-chip computers that are at the core of much of today’s technology to automate and control tasks. Generally, they have a Central Processing Unit (CPU), some memory, and programmable input and output ports. This intermediate workshop builds on prior knowledge of microcontrollers and introduces polling loops, interrupts, and timers.  With polling loops, our code manually checks the status of any input pins at a regular interval, and then we can respond.  Interrupts are used for more critical events so that the code can respond more quickly. 

These concepts will be used to create a simple, 2-player version of the game Pong. 


### 1.1 Required Materials
* 1x Arduino UNO Rev. 4 
* 1x OLED Display 
* 1x Breadboard 
* 3x Pushbuttons 
* 12x Wires 
* 1x USB-C Cable 


## 2 Activity - Pong Overview
Pong is a simple game, however the logic used is fundamental to creating interactable devices that respond to the real world. This activity aims to help you grasp the principles of digital logic and interactable devices by introducing concepts such as button polling, timers and interrupts. These principles are the core of the systems we interact with every day ranging from handheld devices to complex game engines.  

### 2.1 Build Your Circuit
Follow ***Figure 1*** below to connect the OLED display and the 3 pushbuttons to the Arduino. Ensure the positive rail on the breadboard that is connected to the OLED display is connected to the 5V pin on the Arduino, not the 3.3V. The pushbutton that will be the game pause button must remain connected to the Digital0, Digital1, Digital2, or Digital3 pins on the Arduino Uno as the pause function will be implemented using an interrupt. These pins are the only digital pins that can be used for external interrupts on the Arduino. 

If your kit included a shield, attach the shield onto the Arduino and wire the buttons as shown. Otherwise, if your kit included an individual screen, wire the buttons and the screen as shown. 


![image info](./assets/circuit_pong.png)
Figure 1 - Circuit diagram for Pong game 


### 2.2 Skeleton Code Checklist 
You’ll build on some skeleton code that provides the framework for Pong. Most of the logic was pulled from the code and it's up to you to fill it in using the tutorials and code blocks from this document.  

You can find the skeleton code in the same LEARN folder as this document. 

Here’s a checklist to help you keep track of your progress through the skeleton. This is the bare minimum to create a functional game but there’s lots more that can be added 

* Declerations 
    * Declare all the variables and libraries at the start of the program. This includes the variables in section 3.1-I2C and the button pin declarations according to your circuits 
* setup() 
    * Complete the screen configuration according to section 3.1-I2C 
    * Declare the pin Modes of the buttons 
    * Attach the interrupt according to section 3.3 
* pause()
    * Complete the logic to switch between the play and pause states
    * Find out how to pause the game clock 
* loop()
    * Handle the paddle direction switches according to button presses according to section 3.2 Button polling 
    * Handle the paddle constraints, restricting the paddle in the screen according to section 3.2 
    * Ball Movement according to section 3.5 
    * Ball collision with paddles according to section 3.5 
    * Ball collision with screen according to section 3.5 
    * Handle scoring, resetting rounds and game over conditions according to section 3.5 
    * Draw the screen according to section 3.1 I2C 
    * Game clock 
    * Update the state of buttons on previous loop according to section 3.2 
* resetRound()
    * Fill in starting locations of balls and paddles according when resetting rounds after scoring 

## 3 Coding the Game
Now you’re ready to create the project (aka sketch) and write the code to control your system. Follow these steps:  

1. Download the skeleton code from Learn 
2. Start the Arduino Integrated Development Environment (IDE) 
3. Go to **File > Open** to open the skeleton code. The skeleton code is missing most of its functionality. Use this document to fill it in. 


### 3.1 I2C Communication 
I2C is an important protocol for serial communication between devices. It is often used to connect peripherals like sensors or displays to a central controller system. In this case, I2C communication will be used to connect the Arduino microcontroller to the OLED display. I2C uses two wires to enable this synchronous transmission of data, the first being SCL which is the Serial Clock which keeps the two systems synchronized, and SDA which is Serial Data and is used for the serial transmission of data. The Arduino UNO has 2 dedicated I2C pins labelled SCL and SDA that can be used.  

Here’s the code to display the player paddles, scores, and ball for the Pong game. Copy and paste this into your project, then compile and upload the program. Sections in orange should already be included in the skeleton project. 

You’ll need to install some libraries to interface with the screen. In the Arduino Library manager, search Adafruit GFX and Adafruit SSD1306. Make sure to also install all dependencies.  

You’ll know you’re successful when you see the scores, paddles, and a ball on the screen. 

This code can be pasted into a new sketch. Once you understand the process of writing to the screen, you can add this code to the corresponding sections of the skeleton to add display functionality. 

Pay attention to the relvent comments which indicate what should go where. 

3.1 A
````arduino 

//Defining screen
//Screen Variables
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
 
//Score tracking
int scoreP1 = 0;
int scoreP2 = 0;

const int PADDLE_WIDTH = 2;
const int PADDLE_HEIGHT = 12;
 
//Position tracking for player 1 paddle
int P1_X =0;
int P1_Y = 32;
//Position tracking for player 2 paddle
int P2_X = 128-PADDLE_WIDTH;
int P2_Y = 32;
//Position tracking for ball
int ballX = 64;
int ballY = 32;
````

3.1 B
````arduino 
display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
display.clearDisplay();
display.setTextSize(1);
display.setTextColor(SSD1306_WHITE);
````


3.1 C
````arduino
//Display must first be cleared display.clearDisplay();
 
// Sets up text for the player scores
display.setTextSize(1);
display.setCursor(40, 0);
display.print("P1:");
display.print(scoreP1);
display.print("  P2:");
display.print(scoreP2);
display.setCursor(40,10);
display.print(gameTime);

//Set up paddles
display.fillRect(P1_X, P1_Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
display.fillRect(P2_X, P2_Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
//Set up ball
display.fillRect(ballX, ballY, 2, 2, SSD1306_WHITE);
 
display.display();
//Displays everything
delay(15);
````

