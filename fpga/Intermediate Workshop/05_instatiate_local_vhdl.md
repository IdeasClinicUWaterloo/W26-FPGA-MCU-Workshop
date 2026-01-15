# Instantiate Local VHDL Modules

For this workshop, we've provided logic for video timing and I2C communication as well as most of the code for renderering on a monitor. This is because in real-life situations you wouldn't be implmenting these functionalities by hand and instead use existing implementations. 

## Instantiate `video_timing`

### 1. Identify input and output signals

We need to know what are the input and output signals for `video_timing`. We can do this by navigating to `video_timing` and looking at it's **entity declaration** which  essentially outlines it's inputs and outputs. 

The **entity declaration** in `video_timing` looks like this: 

![Video timing entity code](assets/video_timing_entity.png)

Notice how the ports in the entity declaration match the input and outputs of the block diagram for `video_timing`

![Video timing block diagram](assets/video_timing_block_diagram.png)

### 2. Set up input and output signals

In the **declaration section** of the architecture body in `hdmi_top`, we need to add the inputs and outputs we identified to support our video timing generator (remember to put them before the begin keyword).

We do **not** need to add new signals for the inputs: `clk` and `reset`. This is because we use the output of the PLL: `clk_pixel` as our `clk` input. Also, we set our `reset` input as `(not pll_locked) or reset` because we reset when the phase-locked loop is unusable or when the reset button is pushed. This is the same for the rest of our components: `i2c_config`, `renderer`, etc. 

````VHDL
-- video timing signals
signal hcount : INTEGER; -- current horizontal pixel position
signal vcount : INTEGER; -- current vertical pixel position
signal hsync, vsync, de, frame_start : STD_LOGIC; 
````

### 3. Write instatiation

In the **logic section** of `hdmi_top` (i.e., after the begin keyword), add this instatiation: 

````VHDL
-- video timing instatatioin  
video_timing: entity work.video_timing 
	port map(
		clk => clk_pixel, 
		reset => (not pll_locked) or reset, 
		hcount => hcount, 
		vcount => vcount, 
		vsync => vsync, 
		hsync => hsync, 
		de => de, 
		frame_start => frame_start
	);
````
### Explaination of the code

General syntax for component instatiation: 

![Component instatiation syntax](assets/component_syntax.png)

For `video_timing`: 
- We set `library` to `work` because this component is part of our project and not a library. `work` is the keyword that refers to the current project. 
- We omit `generic map` since we want to use the default generic values
- We connect the inputs and outputs we identified earlier in `port map`

## Instantiate `i2c_config`

Use the same steps that we went through for `video_timing` to instantiate `i2c_config`. 

You should also know that we do **not** need to add new signals for the output of this component, instead we will connect the outputs of `i2c_config` to the existing signals: `i2c_scl` and `i2c_sda`.  

````VHDL
scl => i2c_scl, 
sda => i2c_sda
````

Here is the block diagram for `i2c_config` to help you: 

![I2C block diagram](assets/i2c_block_diagram.png)

### Reminder for setting `clk` and `reset` inputs

**All the local components** in this project use `clk_pixel` (the output of the PLL) as their `clk` input. 

**All local components** in this project take `(not pll_locked) or reset` as their `reset` input. 

````VHDL
clk => clk_pixel, 
reset => (not pll_locked) or reset, 
````

## Instantiate `renderer`

Use the same steps that we went through for `video_timing` to instantiate `renderer`. We will set `clk` and `reset` for `renderer` the same way we did it for `video_timing` and `i2c_config`. 

Here is the block diagram for `renderer` to help you:

![Renderer block diagram](assets/renderer_block_diagram.png)

Notice how the signals for the inputs of `renderer` are the same signals used in the outputs for `video_timing`. 

### Ignore all game logic signals for now
Please note that we will be ignoring all the signals for game logic (`pl_y` , `pr_y`, `ball_x`, `ball_y`, `score_l`, and `score_r` ) at this time for `renderer` because right now we're just trying to get the display working on HDMI. 

----
Now, compile the project and resolve any errors. The board will not display anything over HDMI yet. 