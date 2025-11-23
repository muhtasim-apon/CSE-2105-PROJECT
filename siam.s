        AREA siam, CODE, READONLY
        EXPORT siam_main

siam_main
        LDR     R0, =0x11115555
        LDR     R1, =0x55555555
        EOR     R2, R0, R1
        BX      LR

        END
