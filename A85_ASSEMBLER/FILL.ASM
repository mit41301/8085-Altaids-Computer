	TITLE "CLEAR the RAM 200CH ~ 3FFFH"
	ORG  2000H
START:
        MVI  A,0FFH 	;Fill "00" value in register A
        LXI  B,200CH 	;200CH value in register pair BC
L1:     STAX B 		;load value in A to the memory location addressed by BC
        INX  B 		;increment BC
        JMP  L1
        STAX B 		;load value 00H to memory location FFFFH
        HLT 		;halt cpu
        END  START
