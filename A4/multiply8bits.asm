; multiply
;   Given two 16-bit 2's complement numbers use booth's algorithm to compute
;   the 16-bit 2's complement product. Return the product.
;
; Register Dictionary
; -------------------
; R0 - the product of operand1 and operand2
; R1 - operand1
; R2 - operand2
; R3 - previous bit in operand 1
; R4 - mask to isolate current bit in operand2 
; R5 - the frame pointer
; R6 - the stack pointer
; R7 - the return address, current bit in operand 1, -operand 2
;
; Activation Record
; -----------------
; R5 - 2 : current bit value of multiplier
; R5 + 0 : return value (product of operand1 and operand2)
; R5 + 1 : operand2
; R5 + 2 : operand1

multiply
           add     r6,r6,#-1     ; establish the frame pointer
           str     r5,r6,#0      ; r5
           add     r5,r6,#1
           add     r6,r6,#-1     ; space for local variable: current
           add     r6,r6,#-1     ; save caller's registers
           str     r0,r6,#0      ; r0
           add     r6,r6,#-1
           str     r1,r6,#0      ; r1
           add     r6,r6,#-1
           str     r2,r6,#0      ; r2
           add     r6,r6,#-1
           str     r3,r6,#0      ; r3
           add     r6,r6,#-1
           str     r4,r6,#0      ; r4
           add     r6,r6,#-1
           str     r7,r6,#0      ; r7
           
           and     r0,r0,#0      ; product <- 0
           ldr     r1,r5,#1      ; operand 1
           ldr     r2,r5,#2      ; operand 2
           and     r3,r3,#0      ; previous bit <- 0
           and     r4,r4,#0      ; mask <- 1
           add     r4,r4,#1
multLoop
           brz     multExit      ; zero mask -> all bits processed
           and     r7,r1,r4      ; current bit
           str     r7,r5,#-2     ; save local variable
           add     r7,r7,#0      ; test r7 to set condition code bits
           brz     multCur0      ; current bit == 0?
           add     r3,r3,#0      ; no, current bit == 1, test previous bit
           brnp    multNext      ; both bits == 1 -> nothing to do
           add     r7,r2,#0      ; current == 1 and previous == 0
           not     r7,r7         ; compute -operand 2
           add     r7,r7,#1
           add     r0,r0,r7      ; product += -operand 2
           br      multNext
multCur0
           add     r3,r3,#0      ; current bit == 0, test previous bit
           brz     multNext      ; both bits == 0 -> nothing to do
           add     r0,r0,r2      ; product += operand 2
multNext
           ldr     r3,r5,#-2     ; previous <- current
           add     r2,r2,r2      ; shift operand 2 left 1 bit position
           add     r4,r4,r4      ; shift mask left 1 bit position
           br      multLoop
multExit
           str     r0,r5,#0      ; return the product
           ldr     r7,r6,#0      ; restore the caller's registers, r7
           add     r6,r6,#1
           ldr     r4,r6,#0      ; r4
           add     r6,r6,#1
           ldr     r3,r6,#0      ; r3
           add     r6,r6,#1
           ldr     r2,r6,#0      ; r2
           add     r6,r6,#1
           ldr     r1,r6,#0      ; r1
           add     r6,r6,#1
           ldr     r0,r6,#0      ; r0
           add     r6,r6,#1
           add     r6,r6,#1      ; free space for local variable
           ldr     r5,r6,#0      ; r5
           add     r6,r6,#1
           ret
           .end
