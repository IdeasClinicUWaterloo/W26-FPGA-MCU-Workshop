# Activity 3: Displaying Digital Circuit Results

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
