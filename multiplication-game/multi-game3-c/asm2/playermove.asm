.data
    prompt:    .asciiz "Enter a number (1-9) to move your marker: "
    invalid:   .asciiz "Invalid input! Please enter a number between 1 and 9.\n"
    row_msg:   .asciiz "row: "
    col_msg:   .asciiz "col: "
    space:     .asciiz " "
    newline:   .asciiz "\n"

.text
    #.extern set_top_marker 4
    #.extern get_top_marker 4
    #.extern get_bottom_marker 4
    #.extern find_cell 4
    #.extern get_ownership 4
    #.extern set_ownership 4

    .globl player_turn

player_turn:
    addi $sp, $sp, -20        # 5 words: ra, s0, s1, row, col
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # 12($sp) for row, 16($sp) for col

    la $a0, prompt            # Prompt user for input a number
    li $v0, 4
    syscall

    li $v0, 5               # Get user input
    syscall
    move $s0, $v0             # new_pos

  # Validate user input
    li $t0, 1
    blt $s0, $t0, invalid_input
    li $t0, 9
    bgt $s0, $t0, invalid_input

    move $a0, $s0
    jal set_top_marker

    jal get_top_marker
    move $s1, $v0
    jal get_bottom_marker
    mul $t0, $s1, $v0         # product

    move $a0, $t0
    jal find_cell
    sw $v0, 12($sp)           # Save row to stack immediately
    sw $v1, 16($sp)           # Save col stack immediately
    lw $t1, 12($sp)           # load row
    lw $t2, 16($sp)           # load col

    li $t3, -1
    beq $t1, $t3, invalid_move
    move $a0, $t1
    move $a1, $t2
    jal get_ownership
    bnez $v0, invalid_move

    la $a0, row_msg
    li $v0, 4
    syscall
    lw $a0, 12($sp)           # Use saved row
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall
    la $a0, col_msg
    li $v0, 4
    syscall
    lw $a0, 16($sp)           # Use saved col
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Claim cell (player = 1)
    lw $a0, 12($sp)           # row
    lw $a1, 16($sp)           # col
    li $a2, 1               # player = 1 (X)
    jal set_ownership

    li $v0, 1
    j cleanup

invalid_input:
    la $a0, invalid
    li $v0, 4
    syscall
    li $v0, 0
    j cleanup

invalid_move:
    li $v0, 0

cleanup:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 20
    jr $ra
