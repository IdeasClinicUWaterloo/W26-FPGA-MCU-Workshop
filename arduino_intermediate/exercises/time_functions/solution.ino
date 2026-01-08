// BEGIN INCLUDES
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
// END INCLUDES


// BEGIN DEFINITIONS
// Screen Variables
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Score tracking
int scoreP1 = 0;
int scoreP2 = 0;

const int PADDLE_WIDTH = 2;
const int PADDLE_HEIGHT = 12;

// Position tracking for player 1 paddle
int P1_X =0;
int P1_Y = 32;
// Position tracking for player 2 paddle
int P2_X = 128-PADDLE_WIDTH;
int P2_Y = 32;
// Position tracking for ball
int ballX = 64;
int ballY = 32;


// Time and state keeping
unsigned long lastMillis = 0;
unsigned long elapsedTime = 0;
unsigned long now;

int gameTime = 0;
int minutes = 0;
int seconds = 0;

volatile bool paused = false;

int BTN_PAUSE = 2;
void buttonInterrupt(){
    // This is the code that will be executed after triggering the interrupt
    paused = !paused;
}

// END DEFINTIONS


void setup() {
    // BEGIN SETUP CODE
    display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);

    pinMode(BTN_PAUSE, INPUT_PULLUP);

    // INPUT_PULLDOWN will by default set the pin low when the button is not pressed, and high when it is

    attachInterrupt(digitalPinToInterrupt(BTN_PAUSE), buttonInterrupt, FALLING);


    // END SETUP CODE

}

void loop() {
    // BEGIN LOOP CODE
    // Display must first be cleared 

    now = millis();
    if (!paused) {
        elapsedTime += now - lastMillis;
    }

    lastMillis = now;

    gameTime = elapsedTime / 1000;
    minutes = gameTime / 60;
    seconds = gameTime % 60;
    
    display.clearDisplay();

    // Sets up text for the player scores
    display.setTextSize(1);
    display.setCursor(40, 0);
    display.print("P1:");
    display.print(scoreP1);
    display.print("  P2:");
    display.print(scoreP2);
    display.setCursor(55,10);

    if (minutes < 10) display.print("0");
    display.print(minutes);
    display.print(":");
    if (seconds < 10) display.print("0");
    display.print(seconds);

    // Set up paddles
    display.fillRect(P1_X, P1_Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
    display.fillRect(P2_X, P2_Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
    // Set up ball
    display.fillRect(ballX, ballY, 2, 2, SSD1306_WHITE);

    display.display();
    // Displays everything
    delay(15);
    // END LOOP CODE

}