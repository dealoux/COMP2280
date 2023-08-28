; This example adds the contents of two registers and stores it
; into a third

        .orig   x3000
        
        and r3,r3,x0    ; clear r3
        and r1,r1,x0    ; clear r1
    add     r1,r1,x3    ; r1 is set to 3
        and r2,r2,x0    ; clear r2
        add r2,r2,xA    ; r2 is set to 10 (base 10)
    add r3,r1,r2    ; r3 <- r1 + r2
    
        halt
        .end