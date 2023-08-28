; r0 = I/O
; r1 = input value
; r2 = vales for comp

.orig x3000

lea r0, promptmsg
puts

in
add

lea r0, errormsg
puts
br eopmsg

input0
    ldi

input1
    ldi

output
    out
    lea
    puts
    halt
    
negZero .fill
negone .fill

chr1ptr .fill
chr2ptr .fill

chr1
chr2

promptmsg .stringz "Enter "0" or "1"\n"
errormsg .stringz "\nPlease enter a valid input of "0" or "1"\n"
eopmsg .stringz "\nEmd of processing\n"

.end