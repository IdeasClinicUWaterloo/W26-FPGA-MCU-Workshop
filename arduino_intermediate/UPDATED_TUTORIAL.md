# Arduino Intermediate Activity

### Authors: 
Chris Rennick, Fareed Rasheed, Hailey Doleweerd, Orion Bruckman, Nancy Nelson



## 1 Microcontrollers 
Microcontrollers are small one-chip computers that are at the core of much of today’s technology to automate and control tasks. Generally, they have a Central Processing Unit (CPU), some memory, and programmable input and output ports. This intermediate workshop builds on prior knowledge of microcontrollers and introduces polling loops, interrupts, and timers.  With polling loops, our code manually checks the status of any input pins at a regular interval, and then we can respond.  Interrupts are used for more critical events so that the code can respond more quickly. 

These concepts will be used to create a simple, 2-player version of the game Pong. 


### 1.1 Required Materials
* 1x Arduino UNO Rev. 4 
* 1x OLED Display 
* 1x Breadboard 
* 3x Pushbuttons 
* 12x Wires 
* 1x USB-C Cable 


## 2 Activity - Pong Overview
Pong is a simple game, however the logic used is fundamental to creating interactable devices that respond to the real world. This activity aims to help you grasp the principles of digital logic and interactable devices by introducing concepts such as button polling, timers and interrupts. These principles are the core of the systems we interact with every day ranging from handheld devices to complex game engines.  

### 2.1 Build Your Circuit