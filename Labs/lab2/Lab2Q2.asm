;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DentStewLab2Q2.asm
;
; Course:     COMP 2280
; Instructor: Randy Cooper
; Lab:        2 Question 2
; Author:     Stew Dent
; Version:    2015/05/05
;
; Purpose:    Read in a series of characters until EOT is entered. Echo each
;             character that is not EOT and display a message indicating 
;             if the character ends in 111 or 11.
;
; Register Dictionary:
; --------------------
; R0 - input/output
; R1 - result of selecting low order bits
; R2 - result of comparison
;
; Static Variables:
; -----------------
; prompt - the prompt asking for input
; Three1Msg - message for character ending in 111
; Two1Msg - message for character ending in 11
; eopMsg - the termination message

           .orig   x3000         ; location of program in memory
loop
           lea     r0,prompt     ; display the prompt
           puts
           getc                  ; get a character from the user
           add     r1,r0,#-4     ; EOT?
           brz     done
           out                   ; echo the char
			
           and     r1,r0,#7      ; isolate low order 3 bits	
           add     r2,r1,#-7     ; character end with 111?
           brnp    next          ; no, -> try 11
           lea     r0,Three1Msg  ; yes -> display 111 message
           puts
           br      continue
next
           and     r1,r0,#3      ; isolate low order 2 bits
		   add     r2,r1,#-3     ; character end with 11?
           brnp    continue      ; no, -> done
           lea     r0,Two1Msg    ; yes -> display 11 message
           puts
continue
           br      loop
done	
           lea     r0,eopMsg     ; display the end of processing message
           puts
           halt
prompt     .stringz "\nEnter any character: "
Two1Msg    .stringz "\nThe character ends with 11."
Three1Msg  .stringz "\nThe character ends with 111."
eopMsg     .stringz "\n\nProgrammed by Stew Dent.\nEnd of processing.\n"
           .end
