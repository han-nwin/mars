.text

find_cell:
    li $t0, -1
    sw $t0, 0($a1)         # Default row = -1
    sw $t0, 0($a2)         # Default col = -1
    li $t0, 0              # row
row_loop:
    slti $t1, $t0, 6       # row < 6
    beq $t1, $zero, end_find
    li $t1, 0              # col
col_loop:
    slti $t2, $t1, 6       # col < 6
    beq $t2, $zero, next_row_find
    mul $t2, $t0, 6
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, GRID           # Global symbol
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
    li $t0, 0              # row
row_check:
    slti $t1, $t0, 6       # row < 6
    beq $t1, $zero, col_check_start
    li $t1, 0              # col
col_check:
    slti $t2, $t1, 3       # col < 3
    beq $t2, $zero, next_row_check
    li $t2, 1              # win flag
    li $t3, 0              # offset
row_win_loop:
    slti $t4, $t3, 4       # offset < 4
    beq $t4, $zero, check_row_win
    add $t4, $t1, $t3
    mul $t5, $t0, 6
    add $t5, $t5, $t4
    sll $t5, $t5, 2
    la $t6, ownership      # Global symbol
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
    slti $t1, $t0, 3       # row < 3
    beq $t1, $zero, diag_check_start
    li $t1, 0
col_win_check:
    slti $t2, $t1, 6       # col < 6
    beq $t2, $zero, next_col_check_loop
    li $t2, 1
    li $t3, 0
col_win_loop:
    slti $t4, $t3, 4       # offset < 4
    beq $t4, $zero, check_col_win
    add $t4, $t0, $t3
    mul $t5, $t4, 6
    add $t5, $t5, $t1
    sll $t5, $t5, 2
    la $t6, ownership      # Global symbol
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
    slti $t1, $t0, 3       # row < 3
    beq $t1, $zero, diag2_check_start
    li $t1, 0
diag_col_check:
    slti $t2, $t1, 3       # col < 3
    beq $t2, $zero, next_diag_check
    li $t2, 1
    li $t3, 0
diag_win_loop:
    slti $t4, $t3, 4       # offset < 4
    beq $t4, $zero, check_diag_win
    add $t4, $t0, $t3
    add $t5, $t1, $t3
    mul $t6, $t4, 6
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    la $t7, ownership      # Global symbol
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
    slti $t1, $t0, 3       # row < 3
    beq $t1, $zero, no_win
    li $t1, 3
diag2_col_check:
    slti $t2, $t1, 6       # col < 6
    beq $t2, $zero, next_diag2_check
    li $t2, 1
    li $t3, 0
diag2_win_loop:
    slti $t4, $t3, 4       # offset < 4
    beq $t4, $zero, check_diag2_win
    add $t4, $t0, $t3
    sub $t5, $t1, $t3
    mul $t6, $t4, 6
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    la $t7, ownership      # Global symbol
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
    slti $t1, $t0, 6       # row < 6
    beq $t1, $zero, board_full
    li $t1, 0
full_col_loop:
    slti $t2, $t1, 6       # col < 6
    beq $t2, $zero, next_full_row
    mul $t2, $t0, 6
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, ownership      # Global symbol
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
    la $t0, top_marker     # Global symbol
    lw $s0, 0($t0)
    la $t2, custom_marker  # Global symbol
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
    la $t0, ownership      # Global symbol
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
    slti $t1, $s0, 10      # num < 10
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
    slti $t1, $s0, 10      # num < 10
    beq $t1, $zero, random_move_start
    move $a0, $s0
    li $a1, 1
    li $a2, 1
    jal simulate_move
    bne $v0, $zero, block_move
    addi $s0, $s0, 1
    j block_loop

block_move:
    la $t2, custom_marker  # Global symbol
    sw $s0, 0($t2)
    j compute_position

random_move_start:
    li $s0, 0              # count
    li $s1, 1             # num
    sub $sp, $sp, 36
random_loop:
    slti $t1, $s1, 10      # num < 10
    beq $t1, $zero, pick_random
    la $t2, custom_marker  # Global symbol
    sw $s1, 0($t2)
    la $t3, top_marker     # Global symbol
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
    la $t2, ownership      # Global symbol
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
    la $t3, custom_marker  # Global symbol
    sw $t2, 0($t3)
    add $sp, $sp, 36
    j compute_position

apply_move:
    la $t2, custom_marker  # Global symbol
    sw $s0, 0($t2)

compute_position:
    la $t3, top_marker     # Global symbol
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
    la $a0, player_turn_msg  # Global symbol
    jal display_game_state
    li $t0, 0
input_loop:
    bne $t0, $zero, check_move
    la $a0, move_prompt    # Global symbol
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t1, $v0
    slti $t2, $t1, 1       # input < 1
    bne $t2, $zero, invalid_input
    slti $t2, $t1, 10      # input < 10
    beq $t2, $zero, invalid_input
    li $t0, 1
    j clear_input
invalid_input:
    la $a0, invalid_msg    # Global symbol
    jal show_message
    la $a0, player_turn_msg  # Global symbol
    jal display_game_state
    j input_loop
clear_input:
    li $v0, 12
    syscall
    li $t2, 10
    bne $v0, $t2, clear_input
    j input_loop
check_move:
    la $t2, top_marker     # Global symbol
    sw $t1, 0($t2)
    lw $t3, 0($t2)
    la $t4, custom_marker  # Global symbol
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
    la $t9, ownership      # Global symbol
    add $t9, $t9, $t7
    lw $t0, 0($t9)
    beq $t0, $zero, claim_cell
    la $a0, taken_msg      # Global symbol
    jal show_message
    j game_loop
not_in_grid:
    la $a0, not_in_grid_msg  # Global symbol
    jal show_message
    j game_loop
claim_cell:
    li $t0, 1
    sw $t0, 0($t9)
    la $a0, claim_fmt      # Global symbol
    lw $a1, 4($sp)
    li $v0, 4
    syscall
    li $a0, 1
    jal check_win
    beq $v0, $zero, check_full
    la $a0, player_turn_msg  # Global symbol
    jal display_game_state
    la $a0, win_msg        # Global symbol
    jal show_message
    j end_game
check_full:
    jal is_board_full
    beq $v0, $zero, computer_turn
    la $a0, player_turn_msg  # Global symbol
    jal display_game_state
    la $a0, tie_msg        # Global symbol
    jal show_message
    j end_game
computer_turn:
    la $a0, comp_turn_msg  # Global symbol
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
    la $t9, ownership      # Global symbol
    add $t9, $t9, $t7
    li $t0, 2
    sw $t0, 0($t9)
    la $t2, top_marker     # Global symbol
    lw $t3, 0($t2)
    la $t4, custom_marker  # Global symbol
    lw $t4, 0($t4)
    mul $t5, $t3, $t4
    sw $t5, 4($sp)
    la $a0, comp_claim_fmt  # Global symbol
    lw $a1, 4($sp)
    li $v0, 4
    syscall
    li $a0, 2
    jal check_win
    beq $v0, $zero, check_full_again
    la $a0, comp_turn_msg  # Global symbol
    jal display_game_state
    la $a0, comp_win_msg   # Global symbol
    jal show_message
    j end_game
comp_no_moves:
    la $a0, no_moves_msg   # Global symbol
    jal show_message
    j check_full
check_full_again:
    jal is_board_full
    beq $v0, $zero, game_loop
    la $a0, comp_turn_msg  # Global symbol
    jal display_game_state
    la $a0, tie_msg        # Global symbol
    jal show_message
end_game:
    lw $ra, 0($sp)
    add $sp, $sp, 24
    jr $ra