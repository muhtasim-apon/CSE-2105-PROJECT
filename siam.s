        AREA 	siam, CODE, READONLY
        EXPORT 	main

main
        LDR     R0, =0x11115555
        LDR     R1, =0x55555555     

        EOR     R2, R0, R1	; Toggle all even bits using XOR

STOP    B       STOP               

        END
