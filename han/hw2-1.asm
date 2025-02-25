.data
nums: .word 15,7,25 # Store 3 number into memory
.text
la $t0, nums # Load the address of nums
lw $t1, 0($t0) # Load first number to t1
lw $t2, 4($t0) # Load second number to t2
lw $t3, 8($t0) # Load third number to t3

add $t1, $t1, $t2 # Calculate first 2 nums sum and store back to t1
add $t1, $t1, $t3 # Calculate final sum and store back to t1

sw $t1, 12($t0) # Store the result at the next memory address
