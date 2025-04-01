.data
prompt:     .asciiz "Enter a number (1-9) to move your marker: "  # Prompt for player input
invalid:    .asciiz "Invalid input! Please enter a number between 1 and 9.\n"  # Error for bad input

.text
.globl player_turn
player_turn:
    # Handle player’s turn: get input, update marker, claim cell
    addiu $sp, $sp, -12              # Allocate 12 bytes on stack
    sw $ra, 0($sp)                   # Save return address
    sw $s0, 4($sp)                   # Save $s0 (product)
    sw $s1, 8($sp)                   # Save $s1 (input)

    la $a0, prompt                   # Load prompt string
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print "Enter a number (1-9)..."

    li $v0, 5                        # Syscall 5: Read integer
    syscall                          # Read player input into $v0
    move $s1, $v0                    # Save input in $s1

clear_buffer:
    # Clear input buffer until newline
    li $v0, 12                       # Syscall 12: Read character
    syscall                          # Read next char into $v0
    bne $v0, 10, clear_buffer        # If not newline (10), keep clearing

    blt $s1, 1, invalid_input        # If input < 1, invalid
    bgt $s1, 9, invalid_input        # If input > 9, invalid

    move $a0, $s1                    # Pass input to set marker
    jal set_top_marker               # Update top_marker with input

    jal get_top_marker               # Get top_marker value
    move $s0, $v0                    # $s0 = top_marker
    jal get_bottom_marker            # Get bottom_marker value
    mul $s0, $s0, $v0                # $s0 = top_marker * bottom_marker (product)

    addiu $sp, $sp, -16              # Allocate 16 bytes for find_cell (row, col + alignment)
    move $a0, $s0                    # Pass product to find_cell
    move $a1, $sp                    # Pass stack pointer to store row, col
    jal find_cell                    # Find row, col where GRID[row][col] = product
    lw $t0, 0($sp)                   # Load row from stack
    lw $t1, 4($sp)                   # Load col from stack
    addiu $sp, $sp, 16               # Deallocate stack space

    li $t2, -1                       # -1 indicates no match
    beq $t0, $t2, invalid_move       # If row = -1, move is invalid
    move $a0, $t0                    # Pass row
    move $a1, $t1                    # Pass col
    jal get_ownership                # Check if cell is already taken
    bnez $v0, invalid_move           # If ownership != 0, move is invalid

    move $a0, $t0                    # Pass row
    move $a1, $t1                    # Pass col
    li $a2, 1                        # Player marker (X = 1)
    jal set_ownership                # Claim cell with X

    li $v0, 1                        # Return 1 (valid move)
    j turn_end                       # Finish turn

invalid_input:
    # Handle invalid input (not 1-9)
    la $a0, invalid                  # Load error message
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print "Invalid input!"
    li $v0, 0                        # Return 0 (invalid)
    j turn_end                       # Finish turn

invalid_move:
    # Handle invalid move (cell not found or taken)
    li $v0, 0                        # Return 0 (invalid)
    j turn_end                       # Finish turn

turn_end:
    # Clean up and return
    lw $ra, 0($sp)                   # Restore return address
    lw $s0, 4($sp)                   # Restore $s0
    lw $s1, 8($sp)                   # Restore $s1
    addiu $sp, $sp, 12               # Deallocate stack
    jr $ra                           # Return to main.asm
