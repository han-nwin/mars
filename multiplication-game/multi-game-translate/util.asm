.text

clear_console:
    li $v0, 11
    li $a0, '\n'
    syscall
    syscall
    syscall
    jr $ra

display_grid:
    li $t0, 0              # row
outer_loop:
    slti $t1, $t0, 6       # row < 6
    beq $t1, $zero, end_display_grid
    li $t1, 0              # col
inner_loop:
    slti $t2, $t1, 6       # col < 6
    beq $t2, $zero, next_row
    mul $t2, $t0, 6
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    la $t3, ownership      # Global symbol
    add $t3, $t3, $t2
    lw $t3, 0($t3)
    li $t4, 1
    beq $t3, $t4, print_x
    li $t4, 2
    beq $t3, $t4, print_o
    la $t4, GRID           # Global symbol
    add $t4, $t4, $t2
    lw $t5, 0($t4)
    slti $t6, $t5, 10
    beq $t6, $zero, print_large_num
    li $v0, 4
    la $a0, fmt_num1       # Global symbol
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    j check_col
print_large_num:
    li $v0, 4
    la $a0, fmt_num2       # Global symbol
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    j check_col
print_x:
    li $v0, 4
    la $a0, fmt_x          # Global symbol
    la $a1, red_color      # Global symbol
    la $a2, reset_color    # Global symbol
    syscall
    j check_col
print_o:
    li $v0, 4
    la $a0, fmt_o          # Global symbol
    la $a1, blue_color     # Global symbol
    la $a2, reset_color    # Global symbol
    syscall
check_col:
    slti $t2, $t1, 5       # col < 5
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
    la $t0, top_marker     # Global symbol
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
    la $a0, v_str          # Global symbol
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    li $v0, 4
    la $a0, num_line       # Global symbol
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    la $t0, custom_marker  # Global symbol
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
    la $a0, caret_str      # Global symbol
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    la $t0, top_marker     # Global symbol
    lw $t1, 0($t0)
    la $t0, custom_marker  # Global symbol
    lw $t2, 0($t0)
    mul $t3, $t1, $t2
    li $v0, 4
    la $a0, prod_fmt       # Global symbol
    move $a1, $t1
    move $a2, $t2
    move $a3, $t3
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
    la $a0, cont_msg       # Global symbol
    syscall
wait_enter:
    li $v0, 12
    syscall
    li $t0, 10
    bne $v0, $t0, wait_enter
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra