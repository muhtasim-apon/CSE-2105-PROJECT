        AREA  	myCode, CODE, READONLY
        EXPORT 	main
		IMPORT	udiv16_nonrestoring

main
        LDR     R0, =17
        LDR     R1, =3
        BL      udiv16_nonrestoring

stop
        B       stop