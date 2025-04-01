.data
    # 6x6 grid of numbers for the game (products of 1-9)
    .globl GRID
    GRID:   .word 1, 2, 3, 4, 5, 6
            .word 7, 8, 9, 10, 12, 14
            .word 15, 16, 18, 20, 21, 24
            .word 25, 27, 28, 30, 32, 35
            .word 36, 40, 42, 45, 48, 49
            .word 54, 56, 63, 64, 72, 81
    .globl ownership
    ownership: .word 0:36           # Array tracking cell ownership (0 = empty, 1 = player, 2 = computer)
    .globl top_marker
    top_marker: .word 1             # Initial top marker position (1-9)
    .globl bottom_marker
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
