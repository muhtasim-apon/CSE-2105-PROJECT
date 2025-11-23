        AREA apon, CODE, READONLY
<<<<<<< HEAD
        EXPORT apon_main

apon_main
        MOV     R1, #5
        MOV     R2, #1
        LSL     R3, R1, R2       ; R3 = R1 << R2 (5 << 1 = 10)

        LDR     R0, =0x20000000
        STR     R3, [R0]

        BX      LR
=======
        ENTRY
        EXPORT main

main
        ; Load a number into R1 (example: 0x5)
        MOV    R1, #5

        ; Load shift amount into R2 (example: shift left by 1)
        MOV   R2, #1

        ; Perform LSL: R3 = R1 << R2
        LSL    R3, R1, R2

        ; Store the result at memory address 0x20000000
        LDR     R0, =0x20000000
        STR     R3, [R0]

stop
        B       stop
>>>>>>> 5fc1055288f07277b7f44076bc16c77a7ea20ff2

        END
