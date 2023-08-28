; COMP 2280
; Lab 5
; Keyboard interrupt test
; Each time a key is pressed, count the number of 0 bits in the character and
; display the count as an ASCII decimal digit.

           .orig   x3000

;this is the main line
Main
           LD      R6,STACKBASE  ; set up user stack (MUST be done)
           LEA     R0,prompt     ; display the prompt
           PUTS

           LEA     R0,KBHandler		
           LD      R1,KBVEC
           STR     R0,R1,#0      ; set kb interrupt vector

           LD      R0,KBEN       ; enable keyboard interrupt
           STI     R0,KBSR
Loop
           BR      Loop          ; loop forever!
           HALT
prompt:    .stringz "Enter characters:\n"

;---------------------------------------------------------------
;Keyboard interrupt handler (no need for Frame pointer)
;
; R0 - character from keyboard, character to output
; R1 - status for console, result of and
; R2 - number of bits left to  process
; R3 - number of one bits
; R4 - mark for current bit

KBHandler
           ADD     R6,R6,#-1   ; save R0
           STR     R0,R6,#0
           ADD     R6,R6,#-1   ; save R1
           STR     R1,R6,#0
           ADD     R6,R6,#-1   ; save R2
           STR     R2,R6,#0
           ADD     R6,R6,#-1   ; save R3
           STR     R3,R6,#0
           ADD     R6,R6,#-1   ; save R4
           STR     R4,R6,#0

           AND     R2,R2,#0
           ADD     R2,R2,#8    ; 7 bits left to process
           AND     R3,R3,#0    ; no 1 bits yet
           AND     R4,R4,#0
           ADD     R4,R4,#1    ; mask of 1 test lsb
           LDI     R0,KBDR     ; get character from keyboard
CountLoop
           AND     R1,R0,R4    ; current bit == 0?
           BRP     NextBit     ; no, nothing to count
           ADD     R3,R3,#1    ; yes, count a 0 bit
NextBit
           ADD     R4,R4,R4    ; shift mask left 1 bit position					
           ADD     R2,R2,#-1   ; count a bit processed
           BRP     CountLoop
           LD      R0,ASCII    ; base value for ascii digit
           ADD     R0,R0,R3    ; convert count to ascii
WaitToWrite
           LDI     R1,DSR      ; get console output status
           BRzp    WaitToWrite

           STI     R0,DDR      ; write new character to console

           LDR     R4,R6,#0    ; restore r4
           ADD     R6,R6,#1
           LDR     R3,R6,#0    ; restore r3
           ADD     R6,R6,#1
           LDR     R2,R6,#0    ; restore r2
           ADD     R6,R6,#1			
           LDR     R1,R6,#0    ; restore r1
           ADD     R6,R6,#1
           LDR     R0,R6,#0    ; restore r0
           ADD     R6,R6,#1

           RTI                 ; return from interrupt

STACKBASE  .FILL   xFD00       ; stack base (can be changed)
KBSR       .FILL   xFE00       ; keyboard status register
KBDR       .FILL   xFE02       ; keyboard data register 
DSR        .FILL   xFE04       ; console status register
DDR        .FILL   xFE06       ; console data register 

KBEN       .FILL   x4000       ; use to enable keyboard interrupt
KBVEC      .FILL   x0180       ; keyboard vector number/location

ASCII      .FILL   X30         ; base ascii value for decimal digit

           .END