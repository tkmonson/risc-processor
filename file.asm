.text
main: addi $1, $0, 1999
noop
halt
sw $r18, -640($r7)
bne $3, $2, middle
addi $6, $1, 65535
addi $7, $1, -65536

middle:
sub $8, $2, $1
and $9, $2, $1
j quit
dead: addi $r7, $r0, 0x0000DF00
quit:

.data
wow: .word 0x0000B504
mystring: .string ASDASDASDASDASDASD
var: .char Z
label: .char A
heapsize: .word 0x00000000
myheap: .word 0x00000000