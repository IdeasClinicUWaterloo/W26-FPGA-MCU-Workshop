# Activity 3: Displaying Digital Circuit Results


## From Digital to Programmed Logic

### Function

A function is a reusable block of code that executes a specific computation and returns a value. VHDL functions are like regular programming languages.

![Function Example](assets/function_example.png)

### Case Statement

A case statement is like a multiple-choice decision. It checks the value of a signal or variable and executes different code depending on the value.

![Case Statement Example](assets/case_statement_example.png)

### Variables

In VHDL, variables and signals are both used to store data, but they behave differently. Signals represent connections and are used to model hardware wires—they update their values after a delay (in the next simulation cycle). In contrast, variables are used inside processes and update immediately, making them useful for intermediate calculations. Use signals when you want to communicate between processes or drive outputs, and variables when you need quick updates within a single process or function.

In VHDL, := and <= are assignment operators, but they are used in different contexts. The := operator is used to assign values to variables, and the change happens immediately within the process or function. The <= operator is used to assign values to signals, and the change takes effect after the current simulation cycle, reflecting actual hardware behavior. So, use := for quick, local calculations with variables, and use <= when updating signals that represent hardware connections.

## Example Code

This sample code shows the usage of functions and case statements. Again, you can use the syntax of this file as a reference for the following activity.

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SegExample is
    Port (
        SW   : in  STD_LOGIC_VECTOR(1 downto 0);
        HEX0 : out STD_LOGIC_VECTOR(6 downto 0)      -- 7-seg display (active-low)
    );
end SegExample;

architecture Behavioral of SegExample is

    --SIGNAL declarations    
    signal result : STD_LOGIC;

    -- Function: Convert '0' or '1' (as character) to 7-segment encoding
    function to_seven_segment(bit_char : character) return STD_LOGIC_VECTOR is
        variable seg : STD_LOGIC_VECTOR(6 downto 0);
    begin
        case bit_char is
            when '0' => seg := "1000000";  -- 7-seg for 0
            when '1' => seg := "1111001";  -- 7-seg for 1
            when others => seg := "1111111";  -- blank display (all off)
        end case;
        return seg;
    end function;

begin

    result <= SW(0) and SW(1);

    -- Use function to choose display value
    process(result)
    begin
         if (SW(0) = '0' and SW(1) = '0') then
              HEX0 <= to_seven_segment('X');  -- undefined → blank
         elsif result = '1' then
              HEX0 <= to_seven_segment('1');
         else
              HEX0 <= to_seven_segment('0');
         end if;
    end process;

end Behavioral;
```

## Activity Instructions

It's time to combine some of the skills you've developed. This activity involves displaying numbers using the seven-segment display and building on the full adder, modify your code to display the result of the full adder using the seven-segment display.

To do this, you will need to add two standard logic type signals to your architecture, one for the sum, and one for the carry out. 

Use a process that triggers whenever the state of either of the signals changes. Inside the process, you should use if statements that check the state of the carry out and the sum simultaneously. Then use this logic to define which values must be assigned to the display.

Finally, assign the appropriate value to the seven-segment display HEX1. 

Refer to the truth table below for the expected behavior

| Carry Out | Sum | Display |
|-----------|-----|---------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 2 |
| 1 | 1 | 3 |

---

|Back: [Activity 2](activity_2.md) | [Top](../README.md) |Next: [Activity 4](activity_4.md)|
|---|---|---|