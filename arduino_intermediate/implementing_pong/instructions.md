# Implementing Pong
Now that you've gone through the exercises, you're ready to take on the main challenge. You'll be using what you've learned to create a complete implementation of the Pong game. Find the **starter.ino** file and familiarize yourself with it. Make mental notes of what's already there and whats missing. 

Before you start, here are some hints to keep in mind. 

1. Paddle direction changes should be implemented using button polling. 
2. The pause button should be implemented using an interrupt
3. It will not be sufficient to simply copy and past the code from the exersises. Think about what you've learned, and how you can extend it. For example, the button polling code only implemented oen button, but actually you're dealing with *two different players*. 
4. The **interrupts** module mentioned using alternatives to *CHANGE* mode; consider what those two alternatives were and why they might be useful.


## Usefule Code Snippets

### 1 Paddle Directions
In Pong, we will be using 3 buttons. Buttons 1 and 2 will be used to control the paddles of P1 and P2. When designing your game, read the button states to determine the direction of the paddles. Pressing button1 should flip the direction of player 1’s paddles while pressing button2 should flip the direction of player 2’s paddles. 

The code below is what the logic for flipping the paddle direction might look like, but it is incomplete.  Think about where the paddle direction flags should be declared. 

Take a look at the skeleton code and paste the sections of this block you need into the skeleton.

````arduino
/* If the button states for either player change from Low to HIGH, the paddle direction is flipped p1 and p2Dir need to be declared as const int before your setup. 
Assign them a value to determine their speed. */ 

/* If the state of the player1 button is high, the direction of the paddle is flipped. 
lastBtnP1 tracks the state of the button on the previous loop of the code. 
This is called edge detection and detects the change of the button state. */

if (lastBtnP1 == HIGH && btnP1 == LOW) {

      // If the paddle is not moving at the bottom, set dir +ve. Else if paddle is not moving, set dir -ve.
      if (p1Dir == 0) {
        p1Dir = (P1_Y <= 0) ? 1 : -1;

      } else { // If direction is not 0, flip p1Dir
        p1Dir *= -1;
      }
}

// Paddle movement
P1_Y += p1Dir; // This is what actually updates the paddle location

// Above is the paddle movement for paddle1. Repeat the above code with the corresponding variable names for paddle2.
````

How do we stop the paddles from extending past the screen borders? We need to compare the borders of the paddles with the size of the screen. If the paddles reach the edge, the directions must be set to zero (not moving).


This can be copied into the corresponding section of the skeleton code to add paddle constraint functionality.

````arduino
if (P1_Y <= 0 || P1_Y >= SCREEN_HEIGHT - PADDLE_HEIGHT) {
    // constrain prevents the paddle from extending beond the screen

    P1_Y = constrain(P1_Y, 0, SCREEN_HEIGHT - PADDLE_HEIGHT);
    p1Dir = 0;
}

````