# Drawing rectangles

In this section, you will get an opportunity to write your own module and integrate it with the rest of the logic. We will write a module to help display a rectangle at an arbitrary position on-screen. We will use this module later to draw the ball and paddles for our game. 

## How 

## Create a new VHDL file

In Quartus, create a new VHDL file called: `rect_display` with the following: 

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

Write architecture logic to set lit to '1' when the current pixel is in the rectangle, '0' otherwise. 

````vhdl
architecture procedural of rect_display is
	begin
    -- Fill in your logic here
end procedural;
````

It may be useful to know the syntax of conditional assignment, which allows conditional behavior without using a process: