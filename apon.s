        AREA apon, CODE, READONLY
        EXPORT apon_main


apon_main
        PUSH    {LR}            ; Save LR before calling subroutine
        BL      booth_algo
        POP     {LR}           
        BX      LR		
		
booth_algo
		PUSH    {R4-R8, LR}
        
        ; Example: Multiply -8 × 5 = -40
        MOV     R1, #-8         ; Multiplicand (M)
        SXTH    R1, R1          ; Sign extend to 32-bit
        
        MOV     R2, #5          ; Multiplier (Q)
        UXTH    R2, R2          ; Keep only lower 16 bits
        
        BL      booth_multiply
        
        ; Result in R0 (32-bit signed result)
        
        POP     {R4-R8, LR}
        BX      LR

; Booth's Multiplication Algorithm
; Input:  R1 = Multiplicand (M) - 16-bit signed, sign-extended to 32-bit
;         R2 = Multiplier (Q) - 16-bit unsigned representation
; Output: R0 = Product (32-bit signed result)
booth_multiply
        PUSH    {R4-R8}
        
        ; Initialize registers
        MOV     R3, #0          ; A = Accumulator
        MOV     R4, R2          ; Q = Multiplier
        MOV     R5, R1          ; M = Multiplicand
        MOV     R6, #0          ; Q_minus1 bit
        MOV     R7, #16         ; Loop counter
        
booth_loop
        ; Extract Q0 (bit 0 of Q)
        AND     R8, R4, #1      ; Q0 = Q[0]
        
        ; Determine operation based on Q0 and Q_minus1
        CMP     R8, R6          ; Compare Q0 with Q_minus1
        BEQ     booth_shift     ; If equal (00 or 11), just shift
        
        ; Q0 != Q_minus1
        CMP     R8, #1
        BEQ     booth_add       ; Q0=1, Q_minus1=0 (case 01)
        
        ; Otherwise Q0=0, Q_minus1=1 (case 10)
        SUB     R3, R3, R5      ; A = A - M
        B       booth_shift
        
booth_add
        ADD     R3, R3, R5      ; A = A + M
        
booth_shift
        ; Save current Q0 as next Q_minus1
        MOV     R6, R8
        
        ; Save LSB of A before shifting
        AND     R8, R3, #1      ; Save A[0]
        
        ; Arithmetic shift A right by 1 (preserves sign)
        ASR     R3, R3, #1
        
        ; Logical shift Q right by 1
        LSR     R4, R4, #1
        
        ; Move saved A[0] to MSB of Q (bit 15)
        CMP     R8, #1
        ORREQ   R4, R4, #0x8000 ; Set bit 15 if A[0] was 1
        
        ; Decrement counter and loop
        SUBS    R7, R7, #1
        BNE     booth_loop
        
        ; Combine final result
        LSL     R0, R3, #16     ; Upper 16 bits from A
        UXTH    R4, R4          ; Lower 16 bits from Q - OPTIMAL FIX
        ORR     R0, R0, R4      ; Combine
        
        POP     {R4-R8}
        BX      LR
        
        END
