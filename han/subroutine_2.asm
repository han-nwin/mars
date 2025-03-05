.data
prompt1: .asciiz "Enter first number: "
prompt2: .asciiz "Enter second number: "
result_msg: .asciiz "The sum is: "

.text
.globl main

main:
    # Print "Enter first number: "
    li $v0, 4          
    la $a0, prompt1   
    syscall

    # Read first integer input
    li $v0, 5         
    syscall           
    move $t0, $v0     # Store first number in $t0

    # Print "Enter second number: "
    li $v0, 4         
    la $a0, prompt2   
    syscall

    # Read second integer input
    li $v0, 5         
    syscall           
    move $t1, $v0     # Store second number in $t1

    # Save return address and call sum_numbers
    addi $sp, $sp, -4   # Allocate stack space
    sw $ra, 0($sp)      # Save return address
   # sw $t0, 0($sp)      # Save $t0 (first number)

    move $a0, $t0       # Pass first number
    move $a1, $t1       # Pass second number
    jal sum_numbers     # Jump to function

    # Restore registers
   # lw $t0, 0($sp)      # Restore $t0
    lw $ra, 0($sp)      # Restore return address
    addi $sp, $sp, 4    # Deallocate stack space

    # Print result message
    li $v0, 4          
    la $a0, result_msg 
    syscall

    # Print sum result
    move $a0, $v1    # Move sum result to $a0
    li $v0, 1          
    syscall            

    # Exit program
    li $v0, 10         
    syscall           

# Function: sum_numbers
# Arguments: $a0 (first number), $a1 (second number)
# Returns: $v0 (sum)
sum_numbers:
    add $v1, $a0, $a1  # Compute sum
    jr $ra             # Return to caller
