.text
li $a0, 8
li $a1, 6
li $a2, 5
li $a3, 2

li $s0,5
jal leaf_example
addi $s0,$s0,1

li $v0, 10 # exit the program 
syscall 

leaf_example: 
addi $sp, $sp, -4
sw   $s0, 0($sp)
add  $t0, $a0, $a1
add  $t1, $a2, $a3
sub  $s0, $t0, $t1
add  $v0, $s0, $zero
lw   $s0, 0($sp)
addi $sp, $sp, 4
jr   $ra