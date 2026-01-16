# Overview: Setting Up Video over HDMI

Before we can build the game logic for Pong, we first need to configure the system to display graphics over HDMI. This section provides an overview of how we will use pre-built VHDL modules to show video over HDMI.

## What is Logic Reuse in VHDL?

A digital system is often made up of several smaller subsystems. This allows you to design large systems using simpler and pre-designed components as building blocks. 

In VHDL, components (entity/architecture pairs) may be reused in different portions of your logic. These components may be instantiated, which creates a copy of them in the logic gates of your FPGA. These copies may have their inputs and outputs connected to other signals in your program. This allows designers to reuse components within and across designs, organize their logic hierarchically, and create vastly more complicated designs via abstraction. 

## How This Applies to This Project

In the provided skeleton for this project, several subsystems are already implemented for you, including modules for:
- Video timing
- I2C communication
- Pixel rendering

These subsystems are all connected together by a top-level file: `hdmi_top.vhd`, which acts as a wrapper for all these modules.

The first step in building the Pong game is to set up HDMI output. This requires instantiating the PLL IP core (`pll_74mhz`) and `video_timing`, `i2c_config`, and `renderer` in the top-level file: `hdmi_top.vhd`.