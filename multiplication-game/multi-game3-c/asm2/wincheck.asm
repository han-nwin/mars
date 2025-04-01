.text
    .extern get_ownership 4

    .globl check_win
    .globl is_board_full

check_win:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $a0, 12($sp)

    # Horizontal check
    li $s0, 0
horiz_row_loop:
    li $s1, 0
horiz_col_loop:
    li $t0, 2
    bgt $s1, $t0, next_horiz_col
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 1
    jal get_ownership
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 2
    jal get_ownership
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 3
    jal get_ownership
    bne $v0, $t1, no_horiz_win
    li $v0, 1
    j win_cleanup
no_horiz_win:
    lw $a0, 12($sp)       # Restore player, not row
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, horiz_col_loop
next_horiz_col:
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, horiz_row_loop
    # ... (rest unchanged) ...

    # Vertical check
    li $s0, 0
vert_row_loop:
    li $s1, 0
vert_col_loop:
    li $t0, 2
    bgt $s0, $t0, next_vert_row
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 1
    move $a1, $s1
    jal get_ownership
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 2
    move $a1, $s1
    jal get_ownership
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 3
    move $a1, $s1
    jal get_ownership
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
    li $t0, 2
    bgt $s0, $t0, next_diag1_row
    bgt $s1, $t0, next_diag1_col
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 1
    addi $a1, $s1, 1
    jal get_ownership
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 2
    addi $a1, $s1, 2
    jal get_ownership
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 3
    addi $a1, $s1, 3
    jal get_ownership
    bne $v0, $t1, no_diag1_win
    li $v0, 1
    j win_cleanup
no_diag1_win:
    move $a0, $s0
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, diag1_col_loop
next_diag1_col:
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, diag1_row_loop
next_diag1_row:

    # Diagonal (top-right to bottom-left)
    li $s0, 0
diag2_row_loop:
    li $s1, 3
diag2_col_loop:
    li $t0, 2
    bgt $s0, $t0, next_diag2_row
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 1
    addi $a1, $s1, -1
    jal get_ownership
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 2
    addi $a1, $s1, -2
    jal get_ownership
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 3
    addi $a1, $s1, -3
    jal get_ownership
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
    lw $a0, 12($sp)           # Restore original $a0
    addi $sp, $sp, 16
    jr $ra

# is_board_full: Check if no empty cells remain (all 1s or 2s)
# Returns $v0 = 1 if full, 0 if not full
is_board_full:
    addi $sp, $sp, -12        # Allocate stack for $ra, $s0, $s1
    sw $ra, 0($sp)            # Save return address
    sw $s0, 4($sp)            # Save row counter
    sw $s1, 8($sp)            # Save col counter

    li $s0, 0                 # Start at row 0
full_row_loop:
    li $s1, 0                 # Start at col 0
full_col_loop:
    move $a0, $s0             # Set row for get_ownership
    move $a1, $s1             # Set col
    jal get_ownership         # Check cell ownership
    beqz $v0, not_full        # If 0 (unclaimed), board isn’t full
    addi $s1, $s1, 1          # Next column
    li $t0, 6                 # Grid width
    blt $s1, $t0, full_col_loop  # Keep checking this row
    addi $s0, $s0, 1          # Next row
    li $t0, 6                 # Grid height
    blt $s0, $t0, full_row_loop  # Keep checking rows

    li $v0, 1                 # All cells claimed, board is full
    j full_cleanup
not_full:
    li $v0, 0                 # Found an empty cell, not full
full_cleanup:
    lw $ra, 0($sp)            # Restore return address
    lw $s0, 4($sp)            # Restore row counter
    lw $s1, 8($sp)            # Restore col counter
    addi $sp, $sp, 12         # Deallocate stack
    jr $ra                    # Return with $v0 (1 or 0)
