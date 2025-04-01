.data
    .globl ownership
    ownership: .space 144
    test_horiz:  .asciiz "Horizontal Test: "
    test_vert:   .asciiz "Vertical Test: "
    test_diag1:  .asciiz "Diagonal (TL-BR) Test: "
    test_diag2:  .asciiz "Diagonal (TR-BL) Test: "
    test_nowin:  .asciiz "No Win Test: "
    pass:        .asciiz "PASS (1)\n"
    fail:        .asciiz "FAIL (0)\n"
    newline:     .asciiz "\n"
    debug_msg:   .asciiz "Debug: "

.text
    .globl main

main:
    jal reset_board
    la $t0, ownership
    li $t1, 1
    sw $t1, 8($t0)    # (0,2) = 1
    sw $t1, 12($t0)   # (0,3) = 1
    sw $t1, 16($t0)   # (0,4) = 1
    sw $t1, 20($t0)   # (0,5) = 1
    # Debug print
    la $a0, debug_msg
    li $v0, 4
    syscall
    la $t0, ownership
    lw $a0, 0($t0)    # Should be 0
    li $v0, 1
    syscall
    lw $a0, 4($t0)    # Should be 0
    li $v0, 1
    syscall
    lw $a0, 8($t0)    # Should be 1
    li $v0, 1
    syscall
    lw $a0, 12($t0)   # Should be 1
    li $v0, 1
    syscall
    lw $a0, 16($t0)   # Should be 1
    li $v0, 1
    syscall
    lw $a0, 20($t0)   # Should be 1
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    # End debug
    la $a0, test_horiz
    li $v0, 4
    syscall
    li $a0, 1
    jal check_win
    jal print_result

    # Rest of tests unchanged...
    jal reset_board
    la $t0, ownership
    li $t1, 1
    sw $t1, 0($t0)
    sw $t1, 24($t0)
    sw $t1, 48($t0)
    sw $t1, 72($t0)
    la $a0, test_vert
    li $v0, 4
    syscall
    li $a0, 1
    jal check_win
    jal print_result

    jal reset_board
    la $t0, ownership
    li $t1, 1
    sw $t1, 0($t0)
    sw $t1, 28($t0)
    sw $t1, 56($t0)
    sw $t1, 84($t0)
    la $a0, test_diag1
    li $v0, 4
    syscall
    li $a0, 1
    jal check_win
    jal print_result

    jal reset_board
    la $t0, ownership
    li $t1, 1
    sw $t1, 20($t0)
    sw $t1, 40($t0)
    sw $t1, 60($t0)
    sw $t1, 80($t0)
    la $a0, test_diag2
    li $v0, 4
    syscall
    li $a0, 1
    jal check_win
    jal print_result

    jal reset_board
    la $t0, ownership
    li $t1, 1
    sw $t1, 0($t0)
    sw $t1, 28($t0)
    sw $t1, 60($t0)
    la $a0, test_nowin
    li $v0, 4
    syscall
    li $a0, 1
    jal check_win
    jal print_result

    li $v0, 10
    syscall

reset_board:
    la $t0, ownership
    li $t1, 0
    li $t2, 36
reset_loop:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, -1
    bnez $t2, reset_loop
    jr $ra

print_result:
    move $t0, $v0
    beq $t0, 1, print_pass
    la $a0, fail
    li $v0, 4
    syscall
    j print_done
print_pass:
    la $a0, pass
    li $v0, 4
    syscall
print_done:
    la $a0, newline
    li $v0, 4
    syscall
    jr $ra
