.data
    # 6x6 grid of numbers for the game (products of 1-9)
    GRID:   .word 1, 2, 3, 4, 5, 6
            .word 7, 8, 9, 10, 12, 14
            .word 15, 16, 18, 20, 21, 24
            .word 25, 27, 28, 30, 32, 35
            .word 36, 40, 42, 45, 48, 49
            .word 54, 56, 63, 64, 72, 81
    ownership: .word 0:36           # Array tracking cell ownership (0 = empty, 1 = player, 2 = computer)
    top_marker: .word 1             # Initial top marker position (1-9)
    bottom_marker: .word 1          # Initial bottom marker position (1-9)

    # Strings for game output
    comp_row_msg: .asciiz "comp row: "  # Label for computer’s row coordinate
    comp_col_msg: .asciiz "comp col: "  # Label for computer’s column coordinate
    space:        .asciiz " "           # Space for formatting
    newline:      .asciiz "\n"          # Newline for line breaks
    pick_msg:     .asciiz "comp pick: " # Label for computer’s chosen number
    player_win:   .asciiz "You win!\n"  # Victory message for player
    comp_win:     .asciiz "Computer wins!\n"  # Victory message for computer
    tie_msg:      .asciiz "It's a tie!\n"     # Message for a draw

.text
    .globl main                     # Main entry point of the game
    .globl init_game                # Initialize game state
    .globl get_grid_value           # Get number at grid position
    .globl get_ownership            # Get ownership of a cell
    .globl set_ownership            # Set ownership of a cell
    .globl get_top_marker           # Get top marker value
    .globl get_bottom_marker        # Get bottom marker value
    .globl set_top_marker           # Set top marker value
    .globl set_bottom_marker        # Set bottom marker value
    .globl find_cell                # Find grid coordinates for a number

# main: Main game loop—seeds random, initializes, alternates player and computer turns
main:
    # Seed the random number generator
    li $v0, 30                      # Syscall to get system time
    syscall                         # Returns time in $a0
    move $a1, $a0                   # Use time as seed
    li $a0, 1                       # Random generator ID 1
    li $v0, 40                      # Syscall to set seed
    syscall

    jal init_game                   # Set up initial game state
    jal display_game_state          # Show initial board

game_loop:
    jal player_turn                 # Execute player’s turn
    move $t0, $v0                   # Store result (1 = success, 0 = invalid)
    beqz $t0, game_loop             # If invalid move, retry player turn
    move $a0, $t0                   # Load result (1) to print
    li $v0, 1                       # Syscall to print integer
    syscall                         # Print "1" for success
    la $a0, newline                 # Load newline
    li $v0, 4                       # Syscall to print string
    syscall
    jal display_game_state          # Update and show board

    li $a0, 1                       # Player 1’s number
    jal check_win                   # Check if player won
    beq $v0, 1, player_wins         # If win ($v0 = 1), jump to victory
    jal is_board_full               # Check if board is full
    beq $v0, 1, tie_game            # If full ($v0 = 1), jump to tie

computer_loop:
    jal computer_turn               # Execute computer’s turn
    move $t0, $v0                   # Store result (1 = success, 0 = invalid)
    beqz $t0, computer_loop         # If invalid move, retry computer turn
    jal display_game_state          # Update and show board
    jal get_bottom_marker           # Get computer’s chosen marker (for spacing)
    la $a0, space                   # Load space
    li $v0, 4                       # Syscall to print string
    syscall
    la $a0, newline                 # Load newline
    li $v0, 4
    syscall

    li $a0, 2                       # Player 2’s number (computer)
    jal check_win                   # Check if computer won
    beq $v0, 1, comp_wins           # If win ($v0 = 1), jump to victory
    jal is_board_full               # Check if board is full
    beq $v0, 1, tie_game            # If full ($v0 = 1), jump to tie

    j game_loop                     # Back to player’s turn

player_wins:
    la $a0, player_win              # Load player win message
    li $v0, 4                       # Syscall to print string
    syscall
    j end_game                      # End the game
comp_wins:
    la $a0, comp_win                # Load computer win message
    li $v0, 4
    syscall
    j end_game                      # End the game
tie_game:
    la $a0, tie_msg                 # Load tie message
    li $v0, 4
    syscall
end_game:
    li $v0, 10                      # Syscall to exit program
    syscall

# init_game: Resets game state—clears ownership, sets markers to 1
init_game:
    la $t0, ownership               # Load base address of ownership array
    li $t1, 36                      # Total cells in 6x6 grid
    li $t2, 0                       # Value to clear cells (unclaimed)
init_loop:
    sw $t2, 0($t0)                  # Set cell to 0
    addi $t0, $t0, 4                # Move to next word (4 bytes)
    addi $t1, $t1, -1               # Decrement counter
    bnez $t1, init_loop             # If counter > 0, keep looping
    la $t0, top_marker              # Load top marker address
    li $t1, 1                       # Initial value of 1
    sw $t1, 0($t0)                  # Set top marker to 1
    la $t0, bottom_marker           # Load bottom marker address
    sw $t1, 0($t0)                  # Set bottom marker to 1
    jr $ra                          # Return

# get_grid_value: Retrieves the original number at a grid position
# Input: $a0 = row, $a1 = col
# Output: $v0 = grid value (e.g., 1, 2, 3, etc.)
get_grid_value:
    li $t0, 6                       # Grid width (6 columns)
    mul $t1, $a0, $t0               # Calculate row offset (row * 6)
    add $t1, $t1, $a1               # Add column offset (row * 6 + col)
    sll $t1, $t1, 2                 # Multiply by 4 (bytes per word)
    la $t2, GRID                    # Load base address of GRID
    add $t1, $t2, $t1               # Compute final address
    lw $v0, 0($t1)                  # Load value at position
    jr $ra                          # Return

# get_ownership: Retrieves ownership status of a cell
# Input: $a0 = row, $a1 = col
# Output: $v0 = 0 (empty), 1 (player), 2 (computer)
get_ownership:
    li $t0, 6                       # Grid width
    mul $t1, $a0, $t0               # Row offset
    add $t1, $t1, $a1               # Add column offset
    sll $t1, $t1, 2                 # Multiply by 4 for byte offset
    la $t2, ownership               # Load base address of ownership
    add $t1, $t2, $t1               # Compute final address
    lw $v0, 0($t1)                  # Load ownership value
    jr $ra                          # Return

# set_ownership: Sets ownership of a cell
# Input: $a0 = row, $a1 = col, $a2 = player (1 or 2)
set_ownership:
    li $t0, 6                       # Grid width
    mul $t1, $a0, $t0               # Row offset
    add $t1, $t1, $a1               # Add column offset
    sll $t1, $t1, 2                 # Multiply by 4 for byte offset
    la $t2, ownership               # Load base address of ownership
    add $t1, $t2, $t1               # Compute final address
    sw $a2, 0($t1)                  # Store player number in cell
    jr $ra                          # Return

# get_top_marker: Retrieves current top marker value
# Output: $v0 = top marker (1-9)
get_top_marker:
    la $t0, top_marker              # Load top marker address
    lw $v0, 0($t0)                  # Load value
    jr $ra                          # Return

# get_bottom_marker: Retrieves current bottom marker value
# Output: $v0 = bottom marker (1-9)
get_bottom_marker:
    la $t0, bottom_marker           # Load bottom marker address
    lw $v0, 0($t0)                  # Load value
    jr $ra                          # Return

# set_top_marker: Updates top marker value
# Input: $a0 = new top marker value (1-9)
set_top_marker:
    la $t0, top_marker              # Load top marker address
    sw $a0, 0($t0)                  # Store new value
    jr $ra                          # Return

# set_bottom_marker: Updates bottom marker value
# Input: $a0 = new bottom marker value (1-9)
set_bottom_marker:
    la $t0, bottom_marker           # Load bottom marker address
    sw $a0, 0($t0)                  # Store new value
    jr $ra                          # Return

# find_cell: Finds grid coordinates for a given number
# Input: $a0 = target number (product of markers)
# Output: $v0 = row, $v1 = col, or -1/-1 if not found
find_cell:
    la $t0, GRID                    # Load base address of GRID
    li $t1, 0                       # Row counter
    li $t2, 0                       # Column counter
    li $t3, 36                      # Total cells to check
    li $t4, 0                       # Index counter
find_loop:
    lw $t5, 0($t0)                  # Load current grid value
    beq $t5, $a0, found             # If value matches target, jump to found
    addi $t0, $t0, 4                # Move to next word
    addi $t4, $t4, 1                # Increment index
    li $t6, 6                       # Grid width for division
    div $t4, $t6                    # Divide index by 6
    mfhi $t2                        # Remainder = column
    mflo $t1                        # Quotient = row
    bne $t4, $t3, find_loop         # If index < 36, keep searching
    li $v0, -1                      # Number not found, return row = -1
    li $v1, -1                      # Return col = -1
    jr $ra                          # Return
found:
    move $v0, $t1                   # Return row
    move $v1, $t2                   # Return column
    jr $ra                          # Return
