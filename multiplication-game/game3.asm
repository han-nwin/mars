.data
    GRID: .word 1, 2, 3, 4, 5, 6,
                7, 8, 9, 10, 12, 14,
                15, 16, 18, 20, 21, 24,
                25, 27, 28, 30, 32, 35,
                36, 40, 42, 45, 48, 49,
                54, 56, 63, 64, 72, 81
    ownership: .space 144  # 6x6 * 4 bytes
    top_marker: .word 1
    custom_marker: .word 1

    # Display strings
    clear_cmd:   .asciiz "clear"
    reset_color: .asciiz "\033[0m"
    red_color:   .asciiz "\033[31m"
    blue_color:  .asciiz "\033[34m"
    fmt_x:       .asciiz " %sX%s "
    fmt_o:       .asciiz " %sO%s "
    fmt_num1:    .asciiz " %d "
    fmt_num2:    .asciiz "%d "
    v_str:       .asciiz "v"
    num_line:    .asciiz "Number line: 1 2 3 4 5 6 7 8 9"
    caret_str:   .asciiz "^"
    prod_msg:    .asciiz "Product: "  # Adjusted: no %d
    x_msg:       .asciiz " x "
    eq_msg:      .asciiz " = "
    newline:     .asciiz "\n"
    cont_msg:    .asciiz "Press Enter to continue...\n"

    # Game strings
    player_turn_msg: .asciiz "Your turn (X)\n"
    move_prompt:     .asciiz "Move the top marker to a number (1-9): "
    invalid_msg:     .asciiz "Invalid input, enter a number between 1 and 9.\n"
    not_in_grid_msg: .asciiz "Product not in the grid, try again.\n"
    taken_msg:       .asciiz "Cell already taken, try again.\n"
    claim_msg:       .asciiz "You claim "  # Adjusted: no %d
    win_msg:         .asciiz "You win!\n"
    tie_msg:         .asciiz "It's a tie!\n"
    comp_turn_msg:   .asciiz "Computer's turn (O)\n"
    no_moves_msg:    .asciiz "Computer has no valid moves left!\n"
    comp_claim_msg:  .asciiz "Computer claims "  # Adjusted: no %d
    comp_win_msg:    .asciiz "Computer wins!\n"

.text
main:
    li $v0, 30
    syscall
    move $a0, $v0
    li $v0, 40
    syscall
    jal play_game
    li $v0, 10
    syscall

# Utility Functions
clear_console:
    li $v0, 11
    li $a0, '\n'
    syscall
    syscall
    syscall
    jr $ra

display_grid:
    li $t0, 0
outer_loop:
    slti $t1, $t0, 6
    beq $t1, $zero, end_display_grid
    li $t1, 0
inner_loop:
    slti $t2, $t1, 6
    beq $t2, $zero, next_row
    mul $t2, $t0, 6
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, ownership
    add $t3, $t3, $t2
    lw $t3, 0($t3)
    li $t4, 1
    beq $t3, $t4, print_x
    li $t4, 2
    beq $t3, $t4, print_o
    la $t4, GRID
    add $t4, $t4, $t2
    lw $t5, 0($t4)
    slti $t6, $t5, 10
    beq $t6, $zero, print_large_num
    li $v0, 4
    la $a0, fmt_num1
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    j check_col
print_large_num:
    li $v0, 4
    la $a0, fmt_num2
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    j check_col
print_x:
    li $v0, 4
    la $a0, fmt_x
    la $a1, red_color
    la $a2, reset_color
    syscall
    j check_col
print_o:
    li $v0, 4
    la $a0, fmt_o
    la $a1, blue_color
    la $a2, reset_color
    syscall
check_col:
    slti $t2, $t1, 5
    beq $t2, $zero, next_col
    li $v0, 11
    li $a0, '|'
    syscall
next_col:
    addi $t1, $t1, 1
    j inner_loop
next_row:
    li $v0, 11
    li $a0, '\n'
    syscall
    addi $t0, $t0, 1
    j outer_loop
end_display_grid:
    li $v0, 11
    li $a0, '\n'
    syscall
    jr $ra

display_number_line:
    la $t0, top_marker
    lw $t0, 0($t0)
    addi $t0, $t0, -1
    sll $t0, $t0, 1
    addi $t0, $t0, 13
    li $t1, 0
top_spaces:
    slt $t2, $t1, $t0
    beq $t2, $zero, print_v
    li $v0, 11
    li $a0, ' '
    syscall
    addi $t1, $t1, 1
    j top_spaces
print_v:
    li $v0, 4
    la $a0, v_str
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    li $v0, 4
    la $a0, num_line
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    la $t0, custom_marker
    lw $t0, 0($t0)
    addi $t0, $t0, -1
    sll $t0, $t0, 1
    addi $t0, $t0, 13
    li $t1, 0
bottom_spaces:
    slt $t2, $t1, $t0
    beq $t2, $zero, print_caret
    li $v0, 11
    li $a0, ' '
    syscall
    addi $t1, $t1, 1
    j bottom_spaces
print_caret:
    li $v0, 4
    la $a0, caret_str
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    # Print product manually
    la $t0, top_marker
    lw $t1, 0($t0)
    la $t0, custom_marker
    lw $t2, 0($t0)
    mul $t3, $t1, $t2
    li $v0, 4
    la $a0, prod_msg
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, x_msg
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, eq_msg
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

display_game_state:
    sub $sp, $sp, 4
    sw $ra, 0($sp)
    move $t0, $a0
    jal clear_console
    li $v0, 4
    move $a0, $t0
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    jal display_grid
    jal display_number_line
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

show_message:
    sub $sp, $sp, 4
    sw $ra, 0($sp)
    li $v0, 4
    syscall
    li $v0, 4
    la $a0, cont_msg
    syscall
wait_enter:
    li $v0, 12
    syscall
    li $t0, 10
    bne $v0, $t0, wait_enter
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

# Game Logic Functions
find_cell:
    li $t0, -1
    sw $t0, 0($a1)
    sw $t0, 0($a2)
    li $t0, 0
row_loop:
    slti $t1, $t0, 6
    beq $t1, $zero, end_find
    li $t1, 0
col_loop:
    slti $t2, $t1, 6
    beq $t2, $zero, next_row_find
    mul $t2, $t0, 6
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, GRID
    add $t3, $t3, $t2
    lw $t3, 0($t3)
    bne $t3, $a0, next_col_find
    sw $t0, 0($a1)
    sw $t1, 0($a2)
    j end_find
next_col_find:
    addi $t1, $t1, 1
    j col_loop
next_row_find:
    addi $t0, $t0, 1
    j row_loop
end_find:
    jr $ra

check_win:
    li $t0, 0
row_check:
    slti $t1, $t0, 6
    beq $t1, $zero, col_check_start
    li $t1, 0
col_check:
    slti $t2, $t1, 3
    beq $t2, $zero, next_row_check
    li $t2, 1
    li $t3, 0
row_win_loop:
    slti $t4, $t3, 4
    beq $t4, $zero, check_row_win
    add $t4, $t1, $t3
    mul $t5, $t0, 6
    add $t5, $t5, $t4
    sll $t5, $t5, 2
    la $t6, ownership
    add $t6, $t6, $t5
    lw $t6, 0($t6)
    beq $t6, $a0, row_win_next
    li $t2, 0
    j check_row_win
row_win_next:
    addi $t3, $t3, 1
    j row_win_loop
check_row_win:
    bne $t2, $zero, win_found
    addi $t1, $t1, 1
    j col_check
next_row_check:
    addi $t0, $t0, 1
    j row_check

col_check_start:
    li $t0, 0
col_check_loop:
    slti $t1, $t0, 3
    beq $t1, $zero, diag_check_start
    li $t1, 0
col_win_check:
    slti $t2, $t1, 6
    beq $t2, $zero, next_col_check_loop
    li $t2, 1
    li $t3, 0
col_win_loop:
    slti $t4, $t3, 4
    beq $t4, $zero, check_col_win
    add $t4, $t0, $t3
    mul $t5, $t4, 6
    add $t5, $t5, $t1
    sll $t5, $t5, 2
    la $t6, ownership
    add $t6, $t6, $t5
    lw $t6, 0($t6)
    beq $t6, $a0, col_win_next
    li $t2, 0
    j check_col_win
col_win_next:
    addi $t3, $t3, 1
    j col_win_loop
check_col_win:
    bne $t2, $zero, win_found
    addi $t1, $t1, 1
    j col_win_check
next_col_check_loop:
    addi $t0, $t0, 1
    j col_check_loop

diag_check_start:
    li $t0, 0
diag_check:
    slti $t1, $t0, 3
    beq $t1, $zero, diag2_check_start
    li $t1, 0
diag_col_check:
    slti $t2, $t1, 3
    beq $t2, $zero, next_diag_check
    li $t2, 1
    li $t3, 0
diag_win_loop:
    slti $t4, $t3, 4
    beq $t4, $zero, check_diag_win
    add $t4, $t0, $t3
    add $t5, $t1, $t3
    mul $t6, $t4, 6
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    la $t7, ownership
    add $t7, $t7, $t6
    lw $t7, 0($t7)
    beq $t7, $a0, diag_win_next
    li $t2, 0
    j check_diag_win
diag_win_next:
    addi $t3, $t3, 1
    j diag_win_loop
check_diag_win:
    bne $t2, $zero, win_found
    addi $t1, $t1, 1
    j diag_col_check
next_diag_check:
    addi $t0, $t0, 1
    j diag_check

diag2_check_start:
    li $t0, 0
diag2_check:
    slti $t1, $t0, 3
    beq $t1, $zero, no_win
    li $t1, 3
diag2_col_check:
    slti $t2, $t1, 6
    beq $t2, $zero, next_diag2_check
    li $t2, 1
    li $t3, 0
diag2_win_loop:
    slti $t4, $t3, 4
    beq $t4, $zero, check_diag2_win
    add $t4, $t0, $t3
    sub $t5, $t1, $t3
    mul $t6, $t4, 6
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    la $t7, ownership
    add $t7, $t7, $t6
    lw $t7, 0($t7)
    beq $t7, $a0, diag2_win_next
    li $t2, 0
    j check_diag2_win
diag2_win_next:
    addi $t3, $t3, 1
    j diag2_win_loop
check_diag2_win:
    bne $t2, $zero, win_found
    addi $t1, $t1, 1
    j diag2_col_check
next_diag2_check:
    addi $t0, $t0, 1
    j diag2_check

win_found:
    li $v0, 1
    jr $ra
no_win:
    li $v0, 0
    jr $ra

is_board_full:
    li $t0, 0
full_row_loop:
    slti $t1, $t0, 6
    beq $t1, $zero, board_full
    li $t1, 0
full_col_loop:
    slti $t2, $t1, 6
    beq $t2, $zero, next_full_row
    mul $t2, $t0, 6
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, ownership
    add $t3, $t3, $t2
    lw $t3, 0($t3)
    beq $t3, $zero, not_full
    addi $t1, $t1, 1
    j full_col_loop
next_full_row:
    addi $t0, $t0, 1
    j full_row_loop
not_full:
    li $v0, 0
    jr $ra
board_full:
    li $v0, 1
    jr $ra

simulate_move:
    sub $sp, $sp, 12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    la $t0, top_marker
    lw $s0, 0($t0)
    la $t2, custom_marker
    lw $s1, 0($t2)
    beq $a1, $zero, set_custom
    sw $a0, 0($t0)
    j calc_product
set_custom:
    sw $a0, 0($t2)
calc_product:
    lw $t4, 0($t0)
    lw $t5, 0($t2)
    mul $t6, $t4, $t5
    sub $sp, $sp, 8
    move $a0, $t6
    move $a1, $sp
    add $a2, $sp, 4
    jal find_cell
    lw $t7, 0($sp)
    lw $t8, 4($sp)
    add $sp, $sp, 8
    sw $s0, 0($t0)
    sw $s1, 0($t2)
    li $t9, -1
    beq $t7, $t9, sim_fail
    mul $t9, $t7, 6
    add $t9, $t9, $t8
    sll $t9, $t9, 2
    la $t0, ownership
    add $t0, $t0, $t9
    lw $t2, 0($t0)
    bne $t2, $zero, sim_fail
    sw $a2, 0($t0)
    move $a0, $a2
    jal check_win
    move $t3, $v0
    sw $zero, 0($t0)
    move $v0, $t3
    j sim_end
sim_fail:
    li $v0, 0
sim_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    add $sp, $sp, 12
    jr $ra

computer_move:
    sub $sp, $sp, 12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    li $s0, 1
win_loop:
    slti $t1, $s0, 10
    beq $t1, $zero, block_loop_start
    move $a0, $s0
    li $a1, 0
    li $a2, 2
    jal simulate_move
    bne $v0, $zero, apply_move
    addi $s0, $s0, 1
    j win_loop

block_loop_start:
    li $s0, 1
block_loop:
    slti $t1, $s0, 10
    beq $t1, $zero, random_move_start
    move $a0, $s0
    li $a1, 1
    li $a2, 1
    jal simulate_move
    bne $v0, $zero, block_move
    addi $s0, $s0, 1
    j block_loop

block_move:
    la $t2, custom_marker
    sw $s0, 0($t2)
    j compute_position

random_move_start:
    li $s0, 0
    li $s1, 1
    sub $sp, $sp, 36
random_loop:
    slti $t1, $s1, 10
    beq $t1, $zero, pick_random
    la $t2, custom_marker
    sw $s1, 0($t2)
    la $t3, top_marker
    lw $t4, 0($t3)
    lw $t5, 0($t2)
    mul $t6, $t4, $t5
    sub $sp, $sp, 8
    move $a0, $t6
    move $a1, $sp
    add $a2, $sp, 4
    jal find_cell
    lw $t7, 0($sp)
    lw $t8, 4($sp)
    add $sp, $sp, 8
    li $t9, -1
    beq $t7, $t9, next_random
    mul $t9, $t7, 6
    add $t9, $t9, $t8
    sll $t9, $t9, 2
    la $t2, ownership
    add $t2, $t2, $t9
    lw $t3, 0($t2)
    bne $t3, $zero, next_random
    sll $t3, $s0, 2
    add $t3, $t3, $sp
    sw $s1, 0($t3)
    addi $s0, $s0, 1
next_random:
    addi $s1, $s1, 1
    j random_loop

pick_random:
    beq $s0, $zero, no_moves
    li $v0, 42
    move $a1, $s0
    syscall
    sll $t1, $a0, 2
    add $t1, $t1, $sp
    lw $t2, 0($t1)
    la $t3, custom_marker
    sw $t2, 0($t3)
    add $sp, $sp, 36
    j compute_position

apply_move:
    la $t2, custom_marker
    sw $s0, 0($t2)

compute_position:
    la $t3, top_marker
    lw $t4, 0($t3)
    lw $t5, 0($t2)
    mul $t6, $t4, $t5
    sub $sp, $sp, 8
    move $a0, $t6
    move $a1, $sp
    add $a2, $sp, 4
    jal find_cell
    lw $t7, 0($sp)
    lw $t8, 4($sp)
    add $sp, $sp, 8
    sw $t7, 0($a0)
    sw $t8, 0($a1)
    j comp_move_end

no_moves:
    li $t0, -1
    sw $t0, 0($a0)
    sw $t0, 0($a1)
    add $sp, $sp, 36

comp_move_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    add $sp, $sp, 12
    jr $ra

play_game:
    sub $sp, $sp, 24
    sw $ra, 0($sp)
game_loop:
    la $a0, player_turn_msg
    jal display_game_state
    li $t0, 0
input_loop:
    bne $t0, $zero, check_move
    la $a0, move_prompt
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t1, $v0
    slti $t2, $t1, 1
    bne $t2, $zero, invalid_input
    slti $t2, $t1, 10
    beq $t2, $zero, invalid_input
    li $t0, 1
    j clear_input
invalid_input:
    la $a0, invalid_msg
    jal show_message
    la $a0, player_turn_msg
    jal display_game_state
    j input_loop
clear_input:
    li $v0, 12
    syscall
    li $t2, 10
    bne $v0, $t2, clear_input
    j input_loop
check_move:
    la $t2, top_marker
    sw $t1, 0($t2)
    lw $t3, 0($t2)
    la $t4, custom_marker
    lw $t4, 0($t4)
    mul $t5, $t3, $t4
    sw $t5, 4($sp)
    move $a0, $sp
    add $a1, $sp, 8
    add $a2, $sp, 12
    jal find_cell
    lw $t6, 8($sp)
    li $t7, -1
    beq $t6, $t7, not_in_grid
    mul $t7, $t6, 6
    lw $t8, 12($sp)
    add $t7, $t7, $t8
    sll $t7, $t7, 2
    la $t9, ownership
    add $t9, $t9, $t7
    lw $t0, 0($t9)
    beq $t0, $zero, claim_cell
    la $a0, taken_msg
    jal show_message
    j game_loop
not_in_grid:
    la $a0, not_in_grid_msg
    jal show_message
    j game_loop
claim_cell:
    li $t0, 1
    sw $t0, 0($t9)
    # Print "You claim" followed by number
    li $v0, 4
    la $a0, claim_msg
    syscall
    li $v0, 1
    lw $a0, 4($sp)
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    li $a0, 1
    jal check_win
    beq $v0, $zero, check_full
    la $a0, player_turn_msg
    jal display_game_state
    la $a0, win_msg
    jal show_message
    j end_game
check_full:
    jal is_board_full
    beq $v0, $zero, computer_turn
    la $a0, player_turn_msg
    jal display_game_state
    la $a0, tie_msg
    jal show_message
    j end_game
computer_turn:
    la $a0, comp_turn_msg
    jal display_game_state
    add $a0, $sp, 8
    add $a1, $sp, 12
    jal computer_move
    lw $t6, 8($sp)
    li $t7, -1
    beq $t6, $t7, comp_no_moves
    mul $t7, $t6, 6
    lw $t8, 12($sp)
    add $t7, $t7, $t8
    sll $t7, $t7, 2
    la $t9, ownership
    add $t9, $t9, $t7
    li $t0, 2
    sw $t0, 0($t9)
    la $t2, top_marker
    lw $t3, 0($t2)
    la $t4, custom_marker
    lw $t4, 0($t4)
    mul $t5, $t3, $t4
    sw $t5, 4($sp)
    # Print "Computer claims" followed by number
    li $v0, 4
    la $a0, comp_claim_msg
    syscall
    li $v0, 1
    lw $a0, 4($sp)
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    li $a0, 2
    jal check_win
    beq $v0, $zero, check_full_again
    la $a0, comp_turn_msg
    jal display_game_state
    la $a0, comp_win_msg
    jal show_message
    j end_game
comp_no_moves:
    la $a0, no_moves_msg
    jal show_message
    j check_full
check_full_again:
    jal is_board_full
    beq $v0, $zero, game_loop
    la $a0, comp_turn_msg
    jal display_game_state
    la $a0, tie_msg
    jal show_message
end_game:
    lw $ra, 0($sp)
    add $sp, $sp, 24
    jr $ra