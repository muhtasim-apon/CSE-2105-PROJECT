        AREA apon, CODE, READONLY
        EXPORT apon_main

apon_main
        MOV     R1, #5
        MOV     R2, #1
        LSL     R3, R1, R2       ; R3 = R1 << R2 (5 << 1 = 10)

        LDR     R0, =0x20000000
        STR     R3, [R0]

        BX      LR

        END
