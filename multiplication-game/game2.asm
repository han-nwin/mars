# MIPS 32-bit Assembly Code for Multiplication Four Game
# Player (X) vs Computer (O), 6x6 grid, four in a row wins
# Grid display fixed for proper alignment (3 characters per cell)

.data
    # 6x6 grid with predefined products (stored as 36 integers)
    GRID: .word 1, 2, 3, 4, 5, 6,
                7, 8, 9, 10, 12, 14,
                15, 16, 18, 20, 21, 24,
                25, 27, 28, 30, 32, 35,
                36, 40, 42, 45, 48, 49,
                54, 56, 63, 64, 72, 81

    # Ownership array: 0 = empty, 1 = Player (X), 2 = Computer (O)
    ownership: .space 144  # 6x6 * 4 bytes = 144 bytes

    # Markers
    top_marker: .word 1  # Player's marker
    bottom_marker: .word 1  # Computer's marker

    # Strings for output
    welcome_msg: .asciiz "Welcome to Multiplication Four!\nMove the top marker (1-9) to claim cells. Four in a row wins!\nYou are X, Computer is O.\nPress Enter to start...\n"
    your_turn_msg: .asciiz "Your turn (X)\n"
    computer_turn_msg: .asciiz "Computer's turn (O)\n"
    number_line_msg: .asciiz "Number line: 1 2 3 4 5 6 7 8 9\n"
    product_msg: .asciiz "Product: "
    x_msg: .asciiz " x "
    eq_msg: .asciiz " = "
    newline: .asciiz "\n"
    space: .asciiz " "
    pipe: .asciiz "|"
    v_marker: .asciiz "v"
    caret_marker: .asciiz "^"
    x_char: .asciiz "X"
    o_char: .asciiz "O"
    prompt_msg: .asciiz "Move the top marker to a number (1-9): "
    invalid_input_msg: .asciiz "Invalid input, enter a number between 1 and 9.\n"
    product_not_found_msg: .asciiz "Product not in the grid, try again.\n"
    cell_taken_msg: .asciiz "Cell already taken, try again.\n"
    you_claim_msg: .asciiz "You claim "
    computer_claims_msg: .asciiz "Computer claims "
    you_win_msg: .asciiz "You win!\n"
    computer_wins_msg: .asciiz "Computer wins!\n"
    no_moves_msg: .asciiz "Computer has no valid moves.\n"
    tie_msg: .asciiz "It's a tie!\n"
    num_buffer: .space 4  # Buffer for number strings (e.g., " 1 ", "81 ")
    # Increase buffer size to handle up to 9 moves
    buffer: .space 36  # 9 words * 4 bytes

.text
main:
    # Seed the random number generator (using system time)
    li $v0, 30  # Syscall to get system time
    syscall
    move $a0, $v0  # Use time as seed
    li $v0, 40  # Syscall to set seed
    syscall

    # Print welcome message
    la $a0, welcome_msg
    li $v0, 4
    syscall

    # Wait for Enter to start
    li $v0, 12  # Read character
    syscall

game_loop:
    # Player's turn
    jal player_turn
    beq $v0, 1, game_end  # If $v0 == 1, game ended (win or tie)

    # Computer's turn
    jal computer_turn
    beq $v0, 1, game_end  # If $v0 == 1, game ended (win or tie)

    j game_loop

game_end:
    # Game ended, exit
    li $v0, 10
    syscall

player_turn:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Display game state
    la $a0, your_turn_msg
    jal display_game_state

    # Prompt for input
    la $a0, prompt_msg
    li $v0, 4
    syscall

    # Read integer input
    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = new_pos

    # Validate input (1-9)
    li $t1, 1
    li $t2, 9
    blt $t0, $t1, invalid_input
    bgt $t0, $t2, invalid_input
    j input_valid

invalid_input:
    la $a0, invalid_input_msg
    li $v0, 4
    syscall
    li $v0, 0  # Return 0 (game not ended)
    j player_turn_end

input_valid:
    # Update top_marker
    la $t1, top_marker
    sw $t0, 0($t1)

    # Calculate product
    lw $t2, 0($t1)  # top_marker
    la $t3, bottom_marker
    lw $t4, 0($t3)  # bottom_marker
    mul $t5, $t2, $t4  # product = top_marker * bottom_marker

    # Find cell
    move $a0, $t5
    jal find_cell
    move $t6, $v0  # row
    move $t7, $v1  # col

    # Check if product exists
    li $t8, -1
    beq $t6, $t8, product_not_found

    # Check if cell is taken
    la $t9, ownership
    mul $t8, $t6, 24  # row * 24 (6 columns * 4 bytes)
    sll $t0, $t7, 2   # col * 4
    add $t8, $t8, $t0
    add $t8, $t8, $t9  # Address of ownership[row][col]
    lw $t0, 0($t8)    # ownership[row][col]
    bne $t0, $zero, cell_taken

    # Claim the cell
    li $t0, 1  # Player = 1
    sw $t0, 0($t8)

    # Print "You claim {product}!"
    la $a0, you_claim_msg
    li $v0, 4
    syscall
    move $a0, $t5
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Check for win
    li $a0, 1  # Player = 1
    jal check_win
    beq $v0, 1, player_wins

    # Check for tie
    jal is_board_full
    beq $v0, 1, tie_game

    li $v0, 0  # Game not ended
    j player_turn_end

product_not_found:
    la $a0, product_not_found_msg
    li $v0, 4
    syscall
    li $v0, 0
    j player_turn_end

cell_taken:
    la $a0, cell_taken_msg
    li $v0, 4
    syscall
    li $v0, 0
    j player_turn_end

player_wins:
    la $a0, your_turn_msg
    jal display_game_state
    la $a0, you_win_msg
    li $v0, 4
    syscall
    li $v0, 1  # Game ended
    j player_turn_end

tie_game:
    la $a0, your_turn_msg
    jal display_game_state
    la $a0, tie_msg
    li $v0, 4
    syscall
    li $v0, 1  # Game ended

player_turn_end:
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

computer_turn:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    la $a0, computer_turn_msg
    jal display_game_state

    jal computer_move
    move $t6, $v0  # row
    move $t7, $v1  # col

    li $t8, -1
    beq $t6, $t8, computer_no_moves

    # Claim the cell
    la $t9, ownership
    mul $t8, $t6, 24
    sll $t0, $t7, 2
    add $t8, $t8, $t0
    add $t8, $t8, $t9
    li $t0, 2
    sw $t0, 0($t8)  # ownership[row][col] = 2

    # Use GRID[row][col] for product instead of recalculating
    la $t1, GRID
    mul $t2, $t6, 24
    sll $t3, $t7, 2
    add $t2, $t2, $t3
    add $t2, $t2, $t1
    lw $t5, 0($t2)  # product = GRID[row][col]

    la $a0, computer_claims_msg
    li $v0, 4
    syscall
    move $a0, $t5
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    li $a0, 2
    jal check_win
    beq $v0, 1, computer_wins

    jal is_board_full
    beq $v0, 1, tie_game_computer

    li $v0, 0
    j computer_turn_end

computer_no_moves:
    # Debug: Print a message to confirm this case
    la $a0, no_moves_msg
    li $v0, 4
    syscall
    li $v0, 0
    j computer_turn_end

computer_wins:
    la $a0, computer_turn_msg
    jal display_game_state
    la $a0, computer_wins_msg
    li $v0, 4
    syscall
    li $v0, 1
    j computer_turn_end

tie_game_computer:
    la $a0, computer_turn_msg
    jal display_game_state
    la $a0, tie_msg
    li $v0, 4
    syscall
    li $v0, 1

computer_turn_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

display_game_state:
    # $a0 = turn message
    # Save registers
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    # Print turn message
    li $v0, 4
    syscall

    # Display grid
    jal display_grid

    # Display number line
    jal display_number_line

    # Restore registers
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

display_grid:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    li $s0, 0  # row
grid_row_loop:
    li $s1, 0  # col
grid_col_loop:
    # Calculate ownership[row][col] address
    la $t0, ownership
    mul $t1, $s0, 24  # row * 24 (6 columns * 4 bytes)
    sll $t2, $s1, 2   # col * 4
    add $t1, $t1, $t2
    add $t1, $t1, $t0
    lw $t2, 0($t1)    # ownership[row][col]

    # Check ownership
    li $t3, 1
    beq $t2, $t3, print_x
    li $t3, 2
    beq $t2, $t3, print_o

    # Print number (GRID[row][col])
    la $t0, GRID
    mul $t1, $s0, 24
    sll $t2, $s1, 2
    add $t1, $t1, $t2
    add $t1, $t1, $t0
    lw $t3, 0($t1)  # GRID[row][col]

    # Convert number to string with padding
    la $t4, num_buffer
    li $t5, 32  # Space character
    sb $t5, 0($t4)  # First character is a space

    # Check if number is single or double digit
    li $t6, 10
    blt $t3, $t6, single_digit

    # Double digit (e.g., 81)
    div $t3, $t6
    mflo $t7  # Tens digit
    mfhi $t8  # Ones digit
    addi $t7, $t7, 48  # Convert to ASCII
    addi $t8, $t8, 48
    sb $t7, 1($t4)
    sb $t8, 2($t4)
    j print_number

single_digit:
    # Single digit (e.g., 1)
    addi $t7, $t3, 48  # Convert to ASCII
    sb $t7, 1($t4)
    sb $t5, 2($t4)  # Trailing space

print_number:
    # Null terminate the string
    sb $zero, 3($t4)
    move $a0, $t4
    li $v0, 4
    syscall
    j print_separator

print_x:
    la $a0, space
    li $v0, 4
    syscall
    la $a0, x_char
    li $v0, 4
    syscall
    la $a0, space
    li $v0, 4
    syscall
    j print_separator

print_o:
    la $a0, space
    li $v0, 4
    syscall
    la $a0, o_char
    li $v0, 4
    syscall
    la $a0, space
    li $v0, 4
    syscall
    j print_separator

print_separator:
    # Print separator if not last column
    li $t0, 5
    beq $s1, $t0, skip_pipe
    la $a0, pipe
    li $v0, 4
    syscall

skip_pipe:
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, grid_col_loop

    # Newline after row
    la $a0, newline
    li $v0, 4
    syscall

    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, grid_row_loop

    # Extra newline after grid
    la $a0, newline
    li $v0, 4
    syscall

    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

display_number_line:
    # Save registers
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    # Top marker (v for Player)
    la $t0, top_marker
    lw $t1, 0($t0)
    li $t2, 13
    addi $t3, $t1, -1
    mul $t3, $t3, 2
    add $s0, $t2, $t3  # top_position = 13 + (top_marker - 1) * 2

    li $t4, 0
top_spaces_loop:
    beq $t4, $s0, end_top_spaces
    la $a0, space
    li $v0, 4
    syscall
    addi $t4, $t4, 1
    j top_spaces_loop

end_top_spaces:
    la $a0, v_marker
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Number line
    la $a0, number_line_msg
    li $v0, 4
    syscall

    # Bottom marker (^ for Computer)
    la $t0, bottom_marker
    lw $t1, 0($t0)
    li $t2, 13
    addi $t3, $t1, -1
    mul $t3, $t3, 2
    add $s0, $t2, $t3  # bottom_position = 13 + (bottom_marker - 1) * 2

    li $t4, 0
bottom_spaces_loop:
    beq $t4, $s0, end_bottom_spaces
    la $a0, space
    li $v0, 4
    syscall
    addi $t4, $t4, 1
    j bottom_spaces_loop

end_bottom_spaces:
    la $a0, caret_marker
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Product
    la $a0, product_msg
    li $v0, 4
    syscall
    la $t0, top_marker
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    la $a0, x_msg
    li $v0, 4
    syscall
    la $t0, bottom_marker
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    la $a0, eq_msg
    li $v0, 4
    syscall
    la $t0, top_marker
    lw $t1, 0($t0)
    la $t0, bottom_marker
    lw $t2, 0($t0)
    mul $a0, $t1, $t2
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

find_cell:
    # $a0 = product
    # Returns: $v0 = row, $v1 = col
    li $v0, -1
    li $v1, -1

    li $t0, 0  # row
find_row_loop:
    li $t1, 0  # col
find_col_loop:
    la $t2, GRID
    mul $t3, $t0, 24
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    add $t3, $t3, $t2
    lw $t4, 0($t3)  # GRID[row][col]
    bne $t4, $a0, not_found_cell

    move $v0, $t0
    move $v1, $t1
    jr $ra

not_found_cell:
    addi $t1, $t1, 1
    li $t5, 6
    blt $t1, $t5, find_col_loop

    addi $t0, $t0, 1
    li $t5, 6
    blt $t0, $t5, find_row_loop

    jr $ra

check_win:
    # $a0 = player
    # Returns: $v0 = 1 if win, 0 otherwise
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0  # Save player

    # Check horizontal
    li $t0, 0  # row
check_horiz_row:
    li $t1, 0  # col
check_horiz_col:
    li $t2, 0  # i
    li $t3, 1  # win = 1
check_horiz_i:
    la $t4, ownership
    mul $t5, $t0, 24
    add $t6, $t1, $t2
    sll $t6, $t6, 2
    add $t5, $t5, $t6
    add $t5, $t5, $t4
    lw $t6, 0($t5)  # ownership[row][col+i]
    beq $t6, $s0, horiz_i_next
    li $t3, 0
    j horiz_win_check

horiz_i_next:
    addi $t2, $t2, 1
    li $t7, 4
    blt $t2, $t7, check_horiz_i

horiz_win_check:
    beq $t3, 1, win_found

    addi $t1, $t1, 1
    li $t7, 3
    blt $t1, $t7, check_horiz_col

    addi $t0, $t0, 1
    li $t7, 6
    blt $t0, $t7, check_horiz_row

    # Check vertical
    li $t0, 0  # row
check_vert_row:
    li $t1, 0  # col
check_vert_col:
    li $t2, 0  # i
    li $t3, 1  # win = 1
check_vert_i:
    la $t4, ownership
    add $t5, $t0, $t2
    mul $t5, $t5, 24
    sll $t6, $t1, 2
    add $t5, $t5, $t6
    add $t5, $t5, $t4
    lw $t6, 0($t5)  # ownership[row+i][col]
    beq $t6, $s0, vert_i_next
    li $t3, 0
    j vert_win_check

vert_i_next:
    addi $t2, $t2, 1
    li $t7, 4
    blt $t2, $t7, check_vert_i

vert_win_check:
    beq $t3, 1, win_found

    addi $t1, $t1, 1
    li $t7, 6
    blt $t1, $t7, check_vert_col

    addi $t0, $t0, 1
    li $t7, 3
    blt $t0, $t7, check_vert_row

    # Check diagonal (top-left to bottom-right)
    li $t0, 0  # row
check_diag1_row:
    li $t1, 0  # col
check_diag1_col:
    li $t2, 0  # i
    li $t3, 1  # win = 1
check_diag1_i:
    la $t4, ownership
    add $t5, $t0, $t2
    mul $t5, $t5, 24
    add $t6, $t1, $t2
    sll $t6, $t6, 2
    add $t5, $t5, $t6
    add $t5, $t5, $t4
    lw $t6, 0($t5)  # ownership[row+i][col+i]
    beq $t6, $s0, diag1_i_next
    li $t3, 0
    j diag1_win_check

diag1_i_next:
    addi $t2, $t2, 1
    li $t7, 4
    blt $t2, $t7, check_diag1_i

diag1_win_check:
    beq $t3, 1, win_found

    addi $t1, $t1, 1
    li $t7, 3
    blt $t1, $t7, check_diag1_col

    addi $t0, $t0, 1
    li $t7, 3
    blt $t0, $t7, check_diag1_row

    # Check diagonal (top-right to bottom-left)
    li $t0, 0  # row
check_diag2_row:
    li $t1, 3  # col
check_diag2_col:
    li $t2, 0  # i
    li $t3, 1  # win = 1
check_diag2_i:
    la $t4, ownership
    add $t5, $t0, $t2
    mul $t5, $t5, 24
    sub $t6, $t1, $t2
    sll $t6, $t6, 2
    add $t5, $t5, $t6
    add $t5, $t5, $t4
    lw $t6, 0($t5)  # ownership[row+i][col-i]
    beq $t6, $s0, diag2_i_next
    li $t3, 0
    j diag2_win_check

diag2_i_next:
    addi $t2, $t2, 1
    li $t7, 4
    blt $t2, $t7, check_diag2_i

diag2_win_check:
    beq $t3, 1, win_found

    addi $t1, $t1, 1
    li $t7, 6
    blt $t1, $t7, check_diag2_col

    addi $t0, $t0, 1
    li $t7, 3
    blt $t0, $t7, check_diag2_row

    li $v0, 0  # No win
    j check_win_end

win_found:
    li $v0, 1

check_win_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

is_board_full:
    li $t0, 0  # row
board_full_row:
    li $t1, 0  # col
board_full_col:
    la $t2, ownership
    mul $t3, $t0, 24
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    add $t3, $t3, $t2
    lw $t4, 0($t3)  # ownership[row][col]
    beq $t4, $zero, not_full

    addi $t1, $t1, 1
    li $t5, 6
    blt $t1, $t5, board_full_col

    addi $t0, $t0, 1
    li $t5, 6
    blt $t0, $t5, board_full_row

    li $v0, 1  # Board is full
    jr $ra

not_full:
    li $v0, 0
    jr $ra

computer_move:
    # Returns: $v0 = row, $v1 = col
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # Find valid moves
    li $s0, 0  # count
    li $t0, 1  # pos
    la $s1, buffer  # Use buffer to store valid moves
find_valid_moves:
    la $t1, bottom_marker
    sw $t0, 0($t1)  # bottom_marker = pos
    la $t2, top_marker
    lw $t3, 0($t2)
    mul $t4, $t3, $t0  # product
    move $a0, $t4
    jal find_cell
    move $t5, $v0  # row
    move $t6, $v1  # col

    li $t7, -1
    beq $t5, $t7, not_valid_move

    la $t7, ownership
    mul $t8, $t5, 24
    sll $t9, $t6, 2
    add $t8, $t8, $t9
    add $t8, $t8, $t7
    lw $t9, 0($t8)  # ownership[row][col]
    bne $t9, $zero, not_valid_move

    # Valid move, store pos
    sll $t9, $s0, 2
    add $t9, $t9, $s1
    sw $t0, 0($t9)
    addi $s0, $s0, 1

not_valid_move:
    addi $t0, $t0, 1
    li $t7, 10
    blt $t0, $t7, find_valid_moves

    # If no valid moves, return -1, -1
    beq $s0, $zero, no_valid_moves

    # Pick a random valid move
    move $a1, $s0  # Upper bound for random number
    li $v0, 42     # Random int in range [0, $a1)
    syscall
    move $t0, $a0  # Random index

    sll $t1, $t0, 2
    add $t1, $t1, $s1
    lw $t2, 0($t1)  # pos = valid_moves[index]
    la $t3, bottom_marker
    sw $t2, 0($t3)

    # Find the cell for the new bottom_marker
    la $t4, top_marker
    lw $t5, 0($t4)
    mul $a0, $t5, $t2
    jal find_cell
    j computer_move_end

no_valid_moves:
    li $v0, -1
    li $v1, -1

computer_move_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
