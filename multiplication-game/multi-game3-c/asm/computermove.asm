.text
.globl computer_turn
computer_turn:
    addiu $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # pos
    sw $s1, 8($sp)      # count
    sw $s2, 12($sp)     # pointer
    sw $s3, 16($sp)     # valid_moves base

    move $s2, $a0       # Save pointer
    addiu $sp, $sp, -36 # Space for valid_moves[9]
    move $s3, $sp
    li $s1, 0           # count
    li $s0, 1           # pos

comp_loop:
    bgt $s0, 9, comp_select
    move $a0, $s0
    jal set_bottom_marker

    jal get_top_marker
    move $t0, $v0
    jal get_bottom_marker
    mul $t0, $t0, $v0

    addiu $sp, $sp, -8
    move $a0, $t0
    move $a1, $sp
    jal find_cell
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addiu $sp, $sp, 8

    li $t2, -1
    beq $t0, $t2, comp_next
    move $a0, $t0
    move $a1, $t1
    jal get_ownership
    bnez $v0, comp_next

    sll $t2, $s1, 2
    addu $t2, $s3, $t2
    sw $s0, 0($t2)
    addiu $s1, $s1, 1

comp_next:
    addiu $s0, $s0, 1
    j comp_loop

comp_select:
    beqz $s1, comp_fail
    move $a0, $s1
    li $v0, 42          # Random bounded
    syscall
    sll $t0, $v0, 2
    addu $t0, $s3, $t0
    lw $a0, 0($t0)
    jal set_bottom_marker

    jal get_top_marker
    move $t0, $v0
    jal get_bottom_marker
    mul $t0, $t0, $v0
    move $a0, $t0
    move $a1, $s2
    jal find_cell
    j comp_end

comp_fail:
    li $t0, -1
    sw $t0, 0($s2)
    sw $t0, 4($s2)

comp_end:
    move $sp, $s3
    addiu $sp, $sp, 36
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addiu $sp, $sp, 20
    jr $ra
