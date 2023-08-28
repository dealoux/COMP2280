;COMP 2280 2022
;Sample Solution for programming question on Assignment 2
;Given a 8 bit ASCII value (which will be in low 8 bits of R0), compute the # of times the pattern 10 occurs.
;Idea: Start at bit 0, and scan from right to left.  
;      At the current bit, if it is a one and the previous bit is a zero, increment count.
;      We can keep the previous bit's value in a register.
;      We'll use bit-masking to determine the value of a bit.

;Register Dictionary
;R0 - input
;R1 - loop counter (inner)
;R2 - value of previous bit
;R3 - bit mask
;R4 - value of current bit; also used to hold sentinel during read
;R5 - # of times 10 appears

	.orig x3000

Init				;initialization


;NOTE: One must be careful when using traps.  They can modify registers.
;      We'll see how to save registers before calling traps/routines later.

    lea R0, prompt
    trap x22
	trap x20		;read data (into R0[7..0])
				;note top 8 bits of R0 are 0's
				;but we'll still look at them
				

	
	AND R2,R2,#0		
    ADD R2,R2,#1		;set prev bit to 1 to start
	AND R3,R3,#0
	ADD R3,R3,#1		;set bitmask to 000...01b
	AND R5,R5,#0		;set result to 0
	AND R1,R1,#0		;set loop counter to 7 
	ADD R1,R1,#7
				;will count from 7 to 0


	LD R4,Sentinel		;get sentinel
	ADD R4,R0,R4		
	BRZ Done
    trap x21 ; output the character
    
				;we now start our processing

Loop
	AND R4,R0,R3		;get value of bit 7-[R1]
	BRNZ NoInc
				;current input is 1
				;check previous input
	AND R2,R2,R2		
	BRP NoInc		;previous bit was one, no 10 will be seen here

Inc
	ADD R5,R5,#1					

NoInc
	AND R2,R2,#0
	ADD R2,R2,R4		;store current bit as previous bit
	
	ADD R3,R3,R3		;shift bit mask to the left

	ADD R1,R1,#-1		;decrement loop counter
	BRZP Loop

Print

    lea R0,newLine
	trap x22
	
	LEA R0, strPrint
	trap x22

	LD R0,AOffset	;need to add x30 to answer 
	ADD R0,R0,R5	;to get right ASCII code
	trap x21		;print count

	LEA R0,newLine
	trap x22

	BR Init		;read in next input to process
Done
	LEA R0,strEOP
	trap x22

	HALT

Sentinel .fill	x-4
AOffset	 .fill	#48  		; same as x30
strPrint	.stringz "Number of 10s:"
prompt      .stringz "Enter a character: "
newLine	.stringz "\n"
strEOP	.stringz "\nProgrammed by Stew Dent\nEnd of Processing."

	.end
	