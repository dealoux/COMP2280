; LeTomA1Q9.asm
;
; Course: COMP 2280
; Instructor: Jonathan Boisvert
; Assignement: 1 Question 9
; Author: Tom Le
; Version: 2022/06/01
;
; Purpose: implements the following statement: result = num1 + num2 - 2 * num3;
;
; Register Dictionary:
; --------------------
; R0 - current result of the calculation
; R1 - next number to be added to the calculation

;
; Static Variables:
; -----------------
; result - store the the result of num1 + num2 - 2 * num3;
; strEOP - a termination message to display

.orig x3000
    ; calculates 2 * num3 = num3 + num3
    lea R0, num3
    add R0, R0, R0 
    
    ; calculates 2's complement -num3
    not R0, R0
    add R0, R0, #1
    
    ; calculates num2 - num3
    lea R1, num2
    add R0, R0, R1
    
    ; calculates num1 + num2 - 2 * num3
    lea R1, num1
    add R0, R0, R1
    
    ST R0, result ; stores the result
    
    ; displays the EOP message
    lea R0, strEOP
    puts
    halt

result .blkw 1
num1 .fill x00AA
num2 .fill xFFFF
num3 .fill x0055
strEOP	.stringz "\nProgrammed by Tom Le\nEnd of Processing."

.end