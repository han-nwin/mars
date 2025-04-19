.data
    x_mark:    .asciiz " X"       # String for player 1’s mark (X with leading space)
    o_mark:    .asciiz " O"       # String for player 2’s mark (O with leading space)
    separator: .asciiz "|"        # Vertical line for cell separation
    space:     .asciiz " "        # Single space for padding numbers
    newline:   .asciiz "\n"       # Newline character for row breaks
    num_line:  .asciiz "Select nums: 1 2 3 4 5 6 7 8 9\n"  # Original number line string
    top_ptr:   .asciiz "v"        # Down arrow for top marker position
    bottom_ptr:.asciiz "^"        # Up arrow for bottom marker position
    h_border:  .asciiz "-"        # Horizontal line for row separation
    corner:    .asciiz "+"        # Corner and intersection character

.text
    .globl display_game_state     # Global function to display the game board

# display_game_state: Prints the 6x6 game grid with standard ASCII borders, number line, and markers
# No inputs/outputs via registers; uses syscalls to print directly
display_game_state:
    # Save registers to stack per MIPS convention
    addi $sp, $sp, -16        # Allocate 16 bytes for 4 registers
    sw $ra, 0($sp)            # Save return address
    sw $s0, 4($sp)            # Save $s0 (row counter)
    sw $s1, 8($sp)            # Save $s1 (column counter)
    sw $s2, 12($sp)           # Save $s2 (temp for border printing)

    # Print top border: +---------+
    la $a0, corner            # Print top-left corner
    li $v0, 4
    syscall
    li $s1, 0                 # Counter for horizontal lines
top_border_loop:
    la $a0, h_border          # Print horizontal line segment
    li $v0, 4
    syscall
    la $a0, h_border          # Double for 2-char cell width
    li $v0, 4
    syscall
    la $a0, corner            # Print intersection
    li $v0, 4
    syscall
    addi $s1, $s1, 1
    li $t0, 5                 # 5 separators for 6 columns
    blt $s1, $t0, top_border_loop
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, corner            # Print top-right corner
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Print the 6x6 grid
    li $s0, 0                 # Initialize row counter to 0
grid_row_loop:
    la $a0, separator         # Print left vertical border
    li $v0, 4
    syscall
    li $s1, 0                 # Initialize column counter to 0
grid_col_loop:
    move $a0, $s0             # Set row argument for get_ownership
    move $a1, $s1             # Set column argument
    jal get_ownership         # Get cell ownership (0 = empty, 1 = X, 2 = O)
    move $t0, $v0             # Store ownership value in $t0

    beq $t0, 1, print_x       # If cell owned by player 1, print " X"
    beq $t0, 2, print_o       # If cell owned by player 2, print " O"
    # If cell is empty (0), print the grid number
    move $a0, $s0             # Set row for get_grid_value
    move $a1, $s1             # Set column
    jal get_grid_value        # Get the original number at this position
    move $t1, $v0             # Store grid value in $t1
    li $t2, 10                # Threshold for single vs. double digits
    blt $t1, $t2, print_single_digit  # If number < 10, pad with space
    # Handle two-digit numbers (10 or higher)
    move $a0, $t1             # Load number to print
    li $v0, 1                 # Syscall to print integer
    syscall
    j after_print             # Skip to post-print logic
print_single_digit:
    la $a0, space             # Load space for padding
    li $v0, 4                 # Syscall to print string
    syscall
    move $a0, $t1             # Load single-digit number
    li $v0, 1                 # Syscall to print integer
    syscall
    j after_print             # Skip to post-print logic
print_x:
    la $a0, x_mark            # Load " X" string
    li $v0, 4                 # Syscall to print string
    syscall
    j after_print             # Skip to post-print logic
print_o:
    la $a0, o_mark            # Load " O" string
    li $v0, 4                 # Syscall to print string
    syscall
after_print:
    la $a0, separator         # Print vertical separator
    li $v0, 4
    syscall
    addi $s1, $s1, 1          # Move to next column
    li $t0, 6                 # Grid width is 6
    blt $s1, $t0, grid_col_loop  # If col < 6, continue row

    la $a0, newline           # Newline after row
    li $v0, 4
    syscall

    # Print horizontal separator between rows (except after last row)
    li $t0, 5                 # Last row index
    beq $s0, $t0, skip_h_separator
    la $a0, corner            # Print left intersection
    li $v0, 4
    syscall
    li $s1, 0                 # Reset column counter
mid_border_loop:
    la $a0, h_border          # Print horizontal line
    li $v0, 4
    syscall
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, corner            # Print intersection
    li $v0, 4
    syscall
    addi $s1, $s1, 1
    li $t0, 5                 # 5 separators
    blt $s1, $t0, mid_border_loop
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, corner            # Print right intersection
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall
skip_h_separator:
    addi $s0, $s0, 1          # Move to next row
    li $t0, 6                 # Grid height is 6
    blt $s0, $t0, grid_row_loop  # If row < 6, print next row

    # Print bottom border: +---------+
    la $a0, corner            # Print bottom-left corner
    li $v0, 4
    syscall
    li $s1, 0
bottom_border_loop:
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, corner            # Print intersection
    li $v0, 4
    syscall
    addi $s1, $s1, 1
    li $t0, 5
    blt $s1, $t0, bottom_border_loop
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, h_border
    li $v0, 4
    syscall
    la $a0, corner            # Print bottom-right corner
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Print the number line with top marker
    la $a0, newline           # Add blank line before number line
    li $v0, 4
    syscall
    jal get_top_marker        # Get top marker position (1-9)
    move $t0, $v0             # Store top marker position
    addi $t0, $t0, -1         # Adjust to 0-8 for indexing
    sll $t0, $t0, 1           # Multiply by 2 (each number takes 2 spaces)
    addi $t0, $t0, 13         # Add 13 (length of "Select nums: ")
    li $t1, 0                 # Initialize space counter
top_space_loop:
    beq $t1, $t0, print_top_ptr  # If counter matches offset, print arrow
    la $a0, space             # Load space string
    li $v0, 4                 # Syscall to print string
    syscall
    addi $t1, $t1, 1          # Increment counter
    j top_space_loop          # Keep adding spaces
print_top_ptr:
    la $a0, top_ptr           # Load "v" string
    li $v0, 4                 # Syscall to print string
    syscall
    la $a0, newline           # Newline after top marker
    li $v0, 4
    syscall

    la $a0, num_line          # Print original number line
    li $v0, 4
    syscall

    # Print bottom marker below number line
    jal get_bottom_marker     # Get bottom marker position (1-9)
    move $t0, $v0             # Store bottom marker position
    addi $t0, $t0, -1         # Adjust to 0-8
    sll $t0, $t0, 1           # Multiply by 2 for spacing
    addi $t0, $t0, 13         # Add 13 for base offset
    li $t1, 0                 # Initialize space counter
bottom_space_loop:
    beq $t1, $t0, print_bottom_ptr  # If counter matches offset, print arrow
    la $a0, space             # Load space string
    li $v0, 4                 # Syscall to print string
    syscall
    addi $t1, $t1, 1          # Increment counter
    j bottom_space_loop       # Keep adding spaces
print_bottom_ptr:
    la $a0, bottom_ptr        # Load "^" string
    li $v0, 4                 # Syscall to print string
    syscall
    la $a0, newline           # Newline after bottom marker
    li $v0, 4
    syscall

    # Restore registers and return
    lw $ra, 0($sp)            # Restore return address
    lw $s0, 4($sp)            # Restore $s0
    lw $s1, 8($sp)            # Restore $s1
    lw $s2, 12($sp)           # Restore $s2
    addi $sp, $sp, 16         # Deallocate stack space
    jr $ra                    # Return to caller