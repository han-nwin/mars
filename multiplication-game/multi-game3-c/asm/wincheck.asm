.text
.globl check_win
check_win:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    move $s0, $a0       # Player

    # Horizontal
    li $t0, 0
horiz_row:
    bge $t0, 6, check_vert
    li $t1, 0
horiz_col:
    bgt $t1, 2, horiz_next_row
    li $t2, 0
    li $t3, 1           # Win flag
horiz_check:
    bge $t2, 4, horiz_win
    addu $t4, $t1, $t2
    move $a0, $t0
    move $a1, $t4
    jal get_ownership
    bne $v0, $s0, horiz_no_win
    addiu $t2, $t2, 1
    j horiz_check
horiz_no_win:
    li $t3, 0
horiz_win:
    bnez $t3, win_found
    addiu $t1, $t1, 1
    j horiz_col
horiz_next_row:
    addiu $t0, $t0, 1
    j horiz_row

check_vert:
    li $t0, 0
vert_row:
    bgt $t0, 2, check_diag1
    li $t1, 0
vert_col:
    bge $t1, 6, vert_next_row
    li $t2, 0
    li $t3, 1
vert_check:
    bge $t2, 4, vert_win
    addu $t4, $t0, $t2
    move $a0, $t4
    move $a1, $t1
    jal get_ownership
    bne $v0, $s0, vert_no_win
    addiu $t2, $t2, 1
    j vert_check
vert_no_win:
    li $t3, 0
vert_win:
    bnez $t3, win_found
    addiu $t1, $t1, 1
    j vert_col
vert_next_row:
    addiu $t0, $t0, 1
    j vert_row

check_diag1:  # Top-left to bottom-right
    li $t0, 0
diag1_row:
    bgt $t0, 2, check_diag2
    li $t1, 0
diag1_col:
    bgt $t1, 2, diag1_next_row
    li $t2, 0
    li $t3, 1
diag1_check:
    bge $t2, 4, diag1_win
    addu $t4, $t0, $t2
    addu $t5, $t1, $t2
    move $a0, $t4
    move $a1, $t5
    jal get_ownership
    bne $v0, $s0, diag1_no_win
    addiu $t2, $t2, 1
    j diag1_check
diag1_no_win:
    li $t3, 0
diag1_win:
    bnez $t3, win_found
    addiu $t1, $t1, 1
    j diag1_col
diag1_next_row:
    addiu $t0, $t0, 1
    j diag1_row

check_diag2:  # Top-right to bottom-left
    li $t0, 0
diag2_row:
    bgt $t0, 2, no_win
    li $t1, 3
diag2_col:
    bge $t1, 6, diag2_next_row
    li $t2, 0
    li $t3, 1
diag2_check:
    bge $t2, 4, diag2_win
    addu $t4, $t0, $t2
    subu $t5, $t1, $t2
    move $a0, $t4
    move $a1, $t5
    jal get_ownership
    bne $v0, $s0, diag2_no_win
    addiu $t2, $t2, 1
    j diag2_check
diag2_no_win:
    li $t3, 0
diag2_win:
    bnez $t3, win_found
    addiu $t1, $t1, 1
    j diag2_col
diag2_next_row:
    addiu $t0, $t0, 1
    j diag2_row

win_found:
    li $v0, 1
    j win_end

no_win:
    li $v0, 0

win_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addiu $sp, $sp, 8
    jr $ra

.globl is_board_full
is_board_full:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 0
full_row:
    bge $t0, 6, full_true
    li $t1, 0
full_col:
    bge $t1, 6, full_next_row
    move $a0, $t0
    move $a1, $t1
    jal get_ownership
    beqz $v0, full_false
    addiu $t1, $t1, 1
    j full_col
full_next_row:
    addiu $t0, $t0, 1
    j full_row

full_true:
    li $v0, 1
    j full_end

full_false:
    li $v0, 0

full_end:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
