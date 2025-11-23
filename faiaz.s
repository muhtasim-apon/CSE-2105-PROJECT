        AREA faiaz, CODE, READONLY
        EXPORT faiaz_main

faiaz_main
        MOV     r0, #4
        MOV     r1, #5
        ADD     r2, r0, r1
        BX      LR

        END
