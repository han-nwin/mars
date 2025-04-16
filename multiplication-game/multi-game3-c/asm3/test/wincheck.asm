.text
    .globl check_win
    .globl get_ownership
    .globl is_board_full

check_win:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $a0, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)

    # Horizontal check
    li $s0, 0
horiz_row_loop:
    li $s1, 0
horiz_col_loop:
    li $t0, 3
    bge $s1, $t0, next_horiz_row
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 1
    jal get_ownership
    lw $t1, 12($sp)  # Reload $t1 after each call
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 2
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 3
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_horiz_win
    li $v0, 1
    j win_cleanup
no_horiz_win:
    lw $a0, 12($sp)
    addi $s1, $s1, 1
    li $t0, 3
    j horiz_col_loop
next_horiz_row:
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, horiz_row_loop

    # Vertical check
    li $s0, 0
vert_row_loop:
    li $s1, 0
vert_col_loop:
    li $t0, 3
    bge $s0, $t0, next_vert_row
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 1
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 2
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 3
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    li $v0, 1
    j win_cleanup
no_vert_win:
    move $a0, $s0
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, vert_col_loop
next_vert_row:
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, vert_row_loop

    # Diagonal (top-left to bottom-right)
    li $s0, 0
diag1_row_loop:
    li $s1, 0
diag1_col_loop:
    li $t0, 3
    bge $s0, $t0, next_diag1_row
    bge $s1, $t0, next_diag1_col
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 1
    addi $a1, $s1, 1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 2
    addi $a1, $s1, 2
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 3
    addi $a1, $s1, 3
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    li $v0, 1
    j win_cleanup
no_diag1_win:
    move $a0, $s0
    addi $s1, $s1, 1
    li $t0, 3
    j diag1_col_loop
next_diag1_col:
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, diag1_row_loop
next_diag1_row:
    nop

    # Diagonal (top-right to bottom-left)
    li $s0, 0
diag2_row_loop:
    li $s1, 3
diag2_col_loop:
    li $t0, 3
    bge $s0, $t0, next_diag2_row
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 1
    addi $a1, $s1, -1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 2
    addi $a1, $s1, -2
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 3
    addi $a1, $s1, -3
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    li $v0, 1
    j win_cleanup
no_diag2_win:
    move $a0, $s0
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, diag2_col_loop
next_diag2_row:
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, diag2_row_loop

    li $v0, 0
win_cleanup:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $a0, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    addi $sp, $sp, 24
    jr $ra

get_ownership:
    li $t0, 6
    mul $t3, $a0, $t0  # Use $t3 instead of $t1
    add $t3, $t3, $a1
    sll $t3, $t3, 2
    la $t2, ownership
    add $t3, $t2, $t3
    lw $v0, 0($t3)
    jr $ra

is_board_full:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $t0, 12($sp)

    li $s0, 0
full_row_loop:
    li $s1, 0
full_col_loop:
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    beqz $v0, not_full
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, full_col_loop

    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, full_row_loop

    li $v0, 1
    j full_cleanup
not_full:
    li $v0, 0
full_cleanup:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $t0, 12($sp)
    addi $sp, $sp, 16
    jr $ra
