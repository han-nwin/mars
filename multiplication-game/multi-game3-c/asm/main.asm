.data
welcome:    .asciiz "Welcome to Multiplication Four!\n"       # Welcome message
startmsg:   .asciiz "Press Enter to start..."                 # Prompt to start game
yourturn:   .asciiz "Your turn (X)"                          # Player turn indicator
compturn:   .asciiz "Computer's turn (O)"                    # Computer turn indicator
gameover:   .asciiz "Game Over"                              # Game over message
youwin:     .asciiz "You win!\n"                             # Player win message
compwin:    .asciiz "Computer wins!\n"                       # Computer win message
tie:        .asciiz "It's a tie!\n"                          # Tie message
nomoves:    .asciiz "You win! (Computer has no moves)\n"     # Win due to computer out of moves
invalidmove:.asciiz "Invalid move! Try again.\n"             # Invalid move feedback

.text
.globl main
main:
    # Seed random number generator for computer moves
    li $v0, 30          # Syscall 30: Get system time
    syscall             # Returns time in $v0
    move $a0, $v0       # Move time to $a0 as seed
    li $v0, 40          # Syscall 40: Set random seed
    syscall             # Seed set for randomness

    # Display welcome message and start prompt
    la $a0, welcome     # Load address of welcome string
    li $v0, 4           # Syscall 4: Print string
    syscall             # Print "Welcome to Multiplication Four!"
    la $a0, startmsg    # Load address of start message
    syscall             # Print "Press Enter to start..."

wait_enter:
    # Wait for player to press Enter
    li $v0, 12          # Syscall 12: Read character
    syscall             # Read input into $v0
    bne $v0, 10, wait_enter  # If not newline (ASCII 10), keep waiting

    jal init_game     # Initialize game state (board, markers)

game_loop:
    # Player's turn
    la $a0, yourturn    # Load "Your turn (X)" message
    jal display_game_state  # Display current board and number line
    jal player_turn   # Handle player move
    beqz $v0, invalid_player_move  # If $v0 = 0 (invalid), print error and loop

    li $a0, 1           # Player 1 (X)
    jal check_win     # Check if player won
    bnez $v0, player_wins  # If $v0 != 0 (win), go to win state

    jal is_board_full # Check if board is full
    bnez $v0, game_tie  # If $v0 != 0 (full), go to tie state

    # Computer's turn
    la $a0, compturn    # Load "Computer's turn (O)" message
    jal display_game_state  # Display updated board
    addiu $sp, $sp, -8  # Allocate stack space for row, col
    move $a0, $sp       # Pass stack pointer to computer_turn
    jal computer_turn # Computer makes a move, stores row/col on stack
    lw $t0, 0($sp)      # Load row from stack
    lw $t1, 4($sp)      # Load col from stack
    addiu $sp, $sp, 8   # Deallocate stack space

    li $t2, -1          # -1 indicates no valid move
    beq $t0, $t2, no_computer_moves  # If row = -1, computer can’t move

    move $a0, $t0       # Row to $a0
    move $a1, $t1       # Col to $a1
    li $a2, 2           # Computer marker (O = 2)
    jal set_ownership # Set ownership[ row ][ col ] = 2

    li $a0, 2           # Player 2 (O)
    jal check_win     # Check if computer won
    bnez $v0, computer_wins  # If $v0 != 0 (win), go to win state

    jal is_board_full # Check if board is full
    bnez $v0, game_tie  # If $v0 != 0 (full), go to tie state

    j game_loop         # Repeat game loop

invalid_player_move:
    # Handle invalid player move
    la $a0, invalidmove # Load "Invalid move!" message
    li $v0, 4           # Syscall 4: Print string
    syscall             # Print feedback
    j game_loop         # Back to start of loop

player_wins:
    # Player victory
    la $a0, gameover    # Load "Game Over" message
    jal display_game_state  # Show final board
    la $a0, youwin      # Load "You win!" message
    li $v0, 4           # Syscall 4: Print string
    syscall             # Print victory message
    j exit              # End program

computer_wins:
    # Computer victory
    la $a0, gameover    # Load "Game Over" message
    jal display_game_state  # Show final board
    la $a0, compwin     # Load "Computer wins!" message
    li $v0, 4           # Syscall 4: Print string
    syscall             # Print victory message
    j exit              # End program

game_tie:
    # Tie game
    la $a0, gameover    # Load "Game Over" message
    jal display_game_state  # Show final board
    la $a0, tie         # Load "It's a tie!" message
    li $v0, 4           # Syscall 4: Print string
    syscall             # Print tie message
    j exit              # End program

no_computer_moves:
    # Player wins due to computer having no moves
    la $a0, gameover    # Load "Game Over" message
    jal display_game_state  # Show final board
    la $a0, nomoves     # Load "You win! (Computer has no moves)" message
    li $v0, 4           # Syscall 4: Print string
    syscall             # Print victory message
    j exit              # End program

exit:
    # Exit program
    li $v0, 10          # Syscall 10: Exit
    syscall             # Terminate execution
