.data
.globl GRID
GRID:   .word 1, 2, 3, 4, 5, 6      # 6x6 grid of multiplication products
        .word 7, 8, 9, 10, 12, 14
        .word 15, 16, 18, 20, 21, 24
        .word 25, 27, 28, 30, 32, 35
        .word 36, 40, 42, 45, 48, 49
        .word 54, 56, 63, 64, 72, 81
.globl ownership
ownership: .space 144                # 6x6 grid (36 words, 4 bytes each) to track ownership: 0 = empty, 1 = X, 2 = O
.globl top_marker
top_marker: .word 1                  # Player’s marker position (1-9)
.globl bottom_marker
bottom_marker: .word 1               # Computer’s marker position (1-9)

.text
.globl init_game
init_game:
    # Initialize game state
    la $t0, ownership                # Load base address of ownership array
    li $t1, 0                        # Counter (0 to 35)
    li $t2, 36                       # Total cells (6x6)
init_loop:
    bge $t1, $t2, init_end           # If counter >= 36, finish
    sw $zero, 0($t0)                 # Set ownership[ counter ] = 0 (empty)
    addiu $t0, $t0, 4                # Move to next word (4 bytes)
    addiu $t1, $t1, 1                # Increment counter
    j init_loop                      # Repeat
init_end:
    li $t0, 1                        # Initial marker value
    sw $t0, top_marker               # Set top_marker = 1
    sw $t0, bottom_marker            # Set bottom_marker = 1
    jr $ra                           # Return

.globl get_grid_value
get_grid_value:
    # Get value from GRID at row ($a0), col ($a1)
    sll $t0, $a0, 4                  # row * 16
    sll $t1, $a0, 3                  # row * 8
    addu $t0, $t0, $t1               # row * 24 (6 cols * 4 bytes)
    sll $t1, $a1, 2                  # col * 4
    addu $t0, $t0, $t1               # Offset = row * 24 + col * 4
    la $t1, GRID                     # Load GRID base address
    addu $t0, $t1, $t0               # Address = GRID + offset
    lw $v0, 0($t0)                   # Load value into $v0
    jr $ra                           # Return value in $v0

.globl get_ownership
get_ownership:
    # Get ownership value at row ($a0), col ($a1)
    sll $t0, $a0, 4                  # row * 16
    sll $t1, $a0, 3                  # row * 8
    addu $t0, $t0, $t1               # row * 24
    sll $t1, $a1, 2                  # col * 4
    addu $t0, $t0, $t1               # Offset = row * 24 + col * 4
    la $t1, ownership                # Load ownership base address
    addu $t0, $t1, $t0               # Address = ownership + offset
    lw $v0, 0($t0)                   # Load ownership value into $v0
    jr $ra                           # Return value in $v0

.globl set_ownership
set_ownership:
    # Set ownership value at row ($a0), col ($a1) to $a2 (1 or 2)
    sll $t0, $a0, 4                  # row * 16
    sll $t1, $a0, 3                  # row * 8
    addu $t0, $t0, $t1               # row * 24
    sll $t1, $a1, 2                  # col * 4
    addu $t0, $t0, $t1               # Offset = row * 24 + col * 4
    la $t1, ownership                # Load ownership base address
    addu $t0, $t1, $t0               # Address = ownership + offset
    sw $a2, 0($t0)                   # Store $a2 (1 = X, 2 = O) at address
    jr $ra                           # Return

.globl get_top_marker
get_top_marker:
    # Get player’s marker position
    lw $v0, top_marker               # Load top_marker into $v0
    jr $ra                           # Return value in $v0

.globl get_bottom_marker
get_bottom_marker:
    # Get computer’s marker position
    lw $v0, bottom_marker            # Load bottom_marker into $v0
    jr $ra                           # Return value in $v0

.globl set_top_marker
set_top_marker:
    # Set player’s marker position to $a0
    sw $a0, top_marker               # Store $a0 in top_marker
    jr $ra                           # Return

.globl set_bottom_marker
set_bottom_marker:
    # Set computer’s marker position to $a0
    sw $a0, bottom_marker            # Store $a0 in bottom_marker
    jr $ra                           # Return

.globl find_cell
find_cell:
    # Find row, col in GRID where value = $a0 (product), store at $a1
    addiu $sp, $sp, -16              # Allocate 16 bytes on stack
    sw $ra, 0($sp)                   # Save return address
    sw $s0, 4($sp)                   # Save $s0 (product)
    sw $s1, 8($sp)                   # Save $s1 (pointer)
    sw $s2, 12($sp)                  # Save $s2 (padding/alignment)

    move $s0, $a0                    # $s0 = product to find
    move $s1, $a1                    # $s1 = pointer to store row, col

    li $t0, 0                        # $t0 = row counter
find_row_loop:
    bge $t0, 6, find_fail            # If row >= 6, no match found
    li $t1, 0                        # $t1 = col counter
find_col_loop:
    bge $t1, 6, find_row_next        # If col >= 6, next row
    move $a0, $t0                    # Pass row to $a0
    move $a1, $t1                    # Pass col to $a1
    jal get_grid_value             # Get GRID[row][col]
    beq $v0, $s0, find_found         # If value = product, found it
    addiu $t1, $t1, 1                # Increment col
    j find_col_loop                  # Next column
find_row_next:
    addiu $t0, $t0, 1                # Increment row
    j find_row_loop                  # Next row

find_found:
    sw $t0, 0($s1)                   # Store row at pointer
    sw $t1, 4($s1)                   # Store col at pointer + 4
    j find_end                       # Done, return

find_fail:
    li $t2, -1                       # -1 indicates failure
    sw $t2, 0($s1)                   # Store -1 for row
    sw $t2, 4($s1)                   # Store -1 for col

find_end:
    lw $ra, 0($sp)                   # Restore return address
    lw $s0, 4($sp)                   # Restore $s0
    lw $s1, 8($sp)                   # Restore $s1
    lw $s2, 12($sp)                  # Restore $s2
    addiu $sp, $sp, 16               # Deallocate stack
    jr $ra                           # Return
