        AREA apon, CODE, READONLY
        EXPORT apon_main                     ; ? Changed: Keil expects "main"

; ============================================================================
; DATA SECTION - Single 16-bit number only
; ============================================================================
        AREA mydata, DATA, READWRITE
        
        ALIGN 2                         ; Align to 2-byte boundary
data_buffer
        DCW     0x1234                  ; ? ONLY ONE 16-bit number
                                        ; This is the number we'll checksum
buffer_size
        DCD     2                       ; ? Size = 2 bytes (one 16-bit word)
stored_checksum
        DCW     0                       ; Storage for calculated checksum

; ============================================================================
; ?? CRITICAL: SWITCH BACK TO CODE SECTION!
; ============================================================================
        AREA apon, CODE, READONLY       ; ? MUST ADD THIS LINE!

; ============================================================================
; MAIN FUNCTION
; ============================================================================
apon_main                                    ; ? Changed from apon_main
        PUSH    {LR}
        BL      booth_algo              ; First: Booth's multiplication
        BL      xor16_demo              ; Second: Checksum demo
        POP     {LR}
        BX      LR

; ============================================================================
; BOOTH'S MULTIPLICATION ALGORITHM
; ============================================================================
booth_algo
        PUSH    {R4-R8, LR}
        
        ; Example: Multiply -8 × 5 = -40
        MOV     R1, #-8                 ; Multiplicand (M)
        SXTH    R1, R1                  ; Sign extend to 32-bit
        
        MOV     R2, #5                  ; Multiplier (Q)
        UXTH    R2, R2                  ; Keep only lower 16 bits
        
        BL      booth_multiply
        ; Result in R0 (32-bit signed result)
        
        POP     {R4-R8, LR}
        BX      LR

booth_multiply
        PUSH    {R4-R8}
        
        ; Initialize registers
        MOV     R3, #0                  ; A = Accumulator
        MOV     R4, R2                  ; Q = Multiplier
        MOV     R5, R1                  ; M = Multiplicand
        MOV     R6, #0                  ; Q_minus1 bit
        MOV     R7, #16                 ; Loop counter
        
booth_loop
        ; Extract Q0 (bit 0 of Q)
        AND     R8, R4, #1              ; Q0 = Q[0]
        
        ; Determine operation based on Q0 and Q_minus1
        CMP     R8, R6                  ; Compare Q0 with Q_minus1
        BEQ     booth_shift             ; If equal (00 or 11), just shift
        
        ; Q0 != Q_minus1
        CMP     R8, #1
        BEQ     booth_add               ; Q0=1, Q_minus1=0 (case 01)
        
        ; Otherwise Q0=0, Q_minus1=1 (case 10)
        SUB     R3, R3, R5              ; A = A - M
        B       booth_shift
        
booth_add
        ADD     R3, R3, R5              ; A = A + M
        
booth_shift
        ; Save current Q0 as next Q_minus1
        MOV     R6, R8
        
        ; Save LSB of A before shifting
        AND     R8, R3, #1              ; Save A[0]
        
        ; Arithmetic shift A right by 1 (preserves sign)
        ASR     R3, R3, #1
        
        ; Logical shift Q right by 1
        LSR     R4, R4, #1
        
        ; Move saved A[0] to MSB of Q (bit 15)
        CMP     R8, #1
        ORREQ   R4, R4, #0x8000         ; Set bit 15 if A[0] was 1
        
        ; Decrement counter and loop
        SUBS    R7, R7, #1
        BNE     booth_loop
        
        ; Combine final result
        LSL     R0, R3, #16             ; Upper 16 bits from A
        UXTH    R4, R4                  ; Lower 16 bits from Q
        ORR     R0, R0, R4              ; Combine
        
        POP     {R4-R8}
        BX      LR

; ============================================================================
; 16-BIT XOR CHECKSUM DEMO - For ONE number only
; ============================================================================
xor16_demo
        PUSH    {R4-R7, LR}
        
        ; STEP 1: Calculate 16-bit checksum for ONE number
        LDR     R0, =data_buffer        ; Address of our single number
        LDR     R1, =buffer_size        ; Address of size variable
        LDR     R1, [R1]                ; R1 = 2 (size in bytes)
        
        BL      calculate_xor16_checksum ; Calculate checksum
                                        ; For one 16-bit number: checksum = number itself
        
        ; STEP 2: Store the calculated checksum
        LDR     R4, =stored_checksum    ; Storage address
        STRH    R0, [R4]                ; Store 16-bit checksum
        MOV     R5, R0                  ; Save for verification
        
        ; STEP 3: Verify data integrity
        LDR     R0, =data_buffer        ; Reload buffer address
        LDR     R1, =buffer_size
        LDR     R1, [R1]                ; R1 = 2
        MOV     R2, R5                  ; Expected checksum
        
        BL      verify_xor16_checksum   ; Verify
                                        ; Returns 0 if valid, 1 if corrupted
        
        POP     {R4-R7, LR}
        BX      LR

; ============================================================================
; Function: calculate_xor16_checksum
; Purpose: Calculate 16-bit XOR checksum
; For ONE 16-bit number: Result = 0x0000 XOR number = number
; Input:  R0 = pointer to data buffer
;         R1 = length in bytes (2 for one 16-bit number)
; Output: R0 = 16-bit checksum
; ============================================================================
calculate_xor16_checksum
        PUSH    {R4-R6, LR}
        
        MOVS    R2, #0                  ; Initialize checksum = 0
        MOVS    R3, #0                  ; Temporary word storage
        
        ; Check if we have at least 2 bytes
        CMP     R1, #2                  ; Do we have 2 bytes?
        BLT     xor16_check_odd         ; If less, check for odd byte

xor16_loop
        ; Process 16-bit word
        CMP     R1, #2                  ; Still have 2+ bytes?
        BLT     xor16_check_odd
        
        LDRH    R3, [R0], #2            ; Load the 16-bit number
                                        ; Example: if data is 0x1234
                                        ; R3 = 0x1234
        
        EOR     R2, R2, R3              ; XOR operation
                                        ; checksum = 0x0000 XOR 0x1234 = 0x1234
                                        ; For ONE number, checksum = the number itself!
        
        SUBS    R1, R1, #2              ; Decrement count by 2
        B       xor16_loop

xor16_check_odd
        ; Handle odd byte (won't execute for single 16-bit number)
        CMP     R1, #1
        BNE     xor16_done
        
        LDRB    R3, [R0]
        LSL     R3, R3, #8
        EOR     R2, R2, R3

xor16_done
        UXTH    R0, R2                  ; Extract 16-bit result
        POP     {R4-R6, LR}
        BX      LR

; ============================================================================
; Function: verify_xor16_checksum
; Purpose: Verify data integrity
; Input:  R0 = pointer to data
;         R1 = length in bytes
;         R2 = expected checksum
; Output: R0 = 0 if valid, 1 if corrupted
; ============================================================================
verify_xor16_checksum
        PUSH    {R4-R5, LR}
        
        MOV     R5, R2                  ; Save expected checksum
        BL      calculate_xor16_checksum ; Recalculate
        
        CMP     R0, R5                  ; Compare
        ITE     EQ
        MOVEQ   R0, #0                  ; Valid
        MOVNE   R0, #1                  ; Corrupted
        
        POP     {R4-R5, LR}
        BX      LR

        END
