.data
num_1: .word 5
num_2: .word 98

.text
lw $t1, num_1
lw $t2, num_2

li $t0, 1 # starting
li, $s0, 0 # stating value

loop_start:
	sleu $t3, $t0, $t2 # if $t0 <= $t2
	beq $t3, $zero, end_loop #zero
	add $s0, $s0, $t1 # s0 = s0 + t1
	add $t0, $t0, 1 # increment index +1
	j loop_start
	
end_loop: