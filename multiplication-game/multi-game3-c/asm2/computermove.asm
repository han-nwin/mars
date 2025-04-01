.data
    # No prompt needed, but keep row/col for debug consistency
    row_msg:   .asciiz "comp row: "
    col_msg:   .asciiz "comp col: "
    pick_msg:  .asciiz "comp pick: "
    space:     .asciiz " "
    newline:   .asciiz "\n"

.text
    .globl computer_turn

computer_turn:
    # Same stack setup as player_turn (5 words)
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)    # new_pos (random number)
    sw $s1, 8($sp)    # temp for product
    # 12($sp) for row, 16($sp) for col

    # Get random number (1-9) instead of waiting for user input
    li $a0, 1         # Random generator ID 1 (matches seed in main)
    li $a1, 9         # Upper bound (exclusive), generates 0-8
    li $v0, 42        # Syscall 42: Get random int in range [0, $a1-1]
    syscall           # Returns random value (0-8) in $a0
    addi $s0, $a0, 1  # Add 1 to shift range from 0-8 to 1-9, store in $s0 as new_pos

    # Print the random pick
    la $a0, pick_msg
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall

    # Set bottom marker
    move $a0, $s0
    jal set_bottom_marker

    # Same as player_turn from here
    jal get_top_marker
    move $s1, $v0
    jal get_bottom_marker
    mul $t0, $s1, $v0         # product

    move $a0, $t0
    jal find_cell
    sw $v0, 12($sp)           # Save row
    sw $v1, 16($sp)           # Save col
    lw $t1, 12($sp)           # row
    lw $t2, 16($sp)           # col

    # Check if valid and unclaimed
    li $t3, -1
    beq $t1, $t3, invalid_move
    move $a0, $t1
    move $a1, $t2
    jal get_ownership
    bnez $v0, invalid_move

    # Print row/col (for debug)
    la $a0, row_msg
    li $v0, 4
    syscall
    lw $a0, 12($sp)
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall
    la $a0, col_msg
    li $v0, 4
    syscall
    lw $a0, 16($sp)
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Claim cell (computer = 2)
    lw $a0, 12($sp)
    lw $a1, 16($sp)
    li $a2, 2         # Computer = 2 (O)
    jal set_ownership

    li $v0, 1
    j cleanup

invalid_move:
    li $v0, 0         # Return 0 if move invalid (we’ll loop in main later)

cleanup:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 20
    jr $ra
