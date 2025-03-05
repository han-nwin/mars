.text
.globl main

main:
    li $a0, 9         # Load argument (5) into $a0
    jal double_value   # Call function

    move $t0, $v0      # Save returned value in $t0

    li $v0, 1          # Syscall to print integer
    move $a0, $t0      # Move result into $a0 for printing
    syscall

    li $v0, 10         # Exit program
    syscall

# Subroutine: double_value
# Argument: $a0 (number)
# Returns: $v0 (number * 2)
double_value:
    mul $v0, $a0, 2    # Multiply argument by 2, store in $v0
    jr $ra             # Return to caller