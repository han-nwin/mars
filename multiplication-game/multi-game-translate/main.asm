.text
main:
    # Seed random number generator with system time
    li $v0, 30          # Get system time
    syscall
    move $a0, $v0       # Use time as seed
    li $v0, 40          # Set seed
    syscall

    # Start the game
    jal play_game

    # Exit
    li $v0, 10
    syscall