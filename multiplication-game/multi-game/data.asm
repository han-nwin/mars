.data
    # 6x6 grid of predefined products (stored as 36 words)
    GRID: .word 1, 2, 3, 4, 5, 6,     # Row 0
                7, 8, 9, 10, 12, 14,  # Row 1
                15, 16, 18, 20, 21, 24,  # Row 2
                25, 27, 28, 30, 32, 35,  # Row 3
                36, 40, 42, 45, 48, 49,  # Row 4
                54, 56, 63, 64, 72, 81   # Row 5

    # Ownership array: 0 = empty, 1 = Player (X), 2 = Computer (O)
    ownership: .space 144   # 6x6 * 4 bytes = 144 bytes

    # Markers for player and computer
    top_marker: .word 1     # Player's marker (initially 1)
    bottom_marker: .word 1  # Computer's marker (initially 1)

    # Strings for game output
    welcome_msg: .asciiz "Welcome to Multiplication Four!\nMove the top marker (1-9) to claim cells. Four in a row wins!\nYou are X, Computer is O.\nPress Enter to start...\n"
    your_turn_msg: .asciiz "Your turn (X)\n"    # Player turn prompt
    computer_turn_msg: .asciiz "Computer's turn (O)\n"  # Computer turn prompt
    number_line_msg: .asciiz "Number line: 1 2 3 4 5 6 7 8 9\n"  # Number line display
    product_msg: .asciiz "Product: "    # Product label
    x_msg: .asciiz " x "                # Multiplication symbol
    eq_msg: .asciiz " = "               # Equals sign
    newline: .asciiz "\n"               # Newline character
    space: .asciiz " "                  # Space character
    pipe: .asciiz "|"                   # Grid separator
    v_marker: .asciiz "v"               # Player's marker symbol
    caret_marker: .asciiz "^"           # Computer's marker symbol
    x_char: .asciiz "X"                 # Player's cell marker
    o_char: .asciiz "O"                 # Computer's cell marker
    prompt_msg: .asciiz "Move the top marker to a number (1-9): "  # Input prompt
    invalid_input_msg: .asciiz "Invalid input, enter a number between 1 and 9.\n"  # Error message
    product_not_found_msg: .asciiz "Product not in the grid, try again.\n"  # Error message
    cell_taken_msg: .asciiz "Cell already taken, try again.\n"  # Error message
    you_claim_msg: .asciiz "You claim "    # Player claim message
    computer_claims_msg: .asciiz "Computer claims "  # Computer claim message
    you_win_msg: .asciiz "You win!\n"      # Player win message
    computer_wins_msg: .asciiz "Computer wins!\n"  # Computer win message
    tie_msg: .asciiz "It's a tie!\n"       # Tie message

    # Buffers
    num_buffer: .space 4    # Buffer for formatted number strings (e.g., " 1 ", "81 ")
    buffer: .space 20       # Buffer for storing valid computer moves
