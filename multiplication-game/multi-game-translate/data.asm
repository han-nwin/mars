.data
    .globl GRID
    GRID: .word 1, 2, 3, 4, 5, 6,
                7, 8, 9, 10, 12, 14,
                15, 16, 18, 20, 21, 24,
                25, 27, 28, 30, 32, 35,
                36, 40, 42, 45, 48, 49,
                54, 56, 63, 64, 72, 81
    .globl ownership
    ownership: .space 144  # 6x6 * 4 bytes
    .globl top_marker
    top_marker: .word 1
    .globl custom_marker
    custom_marker: .word 1

    # Strings for util.asm
    .globl clear_cmd
    clear_cmd:   .asciiz "clear"
    .globl reset_color
    reset_color: .asciiz "\033[0m"
    .globl red_color
    red_color:   .asciiz "\033[31m"
    .globl blue_color
    blue_color:  .asciiz "\033[34m"
    .globl fmt_x
    fmt_x:       .asciiz " %sX%s "
    .globl fmt_o
    fmt_o:       .asciiz " %sO%s "
    .globl fmt_num1
    fmt_num1:    .asciiz " %d "
    .globl fmt_num2
    fmt_num2:    .asciiz "%d "
    .globl v_str
    v_str:       .asciiz "v"
    .globl num_line
    num_line:    .asciiz "Number line: 1 2 3 4 5 6 7 8 9"
    .globl caret_str
    caret_str:   .asciiz "^"
    .globl prod_fmt
    prod_fmt:    .asciiz "Product: %d x %d = %d\n"
    .globl cont_msg
    cont_msg:    .asciiz "Press Enter to continue...\n"

    # Strings for game_logic.asm
    .globl player_turn_msg
    player_turn_msg: .asciiz "Your turn (X)\n"
    .globl move_prompt
    move_prompt:     .asciiz "Move the top marker to a number (1-9): "
    .globl invalid_msg
    invalid_msg:     .asciiz "Invalid input, enter a number between 1 and 9.\n"
    .globl not_in_grid_msg
    not_in_grid_msg: .asciiz "Product not in the grid, try again.\n"
    .globl taken_msg
    taken_msg:       .asciiz "Cell already taken, try again.\n"
    .globl claim_fmt
    claim_fmt:       .asciiz "You claim %d!\n"
    .globl win_msg
    win_msg:         .asciiz "You win!\n"
    .globl tie_msg
    tie_msg:         .asciiz "It's a tie!\n"
    .globl comp_turn_msg
    comp_turn_msg:   .asciiz "Computer's turn (O)\n"
    .globl no_moves_msg
    no_moves_msg:    .asciiz "Computer has no valid moves left!\n"
    .globl comp_claim_fmt
    comp_claim_fmt:  .asciiz "Computer claims %d!\n"
    .globl comp_win_msg
    comp_win_msg:    .asciiz "Computer wins!\n"