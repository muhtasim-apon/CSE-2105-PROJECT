        AREA partho, CODE, READONLY
        EXPORT partho_main

partho_main
        BL      Add_16bit_Function
		BL		Rotation
        BX      LR

Add_16bit_Function
        MOVW    R1, #0x0001
        MOVT    R1, #0x0000

        MOVW    R2, #0xFFFF
        MOVT    R2, #0x0000
		
        ADD     R0, R1, R2       ; 1 + 65535 = 65536
        MOVT    R0, #0x0000
        BX      LR

Rotation
		LDR     R0, =0x1234      ; 16-bit value
        MOV     R1, #5           ; rotate amount n = 4
        UXTH    R0, R0           ; R0 = R0 & 0xFFFF
        ; Compute (16 - n)
        MOV     R2, #16
        SUB     R3, R2, R1       ; R3 = 16 - n
        LSR     R4, R0, R1
        LSL     R5, R0, R3
        ORR     R6, R4, R5
        ; Mask to 16 bits
        UXTH    R6, R6           ; R6 = final 16-bit rotate
		BX		LR

        END
