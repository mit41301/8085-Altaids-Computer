
	TITLE "Self-modifying code for MCS-85"
;	a85 SMoC.ASM -l SMoC.LST -o SMoC.HEX -s SMoC.SYM

	ORG 2000H 	; RAM starts HERE

START:   LXI H, 4000h 	; load HL pair with top of RAM
	SPHL		; init Stack Pointer using HL pair	

INIT:	XRA A		; clear ACCumulator
	STC		; set CARRY Flag to 1

AGAIN:	RAL		; rotate RAL or RAR
	PUSH PSW	; store the ACC content in stack
	CALL DELAY	; time delay to see
	POP PSW		; restore the ACC content back
	OUT 61H		; send it to output port 61H
	CC XOR8		; Call if CARRY FLAG = 1
	JMP AGAIN	; do the Rotate again

XOR8:	LDA AGAIN	; load the current rotate instruction	
	XRI 08H		; this will CHANGE the INSTRUCTION (direction)
	STA AGAIN	; store the modified instruction	
	XRA A		; clear ACCumulator
	STC		; set CARRY Flag to 1
	RET		; return 

; --- 16-bit Delay Routine ---
; Input: HL pair holds the 16-bit count (up to FFFFH)
DELAY:
    	LXI H, -1       ; [10 T-states] Load HL with 65,535
LOOP_16:
    	DCX H           ; [6 T-states] Decrement HL pair
    	MOV A, L        ; [4 T-states] Move Low byte to A
    	ORA H           ; [4 T-states] OR with High byte (Sets Zero flag)
    	JNZ LOOP_16     ; [10/7 T-states] Jump if result not zero
    	RET             ; [10 T-states]
	END START	; Added for A85