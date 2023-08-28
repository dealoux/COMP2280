;Lab 3 Question 1
;Purpose: compute sum of positive #s and sum of negative #s
;Input: array in memory
;Output: counts stored in memory

 	.orig	x3000

;r0 - work register
;r1 - pointer in array
;r2 - element in array
;r3 - pos sum
;r5 - neg sum
;r4 - n

	and	r3,r3,#0	;initialize my two sums
	and	r5,r5,#0

 	ld	r4,n		;get # of element in array
	lea	r1,array	;get (start) address of array

loop
	ldr    r2,r1,0		;get array element

; check if number is positive or not
	brp   positive
negative
	add	r5,r5,r2
	br	endCase

positive
	add	r3,r3,r2	
endCase
	add	r1,r1,#1	;increment array pointer
	add	r4,r4,#-1	;decrement n
	brp	loop

	st	r3,sumPos	;put results into memory
	st	r5,sumNeg
	lea	r0,eopMessage
	puts
	halt

sumPos
	.fill    0      ;sum of positive numbers
sumNeg
	.fill    0      ;sum of negative numbers
n	.fill    10	;length of array

array     		;array of data values
	.fill    3
	.fill    -10
	.fill    0
	.fill    6
	.fill    -6
	.fill    3
	.fill    4
	.fill    0
	.fill    5
	.fill    -9
eopMessage
	.stringz "\nEnd of processing.\n"
	.end
