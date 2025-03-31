.data
numline:    .asciiz "Number line: 1 2 3 4 5 6 7 8 9\n"  # Number line display
sep:        .asciiz " | "                               # Separator between grid cells
equals:     .asciiz "=== "                              # Start of turn header
endsep:     .asciiz " ===\n"                            # End of turn header
space:      .asciiz " "                                 # Space for formatting
xmark:      .asciiz " X "                               # Player marker (X)
omark:      .asciiz " O "                               # Computer marker (O)
newline:    .asciiz "\n"                                # Newline for formatting

.text
.globl display_grid
display_grid:
    # Display the 6x6 game grid
    addiu $sp, $sp, -12              # Allocate 12 bytes on stack
    sw $ra, 0($sp)                   # Save return address
    sw $s0, 4($sp)                   # Save $s0 (row counter)
    sw $s1, 8($sp)                   # Save $s1 (col counter)

    li $s0, 0                        # $s0 = row counter
grid_row_loop:
    bge $s0, 6, grid_end             # If row >= 6, finish
    li $s1, 0                        # $s1 = col counter
grid_col_loop:
    bge $s1, 6, grid_row_end         # If col >= 6, next row

    move $a0, $s0                    # Pass row
    move $a1, $s1                    # Pass col
    jal get_ownership              # Check ownership at [row][col]
    beq $v0, 1, print_x              # If 1, print "X"
    beq $v0, 2, print_o              # If 2, print "O"

    move $a0, $s0                    # Pass row
    move $a1, $s1                    # Pass col
    jal get_grid_value             # Get GRID[row][col]
    move $t0, $v0                    # $t0 = grid value
    li $t1, 10                       # Compare value to 10
    blt $t0, $t1, print_single       # If < 10, print with extra space

    move $a0, $t0                    # Print two-digit number
    li $v0, 1                        # Syscall 1: Print integer
    syscall
    la $a0, space                    # Add space after number
    li $v0, 4                        # Syscall 4: Print string
    syscall
    j print_sep                      # Add separator

print_single:
    la $a0, space                    # Add leading space for single digit
    li $v0, 4                        # Syscall 4: Print string
    syscall
    move $a0, $t0                    # Print single-digit number
    li $v0, 1                        # Syscall 1: Print integer
    syscall
    la $a0, space                    # Add trailing space
    li $v0, 4                        # Syscall 4: Print string
    syscall
    j print_sep                      # Add separator

print_x:
    la $a0, xmark                    # Load " X " string
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print "X" for player
    j print_sep                      # Add separator

print_o:
    la $a0, omark                    # Load " O " string
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print "O" for computer
    j print_sep                      # Add separator

print_sep:
    blt $s1, 5, print_separator      # If col < 5, print separator
    j col_next                       # Otherwise, next column
print_separator:
    la $a0, sep                      # Load " | " string
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print separator
col_next:
    addiu $s1, $s1, 1                # Increment col counter
    j grid_col_loop                  # Next column

grid_row_end:
    la $a0, newline                  # Load newline
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print newline after row
    addiu $s0, $s0, 1                # Increment row counter
    j grid_row_loop                  # Next row

grid_end:
    la $a0, newline                  # Load newline
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print newline after grid
    lw $ra, 0($sp)                   # Restore return address
    lw $s0, 4($sp)                   # Restore $s0
    lw $s1, 8($sp)                   # Restore $s1
    addiu $sp, $sp, 12               # Deallocate stack
    jr $ra                           # Return

.globl display_number_line
display_number_line:
    # Display number line with markers
    addiu $sp, $sp, -4               # Allocate 4 bytes on stack
    sw $ra, 0($sp)                   # Save return address

    jal get_top_marker             # Get top_marker value
    subu $t0, $v0, 1                 # $t0 = top_marker - 1 (0-based)
    sll $t0, $t0, 1                  # $t0 = (top_marker - 1) * 2 (spaces)
    addiu $t0, $t0, 13               # $t0 = offset + 13 (base spacing)
    li $t1, 0                        # $t1 = space counter
top_space_loop:
    bge $t1, $t0, top_space_end      # If counter >= offset, stop
    la $a0, space                    # Load space
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print space
    addiu $t1, $t1, 1                # Increment counter
    j top_space_loop                 # Next space
top_space_end:
    li $a0, 'v'                      # Load 'v' (top marker)
    li $v0, 11                       # Syscall 11: Print char
    syscall                          # Print 'v'
    la $a0, newline                  # Load newline
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print newline

    la $a0, numline                  # Load "Number line: 1 2 3 4 5 6 7 8 9"
    syscall                          # Print number line

    jal get_bottom_marker          # Get bottom_marker value
    subu $t0, $v0, 1                 # $t0 = bottom_marker - 1
    sll $t0, $t0, 1                  # $t0 = (bottom_marker - 1) * 2
    addiu $t0, $t0, 13               # $t0 = offset + 13
    li $t1, 0                        # $t1 = space counter
bottom_space_loop:
    bge $t1, $t0, bottom_space_end   # If counter >= offset, stop
    la $a0, space                    # Load space
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print space
    addiu $t1, $t1, 1                # Increment counter
    j bottom_space_loop              # Next space
bottom_space_end:
    li $a0, '^'                      # Load '^' (bottom marker)
    li $v0, 11                       # Syscall 11: Print char
    syscall                          # Print '^'
    la $a0, newline                  # Load newline
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print newline
    syscall                          # Extra newline for spacing

    lw $ra, 0($sp)                   # Restore return address
    addiu $sp, $sp, 4                # Deallocate stack
    jr $ra                           # Return

.globl display_game_state
display_game_state:
    # Display turn header, grid, and number line
    addiu $sp, $sp, -8               # Allocate 8 bytes on stack
    sw $ra, 0($sp)                   # Save return address
    sw $s0, 4($sp)                   # Save $s0 (message pointer)
    move $s0, $a0                    # $s0 = turn message ("Your turn (X)", etc.)

    la $a0, equals                   # Load "=== "
    li $v0, 4                        # Syscall 4: Print string
    syscall                          # Print start of header
    move $a0, $s0                    # Load turn message
    syscall                          # Print "Your turn (X)" or similar
    la $a0, endsep                   # Load " ===\n"
    syscall                          # Print end of header

    jal display_grid               # Display the 6x6 grid
    jal display_number_line        # Display number line with markers

    lw $ra, 0($sp)                   # Restore return address
    lw $s0, 4($sp)                   # Restore $s0
    addiu $sp, $sp, 8                # Deallocate stack
    jr $ra                           # Return to main.asm
