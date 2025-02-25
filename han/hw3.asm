.data
array: .word 5,8,12,3,9,15,7,11,6,4 # store array elements in memory
size: .word 10 # store the size of the array
sum: .word 0 # placeholder for sum
max: .word 0 # placeholder for max
count: .word 0 # placeholder for count

.text
lw $t0, size # load the size
la $s0, array # load the array first element address
lw $s1, sum # load sum (it's = 0 now)
lw $s2, max # load max (it's = 0 now)
lw $s3, count # load count (it's = 0 now)

li $t1, 0 # starting array index

loop_start:
	slt $t2, $t1, $t0 # if array index less than size
	bne $t2, $zero, loop_body # jump to loop_body
	j end_loop # jump to end 

loop_body:
	# a. Calculate sum
	lw $t3, 0($s0) # get the element
	add $s1, $s1, $t3 # add to the total sum
	
	# b. Calculate max
	slt $t2, $s2, $t3 # check if current max < current element
	beq $t2, $zero, max_done # if not skip changing the max
	
	move $s2, $t3 # update the max value here if condition is met
	
	max_done:
	# c. Calculate nums of element < 9
	slti $t2, $t3, 9 # checking if the current element is less than 9
	beq $t2, $zero, count_done # if not skip this element
	
	addi $s3, $s3, 1 # increment the count by 1
	
	count_done:
	addi $s0, $s0, 4 # move the address 4 bytes to get next element
	addi $t1, $t1, 1 # increment the index
	j loop_start # jump back to the loop_start
		
end_loop:
	sw $s1, sum # store final sum back to memory
	sw $s2, max # store final max back to memory
	sw $s3, count # store final cound back to memory


