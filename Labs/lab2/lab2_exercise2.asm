; Course:      COMP 2280 
; Instructor:  Ben Li 
; Lab: 2 Question 2 
; Author:      Tom Le 
; reg: R0, R1, R2
; static var prompt msg, threemsg, twomsg and namemsg
; if//else: mainline/loop, next, continue, done

.orig x3000

loop
    lea r0, prompt
    puts 
    getc
    add r2, r0, #-4 ; check for EoT
    brz done
    out
    
    add r1, r0, #0 ; store r0 to r1 in case character ends with 11
    and r0, r0, #7
    add r0, r0, #-7
    
    brnp next
    
    lea r0, threemsg
    puts
    br continue
    
next
    and r1, r1, #3
    add r1, r1, #-3
    
    brnp continue
    
    lea r0, twomsg
    puts

continue
    br loop

done
    lea r0, namemsg
    puts
    halt

prompt .stringz "\nEnter any character"
threemsg .stringz "\nThe character ends with 111"
twomsg .stringz "\nThe character ends with 11"
namemsg .stringz "\nProgrammed by Tom Le\nEnd of processing.\n"

.end