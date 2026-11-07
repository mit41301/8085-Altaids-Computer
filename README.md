# 80C85 Altaids Computer

The Altaids Computer Kit is a small single board computer, same as the Raspberry Pi, BeagleBone Black, and Arduino. It uses parts that would have been used in the late 1970s/early 1980s (so, no surface-mount!). When connected to a monitor it has the ability for program development.

The Altaids Computer shows that retro-computing doesn't need to take up a lot of space. If you want to relive the early days of computing with a small 8085 computer board, go out and build your own Altaids Computer.

<img width="720" height="534" alt="_1976_8085_5x7_200dpi" src="https://github.com/user-attachments/assets/78c363f6-54df-400b-8b79-4c3a9c07e5a4" />

Intel released the **8085 Microprocessor** in March **1976**. So by now it is more than 50 years. Like TIME MACHINE can be go back and build a 8085 computer? Even after fifty years we can still build a simple computer based on 8085. The study material available for 8085 is huge. We can find so many text books for 8085 with different level of approach. There are so many tutorial videos available in YouTube. Intel licensed the 8085 design to second source. So AMD, NEC, TOSHIBA, OKI, Siemens, etc., manufactured 8085. It is also available with CMOS technology which consumes very less power.
### BLOCK DIAGRAM
<img width="1203" height="903" alt="BLOCK" src="https://github.com/user-attachments/assets/6e4d23a8-b179-49e3-a15e-907bb16f94b8" />

8085 was over shadowed by Z80 and other eight bit microprocessors. But it found a place in College and University. That may be one of the reason it lasted for long time. Since it is a microprocessor and not a microcontroller, it is very simple in hardware and very easy to understand.  

<img width="1008" height="756" alt="8085" src="https://github.com/user-attachments/assets/980e69d4-e566-49af-bb66-6c4e3638d243" />

# PRACTIAL is better than THEORY
To understand what is a computer, and how it operates, we can study and learn or do it and learn. What is a CPU, ROM, RAM, CLOCK etc., we can realize more easily with practical learning.
For example we can see STEP by STEP how the computer operates in real time. How the computer performs Arithmetic operation, Logical operations and how the computer takes decision all we can see in real time using hardware. We can enter few instruction and see how the computer behaves. So the learning is quick and we will remember the thing for long time.

# Configuration:

The design consists of only 6 ICs. CPU, ROM, RAM, LATCH, DECODER and DRIVER. It is bare minimum configuration but still we can do lot of things with this.
The CPU is a CMOS version 8085 microprocessor with 8kB CMOS version EPROM and 8kB RAM. The computer operates at 4.9152MHz with the actual internal clock will be divided by two. We need a address LATCH to hold the higher address during memory access. The memory space is organized as (0000H-1FFFH) the first 8kB for ROM and the next 2000H-3FFFH 8kB is alotted for RAM memory. There is a single IN/OUT port located at 60H(INPUT) and 61H(OUTPUT)
The CMOS version of the CPU consumes very less power and there is no heating observed. At 5V power supply the computer consumes around 20mA only. But with non COMS versions the current goes upto 110mA.
	
# Parts List			
			
<img width="745" height="683" alt="image" src="https://github.com/user-attachments/assets/4107d05a-32fd-406d-a8f9-10d15ced4f80" />


# A85 8085 cross-assembler

A85 8085 cross-assembler can be found from Herb Johnson's [SITE](https://www.retrotechnology.com/restore/a85.html) and it works on Windows 11!

command line: A85 altaidsRom.asm -l altaids.lst -o altaids.hex  

Since the Intel HEX file format is a standard one, we can use any compatible assembler for 8085. The assembler to assemble syntax may differ little bit. But the final HEX output remains the same.

# ASMX cross-assembler 2.0
There are few minor syntax differences between A85 and ASMX assembler. One advantage of ASMX over A85 is there is a CPU type declaration. If we specify CPU 8085, the assembler works for normal instrction set. If we declare the processor type as **CPU 8085U**, then the assembler supports the extended instructions of 8085. The intel HEX file generated have some difference. While downloading the HEX file into the target, the system will not come back to Monitor prompt. We need to press **CTRL+X** to come out and return back to the monitor.

# Tera Term
We need a serial terminal to connect our computer to a Desktop or Laptop at 2400 baud. The Tera Term app is chosen due to easy file transfer capability and support for XMODEM protocol which is useful while working with tinyBASIC.  
Tera Term is a free, open‑source terminal emulator for Windows that supports SSH, Telnet, and serial connections. We can find the latest release from Github at

https://github.com/TeraTermProject/teraterm/releases

While connecting with serial port, we should add the character and line delay as below.

<img width="626" height="700" alt="TeraTerm" src="https://github.com/user-attachments/assets/85e847cb-b79e-48be-8e6d-aafd993717c9" />

The delay is necessary for downloading large files using Send File option. But the delay is not required for XMODEM protocol transfer which is governed by it's own.

# USB-TTL (CP2102 - 5 PINs)
I have tested the computer with Prolific PL2303 USB-TTL cable with 4 wires. It is very useful since it comes with cable. But windows 10/11 will not support the PL2303 chip. There are fix for the issue. But the fix works for the particular USB port where it is connected. If we plug our computer to another USB port, Windows will not recognize the COM port and again we need to fix for the particular USB port. Similarly over a time, there may be some out of sync issues where we need to restart the PC and Tera Term for normal operation.
Since we need only 4 signals VCC, GND, Tx and Rx I came across CP2102 with just 5 pins. With CP2102 chip there are no issues found till now. It also have onboard RED and BLUE LEDs which shows the connection status and traffic in the serial port. There is another version of CP2102 normally available in 6 pins.  

CP210x USB to UART Bridge VCP Drivers can be found from Silabs web site 

https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=overview
# MEMORY MAP
Hardware Memory Map:  
	0000H - 0EFFH	EPROM: TINY BASIC  
	0F00H - 0FFFH	EPROM: ALTAIR TURNKEY MONITOR  
	1000H - 1BFFH	EPROM: 8085 MONITOR  
	1C00H - 1FFFH	EPROM: unused  
	2000H - 3FFFH	SRAM  
	4000H - 5FFFH	unavailable  
	6000H - 7FFFH	RESERVED (decoded with I/O)  
	8000H - FFFFH	OPEN  

 I/O Map:  
	00H - 5FH	unavailable  
	60H - 7FH	external I/O port  
	80H - FFH	unavailable  

 Input Port:	60H  
 Output Port:	61H  

 Serial interface: 2400 baud, 8N1, Flow control: None  

 Because of processing of the serial data, sending text files from TeraTerm  requires delays for character and lines.  I found the following settings  very reliable:
 Transmit delay =  
	50 msec/char  
	200 msec/line  

# SOFTWARE
The system comes with a inbuilt powerful MONITOR program which runs by default after RESET. 
Monitor commands
```
A : ALTAIR MONITOR
B : TINY BASIC
D : DUMP [Dnnnn mmmmm]
E : ENTER [Ennnn]
G : RUN [Gnnnn]
H : HELP (this message)
I : INPUT FROM PRT 60H
L : LOAD HEX FILE
O : OUTPUT TO PRT 61H [Obb]
R : DISPLAY REG
T : TRACE (STEP) [Tnnnn]
```

### A : ALTAIR MONITOR
It is added just to show the legacy system. Here we need to enter all the numbers in OCTAL. The system output also will be in OCTAL number system.

### B : TINY BASIC
By typing **B** it invokes the tinyBASIC version 1.0. To exit we can type **BYE** or CTRL+X 



# PRIME TESTs
<img width="1217" height="671" alt="benchmark" src="https://github.com/user-attachments/assets/0ee04bcd-c2c7-481a-8975-0e04462866eb" />


# MARS 
<img width="800" height="417" alt="image" src="https://github.com/user-attachments/assets/c334782d-0dd8-4e28-be4f-c4c3b7435c52" />

Dec. 4, 1996

About the mission
The Mars Pathfinder mission, designed to demonstrate a low-cost method for delivering a set of science instruments to the Red Planet, was the first wheeled vehicle to be used on any other planet in the solar system and served as the foundation for the Mars rovers of today.

The mission landed a rover -- Sojourner -- on the surface of Mars using an air bag landing system and innovative petal design, which have been used since in various incarnations to land other rovers on the Red Planet. Sojourner spent 83 days of a planned seven-day mission exploring the Martian terrain, snapping photographs and taking chemical, atmospheric and other measurements.

The Sojourner rover was a vehicle that reached Mars on July 4, 1997 as part of the Mars Pathfinder mission. Sojourner was operational on Mars for 92 sols (95 Earth days), and was the first wheeled vehicle to operate on an astronomical object other than the Earth or Moon. The landing site was in the Ares Vallis channel in the Chryse Planitia region of the Oxia Palus quadrangle.

Sojourner's central processing unit (CPU) was an Intel 80C85 with a 2 MHz clock, addressing 64 kilobytes (Kb) of memory, and running a cyclic executive. It had four memory stores; 64 Kb of RAM made by IBM for the main processor, 16 Kb of radiation-hardened PROM made by Harris, 176 Kb of non-volatile storage made by Seeq Technology, and 512 Kb of temporary data storage made by Micron. The electronics were housed inside the rover's warm electronics box (WEB). The WEB is a box-like structure formed from fiberglass facesheets bonded to aluminum spars. The gaps between facesheets were filled with blocks of aerogel that worked as thermal insulation. The aerogel used on the Sojourner had a density of approximately 20 mg/cc. This insulator was designed to trap heat generated by rover's electronics; this trapped heat soaked at night through the passive insulation maintaining the electronics in the WEB at between −40 and 40 °C (−40 and 104 °F), while externally the rover experienced a temperature range between 0 and −110 °C (32 and −166 °F).
