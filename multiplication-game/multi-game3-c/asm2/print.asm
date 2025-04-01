.data
    x_mark:    .asciiz " X"
    o_mark:    .asciiz " O"
    separator: .asciiz "|"
    space:     .asciiz " "
    newline:   .asciiz "\n"
    num_line:  .asciiz "Number line: 1 2 3 4 5 6 7 8 9\n"
    top_ptr:   .asciiz "v"
    bottom_ptr:.asciiz "^"

.text
    #.extern get_ownership 4
    #.extern get_grid_value 4
    #.extern get_top_marker 4
    #.extern get_bottom_marker 4

    .globl display_game_state

display_game_state:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)    # Row counter
    sw $s1, 8($sp)    # Col counter

    # Print grid
    li $s0, 0         # row = 0
grid_row_loop:
    li $s1, 0         # col = 0
grid_col_loop:
    move $a0, $s0
    move $a1, $s1
    jal get_ownership
    move $t0, $v0     # Ownership value (0, 1, 2)

    beq $t0, 1, print_x
    beq $t0, 2, print_o
    # If 0, print number
    move $a0, $s0
    move $a1, $s1
    jal get_grid_value
    move $t1, $v0     # Grid value
    li $t2, 10
    blt $t1, $t2, print_single_digit
    # Two digits
    move $a0, $t1
    li $v0, 1
    syscall
    j after_print
print_single_digit:
    la $a0, space
    li $v0, 4
    syscall
    move $a0, $t1
    li $v0, 1
    syscall
    j after_print
print_x:
    la $a0, x_mark
    li $v0, 4
    syscall
    j after_print
print_o:
    la $a0, o_mark
    li $v0, 4
    syscall
after_print:
    li $t0, 5
    beq $s1, $t0, skip_separator  # No separator after last col
    la $a0, separator
    li $v0, 4
    syscall
skip_separator:
    addi $s1, $s1, 1
    li $t0, 6
    blt $s1, $t0, grid_col_loop

    la $a0, newline
    li $v0, 4
    syscall
    addi $s0, $s0, 1
    li $t0, 6
    blt $s0, $t0, grid_row_loop

    # Print number line
    la $a0, newline
    li $v0, 4
    syscall
    jal get_top_marker
    move $t0, $v0     # Top marker position (1-9)
    addi $t0, $t0, -1 # Adjust to 0-8
    sll $t0, $t0, 1   # Multiply by 2 for spacing
    addi $t0, $t0, 13 # Base offset (after "Number line: ")
    li $t1, 0         # Counter
top_space_loop:
    beq $t1, $t0, print_top_ptr
    la $a0, space
    li $v0, 4
    syscall
    addi $t1, $t1, 1
    j top_space_loop
print_top_ptr:
    la $a0, top_ptr
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    la $a0, num_line
    li $v0, 4
    syscall

    jal get_bottom_marker
    move $t0, $v0     # Bottom marker position (1-9)
    addi $t0, $t0, -1 # Adjust to 0-8
    sll $t0, $t0, 1   # Multiply by 2 for spacing
    addi $t0, $t0, 13 # Base offset
    li $t1, 0         # Counter
bottom_space_loop:
    beq $t1, $t0, print_bottom_ptr
    la $a0, space
    li $v0, 4
    syscall
    addi $t1, $t1, 1
    j bottom_space_loop
print_bottom_ptr:
    la $a0, bottom_ptr
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
