; purpose: compute the sum of pos and neg in
; input: array in memory
; output: conts stored in memory

; r0 = work register
; r1 = pointer in ther array
; r2 = element in the array
; r3 = pos sum
; r5 = neg sum
; r4 = count array n.

.orig x3000

loop
    ldr r2, r1, 0 ; r2 and r1

pos
    add

neg
    add

    br endcase

endcase
    add
    add
    brp
    
    puts
    halt

array
    .fill 3
    .fill -10
    .fill 0
    .fill 6
    .fill -6
    .fill 3
    .fill 4
    .fill 0
    .fill 5
    .fill -9
    
sumPOS .fill 0 ; total positive numbers sum
    
sumNEG .fill 0 ; total negative numbers sum
    
n .fill 10 ; length of the array
    
msg .stringz "\nEmd of processing\n"

.end