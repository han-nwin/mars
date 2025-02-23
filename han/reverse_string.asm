.data
str: .asciiz "Han Nguyen ^_^"
size: .word 14

.text
la $s0, str #left index
lw $t1, size
subi $t1, $t1, 1 # get size - 1
add $s1, $s0, $t1, #right index

loop:
	slt $t0, $s0, $s1  # if s0 < s1
	beq $t0, $zero, loop_end
	
	lbu $t1, 0($s0) # temp left
	lbu $t2, 0($s1) # temp right
	sb $t2, 0($s0) # swap right to left
	sb $t1, 0($s1) # swap left to right
	
	addi $s0, $s0, 1 # move left index +1
	subi $s1, $s1, 1 # move right index -1
	j loop
	

loop_end:

# print result
li $v0, 4
la $a0, str
syscall