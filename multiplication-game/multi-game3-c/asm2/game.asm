.data
    GRID:   .word 1, 2, 3, 4, 5, 6
            .word 7, 8, 9, 10, 12, 14
            .word 15, 16, 18, 20, 21, 24
            .word 25, 27, 28, 30, 32, 35
            .word 36, 40, 42, 45, 48, 49
            .word 54, 56, 63, 64, 72, 81
    ownership: .word 0:36
    top_marker: .word 1
    bottom_marker: .word 1

    # Player strings (some moved from playermove.asm if separate)
    comp_row_msg: .asciiz "comp row: "
    comp_col_msg: .asciiz "comp col: "
    space:        .asciiz " "
    newline:      .asciiz "\n"
    pick_msg:     .asciiz "comp pick: "
    player_win:   .asciiz "You win!\n"
    comp_win:     .asciiz "Computer wins!\n"
    tie_msg:      .asciiz "It's a tie!\n"

.text
    .globl main
    .globl init_game
    .globl get_grid_value
    .globl get_ownership
    .globl set_ownership
    .globl get_top_marker
    .globl get_bottom_marker
    .globl set_top_marker
    .globl set_bottom_marker
    .globl find_cell

main:
    # Seed random
    li $v0, 30
    syscall
    move $a1, $a0
    li $a0, 1
    li $v0, 40
    syscall

    jal init_game
    jal display_game_state

game_loop:
    jal player_turn
    move $t0, $v0
    beqz $t0, game_loop
    move $a0, $t0         # Print "1"
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    jal display_game_state

    li $a0, 1
    jal check_win
    beq $v0, 1, player_wins  # Exit here if player wins
    jal is_board_full
    beq $v0, 1, tie_game

computer_loop:
    jal computer_turn
    move $t0, $v0
    beqz $t0, computer_loop
    jal display_game_state    # Show board first
    jal get_bottom_marker
    la $a0, space
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    li $a0, 2
    jal check_win
    beq $v0, 1, comp_wins
    jal is_board_full
    beq $v0, 1, tie_game

    j game_loop

player_wins:
    la $a0, player_win
    li $v0, 4
    syscall
    j end_game
comp_wins:
    la $a0, comp_win
    li $v0, 4
    syscall
    j end_game
tie_game:
    la $a0, tie_msg
    li $v0, 4
    syscall
end_game:
    li $v0, 10
    syscall

# ..... #

init_game:
    la $t0, ownership
    li $t1, 36
    li $t2, 0

init_loop:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, init_loop
    la $t0, top_marker
    li $t1, 1
    sw $t1, 0($t0)
    la $t0, bottom_marker
    sw $t1, 0($t0)
    jr $ra

get_grid_value:
    li $t0, 6
    mul $t1, $a0, $t0
    add $t1, $t1, $a1
    sll $t1, $t1, 2
    la $t2, GRID
    add $t1, $t2, $t1
    lw $v0, 0($t1)
    jr $ra

get_ownership:
    li $t0, 6
    mul $t1, $a0, $t0
    add $t1, $t1, $a1
    sll $t1, $t1, 2
    la $t2, ownership
    add $t1, $t2, $t1
    lw $v0, 0($t1)
    jr $ra

set_ownership:
    li $t0, 6
    mul $t1, $a0, $t0
    add $t1, $t1, $a1
    sll $t1, $t1, 2
    la $t2, ownership
    add $t1, $t2, $t1
    sw $a2, 0($t1)
    jr $ra

get_top_marker:
    la $t0, top_marker
    lw $v0, 0($t0)
    jr $ra

get_bottom_marker:
    la $t0, bottom_marker
    lw $v0, 0($t0)
    jr $ra

set_top_marker:
    la $t0, top_marker
    sw $a0, 0($t0)
    jr $ra

set_bottom_marker:
    la $t0, bottom_marker
    sw $a0, 0($t0)
    jr $ra

find_cell:
    la $t0, GRID
    li $t1, 0
    li $t2, 0
    li $t3, 36
    li $t4, 0
find_loop:
    lw $t5, 0($t0)
    beq $t5, $a0, found
    addi $t0, $t0, 4
    addi $t4, $t4, 1
    li $t6, 6
    div $t4, $t6
    mfhi $t2
    mflo $t1
    bne $t4, $t3, find_loop
    li $v0, -1
    li $v1, -1
    jr $ra
found:
    move $v0, $t1
    move $v1, $t2
    jr $ra
