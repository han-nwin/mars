
# while(save[i] == k) i += 1
.data
save: .word 5,5,5,5,6,7,8
k: .word 5

.text
li $s0, 0 # this is index i
la $t0, save # load the array
lw $s2, k # load k

while:
	lw $s1, 0($t0) # point to first element in array
	bne $s1, $s2, exit # exit if condition isn't satisfied anymore
	addi $t0, $t0, 4 # move the index 4 bytes -> next element in array
j while

exit: 