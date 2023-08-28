; LeTomA2Q5a.asm
;
; Course: COMP 2280
; Instructor: Jonathan Boisvert
; Assignement: 2 Question 5a
; Author: Tom Le
; Version: 2022/06/15
;
; Purpose: prompts the user for a character input and checks for the least 3 significant bits of that character
;
; Register Dictionary:
; --------------------
; r0 - store the string messages/user input
; r1 - store the last 3 significant bit of the user input
; r2 - store the result when comparing the last 3 significant bit with 110 (#6)
; r3 - store the result when comparing the last 2 significant bit with 01 (#2)

;
; Static Variables:
; -----------------
; strPrompt - a message for prompting the user for an input
; strPrint2 - a message indicates that the character ends with 01
; strPrint3 - a message indicates that the character ends with 110
; strEOP - a termination message to display

    .orig x3000
main
    ; displays the prompt
    lea r0, strPrompt
    puts
    getc
    out
    
    and r1, r0, #7 ; stores the last 3 bit

three    
    ; checks if the character ends with 110 (#6)
    add r2, r1, #-6
    brnp two ; if no, checks if it ends with 01
    lea r0, strPrint3 ; if yes displays the appropriate message and call done
    puts
    br done
    
two
    ; checks if the character ends with 01 (#2)
    and r3, r1, #-2
    brnp done ; if no, displays nothing and skips to done
    lea r0, strPrint2 ; if yes, displays the appropriate message
    puts

done
    ; displays the EOP message
    lea r0, strEOP
    puts
    halt

strPrompt	.stringz "\nEnter any character: "
strPrint2	.stringz "\nThe character ends with 01.\n"
strPrint3	.stringz "\nThe character ends with 110.\n"
strEOP	.stringz "\nProgrammed by Tom Le.\nEnd of Processing."

.end