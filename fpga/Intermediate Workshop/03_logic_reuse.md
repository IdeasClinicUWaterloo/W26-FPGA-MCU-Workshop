# Logic Reuse in VHDL 

A digital system is often made up of several smaller subsystems. This allows you to design large systems using simpler and pre-designed components as building blocks. 

In VHDL, components (entity/architecture pairs) may be reused in different portions of your logic. These components may be instantiated, which creates a copy of them in the logic gates of your FPGA. These copies may have their inputs and outputs connected to other signals in your program. This allows designers to reuse components within and across designs, organize their logic hierarchically, and create vastly more complicated designs via abstraction. 

In the skeleton for this project, we have multiple sub-modules for I2C communication, video timing, etc. that are all connected together by the top file: `hdmi_top.vhd` which acts as a wrapper for all these components. 

To create our pong game, we first need to be able to show a display over HDMI. We can do this by instantiating the ip core: `pll_74mhz` and the local components: `video_timing`, `i2c_config`, and `renderer` in the top file: `hdmi_top`. 