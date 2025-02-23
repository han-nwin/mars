.data

.text
li $s4, 5
li $s3, 2
li $s0, 0
li $s1, 4
li $s2, 2

bne $s3, $s4, Else
add $s0, $s1, $s2
j Exit

Else: sub $s0, $s1, $s2

Exit: 