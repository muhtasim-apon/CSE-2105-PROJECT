        AREA apon, CODE, READONLY
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

        END
