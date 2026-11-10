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
### MONITOR
The operating system of the Altaids computer is a program known as a “monitor program.” This program allows for
interacting with the computer over a serial port and debugging the programs. Commands consist of simple one or two
letter command followed by hexadecimal values. Monitor programs were very popular with early computers. These
programs allowed values to be written directly to memory, displaying memory, reading and writing Intel Hex files, etc.
The monitor prompt is an asterisk **'*'**.  

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

### MONITOR COMMANDS
**CMD: A**  
Enter Altair Turnkey Monitor (see below)  
**CMD: B**  
Start Tiny BASIC 1.0  
**CMD: Dssss eeee**  
Dump memory from address ssss to eeee. After ssss is entered, a space will automatically be generated.  
**CMD: Eaaaa**  
Write to memory starting at address aaaa. The address will be printed with the current byte. Type a new byte (in
hexadecimal) to change. Press <SPACE> to skip the address leaving it unchanged. Type any other character to exit.  
**CMD: Gaaaa**  
Go (execute) a program from address aaaa  
**CMD: H**  
Help / Display monitor commands  
CMD: I
Input a byte from port 60H and display  
**CMD: L**  
Load an Intel Hex file. Send the text file from the terminal emulator.  
A '.' is printed for each record received correctly, a '?' if there is a checksum error, a '!' is printed when done  
**CMD: Obb**  
Output byte bb to port 61H  
**CMD: R**  
Display the values of the registers. Program Counter, Stack Pointer, Accumulator, Processor flags, BC,DE,HL. The flags  
are: Sign, Zero, Auxiliary carry, Parity, and Carry. An example is below  
PC :SP :A SZ_A_P_C:B C :D E :H L  
11CB 3F9E 22 00000100 01D2 1082 11C8  
**CMD: Taaaa**  
Single Step (trace) instructions starting at address aaaa. Type any key to step. Type ^C to exit. Each step shows the
registers and a disassembled instruction. See the example below for details.  

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

# FAQ

What is 8085?
The 8085 is an 8-bit microprocessor developed by Intel®, known for its simplicity and efficiency. It's a cornerstone in computing, providing a solid foundation for embedded systems and educational purposes. With a 16-bit address bus and a 74-instruction set, it efficiently manages basic computational tasks. You’ll find it largely used in teaching environments due to its straightforward architecture, making it a fantastic way to dive into the world of microprocessors.

How does the 8085 handle data transfer?
The 8085 microprocessor handles data transfer using a combination of registers, buses, and memory. It features an address bus to specify memory locations and a data bus for moving data between the processor and peripherals. You’ll find it uses instructions like MOV to transfer data between registers or from memory to registers. The processor runs in a sequential manner to ensure data is accurately moved, making it a reliable tool for simple data management tasks in computing.

Can I program an 8085 microprocessor easily?
Programming the 8085 can be quite straightforward if you have a basic grasp of assembly language. The instruction set is limited to 74 instructions, making it relatively easy to learn and master. You’ll use mnemonics like LDA, STA, and MOV to perform operations. Numerous simulators are available online to practice without needing physical hardware, offering a practical way to hone your skills. Its simplicity and educational resources make it beginner-friendly, perfect for diving into microprocessor programming.

What are the key registers in the 8085?
The 8085 microprocessor includes several key registers that are crucial for its operation. You’ll find the accumulator, which is used for arithmetic and logic operations. There are also six general-purpose registers – B, C, D, E, H, and L – which can be combined into pairs for 16-bit operations. The stack pointer and program counter are essential for managing memory and execution flow. Understanding these registers is vital for effectively programming the 8085 and using its full potential.

How does the 8085 execute instructions?
The 8085 executes instructions through a systematic fetch-decode-execute cycle. You’ll see the program counter fetch the next instruction from memory, which is then decoded to understand what operation is needed. The execution phase involves carrying out the operation, whether it’s arithmetic, logical, or data transfer. This cycle repeats each instruction in the program, ensuring smooth operation. Understanding this process is essential for grasping how microprocessors function at a fundamental level.

Does the 8085 support interrupt handling?
Yes, the 8085 supports interrupt handling with five interrupt lines. These interruptions allow external devices to pause the current execution flow to address urgent tasks. You’ll find instructions like RIM and SIM to manage interruptions effectively. The processor prioritizes these interruptions to ensure critical operations are handled promptly, enhancing the system’s responsiveness. Learning to manage interruptions is crucial for developing efficient and robust applications using the 8085 microprocessor.

What are the communication capabilities of the 8085?
The 8085 microprocessor offers basic communication capabilities through its system bus and I/O ports. You can work with it with external devices using the IN and OUT instructions, helping data exchange. It supports serial and parallel communication, allowing you to connect a variety of peripherals. This flexibility makes the 8085 a versatile choice for embedded systems where communication with other components is essential. Understanding these capabilities is key to maximizing the potential of your 8085-based projects.

Can I use the 8085 for modern applications?
While the 8085 is primarily educational and historical, it can still find use in some niche modern applications. You might consider it for simple embedded systems or hobbyist projects where its simplicity and low power consumption are helpful. However, for more advanced applications, modern processors with enhanced capabilities and power are recommended. The 8085 serves as a great learning tool or for specific low-resource tasks, offering a glimpse into the roots of computing.

What kind of power supply does the 8085 require?
The 8085 microprocessor requires a single +5V power supply for operation. Its low power consumption makes it suitable for battery-operated devices. You’ll find this characteristic helpful in designing energy-efficient systems. Despite being designed in the 1970s, its power requirements stay modest by today’s standards, making it an attractive choice for educational purposes and small-scale projects. Understanding its power requirements is essential for creating stable and reliable systems.

How do I meet memory with the 8085?
Interfacing memory with the 8085 involves using its 16-bit address bus to specify memory locations and an 8-bit data bus to transfer data. You can connect RAM and ROM to meet your storage needs. You’ll need to manage control signals like RD (read) and WR (write) to execute memory operations. The process requires a clear understanding of addressing modes and timing, but once mastered, it’s straightforward to expand the capabilities of your 8085 system.

Would learning the 8085 help with understanding modern processors?
Absolutely, learning the 8085 microprocessor sets a strong foundation for understanding modern processors. You’ll gain insights into basic processor architecture, instruction sets, and data handling. Although modern processors are more complex, the fundamental concepts stay the same. By mastering the 8085, you develop critical thinking and problem-solving skills applicable to any microprocessor study. It’s a stepping stone into the broader world of computing technology, offering valuable lessons and a historical perspective.

How do I debug programs on the 8085?
Debugging programs on the 8085 involves using an assembler or simulator to test your code. You can step through instructions and check register values to find problems. It’s essential to check for logical errors, incorrect instruction usage, or improper data handling. You’ll often rely on tools that emulate 8085 operations, giving you a safe environment to troubleshoot. Developing debugging skills is crucial for ensuring your programs run smoothly and efficiently on the 8085 microprocessors.

Does the 8085 support advanced programming languages?
The 8085 primarily supports assembly language programming, which is closer to machine code and provides direct control over the hardware. While it doesn’t natively support high-level languages, you can use cross-compilers to write code in languages like C, which is then converted to assembly. This process is less efficient than programming directly in assembly but offers a more familiar syntax if you prefer high-level languages. Understanding this limitation is vital for planning your 8085 projects effectively.

Can I simulate 8085 programs on modern computers?
Yes, you can simulate 8085 programs on modern computers using various emulators and simulators available online. These tools allow you to write, test, and debug your code in a virtual environment without needing physical hardware. You will receive help from features like step execution, register monitoring, and memory tracking, making it easier to understand how your programs run. Simulators are an excellent resource for learning and practicing 8085 programming in a convenient and accessible way.
