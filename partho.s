		AREA    partho, CODE, READONLY
        EXPORT  main
        ENTRY
        
main
		BL		Add_16bit_Function
		B		Stop
		
Add_16bit_Function
        
        MOVW    R1, #0x0001      
        MOVT    R1, #0x0000       
        
        MOVW    R2, #0xFFFF       
        MOVT    R2, #0x0000       

        ADD     R0, R1, R2        
        MOVT	R0, #0x0000
        
        
        BX      LR               
        
Stop
		B		Stop