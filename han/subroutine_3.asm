.data
prompt:     .asciiz "Enter a number: "
result_msg: .asciiz "Factorial result: "

.text
.globl main

main:
    # Print prompt message
    li $v0, 4
    la $a0, prompt
    syscall

    # Read integer input from user
    li $v0, 5
    syscall
    move $a0, $v0   # Store input in $a0

    # Call factorial function
    jal factorial

    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall

    # Print factorial result
    move $a0, $v1  # Move result to $a0 for printing
    li $v0, 1
    syscall

    # Exit program
    li $v0, 10
    syscall


# =======================================================
# Function: factorial(n)
# Computes n! recursively.
# Arguments: $a0 = n
# Returns: $v1 = factorial(n)
# =======================================================
factorial:
    addi $sp, $sp, -8   # Allocate space on stack (for $ra and $s0)
    sw $ra, 4($sp)      # Save return address
    sw $s0, 0($sp)      # Save $s0 (callee-saved register)

    move $s0, $a0       # Save n in $s0 (preserved register)

    # Base case: if (n <= 1) return 1
    ble $a0, 1, base_case

    # Recursive case: factorial(n) = n * factorial(n-1)
    addi $a0, $a0, -1   # Compute n-1
    jal factorial       # Recursively call factorial(n-1)

    mul $v1, $s0, $v1   # Multiply n * factorial(n-1)

    j end_function      # Jump to function cleanup

base_case:
    li $v1, 1           # Return 1 for factorial(0) or factorial(1)

end_function:
    lw $s0, 0($sp)      # Restore $s0
    lw $ra, 4($sp)      # Restore return address
    addi $sp, $sp, 8    # Deallocate stack space
    jr $ra              # Return to caller
