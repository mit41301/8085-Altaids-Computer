	TITLE " BINARY TO BCD CONVERSION "
	ORG 2000H
START:  LXI SP,STACK ;initialize stack pointer
        LXI H,BINBYT ;point HL index to where binary number is stored
        MOV A,M ;transfer byte
        LXI H,OUTBUF ;point HL index to output-buffer memory
        CALL BINBCD
        JMP 1000H ; HLT

BINBCD:
        MVI B,100 ;load 100 into register B (power of ten holding register)
        CALL BCD ;call conversion for BCD3
        MVI B,10 ;load 10 into register B
        CALL BCD ;call conversion for BCD2
        MOV M,A ;store BCD1
        RET

BCD:
        MVI M,0FFH ;load buffer with -1
STORE:  INR M ;clear buffer first and increment for each subtraction
        SUB B ;subtract power of ten from binary number
        JNC STORE ;if number is larger than power of ten, go back and add 1 to buffer
        ADD B ;if no, add power of ten to get back remainder
        INX H ;go to next buffer location
        RET

        ORG 2030H
BINBYT  DB 243 	;example binary number to be converted into a BCD number
OUTBUF  	;output-buffer memory location

STACK   EQU 3FFFH ;definition of stack pointer initialization address
        END START