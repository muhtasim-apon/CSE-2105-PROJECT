    AREA    faiaz, CODE, READONLY
    ENTRY
    EXPORT main

main
    MOV     r0, #4
    MOV     r1, #5
    ADD     r2, r0, r1

stop
    B       stop
    END
