        AREA partho, CODE, READONLY
        EXPORT partho_main

partho_main
        PUSH    {LR}            ; Save LR before calling subroutine
        BL      Add_16bit_Function
        POP     {LR}            ; Restore LR before returning
        BX      LR

Add_16bit_Function
        MOVW    R1, #0x0001
        MOVT    R1, #0x0000

        MOVW    R2, #0xFFFF
        MOVT    R2, #0x0000

        ADD     R0, R1, R2       ; 1 + 65535 = 65536
        MOVT    R0, #0x0000

        BX      LR

        END
