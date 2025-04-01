.data
    prompt:    .asciiz "Enter a number (1-9) to move your marker: "  # Prompt for user input
    invalid:   .asciiz "Invalid input! Please enter a number between 1 and 9.\n"  # Error message for bad input
    row_msg:   .asciiz "row: "      # Label for row coordinate output
    col_msg:   .asciiz "col: "      # Label for column coordinate output
    space:     .asciiz " "          # Space character for formatting
    newline:   .asciiz "\n"         # Newline character for line breaks

.text
    .globl player_turn              # Global function for player’s turn

# player_turn: Handles player’s turn—gets input, validates, updates marker, claims cell
# Output: $v0 = 1 if move succeeds, 0 if invalid input or move
player_turn:
    addi $sp, $sp, -20              # Allocate 20 bytes on stack for 5 words
    sw $ra, 0($sp)                  # Save return address
    sw $s0, 4($sp)                  # Save $s0 (new position from input)
    sw $s1, 8($sp)                  # Save $s1 (top marker value)
    # 12($sp) reserved for row, 16($sp) for column

    la $a0, prompt                  # Load prompt string address
    li $v0, 4                       # Syscall code to print string
    syscall                         # Display "Enter a number (1-9)..."

    li $v0, 5                       # Syscall code to read integer
    syscall                         # Get user input (1-9)
    move $s0, $v0                   # Store input as new_pos in $s0

    # Validate user input: Must be between 1 and 9
    li $t0, 1                       # Minimum valid input
    blt $s0, $t0, invalid_input     # If new_pos < 1, jump to invalid
    li $t0, 9                       # Maximum valid input
    bgt $s0, $t0, invalid_input     # If new_pos > 9, jump to invalid

    move $a0, $s0                   # Set new_pos as argument
    jal set_top_marker              # Update top marker with user input

    jal get_top_marker              # Get current top marker value
    move $s1, $v0                   # Store top marker in $s1
    jal get_bottom_marker           # Get current bottom marker value
    mul $t0, $s1, $v0               # Calculate product (top * bottom)

    move $a0, $t0                   # Set product as argument
    jal find_cell                   # Find cell coordinates for this product
    sw $v0, 12($sp)                 # Save row (returned in $v0) to stack
    sw $v1, 16($sp)                 # Save column (returned in $v1) to stack
    lw $t1, 12($sp)                 # Load row into $t1
    lw $t2, 16($sp)                 # Load column into $t2

    # Validate move: Check if cell is valid and unclaimed
    li $t3, -1                      # -1 indicates invalid cell (from find_cell)
    beq $t1, $t3, invalid_move      # If row = -1, move is invalid
    move $a0, $t1                   # Set row for get_ownership
    move $a1, $t2                   # Set column
    jal get_ownership               # Check if cell is owned (0 = empty, 1/2 = taken)
    bnez $v0, invalid_move          # If cell != 0 (already claimed), move is invalid

    # Print move coordinates (e.g., "row: 2 col: 3")
    la $a0, row_msg                 # Load "row: " string
    li $v0, 4                       # Syscall to print string
    syscall
    lw $a0, 12($sp)                 # Load saved row value
    li $v0, 1                       # Syscall to print integer
    syscall
    la $a0, space                   # Load space for formatting
    li $v0, 4
    syscall
    la $a0, col_msg                 # Load "col: " string
    li $v0, 4
    syscall
    lw $a0, 16($sp)                 # Load saved column value
    li $v0, 1
    syscall
    la $a0, newline                 # Load newline
    li $v0, 4
    syscall

    # Claim the cell for player 1 (X)
    lw $a0, 12($sp)                 # Load row as first argument
    lw $a1, 16($sp)                 # Load column as second argument
    li $a2, 1                       # Set player number (1 for X)
    jal set_ownership               # Mark cell as owned by player 1

    li $v0, 1                       # Move succeeded, return 1
    j cleanup                       # Jump to cleanup

invalid_input:
    la $a0, invalid                 # Load invalid input message
    li $v0, 4                       # Syscall to print string
    syscall
    li $v0, 0                       # Return 0 for invalid input
    j cleanup                       # Jump to cleanup

invalid_move:
    li $v0, 0                       # Return 0 for invalid move (cell taken or out of bounds)

cleanup:
    lw $ra, 0($sp)                  # Restore return address
    lw $s0, 4($sp)                  # Restore $s0
    lw $s1, 8($sp)                  # Restore $s1
    addi $sp, $sp, 20               # Deallocate stack space
    jr $ra                          # Return to caller
