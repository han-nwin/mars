.data
pmt: .asciiz "Enter a number: "
end: .asciiz "You entered: "

.text
# print prompt
li $v0, 4
la $t1, pmt
move $a0, $t1
syscall

# Read an integer
li $v0, 5
syscall
move $t0, $v0

# Print end message
li $v0, 4
la $t1, end
move $a0, $t1
syscall

# Print the number
li $v0, 1
move $a0, $t0
syscall

# End program
li $v0, 10
syscall