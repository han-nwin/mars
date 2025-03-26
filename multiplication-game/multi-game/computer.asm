.text
# Handles the computer's turn
# Output: $v0 = 1 if game ends (win/tie), 0 if continues
computer_turn:
    # Allocate stack space and save return address
    addi $sp, $sp, -4       # Reserve 4 bytes on stack
    sw $ra, 0($sp)          # Save return address

    # Display current game state
    la $a0, computer_turn_msg  # Load "Computer's turn" message
    jal display_game_state  # Call display function

    # Computer makes a move
    jal computer_move       # Call computer_move function
    move $t6, $v0           # $t6 = row
    move $t7, $v1           # $t7 = col

    # Check if move is valid
    li $t8, -1              # Value for "no valid move"
    beq $t6, $t8, computer_no_moves  # If row = -1, no moves available

    # Claim the cell for computer
    la $t9, ownership       # Load base address of ownership
    mul $t8, $t6, 24        # row * 24
    sll $t0, $t7, 2         # col * 4
    add $t8, $t8, $t0       # Offset = row * 24 + col * 4
    add $t8, $t8, $t9       # Full address = base + offset
    li $t0, 2               # Computer value (O)
    sw $t0, 0($t8)          # Store 2 in ownership[row][col]

    # Calculate product for display
    la $t1, top_marker      # Load address of top_marker
    lw $t2, 0($t1)          # Load top_marker
    la $t3, bottom_marker   # Load address of bottom_marker
    lw $t4, 0($t3)          # Load bottom_marker
    mul $t5, $t2, $t4       # product = top_marker * bottom_marker

    # Print claim message
    la $a0, computer_claims_msg  # Load "Computer claims" message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print message
    move $a0, $t5           # Set product as argument
    li $v0, 1               # Syscall code for print integer
    syscall                 # Print product
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline

    # Check if computer wins
    li $a0, 2               # Computer value (O)
    jal check_win           # Call check_win function
    beq $v0, 1, computer_wins  # If $v0 = 1, computer wins

    # Check if board is full (tie)
    jal is_board_full       # Call is_board_full function
    beq $v0, 1, tie_game_computer  # If $v0 = 1, tie game

    li $v0, 0               # Game continues, return 0
    j computer_turn_end     # Jump to end

computer_no_moves:
    # Handle case where no valid moves are available
    li $v0, 0               # Return 0 (game continues, rare case)
    j computer_turn_end     # Jump to end

computer_wins:
    # Handle computer win
    la $a0, computer_turn_msg  # Load "Computer's turn" message
    jal display_game_state  # Display final state
    la $a0, computer_wins_msg  # Load win message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print win message
    li $v0, 1               # Return 1 (game ends)
    j computer_turn_end     # Jump to end

tie_game_computer:
    # Handle tie game
    la $a0, computer_turn_msg  # Load "Computer's turn" message
    jal display_game_state  # Display final state
    la $a0, tie_msg         # Load tie message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print tie message
    li $v0, 1               # Return 1 (game ends)

computer_turn_end:
    # Restore return address and return
    lw $ra, 0($sp)          # Restore return address
    addi $sp, $sp, 4        # Deallocate stack space
    jr $ra                  # Return to caller

# Determines a random valid move for the computer
# Output: $v0 = row, $v1 = col (-1, -1 if no valid moves)
computer_move:
    # Allocate stack space and save registers
    addi $sp, $sp, -12      # Reserve 12 bytes on stack
    sw $ra, 0($sp)          # Save return address
    sw $s0, 4($sp)          # Save $s0 (valid move count)
    sw $s1, 8($sp)          # Save $s1 (buffer address)

    # Find valid moves
    li $s0, 0               # Initialize valid move count
    li $t0, 1               # Start position (1-9)
    la $s1, buffer          # Load address of buffer for valid moves
find_valid_moves:
    # Try each position for bottom_marker
    la $t1, bottom_marker   # Load address of bottom_marker
    sw $t0, 0($t1)          # Set bottom_marker to current position
    la $t2, top_marker      # Load address of top_marker
    lw $t3, 0($t2)          # Load top_marker
    mul $t4, $t3, $t0       # product = top_marker * bottom_marker
    move $a0, $t4           # Set product as argument
    jal find_cell           # Call find_cell function
    move $t5, $v0           # $t5 = row
    move $t6, $v1           # $t6 = col

    # Check if product exists in grid
    li $t7, -1              # Value for "not found"
    beq $t5, $t7, not_valid_move  # If row = -1, not a valid move

    # Check if cell is available
    la $t7, ownership       # Load base address of ownership
    mul $t8, $t5, 24        # row * 24
    sll $t9, $t6, 2         # col * 4
    add $t8, $t8, $t9       # Offset = row * 24 + col * 4
    add $t8, $t8, $t7       # Full address = base + offset
    lw $t9, 0($t8)          # Load ownership[row][col]
    bne $t9, $zero, not_valid_move  # If not 0, cell is taken

    # Store valid move position in buffer
    sll $t9, $s0, 2         # count * 4 (word offset)
    add $t9, $t9, $s1       # buffer[count]
    sw $t0, 0($t9)          # Store position in buffer
    addi $s0, $s0, 1        # Increment valid move count

not_valid_move:
    addi $t0, $t0, 1        # Increment position
    li $t7, 10              # Max position + 1 (1-9)
    blt $t0, $t7, find_valid_moves  # If pos < 10, continue

    # Check if there are any valid moves
    beq $s0, $zero, no_valid_moves  # If count = 0, no moves

    # Pick a random valid move
    move $a1, $s0           # Set upper bound for random number
    li $v0, 42              # Syscall code for random int in range [0, $a1)
    syscall                 # Generate random index in $a0
    move $t0, $a0           # $t0 = random index

    # Get the chosen position from buffer
    sll $t1, $t0, 2         # index * 4
    add $t1, $t1, $s1       # buffer[index]
    lw $t2, 0($t1)          # Load position from buffer
    la $t3, bottom_marker   # Load address of bottom_marker
    sw $t2, 0($t3)          # Update bottom_marker with chosen position

    # Find the cell for the new product
    la $t4, top_marker      # Load address of top_marker
    lw $t5, 0($t4)          # Load top_marker
    mul $a0, $t5, $t2       # product = top_marker * bottom_marker
    jal find_cell           # Call find_cell function
    j computer_move_end     # Jump to end

no_valid_moves:
    # Handle no valid moves
    li $v0, -1              # Return row = -1
    li $v1, -1              # Return col = -1

computer_move_end:
    # Restore registers and return
    lw $ra, 0($sp)          # Restore return address
    lw $s0, 4($sp)          # Restore $s0
    lw $s1, 8($sp)          # Restore $s1
    addi $sp, $sp, 12       # Deallocate stack space
    jr $ra                  # Return to caller
