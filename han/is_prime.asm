.data
prompt: .asciiz "Enter a number: "
yes_msg: .asciiz "Prime\n"
no_msg: .asciiz "Not Prime\n"

.text
li $v0, 4
la $a0, prompt
syscall

li $v0, 5
syscall

move $t0, $v0 # get integer input
ble $t0, 1, not_prime # if <= 1
beq $t0, 2, prime # it = 2

# Calculate square root
li $t5, 1 # start with 1
square_root: 
	mul $t6, $t5, $t5 # i*i
	bge $t6, $t0, square_root_done
	addi $t5, $t5, 1 # increment
	j square_root

square_root_done:
	li $t1, 2 # start checking at 2
	check_prime:
		bgt $t1, $t5, prime
		div $t0, $t1 # divisor
		mfhi $t2 #remainder
	
		beqz $t2, not_prime # if remainer == 0 -> not prime
		addi $t1, $t1, 1
		j check_prime

not_prime:
	li $v0, 4
	la $a0, no_msg
	syscall
	j end

prime:
	li $v0, 4
	la $a0, yes_msg
	syscall
	j end
	
end: 
	li $v0, 10
	syscall

