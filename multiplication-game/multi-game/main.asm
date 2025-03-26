.text
# Main entry point of the program
main:
    # Seed the random number generator using system time
    li $v0, 30          # Syscall code to get system time
    syscall             # Get time into $v0
    move $a0, $v0       # Move time to $a0 as seed
    li $v0, 40          # Syscall code to set random seed
    syscall             # Set the seed

    # Print welcome message
    la $a0, welcome_msg # Load address of welcome message
    li $v0, 4           # Syscall code for print string
    syscall             # Print welcome message

    # Wait for user to press Enter
    li $v0, 12          # Syscall code to read character
    syscall             # Read Enter key

# Main game loop
game_loop:
    # Handle player's turn
    jal player_turn     # Call player_turn function
    beq $v0, 1, game_end  # If $v0 = 1 (game ended), jump to game_end

    # Handle computer's turn
    jal computer_turn   # Call computer_turn function
    beq $v0, 1, game_end  # If $v0 = 1 (game ended), jump to game_end

    j game_loop         # Loop back to start of game_loop

# Exit the program
game_end:
    li $v0, 10          # Syscall code to exit
    syscall             # Exit program

# Include other assembly files
.include "data.asm"     # Data declarations
.include "player.asm"   # Player turn logic
.include "computer.asm" # Computer turn logic
.include "display.asm"  # Display functions
.include "game_logic.asm"  # Core game logic functions
