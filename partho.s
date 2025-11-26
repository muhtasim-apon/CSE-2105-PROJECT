 		AREA partho, CODE, READONLY
        EXPORT partho_main

partho_main
        BL      Add_16bit_Function
		BL		Rotation
		BL		check
        BX      LR

Add_16bit_Function
        MOVW    R1, #0x9000
        MOVT    R1, #0x0000      ; Operand1

        MOVW    R2, #0x9000
        MOVT    R2, #0x0000      ; Operand2

        ; ------------------------------
        ; 16-bit Addition
        ; ------------------------------
        ADD     R0, R1, R2       ; Full 32-bit sum

        ; ------------------------------
        ; Carry (unsigned) -> R3
        ; ------------------------------
        MOV     R3, #0x10000
        AND     R3, R0, R3       ; isolate bit 16
        LSR     R3, R3, #16      ; carry = 0 or 1

        ; ------------------------------
        ; Mask R0 to 16-bit
        ; ------------------------------
        ;AND     R0, R0, #0xFFFF  ; lower 16-bit sum
		MOVT 	R0, #0x0000

        ; ------------------------------
        ; Overflow (signed) -> R4
        ; Formula: (~(A ^ B) & (A ^ Sum)) >> 15
        ; ------------------------------
        UXTH    R1, R1            ; ensure 16-bit
        UXTH    R2, R2
        EOR     R5, R1, R2        ; A ^ B
        MVN     R5, R5            ; ~(A ^ B)
        EOR     R6, R1, R0        ; A ^ Sum
        AND     R4, R5, R6        ; ~(A^B) & (A^Sum)
        LSR     R4, R4, #15       ; overflow = 0 or 1

        BX      LR

; ---------------------------------------------------------
; Rotation with safe limiting of rotate amount (0–15)
; ---------------------------------------------------------
Rotation
        LDR     R0, =0x1234      ; 16-bit value
        MOV     R1, #5           ; rotate amount

        UXTH    R0, R0           ; keep 16-bit only

        ; ---- Error Handling: Force R1 inside 0–15 range ----
        AND     R1, R1, #0x0F    ; (mod 16) ? prevents invalid shift faults

        MOV     R2, #16
        SUB     R3, R2, R1       ; (16-n)

        LSR     R4, R0, R1
        LSL     R5, R0, R3
        ORR     R6, R4, R5

        UXTH    R6, R6           ; final 16-bit masked output

        BX      LR


; ---------------------------------------------------------
; Bit-check with safe masking
; ---------------------------------------------------------
check
        LDR     R0, =0x1234      ; 16-bit value
        MOV     R1, #5           ; bit index

        UXTH    R0, R0           ; preserve lower 16 bits

        ; ---- Error Handling: Limit bit index to 0–15 ----
        AND     R1, R1, #0x0F    ; prevents invalid shift exception

        LSR     R0, R0, R1       ; shift safely
        AND     R0, R0, #1       ; get selected bit

        END
