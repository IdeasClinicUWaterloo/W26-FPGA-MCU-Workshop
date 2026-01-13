# Logic Reuse in VHDL 

A digital system is often made up of several smaller subsystems. This allows you to design large systems using simpler and pre-designed components as building blocks. 

In VHDL, components (entity/architecture pairs) may be reused in different portions of your logic. These components may be instantiated, which creates a copy of them in the logic gates of your FPGA. These copies may have their inputs and outputs connected to other signals in your program. This allows designers to reuse components within and across designs, organize their logic hierarchically, and create vastly more complicated designs via abstraction. 

In the skeleton for this project, we have multiple sub-modules for I2C communication, video timing, etc. that are all connected together by the top file: `hdmi_top.vhd` which acts as a wrapper for all these modules. 

To create our pong game, we first need to instantiate the following: `pll_74mhz`, `video_timing`, `i2c_config`, and `renderer` to in the top file: `hdmi_top`. 

In `hdmi_top.vhd`, the architecture body has a declaration section for internal signals, constants, etc. It also has a main description section encompassed by **begin** and **end** where our instationation statements will go. 

````VHDL
architecture structural of hdmi_top is
	-- SIGNAL and COMPONENT declarations go here
begin
	-- Instatitation statements go here
end structural;
````

## 1. Instantiate Phase-Locked Loop  

### Component Definition
For the Phase-Locked Loop component we grabbed from the Altera IP library earlier, we need to write its component definition so that we're able to use it in for in our code. 

In the **declaration section** of our hdmi_top architecture (i.e., before the begin keyword), we’ll add the following component definition. This informs Quartus that, somewhere in our project, there’s a component named pll_74mhz with two input ports and two output ports of the STD_LOGIC type. 

````VHDL
-- pll_74mhz component definition
component pll_74mhz is
	port (
		refclk   : in  STD_LOGIC; --  refclk.clk
		rst      : in  STD_LOGIC; --  reset.reset
		outclk_0 : out STD_LOGIC; --  outclk0.clk
		locked   : out STD_LOGIC  --  locked.export
	);
end component;
````

### Instatiation
To incorporate the component into our design, we must instantiate it. This tells Quartus to generate logic gates to implement the PLL, and how to connect its inputs and outputs.

In this case, we’re connecting an internal 50 MHz clock to the refclk port, our reset signal to the rst port, our pixel clock to the outclk_0 port, and our PLL locked signal to the locked port. 

![PLL block diagram](assets/pll_block_diagram.png)

#### Set up inputs and outputs
To do this, you need to first add the following internal signals in the **declaration section**: 

````VHDL
-- pll_74mhz signals
signal reset : STD_LOGIC; 
signal clk_pixel : STD_LOGIC; 
signal pll_locked : STD_LOGIC; 
````

where: 
- `reset`: resets input to the PLL
- `clk_pixel`: the 74.25 MHz clock output from the PLL
- `pll_locked`: tells you when the PLL is stable and usable

In the **statements section** (i.e., after the begin keyword), add this instatiation: 


#### Connect Inputs and Outputs
In the **statements section** (i.e., after the begin keyword), add this instatiation: 

````VHDL
-- pll_74mhz instantiation
pll_clock: pll_74mhz
	port map (
		refclk 	    => clock_50_b5b,
		rst 		=> reset,
		outclk_0    => clk_pixel,
		locked 	    => pll_locked
	);
````

