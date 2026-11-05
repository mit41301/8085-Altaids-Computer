	TITLE "Mandelbrot generator (C) ChatGPT"
        ORG     02000H

CO      EQU     01006H

; ============================================================
; Mandelbrot for Intel 8080 / MCS-80 KIT
;
; Display: 79 x 23 characters
;
; Fixed point:
;       128 = 1.0
;
; Program: 1000H onwards
; Stack:   1300H-13FFH -- NEVER TOUCHED BY PROGRAM DATA
; Work:    3000H-33FFH
;
; Exit: RET
; ============================================================


; ------------------------------------------------------------
; Parameter block (this is for easier user access so you can just change those with the ML monitor)
; so the machine doesn't have to render the same image again and again at retrocomputing events
; ------------------------------------------------------------

CENTER_X    EQU     03000H
CENTER_Y    EQU     03002H
STEP_X      EQU     03004H
STEP_Y      EQU     03006H
ITER_MAX    EQU     03008H


; ------------------------------------------------------------
; Working storage
; ------------------------------------------------------------

TOP_Y       EQU     03009H
CUR_X       EQU     0300BH
CUR_Y       EQU     0300DH

Z_X         EQU     0300FH
Z_Y         EQU     03011H

OLD_X       EQU     03013H
OLD_Y       EQU     03015H

X2          EQU     03017H
Y2          EQU     03019H

ITER        EQU     0301BH
COLS        EQU     0301CH
ROWS        EQU     0301DH

SIGN        EQU     0301EH
MUL_A       EQU     0301FH
MUL_B       EQU     03021H


; ============================================================
; PROGRAM
; ============================================================

START:

; ------------------------------------------------------------
; Calculate TOP_Y = CENTER_Y - 11 * STEP_Y
; ------------------------------------------------------------

        LHLD    CENTER_Y
        SHLD    TOP_Y

        MVI     B,11

TOP_Y_LOOP:
        LHLD    TOP_Y
        XCHG
        LHLD    STEP_Y

        MOV     A,E
        SUB     L
        MOV     E,A

        MOV     A,D
        SBB     H
        MOV     D,A

        XCHG
        SHLD    TOP_Y

        DCR     B
        JNZ     TOP_Y_LOOP


; ------------------------------------------------------------
; Start at top row
; ------------------------------------------------------------

        LHLD    TOP_Y
        SHLD    CUR_Y

        MVI     A,23
        STA     ROWS


; ============================================================
; ROW LOOP
; ============================================================

ROW_LOOP:

; ------------------------------------------------------------
; CUR_X = CENTER_X - 40 * STEP_X
; ------------------------------------------------------------

        LHLD    CENTER_X
        SHLD    CUR_X

        MVI     B,40

X_START_LOOP:
        LHLD    CUR_X
        XCHG
        LHLD    STEP_X

        MOV     A,E
        SUB     L
        MOV     E,A

        MOV     A,D
        SBB     H
        MOV     D,A

        XCHG
        SHLD    CUR_X

        DCR     B
        JNZ     X_START_LOOP


; ------------------------------------------------------------
; 79 columns
; ------------------------------------------------------------

        MVI     A,79
        STA     COLS


COLUMN_LOOP:

        CALL    MANDEL_POINT

; ------------------------------------------------------------
; Map iteration count to density.
;
; 0       -> 0
; 1..2    -> 1
; 3..4    -> 2
; ...
; 13..14  -> 7
; 15+     -> 7
; ------------------------------------------------------------

        CPI     15
        JC      DENSITY_LOW

        MVI     A,7
        JMP     DENSITY_INDEX

DENSITY_LOW:
        INR     A
        RRC
        ANI     007H

DENSITY_INDEX:
        MOV     E,A
        MVI     D,0

        LXI     H,DENSITY
        DAD     D

        MOV     A,M
        CALL    CO


; ------------------------------------------------------------
; CUR_X += STEP_X
; ------------------------------------------------------------

        LHLD    CUR_X
        XCHG
        LHLD    STEP_X
        DAD     D
        SHLD    CUR_X

        LDA     COLS
        DCR     A
        STA     COLS
        JNZ     COLUMN_LOOP


; ------------------------------------------------------------
; Newline
; ------------------------------------------------------------

        MVI     A,00DH
        CALL    CO

        MVI     A,00AH
        CALL    CO


; ------------------------------------------------------------
; CUR_Y += STEP_Y
; ------------------------------------------------------------

        LHLD    CUR_Y
        XCHG
        LHLD    STEP_Y
        DAD     D
        SHLD    CUR_Y

        LDA     ROWS
        DCR     A
        STA     ROWS
        JNZ     ROW_LOOP

        RET


; ============================================================
; MANDEL_POINT
;
; Calculate:
;
;       z = z*z + c
;
; starting with z = 0.
;
; Returns A = iteration count.
;
; A = ITER_MAX means the point survived.
; ============================================================

MANDEL_POINT:

        LXI     H,0
        SHLD    Z_X
        SHLD    Z_Y

        XRA     A
        STA     ITER


ITERATE:

; ------------------------------------------------------------
; Preserve the old Z values.
; ------------------------------------------------------------

        LHLD    Z_X
        SHLD    OLD_X

        LHLD    Z_Y
        SHLD    OLD_Y


; ------------------------------------------------------------
; If |X| >= 256, escape.
;
; Allowed values:
;       0000H..00FFH = 0..255
;       FF01H..FFFFH = -255..-1
;
; FF00H is -256 and must escape too.
; ------------------------------------------------------------

        LHLD    OLD_X

        MOV     A,H
        CPI     000H
        JZ      X_OK

        CPI     0FFH
        JNZ     ESCAPED

        MOV     A,L
        ORA     A
        JZ      ESCAPED

X_OK:


; ------------------------------------------------------------
; Same test for Y.
; ------------------------------------------------------------

        LHLD    OLD_Y

        MOV     A,H
        CPI     000H
        JZ      Y_OK

        CPI     0FFH
        JNZ     ESCAPED

        MOV     A,L
        ORA     A
        JZ      ESCAPED

Y_OK:


; ------------------------------------------------------------
; X2 = OLD_X * OLD_X
; ------------------------------------------------------------

        LHLD    OLD_X
        XCHG
        LHLD    OLD_X

        CALL    SMUL
        SHLD    X2


; ------------------------------------------------------------
; Y2 = OLD_Y * OLD_Y
; ------------------------------------------------------------

        LHLD    OLD_Y
        XCHG
        LHLD    OLD_Y

        CALL    SMUL
        SHLD    Y2


; ------------------------------------------------------------
; Escape if X2 + Y2 >= 4.
;
; With 128 = 1.0:
;
;       4 * 128 * 128 = 65536
;
; Carry from the 16-bit addition means >= 4.
; ------------------------------------------------------------

        LHLD    X2
        XCHG

        LHLD    Y2
        DAD     D

        JC      ESCAPED


; ------------------------------------------------------------
; Convert squares to fixed-point:
;
;       raw square / 128
; ------------------------------------------------------------

        LHLD    X2
        CALL    SHR7
        SHLD    X2

        LHLD    Y2
        CALL    SHR7
        SHLD    Y2


; ============================================================
; New X:
;
;       X = X2 - Y2 + CUR_X
; ============================================================

        LHLD    Y2
        XCHG

        LHLD    X2

        MOV     A,L
        SUB     E
        MOV     L,A

        MOV     A,H
        SBB     D
        MOV     H,A

; HL = X2 - Y2

        XCHG

        LHLD    CUR_X
        DAD     D

        SHLD    Z_X


; ============================================================
; New Y:
;
;       Y = 2 * OLD_X * OLD_Y + CUR_Y
;
; Raw product is shifted right 6:
;
;       (X * Y * 128 * 128) / 64
;       = X * Y * 256
;
; which represents 2*X*Y at scale 128.
; ============================================================

        LHLD    OLD_X
        XCHG

        LHLD    OLD_Y

        CALL    SMUL

        CALL    ASR6

        XCHG

        LHLD    CUR_Y
        DAD     D

        SHLD    Z_Y


; ------------------------------------------------------------
; ITER++
; ------------------------------------------------------------

        LDA     ITER
        INR     A
        STA     ITER

        MOV     B,A

        LDA     ITER_MAX
        CMP     B
        JNZ     ITERATE

; Survived all iterations.

        LDA     ITER
        RET


ESCAPED:

        LDA     ITER
        RET


; ============================================================
; SMUL
;
; Signed 16-bit multiply.
;
; Input:
;       HL = signed value
;       DE = signed value
;
; The caller must ensure:
;       - Both operands are in -255..+255.
;       - The signed product fits in 16 bits.
;
; Output:
;       HL = signed product
; ============================================================

SMUL:

        SHLD    MUL_A
        XCHG
        SHLD    MUL_B


; ------------------------------------------------------------
; Determine sign of result.
; ------------------------------------------------------------

        XRA     A
        STA     SIGN

        LHLD    MUL_A

        MOV     A,H
        ANI     080H
        JZ      A_POSITIVE

        MVI     A,1
        STA     SIGN

        CALL    ABS_HL
        SHLD    MUL_A


A_POSITIVE:

        LHLD    MUL_B

        MOV     A,H
        ANI     080H
        JZ      B_POSITIVE

        LDA     SIGN
        XRI     1
        STA     SIGN

        CALL    ABS_HL
        SHLD    MUL_B


B_POSITIVE:

; ------------------------------------------------------------
; Low bytes are now the unsigned operands.
; ------------------------------------------------------------

        LHLD    MUL_A
        MOV     B,L

        LHLD    MUL_B
        MOV     C,L

        CALL    MUL8


; ------------------------------------------------------------
; Apply sign.
; ------------------------------------------------------------

        LDA     SIGN
        ORA     A
        RZ

        MOV     A,L
        CMA
        MOV     L,A

        MOV     A,H
        CMA
        MOV     H,A

        INX     H

        RET


; ============================================================
; ABS_HL
;
; Absolute value of signed 16-bit HL.
; ============================================================

ABS_HL:

        MOV     A,H
        ANI     080H
        RZ

        MOV     A,L
        CMA
        MOV     L,A

        MOV     A,H
        CMA
        MOV     H,A

        INX     H

        RET


; ============================================================
; MUL8
;
; Unsigned 8 x 8 -> 16 bit.
;
; Input:
;       B = multiplicand
;       C = multiplier
;
; Output:
;       HL = product
; ============================================================

MUL8:

        LXI     H,0

        MOV     E,B
        MVI     D,0

        MVI     B,8

MUL_LOOP:

        MOV     A,C
        ANI     1
        JZ      MUL_NO_ADD

        DAD     D

MUL_NO_ADD:

; ------------------------------------------------------------
; DE <<= 1
;
; Clear carry before shifting E, then propagate E's high
; bit into D.
; ------------------------------------------------------------

        XRA     A

        MOV     A,E
        RAL
        MOV     E,A

        MOV     A,D
        RAL
        MOV     D,A


; ------------------------------------------------------------
; Examine the next multiplier bit.
;
; RRC is intentional: over eight iterations, each original
; bit of C reaches bit 0 exactly once.
; ------------------------------------------------------------

        MOV     A,C
        RRC
        MOV     C,A

        DCR     B
        JNZ     MUL_LOOP

        RET


; ============================================================
; SHR7
;
; Logical right shift HL by 7.
;
; Used only on positive squares.
; ============================================================

SHR7:

        MVI     B,7

SHR7_LOOP:

        XRA     A

        MOV     A,H
        RAR
        MOV     H,A

        MOV     A,L
        RAR
        MOV     L,A

        DCR     B
        JNZ     SHR7_LOOP

        RET


; ============================================================
; ASR6
;
; Arithmetic right shift signed HL by 6.
; ============================================================

ASR6:

        CALL    ASR1
        CALL    ASR1
        CALL    ASR1
        CALL    ASR1
        CALL    ASR1
        CALL    ASR1

        RET


; ============================================================
; ASR1
;
; Arithmetic right shift signed HL by one.
; ============================================================

ASR1:

        MOV     A,H
        ANI     080H
        JZ      ASR_POS

        STC
        JMP     ASR_DO

ASR_POS:

        XRA     A

ASR_DO:

        MOV     A,H
        RAR
        MOV     H,A

        MOV     A,L
        RAR
        MOV     L,A

        RET


; ============================================================
; ASCII density LUT
;
; 8 entries, from empty to dense.
; ============================================================

DENSITY:

        DB      ' .-=+*#@'


; ============================================================
; TEST ROUTINES
;
; These can be started using the monitor's G command.
;
; Results are stored at 3100H onwards.
; The parameter and working storage at 3000H-3022H are
; otherwise unchanged by the test wrappers, except that
; the point tests deliberately set CUR_X, CUR_Y and ITER_MAX.
; ============================================================

        ORG     02500H


; ------------------------------------------------------------
; TEST_MUL8_SMALL
;
; 13 * 17 = 221 = 00DDH
;
; Result: 3100H-3101H = DD 00
; THIS TEST HANGS ON MY MACHINE. But it does write the correct result to memory.
; and all the other tests work! And yes I checked, 120A is C9 which is RET.
; ------------------------------------------------------------

TEST_MUL8_SMALL:

        MVI     B,13
        MVI     C,17

        CALL    MUL8

        SHLD    03100H
        RET


; ------------------------------------------------------------
; TEST_MUL8_LARGE
;
; 255 * 255 = 65025 = FE01H
;
; Result: 3102H-3103H = 01 FE
; ------------------------------------------------------------

TEST_MUL8_LARGE:

        MVI     B,255
        MVI     C,255

        CALL    MUL8

        SHLD    03102H
        RET


; ------------------------------------------------------------
; TEST_SMUL_NEGPOS
;
; -3 * 5 = -15 = FFF1H
;
; Result: 3104H-3105H = F1 FF
; ------------------------------------------------------------

TEST_SMUL_NEGPOS:

        LXI     H,0FFFDH
        LXI     D,00005H

        CALL    SMUL

        SHLD    03104H
        RET


; ------------------------------------------------------------
; TEST_SMUL_NEGNEG
;
; -3 * -5 = 15 = 000FH
;
; Result: 3106H-3107H = 0F 00
; ------------------------------------------------------------

TEST_SMUL_NEGNEG:

        LXI     H,0FFFDH
        LXI     D,0FFFBH

        CALL    SMUL

        SHLD    03106H
        RET


; ------------------------------------------------------------
; TEST_SHR7
;
; 8000H >> 7 = 0100H
;
; Result: 3108H-3109H = 00 01
; ------------------------------------------------------------

TEST_SHR7:

        LXI     H,08000H

        CALL    SHR7

        SHLD    03108H
        RET


; ------------------------------------------------------------
; TEST_ASR6
;
; -128 >> 6 = -2 = FFFEH
;
; Result: 310AH-310BH = FE FF
; ------------------------------------------------------------

TEST_ASR6:

        LXI     H,0FF80H

        CALL    ASR6

        SHLD    0310AH
        RET


; ------------------------------------------------------------
; TEST_POINT_ZERO
;
; c = 0 + 0i
; Expected: 16 iterations
;
; Result: 310CH = 10
; ------------------------------------------------------------

TEST_POINT_ZERO:

        LXI     H,0
        SHLD    CUR_X
        SHLD    CUR_Y

        MVI     A,16
        STA     ITER_MAX

        CALL    MANDEL_POINT

        STA     0310CH
        RET


; ------------------------------------------------------------
; TEST_POINT_NEG1
;
; c = -1 + 0i
; Expected: 16 iterations
;
; Result: 310DH = 10
; ------------------------------------------------------------

TEST_POINT_NEG1:

        LXI     H,0FF80H
        SHLD    CUR_X

        LXI     H,0
        SHLD    CUR_Y

        MVI     A,16
        STA     ITER_MAX

        CALL    MANDEL_POINT

        STA     0310DH
        RET


; ------------------------------------------------------------
; TEST_POINT_POS1
;
; c = +1 + 0i
; Expected: 2 iterations
;
; Result: 310EH = 02
; ------------------------------------------------------------

TEST_POINT_POS1:

        LXI     H,00080H
        SHLD    CUR_X

        LXI     H,0
        SHLD    CUR_Y

        MVI     A,16
        STA     ITER_MAX

        CALL    MANDEL_POINT

        STA     0310EH
        RET


; ------------------------------------------------------------
; TEST_POINT_POS2
;
; c = +2 + 0i
; Expected: 1 iteration
;
; Result: 310FH = 01
; ------------------------------------------------------------

TEST_POINT_POS2:

        LXI     H,00100H
        SHLD    CUR_X

        LXI     H,0
        SHLD    CUR_Y

        MVI     A,16
        STA     ITER_MAX

        CALL    MANDEL_POINT

        STA     0310FH
        RET


; ------------------------------------------------------------
; TEST_POINT_NEG2
;
; c = -2 + 0i
; Expected: 1 iteration
;
; Result: 3110H = 01
;
; Specifically tests the -256 component boundary.
; ------------------------------------------------------------

TEST_POINT_NEG2:

        LXI     H,0FF00H
        SHLD    CUR_X

        LXI     H,0
        SHLD    CUR_Y

        MVI     A,16
        STA     ITER_MAX

        CALL    MANDEL_POINT

        STA     03110H
        RET


; ============================================================
; DEFAULT PARAMETERS
;
; 128 = 1.0
;
; CENTER_X = -0.5
; CENTER_Y =  0
;
; STEP_X = 4/128 = 0.03125
; STEP_Y = 10/128 = 0.078125
;
; ITER_MAX = 16
; ============================================================

        ORG     03000H

        DW      0FFC0H         ; CENTER_X = -64
        DW      00000H          ; CENTER_Y = 0
        DW      00004H          ; STEP_X = 4
        DW      0000AH          ; STEP_Y = 10
        DB      16              ; ITER_MAX

        END

If you have an MCS-80, you can just paste this into a terminal.

I1000
2A0230220930060B2A0930EB2A06307B$
I1010
955F7A9C57EB22093005C208102A0930$
I1020
220D303E17321D302A0030220B300628$
I1030
2A0B30EB2A04307B955F7A9C57EB220B$
I1040
3005C230103E4F321C30CD9B10FE0FDA$
I1050
57103E07C35B103C0FE6075F160021FD$
I1060
11194ECDFA032A0B30EB2A043019220B$
I1070
303A1C303D321C30C24A100E0DCDFA03$
I1080
0E0ACDFA032A0D30EB2A063019220D30$
I1090
3A1D303D321D30C22810C9210000220F$
I10A0
30221130AF321B302A0F302213302A11$
I10B0
302215302A13307CFE00CAC710FEFFC2$
I10C0
4E117DB7CA4E112A15307CFE00CADA10$
I10D0
FEFFC24E117DB7CA4E112A1330EB2A13$
I10E0
30CD52112217302A1530EB2A1530CD52$
I10F0
112219302A1730EB2A193019DA4E112A$
I1100
1730CDCA112217302A1930CDCA112219$
I1110
302A1930EB2A17307D936F7C9A67EB2A$
I1120
0B3019220F302A1330EB2A1530CD5211$
I1130
CDD811EB2A0D30192211303A1B303C32$
I1140
1B30473A0830B8C2A8103A1B30C93A1B$
I1150
30C9221F30EB222130AF321E302A1F30$
I1160
7CE680CA71113E01321E30CDA011221F$
I1170
302A21307CE680CA88113A1E30EE0132$
I1180
1E30CDA0112221302A1F30452A21304D$
I1190
CDAC113A1E30B7C87D2F6F7C2F6723C9$
I11A0
7CE680C87D2F6F7C2F6723C921000058$
I11B0
1600060879E601CABB1119AF7B175F7A$
I11C0
1757790F4F05C2B411C90607AF7C1F67$
I11D0
7D1F6F05C2CC11C9CDEB11CDEB11CDEB$
I11E0
11CDEB11CDEB11CDEB11C97CE680CAF5$
I11F0
1137C3F611AF7C1F677D1F6FC9202E2D$
I1200
3D2B2A2340$
I3000
C0FF000004000A0010$

