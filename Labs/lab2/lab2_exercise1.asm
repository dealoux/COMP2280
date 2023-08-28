; Course:      COMP 2280 
; Instructor:  Ben Li 
; Lab: 2 Question 1 
; Author:      Tom Le 
; reg: R0, R1
; static var prompt, threemsg, twomsg and namemsg
; if//else: next, done, mainline

.orig x3000

mainline
    lea r0, prompt
    puts
    getc
    out
    
    add r1, r0, #0 ; store r0 to r1 in case character ends with 11
    and r0, r0, #7
    add r0, r0, #-7
    brnp next
    
    lea r0, threemsg
    puts
    
    br done

next
    and r1, r1, #3
    add r1, r1, #-3
    
    brnp done
    
    lea r0, twomsg
    puts
    br done

done
    lea r0, namemsg
    puts
    halt

prompt .stringz "\nEnter any character: "
threemsg .stringz "\nThe character ends with 111"
twomsg .stringz "\nThe character ends with 11"
namemsg .stringz "\nProgrammed by Tom Le\nEnd of processing.\n"

.end