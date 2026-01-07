# What we will create with code

We will use Arduino "sketches" to program the Uno R4 Minima board.
The sketch API relies on two entrypoints, `setup` and `loop`.

1. The `setup` function is called first when the program is executed.
2. _After_ `setup` is called, the `loop` function is called repeatedly.
   This means that `loop` runs again as soon as it finishes executing.

[docs.arduino.cc](https://docs.arduino.cc/language-reference/#structure) has more information about both functions.

Therefore, the two code examples below are the same.

|Arduino Sketch|Typical C program|
|---|---|
|```c
int main()
{
  setup();
  while (1) {
    loop();
  }
}
```
|
```c
void setup()
{

}

void loop()
{

}
```
|



```c
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

int scoreP1 = 0;
int scoreP2 = 0;

const int PADDLE_WIDTH = 2;
const int PADDLE_HEIGHT = 12;

int P1_X = 0;
int P1_Y = 0;

int P2_X = 128 - PADDLE_WIDTH;
int P2_y = 32;

int ballX = 64;
int ballY = 32;

void setup()
{
    display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
}

void loop()
{

}
```
