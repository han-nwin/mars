.text
    .globl check_win          # Global function to check for a win
    .globl is_board_full      # Global function to check if board is full

# check_win: Checks if a player has four in a row (horizontal, vertical, or diagonal)
# Input: $a0 = player number (1 for X, 2 for O)
# Output: $v0 = 1 if player wins, 0 if no win
check_win:
    addi $sp, $sp, -24        # Allocate 24 bytes on stack for 6 registers
    sw $ra, 0($sp)            # Save return address
    sw $s0, 4($sp)            # Save $s0 (row counter)
    sw $s1, 8($sp)            # Save $s1 (column counter)
    sw $a0, 12($sp)           # Save $a0 (player number)
    sw $t0, 16($sp)           # Save $t0 (loop limit)
    sw $t1, 20($sp)           # Save $t1 (player number for comparison)

    # Horizontal check: Look for four consecutive cells in each row
    li $s0, 0                 # Start at row 0
horiz_row_loop:
    li $s1, 0                 # Start at column 0
horiz_col_loop:
    li $t0, 3                 # Limit starting column to 2 (0-2), since 2+3=5 fits 6x6 grid
    bge $s1, $t0, next_horiz_row  # If col >= 3, move to next row
    move $a0, $s0             # Set row for get_ownership
    move $a1, $s1             # Set column
    jal get_ownership         # Get cell value at (row, col)
    lw $t1, 12($sp)           # Load player number (1 or 2)
    bne $v0, $t1, no_horiz_win  # If cell != player, no win here
    move $a0, $s0
    addi $a1, $s1, 1          # Check next column
    jal get_ownership
    lw $t1, 12($sp)           # Reload player number (in case clobbered)
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 2          # Check two columns over
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_horiz_win
    move $a0, $s0
    addi $a1, $s1, 3          # Check three columns over
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_horiz_win
    li $v0, 1                 # Four in a row found—player wins!
    j win_cleanup             # Jump to cleanup and return
no_horiz_win:
    lw $a0, 12($sp)           # Restore $a0 for next iteration
    addi $s1, $s1, 1          # Move to next starting column
    li $t0, 3                 # Reset loop limit
    j horiz_col_loop          # Try next column position
next_horiz_row:
    addi $s0, $s0, 1          # Move to next row
    li $t0, 6                 # Grid has 6 rows
    blt $s0, $t0, horiz_row_loop  # If row < 6, check next row

    # Vertical check: Look for four consecutive cells in each column
    li $s0, 0                 # Start at row 0
vert_row_loop:
    li $s1, 0                 # Start at column 0
vert_col_loop:
    li $t0, 3                 # Limit starting row to 2 (0-2), since 2+3=5 fits 6x6 grid
    bge $s0, $t0, next_vert_row  # If row >= 3, move to next column
    move $a0, $s0             # Set row
    move $a1, $s1             # Set column
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win  # If cell != player, no win
    addi $a0, $s0, 1          # Check next row down
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 2          # Two rows down
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    addi $a0, $s0, 3          # Three rows down
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_vert_win
    li $v0, 1                 # Four in a column—win!
    j win_cleanup
no_vert_win:
    move $a0, $s0             # Restore row for next iteration
    addi $s1, $s1, 1          # Move to next column
    li $t0, 6                 # Grid has 6 columns
    blt $s1, $t0, vert_col_loop  # If col < 6, check next column
next_vert_row:
    addi $s0, $s0, 1          # Move to next starting row
    li $t0, 6                 # Grid has 6 rows
    blt $s0, $t0, vert_row_loop  # If row < 6, keep going

    # Diagonal check (top-left to bottom-right): Look for four in a diagonal
    li $s0, 0                 # Start at row 0
diag1_row_loop:
    li $s1, 0                 # Start at column 0
diag1_col_loop:
    li $t0, 3                 # Limit start to row/col 2 (0-2), since 2+3=5 fits grid
    bge $s0, $t0, next_diag1_row
    bge $s1, $t0, next_diag1_col
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 1          # Down 1, right 1
    addi $a1, $s1, 1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 2          # Down 2, right 2
    addi $a1, $s1, 2
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    addi $a0, $s0, 3          # Down 3, right 3
    addi $a1, $s1, 3
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag1_win
    li $v0, 1                 # Four in a diagonal—win!
    j win_cleanup
no_diag1_win:
    move $a0, $s0             # Restore row
    addi $s1, $s1, 1          # Next starting column
    li $t0, 3                 # Reset limit
    j diag1_col_loop          # Try next diagonal
next_diag1_col:
    addi $s0, $s0, 1          # Next starting row
    li $t0, 6                 # Grid has 6 rows
    blt $s0, $t0, diag1_row_loop  # If row < 6, keep going
next_diag1_row:
    nop                       # Placeholder for end of diagonal 1 check

    # Diagonal check (top-right to bottom-left): Look for four in opposite diagonal
    li $s0, 0                 # Start at row 0
diag2_row_loop:
    li $s1, 3                 # Start at column 3 (since 3-3=0 fits grid)
diag2_col_loop:
    li $t0, 3                 # Limit start row to 2
    bge $s0, $t0, next_diag2_row
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 1          # Down 1, left 1
    addi $a1, $s1, -1
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 2          # Down 2, left 2
    addi $a1, $s1, -2
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    addi $a0, $s0, 3          # Down 3, left 3
    addi $a1, $s1, -3
    jal get_ownership
    lw $t1, 12($sp)
    bne $v0, $t1, no_diag2_win
    li $v0, 1                 # Four in a diagonal—win!
    j win_cleanup
no_diag2_win:
    move $a0, $s0             # Restore row
    addi $s1, $s1, 1          # Next starting column (3-5)
    li $t0, 6                 # Grid has 6 columns
    blt $s1, $t0, diag2_col_loop  # If col < 6, try next
next_diag2_row:
    addi $s0, $s0, 1          # Next starting row
    li $t0, 6                 # Grid has 6 rows
    blt $s0, $t0, diag2_row_loop  # If row < 6, keep going

    li $v0, 0                 # No win found after all checks
win_cleanup:
    lw $ra, 0($sp)            # Restore return address
    lw $s0, 4($sp)            # Restore $s0
    lw $s1, 8($sp)            # Restore $s1
    lw $a0, 12($sp)           # Restore $a0 (original player number)
    lw $t0, 16($sp)           # Restore $t0
    lw $t1, 20($sp)           # Restore $t1
    addi $sp, $sp, 24         # Deallocate stack space
    jr $ra                    # Return to caller

# is_board_full: Checks if the 6x6 board has no empty cells (all 1s or 2s)
# Output: $v0 = 1 if full, 0 if not full
is_board_full:
    addi $sp, $sp, -16        # Allocate 16 bytes for 4 registers
    sw $ra, 0($sp)            # Save return address
    sw $s0, 4($sp)            # Save $s0 (row counter)
    sw $s1, 8($sp)            # Save $s1 (column counter)
    sw $t0, 12($sp)           # Save $t0 (loop limit)

    li $s0, 0                 # Start at row 0
full_row_loop:
    li $s1, 0                 # Start at column 0
full_col_loop:
    move $a0, $s0             # Set row for get_ownership
    move $a1, $s1             # Set column
    jal get_ownership         # Get cell value
    beqz $v0, not_full        # If cell = 0 (empty), board isn’t full
    addi $s1, $s1, 1          # Next column
    li $t0, 6                 # Grid width is 6
    blt $s1, $t0, full_col_loop  # If col < 6, check next column
    addi $s0, $s0, 1          # Next row
    li $t0, 6                 # Grid height is 6
    blt $s0, $t0, full_row_loop  # If row < 6, check next row

    li $v0, 1                 # All cells checked, none empty—board is full
    j full_cleanup            # Jump to cleanup
not_full:
    li $v0, 0                 # Found an empty cell—board not full
full_cleanup:
    lw $ra, 0($sp)            # Restore return address
    lw $s0, 4($sp)            # Restore $s0
    lw $s1, 8($sp)            # Restore $s1
    lw $t0, 12($sp)           # Restore $t0
    addi $sp, $sp, 16         # Deallocate stack space
    jr $ra                    # Return to caller
