.text
    .globl init_game                # Initialize game state
    .globl get_grid_value           # Get number at grid position
    .globl get_ownership            # Get ownership of a cell
    .globl set_ownership            # Set ownership of a cell
    .globl get_top_marker           # Get top marker value
    .globl get_bottom_marker        # Get bottom marker value
    .globl set_top_marker           # Set top marker value
    .globl set_bottom_marker        # Set bottom marker value
    .globl find_cell                # Find grid coordinates for a number

# init_game: Resets game state—clears ownership, sets markers to 1
init_game:
    la $t0, ownership               # Load base address of ownership array
    li $t1, 36                      # Total cells in 6x6 grid
    li $t2, 0                       # Value to clear cells (unclaimed)
init_loop:
    sw $t2, 0($t0)                  # Set cell to 0
    addi $t0, $t0, 4                # Move to next word (4 bytes)
    addi $t1, $t1, -1               # Decrement counter
    bnez $t1, init_loop             # If counter > 0, keep looping
    la $t0, top_marker              # Load top marker address
    li $t1, 1                       # Initial value of 1
    sw $t1, 0($t0)                  # Set top marker to 1
    la $t0, bottom_marker           # Load bottom marker address
    sw $t1, 0($t0)                  # Set bottom marker to 1
    jr $ra                          # Return

# get_grid_value: Retrieves the original number at a grid position
# Input: $a0 = row, $a1 = col
# Output: $v0 = grid value (e.g., 1, 2, 3, etc.)
get_grid_value:
    li $t0, 6                       # Grid width (6 columns)
    mul $t1, $a0, $t0               # Calculate row offset (row * 6)
    add $t1, $t1, $a1               # Add column offset (row * 6 + col)
    sll $t1, $t1, 2                 # Multiply by 4 (bytes per word)
    la $t2, GRID                    # Load base address of GRID
    add $t1, $t2, $t1               # Compute final address
    lw $v0, 0($t1)                  # Load value at position
    jr $ra                          # Return

# get_ownership: Retrieves ownership status of a cell
# Input: $a0 = row, $a1 = col
# Output: $v0 = 0 (empty), 1 (player), 2 (computer)
get_ownership:
    li $t0, 6                       # Grid width
    mul $t1, $a0, $t0               # Row offset
    add $t1, $t1, $a1               # Add column offset
    sll $t1, $t1, 2                 # Multiply by 4 for byte offset
    la $t2, ownership               # Load base address of ownership
    add $t1, $t2, $t1               # Compute final address
    lw $v0, 0($t1)                  # Load ownership value
    jr $ra                          # Return

# set_ownership: Sets ownership of a cell
# Input: $a0 = row, $a1 = col, $a2 = player (1 or 2)
set_ownership:
    li $t0, 6                       # Grid width
    mul $t1, $a0, $t0               # Row offset
    add $t1, $t1, $a1               # Add column offset
    sll $t1, $t1, 2                 # Multiply by 4 for byte offset
    la $t2, ownership               # Load base address of ownership
    add $t1, $t2, $t1               # Compute final address
    sw $a2, 0($t1)                  # Store player number in cell
    jr $ra                          # Return

# get_top_marker: Retrieves current top marker value
# Output: $v0 = top marker (1-9)
get_top_marker:
    la $t0, top_marker              # Load top marker address
    lw $v0, 0($t0)                  # Load value
    jr $ra                          # Return

# get_bottom_marker: Retrieves current bottom marker value
# Output: $v0 = bottom marker (1-9)
get_bottom_marker:
    la $t0, bottom_marker           # Load bottom marker address
    lw $v0, 0($t0)                  # Load value
    jr $ra                          # Return

# set_top_marker: Updates top marker value
# Input: $a0 = new top marker value (1-9)
set_top_marker:
    la $t0, top_marker              # Load top marker address
    sw $a0, 0($t0)                  # Store new value
    jr $ra                          # Return

# set_bottom_marker: Updates bottom marker value
# Input: $a0 = new bottom marker value (1-9)
set_bottom_marker:
    la $t0, bottom_marker           # Load bottom marker address
    sw $a0, 0($t0)                  # Store new value
    jr $ra                          # Return

# find_cell: Finds grid coordinates for a given number
# Input: $a0 = target number (product of markers)
# Output: $v0 = row, $v1 = col, or -1/-1 if not found
find_cell:
    la $t0, GRID                    # Load base address of GRID
    li $t1, 0                       # Row counter
    li $t2, 0                       # Column counter
    li $t3, 36                      # Total cells to check
    li $t4, 0                       # Index counter
find_loop:
    lw $t5, 0($t0)                  # Load current grid value
    beq $t5, $a0, found             # If value matches target, jump to found
    addi $t0, $t0, 4                # Move to next word
    addi $t4, $t4, 1                # Increment index
    li $t6, 6                       # Grid width for division
    div $t4, $t6                    # Divide index by 6
    mfhi $t2                        # Remainder = column
    mflo $t1                        # Quotient = row
    bne $t4, $t3, find_loop         # If index < 36, keep searching
    li $v0, -1                      # Number not found, return row = -1
    li $v1, -1                      # Return col = -1
    jr $ra                          # Return
found:
    move $v0, $t1                   # Return row
    move $v1, $t2                   # Return column
    jr $ra                          # Return
