.data
    prompt_count: .asciiz "How many numbers do you wanna sort? (max 100): "
    prompt_numbers: .asciiz "\nEnter the numbers one by one separate by <Enter> key:\n"
    too_many_msg: .asciiz "Oppsie! \nThat's a lot of numbers for me to sort, keep it below max\n"
    sorted_msg: .asciiz "Numbers in ascending order:\n"
    space: .asciiz " "
    newline: .asciiz "\n"
    
    .align 2  # Ensure next address can store a word
    numbers: .space 400   # Reserved space for up to 100 integers (4 bytes each)

.text
main:
    # Prompt user for count
    li $v0, 4
    la $a0, prompt_count
    syscall
    
    # Read integer input for count
    li $v0, 5
    syscall

    # Check max
    slti $t0, $v0, 100
    beq $t0, $zero, too_many_exit # exit if user wants more than 100 numbers
    move $a1, $v0  # Otherwise, store count in $a1 (argument for below functions)

    # Prompt user to enter numbers
    li $v0, 4
    la $a0, prompt_numbers
    # $a1 loaded above
    syscall

    # Call function to read numbers
    la $a0, numbers  # Load base address of numbers array
    # $a1 loaded above
    jal read_numbers

    # Call function to sort numbers
    la $a0, numbers  # Load base address again
    # $a1 loaded above
    jal sort_numbers

    # Call function to print numbers
    la $a0, numbers  # Load base address again
    # $a1 loaded above
    jal print_nums

    # Exit after all operations are done
    j exit

# Too many number msg then exit
too_many_exit:
    li $v0, 4
    la $a0, too_many_msg
    syscall
    j exit

# Exit program
exit:
    li $v0, 10
    syscall

# --------------------------------------
# Function to read numbers
# Arguments:
#   $a0 - Base address of numbers array
#   $a1 - Count of numbers to read
# --------------------------------------
read_numbers:
    li $t1, 0  # i = 0
    move $t2, $a0  # Copy base address of numbers array
input_loop:
    bge $t1, $a1, read_done  # if i >= count, return
    
    li $v0, 5
    syscall
    sw $v0, 0($t2)  # store number in array
    
    addi $t2, $t2, 4  # move to next array slot
    addi $t1, $t1, 1  # i++
    j input_loop
read_done:
    jr $ra  # return

# --------------------------------------
# Function to sort numbers (Bubble Sort)
# Arguments:
#   $a0 - Base address of numbers array
#   $a1 - Count of numbers to sort
# --------------------------------------
sort_numbers:
    li $t3, 0  # i = 0
outer_loop:
    bge $t3, $a1, sort_done  # if i >= count, return
    
    li $t4, 1  # j = i + 1
    add $t4, $t3, $t4

inner_loop:
    bge $t4, $a1, next_outer  # if j >= count, go to next outer loop
    
    # Load numbers[i] and numbers[j]
    sll $t6, $t3, 2
    add $t6, $t6, $a0
    lw $t7, 0($t6)  # number[i]
    
    sll $t8, $t4, 2
    add $t8, $t8, $a0
    lw $t9, 0($t8)  # number[j]
    
    # Compare and swap
    ble $t7, $t9, no_swap
    sw $t9, 0($t6)
    sw $t7, 0($t8)

no_swap:
    # If there's no swap move to next j
    addi $t4, $t4, 1  # j++
    j inner_loop

next_outer:
    addi $t3, $t3, 1  # i++
    j outer_loop

sort_done:
    jr $ra  # return

# --------------------------------------
# Function to print numbers
# Arguments:
#   $a0 - Base address of numbers array
#   $a1 - Count of numbers to print
# --------------------------------------
print_nums:
    # Reserve the original arugment value (base address)
    addi $sp, $sp, -4
    sw $a0, 0($sp)

    li $v0, 4
    la $a0, sorted_msg
    syscall
    
    # Get the original argument value back (base address)
    lw $a0, 0($sp)
    addi $sp, $sp, 4
    
    li $t1, 0  # i = 0
    move $t2, $a0  # Copy base address of numbers array to $t2

print_loop:
    bge $t1, $a1, print_done  # if i >= count, return
    
    lw $a0, 0($t2)  # Load number from array
    li $v0, 1
    syscall  # Print number
    
    li $v0, 4
    la $a0, space
    syscall  # Print space
    
    addi $t2, $t2, 4  # Move to next number in array
    addi $t1, $t1, 1  # i++
    j print_loop

print_done:
    jr $ra  # return


