; Given a set of target values call a linear search routine to determine if
; each of the target values is found in a given array of unsorted integers.
; Register Dictionary
; -------------------
; R0 : general purpose work
; R1 : address of array of target values
; R2 : the number of target values left to process
; R3 : the result of the search
; R6 : the stack pointer
; R7 : the return address
    .ORIG x3000
MAINLINE
        LD R6,STACKBASE ;initialize the stack pointer
        LEA R1,TARGETS ; point at the array of targets
        LD R2,NUMTARGETS ; get the number of targets
    
LOOP
        BRZ DONE ; no more targets?
        LEA R0,SOURCE ; address of array to search
        ADD R6,R6,#-1 ; push argument onto stack
        STR R0,R6,#0
        LD R0,N ; number of elements in array
        
        ADD R6,R6,#-1 ; push argument onto stack
        STR R0,R6,#0
        
        LDR R0,R1,#0 ; the target
        ADD R6,R6,#-1; push argument onto stack
        STR R0,R6,#0
        
        ADD R6,R6,#-1 ; reserve space for result
        
        JSR LINEARSEARCH ; search for the target in source
        
        LDR R3,R6,#0 ;get the result of the search
        ADD R6,R6,#4 ; clean up the stack
        
        ADD R0,R3,#1 ; target not found?
        BRZ NOTFOUND ; yes => o/p not found message
        
        LEA R0,FOUNDMSG ; no, o/p found message
        PUTS
        LD R0,ASCII ;ascii base for a digit
        ADD R0,R0,R3 ;convert position to ascii
        OUT; o/p the position
        BR CONTINUE
        
NOTFOUND
        LEA R0,NOTFOUNDMSG ;o/p not found message
        PUTS
CONTINUE
        ADD R1,R1,#1 ;point at next target
        ADD R2,R2,#-1 ; count a target processed
        BR LOOP ; process next target
DONE
        LEA R0,EOPMSG; display EOP message
        PUTS
        HALT
STACKBASE .fill xFE00
ASCII 	.fill 	#48
FOUNDMSG 	.stringz 	"\nFound at position: "
NOTFOUNDMSG 	.stringz 	"\nNot found."
EOPMSG 	.stringz 	"\nEnd of Processing"
N 	.fill 	#10
SOURCE 	.fill 	#99
	.fill 	#67
.fill 	#-33
.fill 	#0
.fill 	#-123
.fill 	#29
.fill 	#17
.fill 	#79
.fill 	#22
.fill 	#-1
NUNMTARGETS 	.fill 	#4
TARGETS 	.fill 	#-33
.fill 	#22
.fill 	#17
.fill 	#89




; Given the address of an array, the number of elements in an array and a
; target to find in the array return the position at which the target is found
; in the array, or if the target is not found return -1.
; Register Dictionary
; -------------------
; R0 : the offset to the current array element
; R1 : the address of the current array element
; R2 : number of elements in the array left to process
; R3 : the target in 2's compliment form
; R4 : current array element
; R5 : the frame pointer
; R6 : the stack pointer
; R7 : the return address
; Activation Record
; -----------------
; R5 + 0 : the return value / result of the search
; R5 + 1 : the target value
; R5 + 2 : the number of elements in the array
; R5 + 3 : the address of the array
LINEARSEARCH
        ADD R6,R6,#-1; save the frame pointer
        STR R5,R6,#0 ;R5
        ADD R5,R6,#1 ;estabish the frame pointer
        ADD R6,R6,#-1; save the registers used by the routine
        STR R0,R6,#0 ;R0
        ADD R6,R6,#-1
        STR R1,R6,#0 ;R1
    
        ADD R6,R6,#-1
        STR R2,R6,#0 ;R2
        
        ADD R6,R6,#-1
        STR R3,R6,#0 ;R3
        
        ADD R6,R6,#-1
        STR R4,R6,#0 ;R4
        
        AND R0,R0,#0 ;assume the target will not be found
        ADD R0,R0,#-1
        
        STR R0,R5,#0 ;save the result as the return value
        
        AND R0,R0,#0 ;offset to current array element
        LDR R1,R5,#3 ;address of array
        LDR R3,R5,#1 ;the target value
        NOT R3,R3; form 2's compliment for comparison
        ADD R3,R3,#1
        LDR R2,R5,#2 ;number of elements in array
SEARCH
        BRZ FINI; zero => no more elements to process
        LDR R4,R1,#0 ; get the current array element
        ADD R4,R4,R3 ; target == current element?
        BRNP NEXT ; no, try next array element
        STR R0,R5,#0 ; yes, save offset as result
        BR FINI ; exit the loop
NEXT
        ADD R0,R0,#1 ;offset to next array element
        ADD R1,R1,#1 ;point at next array element
        ADD R2,R2,#-1; count an array element processed
        BR SEARCH
FINI
        LDR R4,R6,#0 ;R4, restore the registers
        ADD R6,R6,#1
        LDR R3,R6,#0 ;R3
        ADD R6,R6,#1
        LDR R2,R6,#0 ;R2
        ADD R6,R6,#1
        LDR R1,R6,#0 ;R1
        ADD R6,R6,#1
        LDR R0,R6,#0 ;R0
        ADD R6,R6,#1
        LDR R5,R6,#0 ;R5
        ADD R6,R6,#1
        RET
.end