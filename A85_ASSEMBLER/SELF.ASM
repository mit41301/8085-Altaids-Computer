	TITLE "Self modifying LED program for MCS-85"

	ORG 2000H 	; RAM starts HERE
START   LXI H, 4000h 	; load HL pair with RAM end location
	SPHL		; init Stack Pointer	

	XRA A		; clear ACCumulator
	STC		; set CARRY bit
AGAIN	RAL		; rotate RAL or RAR
	OUT 61H		; send it to output port 61H
	PUSH PSW	; store the ACC content in stack
	CALL DELAY	; call time delay
	CALL DELAY	; call more time delay
	POP PSW		; restore the ACC content back
	CC XOR8		; If CARRY bit set change direction
	JMP AGAIN	; do the shift again
XOR8	LDA AGAIN	; load the current rotate instruction	
	XRI 08H		; this will change the direction
	STA AGAIN	; store the modified instruction	
	XRA A		; clear the ACC
	STC		; set CARRY flag
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
	END 		; Added for A85
