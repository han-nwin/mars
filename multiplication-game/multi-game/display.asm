.text
# Displays the current game state, including turn message, grid, and number line
display_game_state:
    # Allocate stack space and save registers
    addi $sp, $sp, -8       # Reserve 8 bytes on stack
    sw $ra, 0($sp)          # Save return address
    sw $a0, 4($sp)          # Save argument (turn message)

    # Print the turn message (passed in $a0)
    li $v0, 4               # Syscall code for print string
    syscall                 # Print the turn message

    # Call functions to display the grid and number line
    jal display_grid        # Display the game grid
    jal display_number_line # Display the number line with markers

    # Restore registers and return
    lw $ra, 0($sp)          # Restore return address
    addi $sp, $sp, 8        # Deallocate stack space
    jr $ra                  # Return to caller

# Displays the 6x6 game grid with numbers or player markers (X/O)
display_grid:
    # Allocate stack space and save registers
    addi $sp, $sp, -12      # Reserve 12 bytes on stack
    sw $ra, 0($sp)          # Save return address
    sw $s0, 4($sp)          # Save $s0 (row counter)
    sw $s1, 8($sp)          # Save $s1 (column counter)

    li $s0, 0               # Initialize row counter to 0
grid_row_loop:
    li $s1, 0               # Initialize column counter to 0
grid_col_loop:
    # Calculate address of ownership[row][col]
    la $t0, ownership       # Load base address of ownership array
    mul $t1, $s0, 24        # row * 24 (6 cols * 4 bytes per word)
    sll $t2, $s1, 2         # col * 4 (bytes per word)
    add $t1, $t1, $t2       # Offset = row * 24 + col * 4
    add $t1, $t1, $t0       # Full address = base + offset
    lw $t2, 0($t1)          # Load ownership value (0 = empty, 1 = X, 2 = O)

    # Check cell ownership and branch accordingly
    li $t3, 1               # Player value (X)
    beq $t2, $t3, print_x   # If cell owned by player, print X
    li $t3, 2               # Computer value (O)
    beq $t2, $t3, print_o   # If cell owned by computer, print O

    # If cell is empty, print the grid number
    la $t0, GRID            # Load base address of GRID array
    mul $t1, $s0, 24        # row * 24
    sll $t2, $s1, 2         # col * 4
    add $t1, $t1, $t2       # Offset = row * 24 + col * 4
    add $t1, $t1, $t0       # Full address = base + offset
    lw $t3, 0($t1)          # Load grid value (product number)

    # Prepare number string in num_buffer with padding
    la $t4, num_buffer      # Load address of num_buffer
    li $t5, 32              # ASCII space character
    sb $t5, 0($t4)          # Store leading space in buffer

    # Check if number is single or double digit
    li $t6, 10              # Threshold for single/double digits
    blt $t3, $t6, single_digit  # If < 10, handle as single digit

    # Handle double-digit number
    div $t3, $t6            # Divide number by 10
    mflo $t7                # $t7 = tens digit (quotient)
    mfhi $t8                # $t8 = ones digit (remainder)
    addi $t7, $t7, 48       # Convert tens digit to ASCII
    addi $t8, $t8, 48       # Convert ones digit to ASCII
    sb $t7, 1($t4)          # Store tens digit in buffer
    sb $t8, 2($t4)          # Store ones digit in buffer
    j print_number          # Jump to print the number

single_digit:
    # Handle single-digit number
    addi $t7, $t3, 48       # Convert number to ASCII
    sb $t7, 1($t4)          # Store digit in buffer
    sb $t5, 2($t4)          # Store trailing space in buffer

print_number:
    # Finalize and print the number string
    sb $zero, 3($t4)        # Null-terminate the string
    move $a0, $t4           # Set $a0 to buffer address
    li $v0, 4               # Syscall code for print string
    syscall                 # Print the number
    j print_separator       # Jump to print separator

print_x:
    # Print " X " for player's marker
    la $a0, space           # Load space string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print leading space
    la $a0, x_char          # Load X string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print X
    la $a0, space           # Load space string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print trailing space
    j print_separator       # Jump to print separator

print_o:
    # Print " O " for computer's marker
    la $a0, space           # Load space string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print leading space
    la $a0, o_char          # Load O string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print O
    la $a0, space           # Load space string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print trailing space
    j print_separator       # Jump to print separator

print_separator:
    # Print pipe separator unless it's the last column
    li $t0, 5               # Last column index (0-5)
    beq $s1, $t0, skip_pipe # Skip pipe if last column
    la $a0, pipe            # Load pipe string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print pipe

skip_pipe:
    # Increment column counter and loop
    addi $s1, $s1, 1        # col++
    li $t0, 6               # Number of columns
    blt $s1, $t0, grid_col_loop  # If col < 6, continue column loop

    # Print newline after each row
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline

    # Increment row counter and loop
    addi $s0, $s0, 1        # row++
    li $t0, 6               # Number of rows
    blt $s0, $t0, grid_row_loop  # If row < 6, continue row loop

    # Print extra newline after grid
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline

    # Restore registers and return
    lw $ra, 0($sp)          # Restore return address
    lw $s0, 4($sp)          # Restore $s0
    lw $s1, 8($sp)          # Restore $s1
    addi $sp, $sp, 12       # Deallocate stack space
    jr $ra                  # Return to caller

# Displays the number line with markers and current product
display_number_line:
    # Allocate stack space and save registers
    addi $sp, $sp, -8       # Reserve 8 bytes on stack
    sw $ra, 0($sp)          # Save return address
    sw $s0, 4($sp)          # Save $s0 (position counter)

    # Calculate position for top marker (v)
    la $t0, top_marker      # Load address of top_marker
    lw $t1, 0($t0)          # Load top_marker value
    li $t2, 13              # Base offset for alignment
    addi $t3, $t1, -1       # top_marker - 1
    mul $t3, $t3, 2         # (top_marker - 1) * 2 (spaces between numbers)
    add $s0, $t2, $t3       # Position = 13 + (top_marker - 1) * 2

    # Print leading spaces for top marker
    li $t4, 0               # Space counter
top_spaces_loop:
    beq $t4, $s0, end_top_spaces  # If counter = position, stop
    la $a0, space           # Load space string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print space
    addi $t4, $t4, 1        # Increment counter
    j top_spaces_loop       # Continue loop

end_top_spaces:
    # Print top marker (v)
    la $a0, v_marker        # Load v string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print v
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline

    # Print the number line (1-9)
    la $a0, number_line_msg # Load number line string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print number line

    # Calculate position for bottom marker (^)
    la $t0, bottom_marker   # Load address of bottom_marker
    lw $t1, 0($t0)          # Load bottom_marker value
    li $t2, 13              # Base offset for alignment
    addi $t3, $t1, -1       # bottom_marker - 1
    mul $t3, $t3, 2         # (bottom_marker - 1) * 2
    add $s0, $t2, $t3       # Position = 13 + (bottom_marker - 1) * 2

    # Print leading spaces for bottom marker
    li $t4, 0               # Space counter
bottom_spaces_loop:
    beq $t4, $s0, end_bottom_spaces  # If counter = position, stop
    la $a0, space           # Load space string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print space
    addi $t4, $t4, 1        # Increment counter
    j bottom_spaces_loop    # Continue loop

end_bottom_spaces:
    # Print bottom marker (^)
    la $a0, caret_marker    # Load ^ string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print ^
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline

    # Print the product (top_marker * bottom_marker)
    la $a0, product_msg     # Load "Product: " string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print product message
    la $t0, top_marker      # Load address of top_marker
    lw $a0, 0($t0)          # Load top_marker value
    li $v0, 1               # Syscall code for print integer
    syscall                 # Print top_marker
    la $a0, x_msg           # Load " x " string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print " x "
    la $t0, bottom_marker   # Load address of bottom_marker
    lw $a0, 0($t0)          # Load bottom_marker value
    li $v0, 1               # Syscall code for print integer
    syscall                 # Print bottom_marker
    la $a0, eq_msg          # Load " = " string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print " = "
    la $t0, top_marker      # Load address of top_marker
    lw $t1, 0($t0)          # Load top_marker value
    la $t0, bottom_marker   # Load address of bottom_marker
    lw $t2, 0($t0)          # Load bottom_marker value
    mul $a0, $t1, $t2       # Calculate product
    li $v0, 1               # Syscall code for print integer
    syscall                 # Print product
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print newline
    la $a0, newline         # Load newline string
    li $v0, 4               # Syscall code for print string
    syscall                 # Print extra newline

    # Restore registers and return
    lw $ra, 0($sp)          # Restore return address
    lw $s0, 4($sp)          # Restore $s0
    addi $sp, $sp, 8        # Deallocate stack space
    jr $ra                  # Return to caller
