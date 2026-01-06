#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Button pins
const int BTN_P1 = 4;
const int BTN_P2 = 3;
const int BTN_PAUSE = 2;

// Paddle & ball settings
const int PADDLE_WIDTH = 2;
const int PADDLE_HEIGHT = 12;
const int P1_X = 2;
const int P2_X = SCREEN_WIDTH - PADDLE_WIDTH - 2;

int p1Y = 26;
int p2Y = 26;
int p1Dir = 0;
int p2Dir = 0;

int ballX = SCREEN_WIDTH / 2;
int ballY = SCREEN_HEIGHT / 2;
int ballVX = -1;
int ballVY = 1;

// Scoring
int scoreP1 = 0;
int scoreP2 = 0;

// State tracking
bool lastBtnP1 = HIGH;
bool lastBtnP2 = HIGH;

int pressCountP1 = 0;
int pressCountP2 = 0;

enum GameState {
  WAIT_P1_READY,
  WAIT_P2_READY,
  PLAYING,
  GAME_OVER,
  GAME_PAUSE
};

GameState state = WAIT_P1_READY;

void setup() {
  pinMode(BTN_P1, INPUT_PULLUP);
  pinMode(BTN_P2, INPUT_PULLUP);
  pinMode(BTN_PAUSE, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(BTN_PAUSE), pause, FALLING);

  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
}

void pause() {
  if(state == PLAYING) {
    state = GAME_PAUSE;
  }
  else if (state == GAME_PAUSE) {
    state = PLAYING;
  }
}

void loop() {
  bool btnP1 = digitalRead(BTN_P1);
  bool btnP2 = digitalRead(BTN_P2);

  // Initial Phase
  if (state == WAIT_P1_READY) {
    display.clearDisplay();
    display.setCursor(10, 20);
    display.println("Player 1: Press");
    display.setCursor(10, 30);
    display.print("Button 3x (");
    display.print(pressCountP1);
    display.println("/3)");
    display.display();

    if (lastBtnP1 == HIGH && btnP1 == LOW) {
      pressCountP1++;
    }
    if (pressCountP1 >= 3) {
      state = WAIT_P2_READY;
    }
  }

  else if (state == WAIT_P2_READY) {
    display.clearDisplay();
    display.setCursor(10, 20);
    display.println("Player 2: Press");
    display.setCursor(10, 30);
    display.print("Button 3x (");
    display.print(pressCountP2);
    display.println("/3)");
    display.display();

    if (lastBtnP2 == HIGH && btnP2 == LOW) {
      pressCountP2++;
    }
    if (pressCountP2 >= 3) {
      state = PLAYING;
      resetGame();
    }
  }

  // Game Loop
  else if (state == PLAYING) {
    // Button presses to toggle paddle direction
    if (lastBtnP1 == HIGH && btnP1 == LOW) {
      if (p1Dir == 0) p1Dir = (p1Y <= 0) ? 1 : -1;
      else p1Dir *= -1;
    }

    if (lastBtnP2 == HIGH && btnP2 == LOW) {
      if (p2Dir == 0) p2Dir = (p2Y <= 0) ? 1 : -1;
      else p2Dir *= -1;
    }

    // Paddle movement
    p1Y += p1Dir;
    if (p1Y <= 0 || p1Y >= SCREEN_HEIGHT - PADDLE_HEIGHT) {
      p1Y = constrain(p1Y, 0, SCREEN_HEIGHT - PADDLE_HEIGHT);
      p1Dir = 0;
    }

    p2Y += p2Dir;
    if (p2Y <= 0 || p2Y >= SCREEN_HEIGHT - PADDLE_HEIGHT) {
      p2Y = constrain(p2Y, 0, SCREEN_HEIGHT - PADDLE_HEIGHT);
      p2Dir = 0;
    }

    // Ball movement
    ballX += ballVX;
    ballY += ballVY;

    if (ballY <= 0 || ballY >= SCREEN_HEIGHT - 2) ballVY *= -1;

    // Paddle collision
    if (ballX <= P1_X + PADDLE_WIDTH &&
        ballY >= p1Y && ballY <= p1Y + PADDLE_HEIGHT) {
      ballVX *= -1;
      ballX = P1_X + PADDLE_WIDTH + 1;
    }

    if (ballX >= P2_X - 1 &&
        ballY >= p2Y && ballY <= p2Y + PADDLE_HEIGHT) {
      ballVX *= -1;
      ballX = P2_X - 2;
    }

    // Scoring
    if (ballX < 0) {
      scoreP2++;
      if (scoreP2 == 3) {
        state = GAME_OVER;
      } else {
        resetRound();
      }
    }

    if (ballX > SCREEN_WIDTH) {
      scoreP1++;
      if (scoreP1 == 3) {
        state = GAME_OVER;
      } else {
        resetRound();
      }
    }

    // Drawing
    display.clearDisplay();

    display.setTextSize(1);
    display.setCursor(40, 0);
    display.print("P1:");
    display.print(scoreP1);
    display.print("  P2:");
    display.print(scoreP2);

    display.fillRect(P1_X, p1Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
    display.fillRect(P2_X, p2Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
    display.fillRect(ballX, ballY, 2, 2, SSD1306_WHITE);

    display.display();
    delay(15);
  }

  // Game Over
  else if (state == GAME_OVER) {
    display.clearDisplay();
    display.setCursor(25, 20);
    display.setTextSize(1);
    if (scoreP1 == 3)
      display.println("Player 1 Wins!");
    else
      display.println("Player 2 Wins!");
    display.setCursor(10, 40);
    display.println("Press any button...");
    display.display();

    // Wait for any button press to restart
    if ((lastBtnP1 == HIGH && btnP1 == LOW) ||
        (lastBtnP2 == HIGH && btnP2 == LOW)) {
      state = WAIT_P1_READY;
      pressCountP1 = 0;
      pressCountP2 = 0;
      scoreP1 = 0;
      scoreP2 = 0;
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

void resetRound() {
  p1Y = 26;
  p2Y = 26;
  p1Dir = 0;
  p2Dir = 0;
  ballX = SCREEN_WIDTH / 2;
  ballY = SCREEN_HEIGHT / 2;
  ballVX *= -1;
  ballVY = (random(0, 2) == 0) ? -1 : 1;
}

void resetGame() {
  resetRound();
  scoreP1 = 0;
  scoreP2 = 0;
}
