	.file	1 "game.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=32
	.module	nooddspreg
	.module	arch=mips1
	.abicalls
	.text
	.globl	GRID
	.data
	.align	2
	.type	GRID, @object
	.size	GRID, 144
GRID:
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8
	.word	9
	.word	10
	.word	12
	.word	14
	.word	15
	.word	16
	.word	18
	.word	20
	.word	21
	.word	24
	.word	25
	.word	27
	.word	28
	.word	30
	.word	32
	.word	35
	.word	36
	.word	40
	.word	42
	.word	45
	.word	48
	.word	49
	.word	54
	.word	56
	.word	63
	.word	64
	.word	72
	.word	81
	.globl	ownership
	.section	.bss,"aw",@nobits
	.align	2
	.type	ownership, @object
	.size	ownership, 144
ownership:
	.space	144
	.globl	top_marker
	.data
	.align	2
	.type	top_marker, @object
	.size	top_marker, 4
top_marker:
	.word	1
	.globl	bottom_marker
	.align	2
	.type	bottom_marker, @object
	.size	bottom_marker, 4
bottom_marker:
	.word	1
	.rdata
	.align	2
$LC0:
	.ascii	"clear\000"
	.text
	.align	2
	.globl	clear_console
	.set	nomips16
	.set	nomicromips
	.ent	clear_console
	.type	clear_console, @function
clear_console:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lui	$2,%hi($LC0)
	addiu	$4,$2,%lo($LC0)
	lw	$2,%call16(system)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,system
1:	jalr	$25
	nop

	lw	$28,16($fp)
	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	clear_console
	.size	clear_console, .-clear_console
	.rdata
	.align	2
$LC1:
	.ascii	"\033[0m\000"
	.align	2
$LC2:
	.ascii	"\033[31m\000"
	.align	2
$LC3:
	.ascii	" %sX%s \000"
	.align	2
$LC4:
	.ascii	"\033[34m\000"
	.align	2
$LC5:
	.ascii	" %sO%s \000"
	.align	2
$LC6:
	.ascii	" %d \000"
	.align	2
$LC7:
	.ascii	"%d \000"
	.text
	.align	2
	.globl	display_grid
	.set	nomips16
	.set	nomicromips
	.ent	display_grid
	.type	display_grid, @function
display_grid:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	sw	$0,24($fp)
	.option	pic0
	b	$L3
	nop

	.option	pic2
$L11:
	sw	$0,28($fp)
	.option	pic0
	b	$L4
	nop

	.option	pic2
$L10:
	lui	$4,%hi(ownership)
	lw	$3,24($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	lw	$3,28($fp)
	nop
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$3,0($2)
	li	$2,1			# 0x1
	bne	$3,$2,$L5
	nop

	lui	$2,%hi($LC1)
	addiu	$6,$2,%lo($LC1)
	lui	$2,%hi($LC2)
	addiu	$5,$2,%lo($LC2)
	lui	$2,%hi($LC3)
	addiu	$4,$2,%lo($LC3)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	.option	pic0
	b	$L6
	nop

	.option	pic2
$L5:
	lui	$4,%hi(ownership)
	lw	$3,24($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	lw	$3,28($fp)
	nop
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$3,0($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L7
	nop

	lui	$2,%hi($LC1)
	addiu	$6,$2,%lo($LC1)
	lui	$2,%hi($LC4)
	addiu	$5,$2,%lo($LC4)
	lui	$2,%hi($LC5)
	addiu	$4,$2,%lo($LC5)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	.option	pic0
	b	$L6
	nop

	.option	pic2
$L7:
	lui	$4,%hi(GRID)
	lw	$3,24($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	lw	$3,28($fp)
	nop
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$4,%lo(GRID)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	sw	$2,32($fp)
	lw	$2,32($fp)
	nop
	slt	$2,$2,10
	beq	$2,$0,$L8
	nop

	lw	$5,32($fp)
	lui	$2,%hi($LC6)
	addiu	$4,$2,%lo($LC6)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	.option	pic0
	b	$L6
	nop

	.option	pic2
$L8:
	lw	$5,32($fp)
	lui	$2,%hi($LC7)
	addiu	$4,$2,%lo($LC7)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
$L6:
	lw	$2,28($fp)
	nop
	slt	$2,$2,5
	beq	$2,$0,$L9
	nop

	li	$4,124			# 0x7c
	lw	$2,%call16(putchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
$L9:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L4:
	lw	$2,28($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L10
	nop

	li	$4,10			# 0xa
	lw	$2,%call16(putchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L3:
	lw	$2,24($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L11
	nop

	li	$4,10			# 0xa
	lw	$2,%call16(putchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	nop
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	display_grid
	.size	display_grid, .-display_grid
	.rdata
	.align	2
$LC8:
	.ascii	"v\000"
	.align	2
$LC9:
	.ascii	"Number line: 1 2 3 4 5 6 7 8 9\000"
	.align	2
$LC10:
	.ascii	"^\000"
	.align	2
$LC11:
	.ascii	"Product: %d x %d = %d\012\000"
	.text
	.align	2
	.globl	display_number_line
	.set	nomips16
	.set	nomicromips
	.ent	display_number_line
	.type	display_number_line, @function
display_number_line:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lui	$2,%hi(top_marker)
	lw	$2,%lo(top_marker)($2)
	nop
	addiu	$2,$2,-1
	sll	$2,$2,1
	addiu	$2,$2,13
	sw	$2,32($fp)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	addiu	$2,$2,-1
	sll	$2,$2,1
	addiu	$2,$2,13
	sw	$2,36($fp)
	sw	$0,24($fp)
	.option	pic0
	b	$L13
	nop

	.option	pic2
$L14:
	li	$4,32			# 0x20
	lw	$2,%call16(putchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L13:
	lw	$3,24($fp)
	lw	$2,32($fp)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L14
	nop

	lui	$2,%hi($LC8)
	addiu	$4,$2,%lo($LC8)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi($LC9)
	addiu	$4,$2,%lo($LC9)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	sw	$0,28($fp)
	.option	pic0
	b	$L15
	nop

	.option	pic2
$L16:
	li	$4,32			# 0x20
	lw	$2,%call16(putchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L15:
	lw	$3,28($fp)
	lw	$2,36($fp)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L16
	nop

	lui	$2,%hi($LC10)
	addiu	$4,$2,%lo($LC10)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,40($fp)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	lw	$7,40($fp)
	move	$6,$2
	move	$5,$3
	lui	$2,%hi($LC11)
	addiu	$4,$2,%lo($LC11)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	li	$4,10			# 0xa
	lw	$2,%call16(putchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	nop
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	display_number_line
	.size	display_number_line, .-display_number_line
	.align	2
	.globl	display_game_state
	.set	nomips16
	.set	nomicromips
	.ent	display_game_state
	.type	display_game_state, @function
display_game_state:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	sw	$4,32($fp)
	.option	pic0
	jal	clear_console
	nop

	.option	pic2
	lw	$28,16($fp)
	lw	$4,32($fp)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	.option	pic0
	jal	display_grid
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	jal	display_number_line
	nop

	.option	pic2
	lw	$28,16($fp)
	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	display_game_state
	.size	display_game_state, .-display_game_state
	.rdata
	.align	2
$LC12:
	.ascii	"Press Enter to continue...\000"
	.text
	.align	2
	.globl	show_message
	.set	nomips16
	.set	nomicromips
	.ent	show_message
	.type	show_message, @function
show_message:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	sw	$4,32($fp)
	lw	$4,32($fp)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi($LC12)
	addiu	$4,$2,%lo($LC12)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	nop
$L19:
	lw	$2,%call16(getchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,getchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$3,$2
	li	$2,10			# 0xa
	bne	$3,$2,$L19
	nop

	nop
	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	show_message
	.size	show_message, .-show_message
	.align	2
	.globl	find_cell
	.set	nomips16
	.set	nomicromips
	.ent	find_cell
	.type	find_cell, @function
find_cell:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$fp,20($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$6,32($fp)
	lw	$2,28($fp)
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,0($2)
	lw	$2,32($fp)
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,0($2)
	sw	$0,8($fp)
	.option	pic0
	b	$L21
	nop

	.option	pic2
$L26:
	sw	$0,12($fp)
	.option	pic0
	b	$L22
	nop

	.option	pic2
$L25:
	lui	$4,%hi(GRID)
	lw	$3,8($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	lw	$3,12($fp)
	nop
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$4,%lo(GRID)
	addu	$2,$3,$2
	lw	$2,0($2)
	lw	$3,24($fp)
	nop
	bne	$3,$2,$L23
	nop

	lw	$2,28($fp)
	lw	$3,8($fp)
	nop
	sw	$3,0($2)
	lw	$2,32($fp)
	lw	$3,12($fp)
	nop
	sw	$3,0($2)
	.option	pic0
	b	$L20
	nop

	.option	pic2
$L23:
	lw	$2,12($fp)
	nop
	addiu	$2,$2,1
	sw	$2,12($fp)
$L22:
	lw	$2,12($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L25
	nop

	lw	$2,8($fp)
	nop
	addiu	$2,$2,1
	sw	$2,8($fp)
$L21:
	lw	$2,8($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L26
	nop

$L20:
	move	$sp,$fp
	lw	$fp,20($sp)
	addiu	$sp,$sp,24
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	find_cell
	.size	find_cell, .-find_cell
	.align	2
	.globl	check_win
	.set	nomips16
	.set	nomicromips
	.ent	check_win
	.type	check_win, @function
check_win:
	.frame	$fp,80,$31		# vars= 64, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-80
	sw	$fp,76($sp)
	move	$fp,$sp
	sw	$4,80($fp)
	sw	$0,8($fp)
	.option	pic0
	b	$L28
	nop

	.option	pic2
$L37:
	sw	$0,12($fp)
	.option	pic0
	b	$L29
	nop

	.option	pic2
$L36:
	li	$2,1			# 0x1
	sw	$2,16($fp)
	sw	$0,20($fp)
	.option	pic0
	b	$L30
	nop

	.option	pic2
$L33:
	lw	$3,12($fp)
	lw	$2,20($fp)
	nop
	addu	$5,$3,$2
	lui	$4,%hi(ownership)
	lw	$3,8($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	lw	$3,80($fp)
	nop
	beq	$3,$2,$L31
	nop

	sw	$0,16($fp)
	.option	pic0
	b	$L32
	nop

	.option	pic2
$L31:
	lw	$2,20($fp)
	nop
	addiu	$2,$2,1
	sw	$2,20($fp)
$L30:
	lw	$2,20($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L33
	nop

$L32:
	lw	$2,16($fp)
	nop
	beq	$2,$0,$L34
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L35
	nop

	.option	pic2
$L34:
	lw	$2,12($fp)
	nop
	addiu	$2,$2,1
	sw	$2,12($fp)
$L29:
	lw	$2,12($fp)
	nop
	slt	$2,$2,3
	bne	$2,$0,$L36
	nop

	lw	$2,8($fp)
	nop
	addiu	$2,$2,1
	sw	$2,8($fp)
$L28:
	lw	$2,8($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L37
	nop

	sw	$0,24($fp)
	.option	pic0
	b	$L38
	nop

	.option	pic2
$L46:
	sw	$0,28($fp)
	.option	pic0
	b	$L39
	nop

	.option	pic2
$L45:
	li	$2,1			# 0x1
	sw	$2,32($fp)
	sw	$0,36($fp)
	.option	pic0
	b	$L40
	nop

	.option	pic2
$L43:
	lw	$3,24($fp)
	lw	$2,36($fp)
	nop
	addu	$3,$3,$2
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	lw	$3,28($fp)
	nop
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	lw	$3,80($fp)
	nop
	beq	$3,$2,$L41
	nop

	sw	$0,32($fp)
	.option	pic0
	b	$L42
	nop

	.option	pic2
$L41:
	lw	$2,36($fp)
	nop
	addiu	$2,$2,1
	sw	$2,36($fp)
$L40:
	lw	$2,36($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L43
	nop

$L42:
	lw	$2,32($fp)
	nop
	beq	$2,$0,$L44
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L35
	nop

	.option	pic2
$L44:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L39:
	lw	$2,28($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L45
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L38:
	lw	$2,24($fp)
	nop
	slt	$2,$2,3
	bne	$2,$0,$L46
	nop

	sw	$0,40($fp)
	.option	pic0
	b	$L47
	nop

	.option	pic2
$L55:
	sw	$0,44($fp)
	.option	pic0
	b	$L48
	nop

	.option	pic2
$L54:
	li	$2,1			# 0x1
	sw	$2,48($fp)
	sw	$0,52($fp)
	.option	pic0
	b	$L49
	nop

	.option	pic2
$L52:
	lw	$3,40($fp)
	lw	$2,52($fp)
	nop
	addu	$3,$3,$2
	lw	$4,44($fp)
	lw	$2,52($fp)
	nop
	addu	$5,$4,$2
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	lw	$3,80($fp)
	nop
	beq	$3,$2,$L50
	nop

	sw	$0,48($fp)
	.option	pic0
	b	$L51
	nop

	.option	pic2
$L50:
	lw	$2,52($fp)
	nop
	addiu	$2,$2,1
	sw	$2,52($fp)
$L49:
	lw	$2,52($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L52
	nop

$L51:
	lw	$2,48($fp)
	nop
	beq	$2,$0,$L53
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L35
	nop

	.option	pic2
$L53:
	lw	$2,44($fp)
	nop
	addiu	$2,$2,1
	sw	$2,44($fp)
$L48:
	lw	$2,44($fp)
	nop
	slt	$2,$2,3
	bne	$2,$0,$L54
	nop

	lw	$2,40($fp)
	nop
	addiu	$2,$2,1
	sw	$2,40($fp)
$L47:
	lw	$2,40($fp)
	nop
	slt	$2,$2,3
	bne	$2,$0,$L55
	nop

	sw	$0,56($fp)
	.option	pic0
	b	$L56
	nop

	.option	pic2
$L64:
	li	$2,3			# 0x3
	sw	$2,60($fp)
	.option	pic0
	b	$L57
	nop

	.option	pic2
$L63:
	li	$2,1			# 0x1
	sw	$2,64($fp)
	sw	$0,68($fp)
	.option	pic0
	b	$L58
	nop

	.option	pic2
$L61:
	lw	$3,56($fp)
	lw	$2,68($fp)
	nop
	addu	$3,$3,$2
	lw	$4,60($fp)
	lw	$2,68($fp)
	nop
	subu	$5,$4,$2
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	lw	$3,80($fp)
	nop
	beq	$3,$2,$L59
	nop

	sw	$0,64($fp)
	.option	pic0
	b	$L60
	nop

	.option	pic2
$L59:
	lw	$2,68($fp)
	nop
	addiu	$2,$2,1
	sw	$2,68($fp)
$L58:
	lw	$2,68($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L61
	nop

$L60:
	lw	$2,64($fp)
	nop
	beq	$2,$0,$L62
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L35
	nop

	.option	pic2
$L62:
	lw	$2,60($fp)
	nop
	addiu	$2,$2,1
	sw	$2,60($fp)
$L57:
	lw	$2,60($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L63
	nop

	lw	$2,56($fp)
	nop
	addiu	$2,$2,1
	sw	$2,56($fp)
$L56:
	lw	$2,56($fp)
	nop
	slt	$2,$2,3
	bne	$2,$0,$L64
	nop

	move	$2,$0
$L35:
	move	$sp,$fp
	lw	$fp,76($sp)
	addiu	$sp,$sp,80
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	check_win
	.size	check_win, .-check_win
	.align	2
	.globl	is_board_full
	.set	nomips16
	.set	nomicromips
	.ent	is_board_full
	.type	is_board_full, @function
is_board_full:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$fp,20($sp)
	move	$fp,$sp
	sw	$0,8($fp)
	.option	pic0
	b	$L66
	nop

	.option	pic2
$L71:
	sw	$0,12($fp)
	.option	pic0
	b	$L67
	nop

	.option	pic2
$L70:
	lui	$4,%hi(ownership)
	lw	$3,8($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	lw	$3,12($fp)
	nop
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	bne	$2,$0,$L68
	nop

	move	$2,$0
	.option	pic0
	b	$L69
	nop

	.option	pic2
$L68:
	lw	$2,12($fp)
	nop
	addiu	$2,$2,1
	sw	$2,12($fp)
$L67:
	lw	$2,12($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L70
	nop

	lw	$2,8($fp)
	nop
	addiu	$2,$2,1
	sw	$2,8($fp)
$L66:
	lw	$2,8($fp)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L71
	nop

	li	$2,1			# 0x1
$L69:
	move	$sp,$fp
	lw	$fp,20($sp)
	addiu	$sp,$sp,24
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	is_board_full
	.size	is_board_full, .-is_board_full
	.align	2
	.globl	simulate_move
	.set	nomips16
	.set	nomicromips
	.ent	simulate_move
	.type	simulate_move, @function
simulate_move:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	sw	$5,60($fp)
	sw	$6,64($fp)
	lui	$2,%hi(top_marker)
	lw	$2,%lo(top_marker)($2)
	nop
	sw	$2,24($fp)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	sw	$2,28($fp)
	lw	$2,60($fp)
	nop
	beq	$2,$0,$L73
	nop

	lui	$2,%hi(top_marker)
	lw	$3,56($fp)
	nop
	sw	$3,%lo(top_marker)($2)
	.option	pic0
	b	$L74
	nop

	.option	pic2
$L73:
	lui	$2,%hi(bottom_marker)
	lw	$3,56($fp)
	nop
	sw	$3,%lo(bottom_marker)($2)
$L74:
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,32($fp)
	addiu	$3,$fp,44
	addiu	$2,$fp,40
	move	$6,$3
	move	$5,$2
	lw	$4,32($fp)
	.option	pic0
	jal	find_cell
	nop

	.option	pic2
	lui	$2,%hi(top_marker)
	lw	$3,24($fp)
	nop
	sw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$3,28($fp)
	nop
	sw	$3,%lo(bottom_marker)($2)
	lw	$3,40($fp)
	li	$2,-1			# 0xffffffffffffffff
	beq	$3,$2,$L75
	nop

	lw	$3,40($fp)
	lw	$5,44($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	beq	$2,$0,$L76
	nop

$L75:
	move	$2,$0
	.option	pic0
	b	$L78
	nop

	.option	pic2
$L76:
	lw	$3,40($fp)
	lw	$5,44($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$3,64($fp)
	nop
	sw	$3,0($2)
	lw	$4,64($fp)
	.option	pic0
	jal	check_win
	nop

	.option	pic2
	sw	$2,36($fp)
	lw	$3,40($fp)
	lw	$5,44($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	sw	$0,0($2)
	lw	$2,36($fp)
$L78:
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	simulate_move
	.size	simulate_move, .-simulate_move
	.align	2
	.globl	computer_move
	.set	nomips16
	.set	nomicromips
	.ent	computer_move
	.type	computer_move, @function
computer_move:
	.frame	$fp,128,$31		# vars= 96, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-128
	sw	$31,124($sp)
	sw	$fp,120($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	sw	$4,128($fp)
	sw	$5,132($fp)
	li	$2,1			# 0x1
	sw	$2,24($fp)
	.option	pic0
	b	$L80
	nop

	.option	pic2
$L83:
	li	$6,2			# 0x2
	move	$5,$0
	lw	$4,24($fp)
	.option	pic0
	jal	simulate_move
	nop

	.option	pic2
	lw	$28,16($fp)
	beq	$2,$0,$L81
	nop

	lui	$2,%hi(bottom_marker)
	lw	$3,24($fp)
	nop
	sw	$3,%lo(bottom_marker)($2)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,60($fp)
	lw	$6,132($fp)
	lw	$5,128($fp)
	lw	$4,60($fp)
	.option	pic0
	jal	find_cell
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L79
	nop

	.option	pic2
$L81:
	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L80:
	lw	$2,24($fp)
	nop
	slt	$2,$2,10
	bne	$2,$0,$L83
	nop

	li	$2,1			# 0x1
	sw	$2,28($fp)
	.option	pic0
	b	$L84
	nop

	.option	pic2
$L89:
	li	$6,1			# 0x1
	li	$5,1			# 0x1
	lw	$4,28($fp)
	.option	pic0
	jal	simulate_move
	nop

	.option	pic2
	lw	$28,16($fp)
	beq	$2,$0,$L85
	nop

	li	$2,1			# 0x1
	sw	$2,32($fp)
	.option	pic0
	b	$L86
	nop

	.option	pic2
$L88:
	lui	$2,%hi(top_marker)
	lw	$2,%lo(top_marker)($2)
	nop
	sw	$2,52($fp)
	lui	$2,%hi(bottom_marker)
	lw	$3,32($fp)
	nop
	sw	$3,%lo(bottom_marker)($2)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,56($fp)
	addiu	$3,$fp,104
	addiu	$2,$fp,100
	move	$6,$3
	move	$5,$2
	lw	$4,56($fp)
	.option	pic0
	jal	find_cell
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi(top_marker)
	lw	$3,52($fp)
	nop
	sw	$3,%lo(top_marker)($2)
	lw	$2,100($fp)
	lw	$3,28($fp)
	nop
	bne	$3,$2,$L87
	nop

	lw	$3,100($fp)
	lw	$5,104($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	bne	$2,$0,$L87
	nop

	lui	$2,%hi(bottom_marker)
	lw	$3,32($fp)
	nop
	sw	$3,%lo(bottom_marker)($2)
	lw	$3,100($fp)
	lw	$2,128($fp)
	nop
	sw	$3,0($2)
	lw	$3,104($fp)
	lw	$2,132($fp)
	nop
	sw	$3,0($2)
	.option	pic0
	b	$L79
	nop

	.option	pic2
$L87:
	lw	$2,32($fp)
	nop
	addiu	$2,$2,1
	sw	$2,32($fp)
$L86:
	lw	$2,32($fp)
	nop
	slt	$2,$2,10
	bne	$2,$0,$L88
	nop

$L85:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L84:
	lw	$2,28($fp)
	nop
	slt	$2,$2,10
	bne	$2,$0,$L89
	nop

	sw	$0,36($fp)
	li	$2,1			# 0x1
	sw	$2,40($fp)
	.option	pic0
	b	$L90
	nop

	.option	pic2
$L92:
	lui	$2,%hi(bottom_marker)
	lw	$3,40($fp)
	nop
	sw	$3,%lo(bottom_marker)($2)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,48($fp)
	addiu	$3,$fp,112
	addiu	$2,$fp,108
	move	$6,$3
	move	$5,$2
	lw	$4,48($fp)
	.option	pic0
	jal	find_cell
	nop

	.option	pic2
	lw	$28,16($fp)
	lw	$3,108($fp)
	li	$2,-1			# 0xffffffffffffffff
	beq	$3,$2,$L91
	nop

	lw	$3,108($fp)
	lw	$5,112($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	bne	$2,$0,$L91
	nop

	lw	$2,36($fp)
	nop
	addiu	$3,$2,1
	sw	$3,36($fp)
	sll	$2,$2,2
	addiu	$3,$fp,24
	addu	$2,$3,$2
	lw	$3,40($fp)
	nop
	sw	$3,40($2)
$L91:
	lw	$2,40($fp)
	nop
	addiu	$2,$2,1
	sw	$2,40($fp)
$L90:
	lw	$2,40($fp)
	nop
	slt	$2,$2,10
	bne	$2,$0,$L92
	nop

	lw	$2,36($fp)
	nop
	blez	$2,$L93
	nop

	lw	$2,%call16(rand)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,rand
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$3,$2
	lw	$2,36($fp)
	nop
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	sll	$2,$2,2
	addiu	$3,$fp,24
	addu	$2,$3,$2
	lw	$3,40($2)
	lui	$2,%hi(bottom_marker)
	sw	$3,%lo(bottom_marker)($2)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,44($fp)
	lw	$6,132($fp)
	lw	$5,128($fp)
	lw	$4,44($fp)
	.option	pic0
	jal	find_cell
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L79
	nop

	.option	pic2
$L93:
	lw	$2,128($fp)
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,0($2)
	lw	$2,132($fp)
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,0($2)
$L79:
	move	$sp,$fp
	lw	$31,124($sp)
	lw	$fp,120($sp)
	addiu	$sp,$sp,128
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	computer_move
	.size	computer_move, .-computer_move
	.rdata
	.align	2
$LC13:
	.ascii	"Your turn (X)\000"
	.align	2
$LC14:
	.ascii	"Move the top marker to a number (1-9): \000"
	.align	2
$LC15:
	.ascii	"%d\000"
	.align	2
$LC16:
	.ascii	"Invalid input, enter a number between 1 and 9.\000"
	.align	2
$LC17:
	.ascii	"Product not in the grid, try again.\000"
	.align	2
$LC18:
	.ascii	"Cell already taken, try again.\000"
	.align	2
$LC19:
	.ascii	"You claim %d!\000"
	.align	2
$LC20:
	.ascii	"You win!\000"
	.align	2
$LC21:
	.ascii	"It's a tie!\000"
	.align	2
$LC22:
	.ascii	"Computer's turn (O)\000"
	.align	2
$LC23:
	.ascii	"Computer has no valid moves left!\000"
	.align	2
$LC24:
	.ascii	"Computer claims %d!\000"
	.align	2
$LC25:
	.ascii	"Computer wins!\000"
	.text
	.align	2
	.globl	play_game
	.set	nomips16
	.set	nomicromips
	.ent	play_game
	.type	play_game, @function
play_game:
	.frame	$fp,104,$31		# vars= 72, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-104
	sw	$31,100($sp)
	sw	$fp,96($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
$L112:
	lui	$2,%hi($LC13)
	addiu	$4,$2,%lo($LC13)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$0,24($fp)
	.option	pic0
	b	$L97
	nop

	.option	pic2
$L101:
	lui	$2,%hi($LC14)
	addiu	$4,$2,%lo($LC14)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	addiu	$2,$fp,32
	move	$5,$2
	lui	$2,%hi($LC15)
	addiu	$4,$2,%lo($LC15)
	lw	$2,%call16(__isoc99_scanf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$3,$2
	li	$2,1			# 0x1
	bne	$3,$2,$L98
	nop

	lw	$2,32($fp)
	nop
	blez	$2,$L98
	nop

	lw	$2,32($fp)
	nop
	slt	$2,$2,10
	beq	$2,$0,$L98
	nop

	li	$2,1			# 0x1
	sw	$2,24($fp)
	.option	pic0
	b	$L99
	nop

	.option	pic2
$L98:
	lui	$2,%hi($LC16)
	addiu	$4,$2,%lo($LC16)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi($LC13)
	addiu	$4,$2,%lo($LC13)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
$L99:
	nop
$L100:
	lw	$2,%call16(getchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,getchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$3,$2
	li	$2,10			# 0xa
	bne	$3,$2,$L100
	nop

$L97:
	lw	$2,24($fp)
	nop
	beq	$2,$0,$L101
	nop

	lw	$3,32($fp)
	lui	$2,%hi(top_marker)
	sw	$3,%lo(top_marker)($2)
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,28($fp)
	addiu	$3,$fp,40
	addiu	$2,$fp,36
	move	$6,$3
	move	$5,$2
	lw	$4,28($fp)
	.option	pic0
	jal	find_cell
	nop

	.option	pic2
	lw	$28,16($fp)
	lw	$3,36($fp)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L102
	nop

	lui	$2,%hi($LC17)
	addiu	$4,$2,%lo($LC17)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L111
	nop

	.option	pic2
$L102:
	lw	$3,36($fp)
	lw	$5,40($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	beq	$2,$0,$L104
	nop

	lui	$2,%hi($LC18)
	addiu	$4,$2,%lo($LC18)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L111
	nop

	.option	pic2
$L104:
	lw	$3,36($fp)
	lw	$5,40($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	li	$3,1			# 0x1
	sw	$3,0($2)
	addiu	$3,$fp,44
	lw	$7,28($fp)
	lui	$2,%hi($LC19)
	addiu	$6,$2,%lo($LC19)
	li	$5,50			# 0x32
	move	$4,$3
	lw	$2,%call16(snprintf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,snprintf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	addiu	$2,$fp,44
	move	$4,$2
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	li	$4,1			# 0x1
	.option	pic0
	jal	check_win
	nop

	.option	pic2
	lw	$28,16($fp)
	beq	$2,$0,$L105
	nop

	lui	$2,%hi($LC13)
	addiu	$4,$2,%lo($LC13)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi($LC20)
	addiu	$4,$2,%lo($LC20)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L106
	nop

	.option	pic2
$L105:
	.option	pic0
	jal	is_board_full
	nop

	.option	pic2
	lw	$28,16($fp)
	beq	$2,$0,$L107
	nop

	lui	$2,%hi($LC13)
	addiu	$4,$2,%lo($LC13)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi($LC21)
	addiu	$4,$2,%lo($LC21)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L106
	nop

	.option	pic2
$L107:
	lui	$2,%hi($LC22)
	addiu	$4,$2,%lo($LC22)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
	addiu	$3,$fp,40
	addiu	$2,$fp,36
	move	$5,$3
	move	$4,$2
	.option	pic0
	jal	computer_move
	nop

	.option	pic2
	lw	$28,16($fp)
	lw	$3,36($fp)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L108
	nop

	lui	$2,%hi($LC23)
	addiu	$4,$2,%lo($LC23)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L106
	nop

	.option	pic2
$L108:
	lui	$2,%hi(top_marker)
	lw	$3,%lo(top_marker)($2)
	lui	$2,%hi(bottom_marker)
	lw	$2,%lo(bottom_marker)($2)
	nop
	mult	$3,$2
	mflo	$2
	sw	$2,28($fp)
	lw	$3,36($fp)
	lw	$5,40($fp)
	lui	$4,%hi(ownership)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,1
	addu	$2,$2,$5
	sll	$3,$2,2
	addiu	$2,$4,%lo(ownership)
	addu	$2,$3,$2
	li	$3,2			# 0x2
	sw	$3,0($2)
	addiu	$3,$fp,44
	lw	$7,28($fp)
	lui	$2,%hi($LC24)
	addiu	$6,$2,%lo($LC24)
	li	$5,50			# 0x32
	move	$4,$3
	lw	$2,%call16(snprintf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,snprintf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	addiu	$2,$fp,44
	move	$4,$2
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	li	$4,2			# 0x2
	.option	pic0
	jal	check_win
	nop

	.option	pic2
	lw	$28,16($fp)
	beq	$2,$0,$L109
	nop

	lui	$2,%hi($LC22)
	addiu	$4,$2,%lo($LC22)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi($LC25)
	addiu	$4,$2,%lo($LC25)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	.option	pic0
	b	$L106
	nop

	.option	pic2
$L109:
	.option	pic0
	jal	is_board_full
	nop

	.option	pic2
	lw	$28,16($fp)
	beq	$2,$0,$L112
	nop

	lui	$2,%hi($LC22)
	addiu	$4,$2,%lo($LC22)
	.option	pic0
	jal	display_game_state
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi($LC21)
	addiu	$4,$2,%lo($LC21)
	.option	pic0
	jal	show_message
	nop

	.option	pic2
	lw	$28,16($fp)
	nop
$L106:
	.option	pic0
	b	$L113
	nop

	.option	pic2
$L111:
	.option	pic0
	b	$L112
	nop

	.option	pic2
$L113:
	move	$sp,$fp
	lw	$31,100($sp)
	lw	$fp,96($sp)
	addiu	$sp,$sp,104
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	play_game
	.size	play_game, .-play_game
	.rdata
	.align	2
$LC26:
	.ascii	"Welcome to Multiplication Four!\000"
	.align	2
$LC27:
	.ascii	"Move the top marker on the number line to claim cells. F"
	.ascii	"our in a row wins!\000"
	.align	2
$LC28:
	.ascii	"You are X (red), the computer is O (blue).\000"
	.align	2
$LC29:
	.ascii	"Press Enter to start the game...\000"
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	move	$4,$0
	lw	$2,%call16(time)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,time
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$4,$2
	lw	$2,%call16(srand)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,srand
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi($LC26)
	addiu	$4,$2,%lo($LC26)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi($LC27)
	addiu	$4,$2,%lo($LC27)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi($LC28)
	addiu	$4,$2,%lo($LC28)
	lw	$2,%call16(puts)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lui	$2,%hi($LC29)
	addiu	$4,$2,%lo($LC29)
	lw	$2,%call16(printf)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	nop
$L115:
	lw	$2,%call16(getchar)($28)
	nop
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,getchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$3,$2
	li	$2,10			# 0xa
	bne	$3,$2,$L115
	nop

	.option	pic0
	jal	play_game
	nop

	.option	pic2
	lw	$28,16($fp)
	move	$2,$0
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 13.3.0"
