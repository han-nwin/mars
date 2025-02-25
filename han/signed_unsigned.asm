    .data
newline: .asciiz "\n"

    .text
    .globl main
main:
    # Load values (signed and unsigned interpretation)
    li $t0, -5      # Signed value (-5)
    li $t1, 5       # Positive value (5)
    li $t2, 0xFFFFFFFB  # -5 as unsigned (0xFFFFFFFB is 4294967291 in decimal)

    # Signed Addition
    add $t3, $t0, $t1  # (-5) + 5 = 0
    li $v0, 1
    move $a0, $t3
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Unsigned Addition (Should behave the same)
    addu $t3, $t0, $t1  # (-5) + 5 = 0, same as signed
    li $v0, 1
    move $a0, $t3
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Signed Comparison
    slt $t3, $t0, $t1  # (-5 < 5) -> $t3 = 1
    li $v0, 1
    move $a0, $t3
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Unsigned Comparison
    sltu $t3, $t0, $t1  # (Treating -5 as unsigned: 4294967291 < 5?) -> $t3 = 0
    li $v0, 1
    move $a0, $t3
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Unsigned Comparison (Treating -5 as unsigned)
    sltu $t3, $t2, $t1  # (4294967291 < 5?) -> False, $t3 = 0
    li $v0, 1
    move $a0, $t3
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Exit
    li $v0, 10
    syscall
