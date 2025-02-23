.data
num_1: .word 17
num_2: .word 29

.text
lw $t0, num_1
lw $t1, num_2

or $s0, $t0, $t1
and $s1, $t0, $t1
xor $s2, $t0, $t1
sll $s3, $t0, 5
srl $s4, $t0, 9

li $v0, 1
move $a0, $s0
syscall

li $v0, 11   # Load system call code for printing a character
li $a0, 10   # ASCII value of newline ('\n')
syscall      # Print newline

li $v0, 1
move $a0, $s1
syscall

li $v0, 11   # Load system call code for printing a character
li $a0, 10   # ASCII value of newline ('\n')
syscall      # Print newline


li $v0, 1
move $a0, $s2
syscall

li $v0, 11   # Load system call code for printing a character
li $a0, 10   # ASCII value of newline ('\n')
syscall      # Print newline

li $v0, 1
move $a0, $s3
syscall

li $v0, 11   # Load system call code for printing a character
li $a0, 10   # ASCII value of newline ('\n')
syscall      # Print newline


li $v0, 1
move $a0, $s4
syscall