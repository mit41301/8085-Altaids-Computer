	TITLE "CLEAR the RAM 2100H ~ 3EFFH"
	ORG  2000H
MONITOR EQU 1000H
	LXI  H,1E00H+0ECH	; NUMBER OF BYTES TO CLEAR
				; 3EFFH-20FFH = 1E00 (7680 Bytes)
        LXI  B,3EFFH 		; 3EFFH Start Address in register pair BC		
START: 
        MVI  A,0FFH 		; Fill "FF" value in register A
L1:     STAX B 			; load value in A to the memory location addressed by BC
        DCX  B 			; increment BC
	DCX  H
	MOV  A,L
	ORA  H
 	JNZ  START		; L1
;       JMP  L1
;       STAX B 			; load value 00H to memory location FFFFH
	JMP  MONITOR
        HLT 			; halt CPU
        END  START		; Added for A85 and ASMX
