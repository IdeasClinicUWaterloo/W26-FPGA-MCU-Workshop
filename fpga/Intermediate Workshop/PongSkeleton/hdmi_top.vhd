-- main top module for hdmi pong on the c5g board with adv7513 transmitter
-- key0/key1 = player 1 up/down, key2/key3 = player 2 up/down
-- reset is moved to the cpu_reset_n pushbutton

library IEEE;
library LIB_PLL_74MHZ;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hdmi_top is
	port (
		clock_50_b5b: 	in STD_LOGIC;								-- 50 mhz main board clock
		
		cpu_reset_n: 	in STD_LOGIC;								-- pushbutton reset, active-low
		key: 				in STD_LOGIC_VECTOR(3 downto 0);		-- player control pushbuttons, active low
		sw:				in STD_LOGIC_VECTOR(9 downto 0);		-- toggle switches for game-speed control
		
		-- The following signals are directly connected to the ADV7513 transmitter
		hdmi_tx_d: 		out STD_LOGIC_VECTOR(23 downto 0);	-- rgb pixel data
		hdmi_tx_de: 	out STD_LOGIC;								-- data enable
		hdmi_tx_hs: 	out STD_LOGIC;								-- horizontal sync
		hdmi_tx_vs: 	out STD_LOGIC;								-- vertical sync
		hdmi_tx_clk: 	out STD_LOGIC;								-- pixel clock
		
		-- The following signals are used for I2C communication with the ADV7513 transmitter
		i2c_sda: 		inout STD_LOGIC;							-- i2c data
		i2c_scl: 		out STD_LOGIC								-- i2c clock
		
	);
end hdmi_top;

architecture structural of hdmi_top is
	
begin
	
end structural;