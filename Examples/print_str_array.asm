;This example implements a simple while loop to print a string 
;Register Usage
;R0 - Used to hold character to print
;R2 - Use to hold address of current character of str to print


	.orig x3000
	
	
	lea r2,mystr	;get address of string
	
	ldr r0,r2,#0	;get character to print
		
	
	brz done	;while (check if it is NULL, if so exit)
loop
	trap x21	;print character
	add r2,r2,#1	;increment array position
	ldr r0,r2,#0	;get element at current array position
	brp loop

done			;end of while loop

	halt

mystr	.stringz		"hello"

	.end