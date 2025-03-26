.text
# Finds the row and column of a product in the GRID
# Input: $a0 = product
# Output: $v0 = row, $v1 = col (-1, -1 if not found)
find_cell:
    li $v0, -1              # Initialize row to -1 (not found)
    li $v1, -1              # Initialize col to -1 (not found)

    li $t0, 0               # Initialize row counter
find_row_loop:
    li $t1, 0               # Initialize column counter
find_col_loop:
    # Calculate address of GRID[row][col]
    la $t2, GRID            # Load base address of GRID
    mul $t3, $t0, 24        # row * 24 (6 cols * 4 bytes)
    sll $t4, $t1, 2         # col * 4 (bytes per word)
    add $t3, $t3, $t4       # Offset = row * 24 + col * 4
    add $t3, $t3, $t2       # Full address = base + offset
    lw $t4, 0($t3)          # Load GRID[row][col] value

    # Check if this is the product we're looking for
    bne $t4, $a0, not_found_cell  # If not equal, skip to next cell
    move $v0, $t0           # Set row result
    move $v1, $t1           # Set col result
    jr $ra                  # Return with found position

not_found_cell:
    addi $t1, $t1, 1        # Increment column counter
    li $t5, 6               # Number of columns
    blt $t1, $t5, find_col_loop  # If col < 6, continue column loop

    addi $t0, $t0, 1        # Increment row counter
    li $t5, 6               # Number of rows
    blt $t0, $t5, find_row_loop  # If row < 6, continue row loop

    jr $ra                  # Return (-1, -1) if not found

# Checks if a player has four in a row
# Input: $a0 = player (1 for X, 2 for O)
# Output: $v0 = 1 if win, 0 if no win
check_win:
    # Allocate stack space and save registers
    addi $sp, $sp, -12      # Reserve 12 bytes on stack
    sw $ra, 0($sp)          # Save return address
    sw $s0, 4($sp)          # Save $s0 (player)
    sw $s1, 8($sp)          # Save $s1 (unused, reserved)

    move $s0, $a0           # Save player value in $s0

    # Check horizontal wins
    li $t0, 0               # Initialize row counter
check_horiz_row:
    li $t1, 0               # Initialize column counter
check_horiz_col:
    li $t2, 0               # Initialize offset counter (i)
    li $t3, 1               # Win flag (1 = potential win)
check_horiz_i:
    # Calculate address of ownership[row][col+i]
    la $t4, ownership       # Load base address of ownership
    mul $t5, $t0, 24        # row * 24
    add $t6, $t1, $t2       # col + i
    sll $t6, $t6, 2         # (col + i) * 4
    add $t5, $t5, $t6       # Offset = row * 24 + (col + i) * 4
    add $t5, $t5, $t4       # Full address = base + offset
    lw $t6, 0($t5)          # Load ownership[row][col+i]
    beq $t6, $s0, horiz_i_next  # If matches player, continue
    li $t3, 0               # Set win flag to 0 (no win)
    j horiz_win_check       # Check win condition

horiz_i_next:
    addi $t2, $t2, 1        # Increment offset (i)
    li $t7, 4               # Check 4 cells
    blt $t2, $t7, check_horiz_i  # If i < 4, continue

horiz_win_check:
    beq $t3, 1, win_found   # If win flag = 1, player wins

    addi $t1, $t1, 1        # Increment column counter
    li $t7, 3               # Max starting col for 4 in a row (6-4+1)
    blt $t1, $t7, check_horiz_col  # If col < 3, continue

    addi $t0, $t0, 1        # Increment row counter
    li $t7, 6               # Number of rows
    blt $t0, $t7, check_horiz_row  # If row < 6, continue

    # Check vertical wins
    li $t0, 0               # Initialize row counter
check_vert_row:
    li $t1, 0               # Initialize column counter
check_vert_col:
    li $t2, 0               # Initialize offset counter (i)
    li $t3, 1               # Win flag (1 = potential win)
check_vert_i:
    # Calculate address of ownership[row+i][col]
    la $t4, ownership       # Load base address of ownership
    add $t5, $t0, $t2       # row + i
    mul $t5, $t5, 24        # (row + i) * 24
    sll $t6, $t1, 2         # col * 4
    add $t5, $t5, $t6       # Offset = (row + i) * 24 + col * 4
    add $t5, $t5, $t4       # Full address = base + offset
    lw $t6, 0($t5)          # Load ownership[row+i][col]
    beq $t6, $s0, vert_i_next  # If matches player, continue
    li $t3, 0               # Set win flag to 0 (no win)
    j vert_win_check        # Check win condition

vert_i_next:
    addi $t2, $t2, 1        # Increment offset (i)
    li $t7, 4               # Check 4 cells
    blt $t2, $t7, check_vert_i  # If i < 4, continue

vert_win_check:
    beq $t3, 1, win_found   # If win flag = 1, player wins

    addi $t1, $t1, 1        # Increment column counter
    li $t7, 6               # Number of columns
    blt $t1, $t7, check_vert_col  # If col < 6, continue

    addi $t0, $t0, 1        # Increment row counter
    li $t7, 3               # Max starting row for 4 in a row (6-4+1)
    blt $t0, $t7, check_vert_row  # If row < 3, continue

    # Check diagonal wins (top-left to bottom-right)
    li $t0, 0               # Initialize row counter
check_diag1_row:
    li $t1, 0               # Initialize column counter
check_diag1_col:
    li $t2, 0               # Initialize offset counter (i)
    li $t3, 1               # Win flag (1 = potential win)
check_diag1_i:
    # Calculate address of ownership[row+i][col+i]
    la $t4, ownership       # Load base address of ownership
    add $t5, $t0, $t2       # row + i
    mul $t5, $t5, 24        # (row + i) * 24
    add $t6, $t1, $t2       # col + i
    sll $t6, $t6, 2         # (col + i) * 4
    add $t5, $t5, $t6       # Offset = (row + i) * 24 + (col + i) * 4
    add $t5, $t5, $t4       # Full address = base + offset
    lw $t6, 0($t5)          # Load ownership[row+i][col+i]
    beq $t6, $s0, diag1_i_next  # If matches player, continue
    li $t3, 0               # Set win flag to 0 (no win)
    j diag1_win_check       # Check win condition

diag1_i_next:
    addi $t2, $t2, 1        # Increment offset (i)
    li $t7, 4               # Check 4 cells
    blt $t2, $t7, check_diag1_i  # If i < 4, continue

diag1_win_check:
    beq $t3, 1, win_found   # If win flag = 1, player wins

    addi $t1, $t1, 1        # Increment column counter
    li $t7, 3               # Max starting col for 4 in a row
    blt $t1, $t7, check_diag1_col  # If col < 3, continue

    addi $t0, $t0, 1        # Increment row counter
    li $t7, 3               # Max starting row for 4 in a row
    blt $t0, $t7, check_diag1_row  # If row < 3, continue

    # Check diagonal wins (top-right to bottom-left)
    li $t0, 0               # Initialize row counter
check_diag2_row:
    li $t1, 3               # Initialize column counter (start at col 3)
check_diag2_col:
    li $t2, 0               # Initialize offset counter (i)
    li $t3, 1               # Win flag (1 = potential win)
check_diag2_i:
    # Calculate address of ownership[row+i][col-i]
    la $t4, ownership       # Load base address of ownership
    add $t5, $t0, $t2       # row + i
    mul $t5, $t5, 24        # (row + i) * 24
    sub $t6, $t1, $t2       # col - i
    sll $t6, $t6, 2         # (col - i) * 4
    add $t5, $t5, $t6       # Offset = (row + i) * 24 + (col - i) * 4
    add $t5, $t5, $t4       # Full address = base + offset
    lw $t6, 0($t5)          # Load ownership[row+i][col-i]
    beq $t6, $s0, diag2_i_next  # If matches player, continue
    li $t3, 0               # Set win flag to 0 (no win)
    j diag2_win_check       # Check win condition

diag2_i_next:
    addi $t2, $t2, 1        # Increment offset (i)
    li $t7, 4               # Check 4 cells
    blt $t2, $t7, check_diag2_i  # If i < 4, continue

diag2_win_check:
    beq $t3, 1, win_found   # If win flag = 1, player wins

    addi $t1, $t1, 1        # Increment column counter
    li $t7, 6               # Max column index + 1
    blt $t1, $t7, check_diag2_col  # If col < 6, continue

    addi $t0, $t0, 1        # Increment row counter
    li $t7, 3               # Max starting row for 4 in a row
    blt $t0, $t7, check_diag2_row  # If row < 3, continue

    li $v0, 0               # No win found, return 0
    j check_win_end         # Jump to end

win_found:
    li $v0, 1               # Win found, return 1

check_win_end:
    # Restore registers and return
    lw $ra, 0($sp)          # Restore return address
    lw $s0, 4($sp)          # Restore $s0
    lw $s1, 8($sp)          # Restore $s1
    addi $sp, $sp, 12       # Deallocate stack space
    jr $ra                  # Return to caller

# Checks if the board is full (no empty cells)
# Output: $v0 = 1 if full, 0 if not full
is_board_full:
    li $t0, 0               # Initialize row counter
board_full_row:
    li $t1, 0               # Initialize column counter
board_full_col:
    # Calculate address of ownership[row][col]
    la $t2, ownership       # Load base address of ownership
    mul $t3, $t0, 24        # row * 24
    sll $t4, $t1, 2         # col * 4
    add $t3, $t3, $t4       # Offset = row * 24 + col * 4
    add $t3, $t3, $t2       # Full address = base + offset
    lw $t4, 0($t3)          # Load ownership[row][col]
    beq $t4, $zero, not_full  # If empty (0), board is not full

    addi $t1, $t1, 1        # Increment column counter
    li $t5, 6               # Number of columns
    blt $t1, $t5, board_full_col  # If col < 6, continue

    addi $t0, $t0, 1        # Increment row counter
    li $t5, 6               # Number of rows
    blt $t0, $t5, board_full_row  # If row < 6, continue

    li $v0, 1               # Board is full, return 1
    jr $ra                  # Return to caller

not_full:
    li $v0, 0               # Board is not full, return 0
    jr $ra                  # Return to caller
