#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

//Defining screen
//FILL IN screen variables from Section 3.1 - I2C Communication




// Button pins
const int BTN_P1 = 4;
const int BTN_P2 = 3;
const int BTN_PAUSE = 2;

int p1Dir = 0;
int p2Dir = 0;
//Ball starting velocity
int ballVX = -1;
int ballVY = 1;

// State tracking
bool lastBtnP1 = HIGH;
bool lastBtnP2 = HIGH;

int pressCountP1 = 0;
int pressCountP2 = 0;
int gameTime = 0;

enum GameState {
  //These are the different game states. In your code, think about what should happen in each state and when to switch between states
  PLAYING,
  GAME_OVER,
  GAME_PAUSE
};

//Starting state
GameState state = PLAYING;


void setup() {
  //Configure screen
  //Copy screen setup code from section 3.1 - I2C Communication

  //Declare our buttons
  pinMode(BTN_P1, INPUT_PULLUP);
  //Missing btn1 and pauseBtn. Remember to attach the interrupt from section 3.3 - Interrupts
}

void pause() {
  //This is our interrupt function triggered by our pause button. Remember, the same button is used to pause and unpause
  //Complete the logic. Think about what happens when the pause interupt it triggered(it has to change gameStates)
  if (state == PLAYING) {
    //Fill in
  } else if (state == GAME_PAUSE) {
    //fill in
  }

  //The pause function will require additional logic to pause the built in timers
}

void loop() {
  //Button polls
  bool btnP1 = digitalRead(BTN_P1);
  bool btnP2 = digitalRead(BTN_P2);

  // Initial Phase
  // Game Loop
  if (state == PLAYING) {

    // Button presses to toggle paddle direction
    if (lastBtnP1 == HIGH && btnP1 == LOW) {
      //Fill in from section 3.2 - Button polling code block 2
    }
    //Toggle P2 paddle direction.
    if (lastBtnP2 == HIGH && btnP2 == LOW) {
      //Fill in
    }

    // Paddle movement
    P1_Y += p1Dir;
    P1_Y += p2Dir;
    //
    //FILL IN paddle constraints from section 3.2 - Button Polling code block 3

    //

    // Ball movement
    //This is acheived by adding the X and Y velocity to the respective X and Y positions.
    // if ball collides with top or bottom screen, what happens?
    //
    //FILL IN as defined in section 3.5 code block 1

    //


    if (ballY <= 0 || ballY >= SCREEN_HEIGHT - 2) {
      //This is the bounds of top and bottom the screen. What happens when the ball hits the bounds?
    }


    // Scoring // Complete these sections as defined in seciton 3.5 code block 3
    //What happens if a ball gets past the paddle and hits the wall? track the score and reset the round. Remember to end the game if the score
    //threshold is met
    if (ballX < 0) {
      //Fill in
    }
    if (ballX > SCREEN_WIDTH) {
      //Fill in
    }

    // Drawing
    //FILL IN with screen code from section 3.1 - I2C Communication

    //

    //Update the states of lastBtnP1 and lastBtnP2
    //FILL IN from Section 3.2 - Button Polling
  }

  // Game Over
  else if (state == GAME_OVER) {
    display.clearDisplay();
    display.setCursor(25, 20);
    display.setTextSize(1);
    if (scoreP1 == 3) {
      display.println("Player 1 Wins!");
    } else {
      display.println("Player 2 Wins!");
    }

    display.setCursor(10, 40);
    display.println("Press any button...");
    display.display();

    // Wait for any button press to restart
    if ((lastBtnP1 == HIGH && btnP1 == LOW) || (lastBtnP2 == HIGH && btnP2 == LOW)) {
      state = PLAYING;
      resetGame();
    }
  }

  else if (state == GAME_PAUSE) {
    display.clearDisplay();
    display.setCursor(25, 20);
    display.setTextSize(1);
    display.println("Game Paused");
    display.setCursor(10, 40);
    display.println("Press pause button again to resume...");
    display.display();
  }

  // Store button state for edge detection
  lastBtnP1 = btnP1;
  lastBtnP2 = btnP2;
}

//Resets the round after a point is scored
void resetRound() {

  //Set the starting positions and directions of the ball and paddles.
  //FILL IN

  //
  ballVX *= -1;
  //Picks a random direction
  ballVY = (random(0, 2) == 0) ? -1 : 1;
}


//resets the game after game over
void resetGame() {
  resetRound();
  pressCountP1 = 0;
  pressCountP2 = 0;
  scoreP1 = 0;
  scoreP2 = 0;
}