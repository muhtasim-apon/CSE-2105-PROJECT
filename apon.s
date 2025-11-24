        AREA apon, CODE, READONLY
        EXPORT apon_main


apon_main
        PUSH    {LR}            ; Save LR before calling subroutine
        BL      lsl_operation
        POP     {LR}            ; Restore LR before returning
        BX      LR		
lsl_operation
        ; Load a number into R1 (example: 0x5)
        MOV    R1, #5

        ; Load shift amount into R2 (example: shift left by 1)
        MOV   R2, #1

        ; Perform LSL: R3 = R1 << R2
        LSL    R3, R1, R2

        ; Store the result at memory address 0x20000000
        LDR     R0, =0x20000000
        STR     R3, [R0]
		BX		LR
        END
