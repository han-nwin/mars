.data
array: .word 1,2,3,4,5,6,7,8,9,10
size: .word 10

.text
la $s0, array #load array address

li $t0, 0 #left index
lw $t1, size #load size
sub $t1, $t1, 1 #right index

loop:
	slt $t2, $t0, $t1 # if t0 < t1
	beq $t2, $zero, end_loop
	
	sll $t3, $t0, 2 # get left offset
	sll $t4, $t1, 2 # get right offset
	
	add $t3, $t3, $s0 # base + offset left
	add $t4, $t4, $s0 # base + offset right
	
	lw $t5, 0($t3) # temp
	lw $t6, 0($t4)
	
	sw $t5, 0($t4)
	sw $t6, 0($t3)
	
	addi $t0, $t0, 1 # left++
	subi $t1, $t1, 1 #right--
	j loop
	
end_loop:
