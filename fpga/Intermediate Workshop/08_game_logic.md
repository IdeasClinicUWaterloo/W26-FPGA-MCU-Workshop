# Game Logic

In this part, we will write logic to drive the movement of paddles in the game logic.

## Overview of `game_logic`

For this part, we will be working mostly in the `game_logic` file. It is mostly pre-written for you. The `game_logic` entity has 7 inputs and 6 outputs. Read the comments next to each port to learn more about them. 

The file also contains a process which serves as the main game loop, and updates the game state every frame. Presently, the game loop deals with the motion of the ball, detecting collisions with the walls and paddles, and scoring logic. 

You may notice that many of the output ports have variables within the process that are modified internally before being assigned out (e.g., `ball_x` is assigned to a variable named `bx_n`, which is the one used in the process). In VHDL, an out port cannot have its value read from within the component. To allow us to make decisions based on the present value, and keep the entity declaration clean, we create an internal variable and assign the outport to that. This is a common idiom in VHDL. 

## Draw the Pong on Your Screen

### 1. Remove `test_rect` and the signal `on_rect` in the `renderer` file

Please remove `test_rect` and the signal `on_rect` from the previous step since that was just to test if we're able to draw rectangles on our screen. 

### 2. Instantiate the `game_logic` component in `hdmi_top`

Navigate to `hdmi_top` in your current project.

Instantiate the `game_logic` component in `hdmi_top`, and map the proper ports, creating appropriate signals. 

As you map the proper port here are some things to keep in mind: 
- `clk`: the PLL 74MHz clock signal 
- `game_clk`: our `frame_start` signal from the `video_timing` component 
- `reset`: `(not pll_locked) or reset` (we don’t want to run game logic until the PLL is back after a reset) 
- `pl_up`, `pl_dn`, `pr_up`, `pr_dn` should map to `not key(3)`, `not key(2)`, `not key(1)`, `not key(0)`, respectively 

Here is a block diagram for `game_logic` you find useful: 

![Game logic block diagram](assets/game_logic_block_diagram.png)

### 3. Map `game_logic` signals to `renderer` component in `hdmi_top`

We also need to add all the game logic signals that we left out in previous steps to the `renderer` component in `hdmi_top`. So your `renderer` instatiation look like this now: 

````vhdl
-- renderer instatatioin
renderer: entity work.renderer
	port map(
		hcount => hcount, 
		vcount => vcount, 
		rgb => rgb,
		de => de, 
		pl_y => pl_y, 
		pr_y => pr_y, 
		ball_x => ball_x, 
		ball_y => ball_y, 
		score_l => score_l,
		score_r => score_r
	); 	
````

### 4. Uncomment lines in the `renderer` file

Navigate to `renderer` in your current project.

Uncomment the lines in the port declaration of renderer (i.e., `pl_y`, `pr_y`, `ball_x`, `ball_y`, `score_l`, and `score_r`)

Uncomment the component instantiations in `renderer` (to draw the paddles and scores). 

### 5. Add logic to draw the paddles and ball 

In the `renderer` file, write logic to draw the paddles and ball using `on_pl`, `on_pr`, and `on_ball`. This should follow the same approach used earlier to draw the test rectangle.


Compile and upload your code. If you followed the steps successfully then you should be displaying the shapes for our pong game.

## Move the paddles

Navigate to the `game_logic` file. Within the `game_logic` architecture, most of the code has been pre-written for you but one thing we need to add is paddle movement.

Write logic to move the paddles up and down when their respective buttons are pressed. Include checks to prevent them from moving out of the screen bounds. 

This can be copied into the corresponding section of the skeleton code to implement paddle movement:

````vhdl
-- left paddle movement
if (pl_up = '1') then
    -- FILL IN logic to move the paddle upward
elsif (pl_dn = '1') then
    -- FILL IN logic to move the paddle downward
end if;

-- right paddle movement
-- FILL IN logic similar to the left paddle

-- clamp paddle positions to prevent them from extending beyond the screen
````

**Note:** You can use the clamp function in the architecture to bound a number between two values, like so: 

![clamp function](assets/clamp.png)

Compile and upload your code. If you're successfull, you will have a fully functional pong game!