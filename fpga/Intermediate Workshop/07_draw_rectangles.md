# Drawing rectangles

In this section, you will get an opportunity to write your own module and integrate it with the rest of the logic. We will write a module to help display a rectangle at an arbitrary position on-screen. We will use this module later to draw the ball and paddles for our game. 

## Background: Computer Graphics

Displays are (typically) made up of grids of square pixels. Each pixel can display a range of visible colors by combining varying levels of red, green, and blue light. To see how these elementary colors combine to form different colors, see this interactive tool. 

For most display applications, a standard coordinate system is used to describe the position of a pixel. 

In this coordinate system, `(0,0)` is the top-left corner of the screen. The x-axis increases from left to right, from `0` to `width - 1`, where width is the width of the screen in pixels. Similarly, the y-axis increases from top to bottom, `0` to `height-1`. 

**It is also useful to note that the display used in this design has a resolution of 1280 x 720 pixels.**

![Screen-space coordinate system](assets/screen_coor_system.png)


## 1. Create the `rect_display` component

In Quartus, create a new VHDL file in the current project called `rect_display` and include the following: 

### Library and packages

````VHDL
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL; 
````
### Entity declaration

Write an architecture/entity pair in the new file with six input ports of type INTEGER and one output port of type STD_LOGIC: 
- `hcount`: x-pos of current pixel
- `vcount`: y-pos of current pixel 
- `x1`: x-pos of left side of rectangle 
- `x2`: x-pos of right side of rectangle
- `y1`: y-pos of top of rectangle 
- `y2`: y-pos of bottom of rectangle 
- `lit`: whether the current pixel is on the rectangle 

````vhdl
entity rect_display is
	port (
        -- Fill in your input and output signals here
	);
end rect_display;
````

### Architecture body

Write architecture logic to set the output signal: `lit` to `'1'` when the current pixel is in the rectangle, `'0'` otherwise. 

As you write this logic, think about whether the x and y-coordinates of the current pixel are inside the region defined by the rectangle’s boundaries.

````vhdl
architecture procedural of rect_display is
	begin
    -- Fill in your logic here
end procedural;
````

It may be useful to know the syntax of conditional assignment, which allows conditional behavior without using a process:

![Conditional assignment](assets/conditional_assign.png)

This syntax will assign `val_1` to `var` when `condition_1` is met, `val_2` when `condition_2` is met, and so on. It will assign `val_default` if none of the conditions are met. 

If more than one condition is met, then the topmost value will be prioritized. When this logic is synthesized (converted from HDL into logic elements for the FPGA), it will become a multiplexer element. 

## 2. Use `rect_display` in `renderer  `

Navigate to `renderer` in your current project. 

In `renderer`, we've already provided the component definition for `rect_display`: 

![Renderer component definition](assets/renderer_comp_def.png)

Create a signal to store the `lit` output from `rect_display`

````vhdl
signal on_rect : STD_LOGIC;
````

You need to now write the instantiation for a copy of your rectangle component (like you did for the PLL in Part 1). 

````vhdl
test_rect : rect_display
  port map (
    -- Fill in the rest of your input and output signals here
    lit => on_rect
  );
````

Replace the test pattern you wrote earlier with logic that uses the `lit` output (that is being stored in `on_rect`) to draw a rectangle on screen. The `lit` output from `rect_display` tell you whether the current pixel is inside the rectangle's boundaries and is used by `renderer` to color only those pixels, with all others left black. This the logic you're being asked to implement. 

Here is the block diagram that you may find useful: 

![Renderer block diagram for rect_test](assets/rect_test_block_diagram.png)

---
Compile and upload your code. If you successfully display a rectangle, continue to the next part. 