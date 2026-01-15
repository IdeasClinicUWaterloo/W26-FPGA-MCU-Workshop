# Game Logic

In this part, we will write logic to drive the movement of paddles in the game logic.

## Overview of `game_logic`

For this part, we will be working mostly in the `game_logic` file. The `game_logic` entity has 7 inputs and 6 outputs. Read the comments next to each port to learn more about them. 

The file also contains a process which serves as the main game loop, and updates the game state every frame. Presently, the game loop deals with the motion of the ball, detecting collisions with the walls and paddles, and scoring logic. 

You may notice that many of the output ports have variables within the process that are modified internally before being assigned out (e.g., `ball_x` is assigned to a variable named `bx_n`, which is the one used in the process). In VHDL, an out port cannot have its value read from within the component. To allow us to make decisions based on the present value, and keep the entity declaration clean, we create an internal variable and assign the outport to that. This is a common idiom in VHDL. 

## Draw the Pong on Your Screen

### 1. Remove `test_rect` and the signal `on_rect` in `renderer` file

Please remove `test_rect` and the signal `on_rect` from the previous step since that was just to test if we're able to draw rectangles on our screen. 

### 2. Instantiate the `game_logic` component in `hdmi_top`

Navigate to `hdmi_top` in your current project.

Instantiate the `game_logic` component in `hdmi_top`, and map the proper ports, creating appropriate signals. 

As you map the proper port here are some things to keep in mind: 
- `clk`: the PLL 74MHz clock signal 
- `game_clk`: our `frame_start` signal from the `video_timing` component 
- `reset`: `(not pll_locked) or reset` (we don’t want to run game logic until the PLL is back after a reset) 
- `pl_up`, `pl_dn`, `pr_up`, `pr_dn` should map to `not key(3)`, `not key(2)`, `not key(1)`, `not key(0)`, respectively 

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

### 4. Uncomment lines in `renderer` file

Navigate to `renderer` in your current project.

Uncomment the lines in the port declaration of renderer (i.e., `pl_y`, `pr_y`, `ball_x`, `ball_y`, `score_l`, and `score_r`)

Uncomment the component instantiations in `renderer` (to draw the paddles and scores). 

### 5. 