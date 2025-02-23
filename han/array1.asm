.data
array: .word 5,6,7,8

.text
la $s0, array

lw $s1, ($s0) # Read first element
addi $s1, $s1, 1 # s1 = s1 + 1
sw $s1, ($s0) # Save back to memory

lw $s1, 4($s0) # Read second element
addi $s1, $s1, 1 # s1 = s1 + 1
sw $s1, 4($s0) # Save back to memory

lw $s1, 8($s0) # Read third element
addi $s1, $s1, 1 # s1 = s1 + 1
sw $s1, 8($s0) # Save back to memory

lw $s1, 12($s0) # Read fourth element
addi $s1, $s1, 1 # s1 = s1 + 1
sw $s1, 12($s0) # Save back to memory