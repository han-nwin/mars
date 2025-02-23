.data


    str:    .asciiz "Hello MIPS Assembly Programming"


    newline: .asciiz "\n"


.text
    .globl main
main:
    # Load address of the string into $a0
    la $a0, str
    li $t0, 0          # Index counter

loop:
    lb $t1, 0($a0)     # Load a character from the string
    beq $t1, $zero, exit  # If end of string, exit
    beq $t1, ' ', new_line  # If space, print newline

    # Print character
    li $v0, 11         # Syscall for printing character
    move $a0, $t1
    syscall
    
    j next_char        # Move to next character

new_line:
    # Print a newline
    li $v0, 4
    la $a0, newline
    syscall


next_char:
    addi $a0, $a0, 1   # Move to next character
    j loop             # Repeat loop
exit:
    li $v0, 10         # Exit program
    syscall

 