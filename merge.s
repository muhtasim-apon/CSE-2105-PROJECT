        AREA merged_code, CODE, READONLY
        ENTRY
        EXPORT main

        IMPORT faiaz_main
        IMPORT apon_main
        IMPORT partho_main
        IMPORT siam_main

main
        BL      faiaz_main
        BL      apon_main
		BL      siam_main
        BL      partho_main
        

stop
        B       stop

        END
