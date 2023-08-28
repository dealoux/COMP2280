;Lab 3 Question 2
;Demonstrate a program with indirect addressing
; display a character depending on user input

 		.orig	x3000		;program origin

;r0 - used for I/O routines
;r1 - input value
;r2 - values for comparison

		lea	r0,promptMessage
		puts			;give a prompt

		in
		add	r1,r0,0			;r1 <- r0
		ld		r2,negZero		;r2 <- -'0'
		add	r0,r0,r2			;test for 0
		brz	input0
		add	r0,r1,0			;r0 <- r1, restore input value
		ld		r2,negOne		;r2 <- -'1'
		add	r0,r0,r2			;test for 1
		brz	input1
		lea	r0,errorMessage
		puts						;invalid input
		br	eop
input0
		ldi	r0,chr1Ptr		;load chr1 indirectly
		br	output
input1
		ldi	r0,chr2Ptr		;load chr2 indirectly
output
		out

		lea	r0,eopMessage
		puts
		halt

negZero	.fill	xFFD0		;-'0'
negOne	.fill	xFFCF		;-'1'
chr1Ptr	.fill	chr1		;pointer to chr1
chr2Ptr	.fill	chr2		;pointer to chr2
chr1		.fill	x0041		;'A'
chr2		.fill	x005A		;'Z'
promptMessage
	.stringz	"Enter a 0 or a 1.\n"
errorMessage
	.stringz	"Invalid input, should be 0 or 1.\n"
eopMessage
	.stringz	"\nEnd of processing.\n"
	.end

