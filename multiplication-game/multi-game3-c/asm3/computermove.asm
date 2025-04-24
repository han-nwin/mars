.data
    row_msg:   .asciiz "comp row: "
    col_msg:   .asciiz "comp col: "
    pick_msg:  .asciiz "comp pick: "
    space:     .asciiz " "
    newline:   .asciiz "\n"

.text
    .globl computer_turn

computer_turn:
    # Stack setup: Save registers and allocate space
    addi $sp, $sp, -32
    sw $ra, 0($sp)        # Save return address
    sw $s0, 4($sp)        # Save $s0 (bottom marker candidate)
    sw $s1, 8($sp)        # Save $s1 (top marker value)
    sw $s2, 12($sp)       # Save $s2 (product)
    sw $s3, 16($sp)       # Save $s3 (row from find_cell)
    sw $s4, 20($sp)       # Save $s4 (column from find_cell)
    sw $s5, 24($sp)       # Save $s5 (saved bottom marker for blocking)
    sw $s6, 28($sp)       # Save $s6 (saved bottom marker for winning)

    # Get current top marker
    jal get_top_marker
    move $s1, $v0         # Store top marker in $s1

    # Initialize variables for tracking best move
    li $s5, -1            # Best blocking move (-1 = none found)
    li $s6, -1            # Best winning move (-1 = none found)

    # Step 1: Check for blocking move (prevent player win)
    li $s0, 1             # Bottom marker candidate (1-9)
block_loop:
    mul $s2, $s1, $s0     # Compute product (top * bottom)
    move $a0, $s2
    jal find_cell
    move $s3, $v0         # Save row
    move $s4, $v1         # Save column
    li $t0, -1
    beq $s3, $t0, next_block  # Skip if product not in grid
    move $a0, $s3
    move $a1, $s4
    jal get_ownership
    bnez $v0, next_block  # Skip if cell already claimed
    # Simulate player move: Temporarily claim cell for player (1)
    move $a0, $s3
    move $a1, $s4
    li $a2, 1             # Player 1 (X)
    jal set_ownership
    # Check if player wins
    li $a0, 1             # Player 1
    jal check_win
    # Undo simulation
    move $a0, $s3
    move $a1, $s4
    li $a2, 0             # Reset to unclaimed
    jal set_ownership
    beq $v0, 1, block_found  # If player would win, this is a blocking move
    j next_block
block_found:
    move $s5, $s0         # Save bottom marker for blocking
    # Continue checking to ensure we don't miss a winning move
next_block:
    addi $s0, $s0, 1      # Next bottom marker
    li $t0, 10            # Upper bound (1-9)
    blt $s0, $t0, block_loop

    # Step 2: Check for winning move (computer wins)
    li $s0, 1             # Bottom marker candidate (1-9)
win_loop:
    mul $s2, $s1, $s0     # Compute product
    move $a0, $s2
    jal find_cell
    move $s3, $v0         # Save row
    move $s4, $v1         # Save column
    li $t0, -1
    beq $s3, $t0, next_win  # Skip if product not in grid
    move $a0, $s3
    move $a1, $s4
    jal get_ownership
    bnez $v0, next_win    # Skip if cell claimed
    # Simulate computer move: Temporarily claim cell for computer (2)
    move $a0, $s3
    move $a1, $s4
    li $a2, 2             # Computer (O)
    jal set_ownership
    # Check if computer wins
    li $a0, 2             # Player 2
    jal check_win
    # Undo simulation
    move $a0, $s3
    move $a1, $s4
    li $a2, 0             # Reset to unclaimed
    jal set_ownership
    beq $v0, 1, win_found  # If computer would win, this is a winning move
    j next_win
win_found:
    move $s6, $s0         # Save bottom marker for winning
    j execute_move        # No need to check further, winning move takes priority
next_win:
    addi $s0, $s0, 1      # Next bottom marker
    li $t0, 10            # Upper bound
    blt $s0, $t0, win_loop

    # Step 3: Choose move (win, block, or random)
    bge $s6, 1, use_win_move  # If winning move found, use it
    bge $s5, 1, use_block_move  # If blocking move found, use it
    j random_move         # Otherwise, use random move

use_win_move:
    move $s0, $s6         # Use winning bottom marker
    j execute_move

use_block_move:
    move $s0, $s5         # Use blocking bottom marker
    j execute_move

random_move:
    # Generate random number (1-9)
    li $a0, 1             # Random generator ID
    li $a1, 9             # Upper bound (0-8)
    li $v0, 42            # Syscall: Random int in range
    syscall
    addi $s0, $a0, 1      # Shift to 1-9

execute_move:
    # Print the chosen bottom marker
    la $a0, pick_msg
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall

    # Set bottom marker
    move $a0, $s0
    jal set_bottom_marker

    # Compute product and find cell
    jal get_top_marker
    move $s1, $v0
    jal get_bottom_marker
    mul $s2, $s1, $v0     # Product
    move $a0, $s2
    jal find_cell
    move $s3, $v0         # Row
    move $s4, $v1         # Column

    # Validate move
    li $t0, -1
    beq $s3, $t0, invalid_move
    move $a0, $s3
    move $a1, $s4
    jal get_ownership
    bnez $v0, invalid_move

    # Print row/col
    la $a0, row_msg
    li $v0, 4
    syscall
    move $a0, $s3
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall
    la $a0, col_msg
    li $v0, 4
    syscall
    move $a0, $s4
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Claim cell for computer (2)
    move $a0, $s3
    move $a1, $s4
    li $a2, 2
    jal set_ownership

    # Play sound for computer move
    li $v0, 31            # Syscall for MIDI note
    li $a0, 60            # Pitch (C4, lower note for computer)
    li $a1, 1000          # Duration (1000ms)
    li $a2, 0             # Instrument (piano)
    li $a3, 127           # Max volume
    syscall

    li $v0, 1             # Move succeeded
    j cleanup

invalid_move:
    li $v0, 0             # Move failed (main will retry)

cleanup:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    addi $sp, $sp, 32
    jr $ra
