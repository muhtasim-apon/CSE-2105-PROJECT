        AREA    faiaz, CODE, READONLY
        EXPORT  faiaz_main

faiaz_main
        BL      revs16     
        BL      sat16     
        BL      bfc16     
        BL      bfi16     
        BX      LR


revs16
        LDR     R0, =0x1234        ; input
        MOV     R1, #0             ; output
        MOV     R2, #16            
rev_loop
        LSL     R1, R1, #1         
        TST     R0, #1             
        ORRNE   R1, R1, #1         
        LSR     R0, R0, #1         
        SUBS    R2, R2, #1         
        BNE     rev_loop
        MOV     R0, R1            
        BX      LR

sat16
        LDR     R0, =0x9000      ; input/output
        MOV     R1, #0x7FFF      ; max
        LDR     R2, =0xFFFF8000  ; min
        CMP     R0, R1
        MOVGT   R0, R1
        MOV     R3, #1
        ANDGT   R3, R3, #1       ;sat flag if higher
        CMP     R0, R2
        MOVLT   R0, R2
        MOV     R3, #1
        ANDLT   R3, R3, #1       ;sat flag if lower
        BX      LR

bfc16
        LDR     R0, =0xFFFF        ; input/output
        MOV     R1, #4             ; lsb
        MOV     R2, #3             ; width
        MOV     R3, #1
        LSL     R3, R3, R2         ; 1 << width
        SUB     R3, R3, #1         ; mask = (1<<width)-1
        LSL     R3, R3, R1        
        LDR     R12, =0xFFFF  
		EOR     R3, R3, R12    ; invert
             ; invert
        AND     R0, R0, R3         
        UXTH    R0, R0             ; keep 16 bits
        BX      LR
		
bfi16
        LDR     R0, =0xABCD      ; Rd = destination
        MOV     R1, #0xFEA        ; Rn = source
        MOV     R2, #4           ; lsb
        MOV     R3, #8           ; width

        MOV     R4, #1
        LSL     R4, R4, R3       ; 1 << width
        SUB     R4, R4, #1       ; width mask
        LSL     R4, R4, R2       ; shift mask 
        ; clear target bits in Rd
		LDR     R12, =0xFFFF  
		EOR     R5, R4, R12    ; invert
        AND     R0, R0, R5     ; Rd cleared
        ; mask source lower bits
        MOV     R6, R4
        LSR     R6, R6, R2       
        AND     R1, R1, R6       
        LSL     R1, R1, R2       

        ORR     R0, R0, R1       ; output
        BX      LR




        END
