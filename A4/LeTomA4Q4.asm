; LeTomA4Q4.asm
;
; Course: COMP 2280
; Instructor: Jonathan Boisvert
; Assignement: 4 Question 4
; Author: Tom Le
; Version: 2022/08/05
;
; Purpose:    Evaluate an expression tree.
;
; Register Dictionary
; -------------------
; R0 - work
; R6 - stack pointer
;
; Static Variables
; ----------------
; stackbase - the initial address of the stack
; result - the value of the expression tree
; root - the first node in the expression tree
; eop - the end of process message

            .orig  x3000
Mainline
			
            ld     r6,stackbase
            lea    r0,root
            add    r6,r6,#-1
            str    r0,r6,#0      ; address of expression tree
            add    r6,r6,-1      ; space for return value
            jsr    evaluate      ; evaluate the expression tree
            ldr    r0,r6,#0      ; get the result
            add    r6,r6,#2      ; clean up the stack
            st     r0,result     ; save the result
            lea    r0,eop        ; display eop message
            puts
			
            halt
stackbase   .fill  xFD00
result      .blkw  1
root        .fill 0 ; *
            .fill op1
            .fill op3
op1         .fill 1 ; +
            .fill L1
            .fill op2
L1          .fill 20 ; operand
            .fill 0
            .fill 0
op2         .fill 0 ; *
            .fill L2
            .fill L3
L2          .fill 3 ; operand
            .fill 0
            .fill 0
L3          .fill -4 ; operand
            .fill 0
            .fill 0
op3         .fill -1 ; -
            .fill op4
            .fill L4
L4          .fill 5 ; operand
            .fill 0
            .fill 0
op4         .fill 1 ; +
            .fill L5
            .fill L6
L5          .fill 4 ; operand
            .fill 0
            .fill 0
L6          .fill 3 ; operand
            .fill 0
            .fill 0
eop         .stringz  "\nProgrammed by Tom Le.\nEnd of processing."

; ----------------------- evaluate -----------------------

; Given a pointer to an expression tree return the value of the tree

; Register Dictionary
; -------------------
; r0 - address of the expression tree / current node
; r1 - address of subtree
; r2 - value of left subtree
; r3 - value of right subtree
; r4 - value of the expression tree
; r5 - frame pointer
; r6 - stack pointer
; r7 - operator code

; Activation Record
; -----------------
; r5 + 0 : return value (value of expression tree)
; r5 + 1 : address of the expression tree

; Static Variables
; ----------------
; Everror - value to return for an empty expression tree

evaluate
            add    r6,r6,#-1
            str    r5,r6,#0
            add    r5,r6,#1      ; establish the frame pointer

            add    r6,r6,#-1     ; save caller's registers
            str    r0,r6,#0      ; r0
            add    r6,r6,#-1
            str    r1,r6,#0      ; r1
            add    r6,r6,#-1
            str    r2,r6,#0      ; r2
            add    r6,r6,#-1
            str    r3,r6,#0      ; r3
            add    r6,r6,#-1
            str    r4,r6,#0      ; r4
            add    r6,r6,#-1
            str    r7,r6,#0      ; r7

            ldr    r0,r5,1       ; address of the expression tree
            brnp   EVnext        ; tree not empty => process it
            and    r4,r4,#0      ; return zero for an empty tree
            br     EVexit
EVnext
            ldr    r1,r0,#1      ; address of left subtree
            brnp   EVoperator    ; not null => process left subtree
            ldr    r4,r0,#0      ; operand node, get its value
            br     EVexit
EVoperator
            add    r6,r6,#-1
            str    r1,r6,#0      ; push  address of left subtree
            add    r6,r6,#-1     ; space for return value
            jsr    evaluate      ; evaluate the left subtree
            ldr    r2,r6,#0	 ; value of left subtree
            add    r6,r6,#2	 ; clean up the stack

            ldr    r1,r0,#2      ; address of right subtree
            add    r6,r6,#-1
            str    r1,r6,#0      ; push  address of right subtree
            add    r6,r6,#-1     ; space for return value
            jsr    evaluate      ; evaluate the right subtree
            ldr    r3,r6,#0      ; value of right subtree
            add    r6,r6,#2      ; clean up the stack

            ldr    r7,r0,#0      ; get the operator code
            brp    EVadd         ; +ve => add operands
            brn    EVsubtract    ; -ve => subtract right from left

            ; multiply operands => call multiply8bits
            add    r6,r6,#-1
            str    r2,r6,#0      ; value of left subtree
            add    r6,r6,#-1
            str    r3,r6,#0      ; value of right subtree
            add    r6,r6,#-1     ; space for return value
            jsr    multiply8bits ; multiply the values
            ldr    r4,r6,#0      ; get the product
            add    r6,r6,#3      ; clean up the stack
            br     EVexit
EVadd
            add    r4,r2,r3      ; add values of right and left subtrees
            br     EVexit
EVsubtract
            not    r3,r3
            add    r3,r3,#1      ; negate value of right subtree
            add    r4,r2,r3      ; subtract value of right subtree from left
EVexit
            str    r4,r5,#0      ; save value to return
            ldr    r7,r6,#0      ; restore caller's registers (r7)
            add    r6,r6,#1
            ldr    r4,r6,#0      ; r4
            add    r6,r6,#1
            ldr    r3,r6,#0      ; r3
            add    r6,r6,#1
            ldr    r2,r6,#0      ; r2
            add    r6,r6,#1
            ldr    r1,r6,#0      ; r1
            add    r6,r6,#1
            ldr    r0,r6,#0      ; r0
            add    r6,r6,#1
            ldr    r5,r6,#0      ; r5
            add    r6,r6,#1
            ret

; multiply8bits
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

multiply8bits
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