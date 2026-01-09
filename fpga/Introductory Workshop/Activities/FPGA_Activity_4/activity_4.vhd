-- ========================================
-- ACTIVITY 4: activity_4.vhd
-- Binary to Decimal Conversion
-- 10-bit signed binary input -> Decimal display
-- ========================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY activity_4 IS
    PORT (
        SW   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);    -- SW(9) = sign, SW(8 DOWNTO 0) = binary number
        HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    -- Ones place display
        HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    -- Tens place display
        HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    -- Hundreds place display
        HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)     -- Sign display
    );
END activity_4;

ARCHITECTURE Behavioral OF activity_4 IS
    
    -- FUNCTION: Convert digit (0-9) to 7-segment display

	 
    
    -- FUNCTION: Convert sign bit to 7-segment display

	 
	 
BEGIN
    
    -- Main process to handle input conversion
    PROCESS (SW)
	 
		VARIABLE temp_signed : INTEGER RANGE -512 TO 511;
        VARIABLE temp_abs : INTEGER RANGE 0 TO 512;
        VARIABLE temp : INTEGER RANGE 0 TO 512;
        VARIABLE hundreds : INTEGER RANGE 0 TO 9;
        VARIABLE tens : INTEGER RANGE 0 TO 9;
        VARIABLE ones : INTEGER RANGE 0 TO 9;
        VARIABLE sign : STD_LOGIC;
    
	 BEGIN
        
		-- Convert input (signed 9-bit number with SW(9) as sign indicator)
		  

        
		  
        -- Get the absolute value and sign
		  

		  
		  
		  
        -- Break into decimal digits
		  

		  
        

		--HEX3 assignment (sign to seven segment function)
		  
		  
	    --HEX2, HEX1, HEX0 assignment (digit to seven segment function)
		  
		          
    END PROCESS;
    
END Behavioral;