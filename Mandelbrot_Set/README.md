# Mandelbrot Set

From Wikpedia [Mandelbrot Set](https://en.wikipedia.org/wiki/Mandelbrot_set)

<img width="700" height="560" alt="image" src="https://github.com/user-attachments/assets/41af7f5d-e18a-496d-ae48-440054a7d419" />

The first Mandelbrot set created by Robert W. Brooks and Peter Matelski in 1978.

In any small microcontroller based system, plotting the Mandelbrot Set is one of the Acid Test due to large number of iterations.

I am able to plot on a 8085 machine running at 4.9152 MHz with 2400 baud using tinyBASIC. Due to limited RAM, unable to run full fledged BASIC with floating point arithmetic. Below is the tinyBASIC output of plotting the Mandelbrot set.

<img width="854" height="506" alt="TWITTER_TINYBASIC" src="https://github.com/user-attachments/assets/ca152dca-44c8-4b25-9000-edd664ece172" />

Another [tiny BASIC](https://rosettacode.org/wiki/Mandelbrot_set#Tiny_BASIC) program with slightly different logic produced the following output

<img width="853" height="581" alt="II_Mandelbrot" src="https://github.com/user-attachments/assets/6434c957-f93a-444e-ba0f-4b5c0a63be88" />

I was looking for other ways to speed up my machine to perform faster. So I was looking simple or native machine language based approach.

There is a Hackaday user [**senily64dx**](https://hackaday.io/SenileDataSystems) who recently built a 8080 kit. The surprise part is the kit was originally built on the year **1976** and was never opened till **2026**. Below is the assembled 8080 kit picture for reference.

<img width="3052" height="1700" alt="8080_SIEMENS" src="https://github.com/user-attachments/assets/18787cb0-44f3-41cd-8520-177133b6e79d" />

If we notice the manufacturing date of the **8080** is **36th WEEK of 1976**!. This kit was opened after **50 Years** and assembled just few months back. For testing the kit **senily64dx** wrote a "Hello, World!" program in 8080 Assembly language. **senily64dx** also published the Mandelbrot set code he tried on his 8080 kit which was built in 1976. The original source code can be found [HERE](https://cdn.hackaday.io/files/2065438836735712/8080.asm)

I do not have a 8080 system to try the Mandelbrot set code. Since I already have a working 80C85 system and 8085 is backward compatible with 8080 code, I want to give a try. 
The code worked well on my 8085 machine.

## BENCHMARK

The 8080 kit with a system clock of 2.0480 MHz took 45.80 seconds to complete the Mandelbrot Set with inbuilt 8251 IC running at 4800 baud.
The 8085 kit with a system clock of 2.4576 MHz took 43.34 seconds to compete the Mandelbrot Set with soft serial using SID, SOD at 2400 baud.

<img width="850" height="462" alt="TWITTER_CHATGPT" src="https://github.com/user-attachments/assets/d9123ee3-4996-49c8-bca4-852883039744" />

After code optimization, the program runs at 40 seconds.

**WARNING: The 8080.asm code will RUN on both 8080 and 8085. 8085.asm will run only with 8085 and not backward compatible with 8080.**

The list and HEX files are generated using **ASMX** 2.0 assembler.

## 8080 support

The **Mandelbrot Set** using **8080/8085 assembly language** instructions for the **8080 processor** support added. The 8080.asm uses **A85** assembler for generating output HEX file. The 8080.hex file should run on both 8080 and 8085 processor. Not tested with 8080 machine. Tested with 8085 machine and works.
