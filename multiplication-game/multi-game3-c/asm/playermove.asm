.data
prompt:     .asciiz "Enter a number (1-9) to move your marker: "
invalid:    .asciiz "Invalid input! Please enter a number between 1 and 9.\n"
debug_before: .asciiz "Row, Col before get_ownership: "
space: .asciiz " "
newline: .asciiz "\n"
debug_sp: .asciiz "SP before load: "
.text
.globl player_turn
player_turn:
    addiu $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # Debug: Save $sp
    move $t3, $sp
    la $a0, prompt
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s1, $v0
clear_buffer:
    li $v0, 12
    syscall
    bne $v0, 10, clear_buffer
    blt $s1, 1, invalid_input
    bgt $s1, 9, invalid_input
    move $a0, $s1
    jal set_top_marker
    jal get_top_marker
    move $s0, $v0
    jal get_bottom_marker
    mul $s0, $s0, $v0
    addiu $sp, $sp, -16
    move $a0, $s0
    move $a1, $sp
    jal find_cell
    # Debug: Print $sp before load
    la $a0, debug_sp
    li $v0, 4
    syscall
    move $a0, $sp
    li $v0, 34
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addiu $sp, $sp, 16
    li $t2, -1
    beq $t0, $t2, invalid_move
    # Debug print
    la $a0, debug_before
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall
    move $a0, $t1
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    move $a0, $t0
    move $a1, $t1
    jal get_ownership
    bnez $v0, invalid_move
    move $a0, $t0
    move $a1, $t1
    li $a2, 1
    jal set_ownership
    li $v0, 1
    j turn_end
invalid_input:
    la $a0, invalid
    li $v0, 4
    syscall
    li $v0, 0
    j turn_end
invalid_move:
    li $v0, 0
    j turn_end
turn_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addiu $sp, $sp, 16
    jr $ra
