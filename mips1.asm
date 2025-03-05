.data
num1:   .word 10
num2:   .word 20
result: .word 0

    .text
    .globl main

main:
    # Load the values of num1 and num2 into argument registers
    lw $a0, num1        # load num1 into $a0
    lw $a1, num2        # load num2 into $a1
    

    li $s0,5
    # Call the add_numbers procedure
    jal add_numbers
    
    # Store the result
    sw $s0, result      # store result from $v0 into memory
    
    # Exit program
    li $v0, 10          # syscall to exit
    syscall

# Procedure to add two numbers
add_numbers:

     addi $sp, $sp, -4      
    sw   $s0, 0($sp)      
    add $s0, $a0, $a1

    lw   $s0, 0($sp)       
    addi $sp, $sp, 4      

 add  $v0, $s0, $zero

        jr $ra 