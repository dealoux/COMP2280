; Course:  COMP2280
; Lab:     4, Question 1
; Author:  Stew Dent 
; Purpose: Compute f(x) where f(x) = f(x-1)+x for x > 0 and f(0) = 0.

; Register dictionary
; R0 - input / output
; R1 - ascii conversion value -x30
; R2 - the integer value of x
; R3 - f(x)
; R4 - x

	.orig	x3000
	ld	r6,stackbase    ; establish the stack pointer

	ld	r4,xValue

	add	r6,r6,#-1       ; push xValue onto the stack
	str	r4,r6,#0
	add	r6,r6,#-1       ; space for return value
	jsr	recurse
	ldr	r3,r6,#0        ; f(x)
	add	r6,r6,#2        ; clean up the stack

	st	r3,result       ; save the result

	lea	r0,eopMsg       ; display EOP message
	puts
	halt

stackbase   .fill	xFD00
;ascii       .fill	x-30
result      .blkw	#1
xValue	    .fill	#5
eopMsg      .stringz    "\n\nProgrammed by Stew Dent.\nEnd of processing.\n"


; recurse
;   Compute the value of f(x) where f(x) = f(x)+x for x > 0 and f(0) = 0.

; Register Dictionary
; R1 - x
; R2 - x-1, f(x-1)

; Activation record
; r5 + 0 : the return value
; r5 + 1 : x

recurse
	add	    r6,r6,#-1        ; save the caller's registers
	str     r5,r6,#0        ; r5
	add     r5,r6,#1        ; establish the frame pointer
	add     r6,r6,#-1
	str     r7,r6,#0        ; r7
	add     r6,r6,#-1
	str     r2,r6,#0        ; r2
	add     r6,r6,#-1
	str     r1,r6,#0        ; r1

	ldr     r1,r5,#1        ; get the parameter x
	brnp    recursion       ; not 0 => process recursive case
baseCase
	str     r1,r5,#0        ; return 0 for base case
	br      exit
recursion
	add     r2,r1,#-1       ; x - 1
	add     r6,r6,#-1       ; push argument onto stack
	str     r2,r6,#0
	add     r6,r6,#-1       ; reserve space for the return value
	jsr     recurse         ; compute f(x-1)

	ldr     r2,r6,#0        ; f(x-1)
	add     r6,r6,#2        ; clean up the stack

	add     r2,r1,r2        ; f(x-1) + x
	str     r2,r5,#0        ; return f(x-1) + x
exit
	ldr     r1,r6,#0        ; r1, restore the caller's registers
	add     r6,r6,#1
	ldr     r2,r6,#0        ; r2
	add     r6,r6,#1
	ldr     r7,r6,#0        ; r7
	add     r6,r6,#1
	ldr     r5,r6,#0        ; r5
	add     r6,r6,#1
	ret
	
	

	.END
	
	
	