.text
# Handles the player's turn
# Output: $v0 = 1 if game ends (win/tie), 0 if continues
player_turn:
    # Allocate stack space and save return address
    addi $sp, $sp, -4       # Reserve 4 bytes on stack
    sw $ra, 0($sp)          # Save return address

    # Display current game state
    la $a0, your_turn_msg   # Load "Your turn" message
    jal display_game_state  # Call display function

    # Prompt for player input
    la $a0, prompt_msg      # Load input prompt
    li $v0, 4               # Syscall code for print string
    syscall                 # Print prompt

    # Read player's integer input
    li $v0, 5               # Syscall code for read integer
    syscall                 # Read input into $v0
    move $t0, $v0           # Move input to $t0 (new_pos)

    # Validate input (must be 1-9)
    li $t1, 1               # Minimum valid input
    li $t2, 9               # Maximum valid input
    blt $t0, $t1, invalid_input  # If < 1, invalid
    bgt $t0, $t2, invalid_input  # If > 9, invalid
    j input_valid           # Input is valid, proceed

invalid_input:
    # Handle invalid input
    la $a0, invalid_input_msg  # Load error message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print error
    li $v0, 0               # Return 0 (game continues)
    j player_turn_end       # Jump to end

input_valid:
    # Update top_marker with player's choice
    la $t1, top_marker      # Load address of top_marker
    sw $t0, 0($t1)          # Store new position

    # Calculate product of markers
    lw $t2, 0($t1)          # Load top_marker
    la $t3, bottom_marker   # Load address of bottom_marker
    lw $t4, 0($t3)          # Load bottom_marker
    mul $t5, $t2, $t4       # product = top_marker * bottom_marker

    # Find cell with this product
    move $a0, $t5           # Set product as argument
    jal find_cell           # Call find_cell function
    move $t6, $v0           # $t6 = row
    move $t7, $v1           # $t7 = col

    # Check if product exists in grid
    li $t8, -1              # Value for "not found"
    beq $t6, $t8, product_not_found  # If row = -1, product not found

    # Check if cell is already taken
    la $t9, ownership       # Load base address of ownership
    mul $t8, $t6, 24        # row * 24
    sll $t0, $t7, 2         # col * 4
    add $t8, $t8, $t0       # Offset = row * 24 + col * 4
    add $t8, $t8, $t9       # Full address = base + offset
    lw $t0, 0($t8)          # Load ownership[row][col]
    bne $t0, $zero, cell_taken  # If not 0, cell is taken

    # Claim the cell for player
    li $t0, 1               # Player value (X)
    sw $t0, 0($t8)          # Store 1 in ownership[row][col]

    # Print claim message
    la $a0, you_claim_msg   # Load "You claim" message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print message
    move $a0, $t5           # Set product as argument
    li $v0, 1               # Syscall code for print integer
    syscall                 # Print product
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline

    # Check if player wins
    li $a0, 1               # Player value (X)
    jal check_win           # Call check_win function
    beq $v0, 1, player_wins  # If $v0 = 1, player wins

    # Check if board is full (tie)
    jal is_board_full       # Call is_board_full function
    beq $v0, 1, tie_game    # If $v0 = 1, tie game

    li $v0, 0               # Game continues, return 0
    j player_turn_end       # Jump to end

product_not_found:
    # Handle product not in grid
    la $a0, product_not_found_msg  # Load error message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print error
    li $v0, 0               # Return 0 (game continues)
    j player_turn_end       # Jump to end

cell_taken:
    # Handle cell already taken
    la $a0, cell_taken_msg  # Load error message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print error
    li $v0, 0               # Return 0 (game continues)
    j player_turn_end       # Jump to end

player_wins:
    # Handle player win
    la $a0, your_turn_msg   # Load "Your turn" message
    jal display_game_state  # Display final state
    la $a0, you_win_msg     # Load win message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print win message
    li $v0, 1               # Return 1 (game ends)
    j player_turn_end       # Jump to end

tie_game:
    # Handle tie game
    la $a0, your_turn_msg   # Load "Your turn" message
    jal display_game_state  # Display final state
    la $a0, tie_msg         # Load tie message
    li $v0, 4               # Syscall code for print string
    syscall                 # Print tie message
    li $v0, 1               # Return 1 (game ends)

player_turn_end:
    # Restore return address and return
    lw $ra, 0($sp)          # Restore return address
    addi $sp, $sp, 4        # Deallocate stack space
    jr $ra                  # Return to caller
