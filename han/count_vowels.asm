.data
string: .asciiz "Hello Han Dep Trai"
vowels: .asciiz "aeiouAEIOU"

.text
la $s0, string # get string starting address
li $s2, 0 # couting vowl register

loop:
	la $s1, vowels # get address of the vowels set
	lb $t0, 0($s0) # load a byte
	beq $t0, $zero, end # meet null terminator end loop
	vowel_check:
		lbu $t1, 0($s1) # load 1 vowel to check
		beq $t1, $zero, end_check # end when hit end of the set
		beq $t1, $t0, increase_count
		add $s1, $s1, 1 # move to next char in the set
		j vowel_check
	increase_count:
		add $s2, $s2, 1  #increase count
		add $s0, $s0, 1 # check next char in the string
		j loop
	end_check:
		add $s0, $s0, 1 #check next char in the string
		j loop
end:
li $v0, 1
move $a0, $s2 
syscall

li $v0, 10
syscall