# using registers without using memory

.text 

#f=(a+b)-(c+d)

li $t0,8  #a=8

li $t1,7 #b=7

li $t2,2 #c=2

li $t3,1 #d=1

add $s0,$t0,$t1 #(a+b) --> ($t0+$t1) --> $s0  --> 15 --f

add $s1,$t2,$t3  # (c+d) --> ($t2+$t3) --> $s1 -->3 

sub $s2,$s0,$s1 # ($s0-$s1)--> $s2--> 15-3 =12 --> 0xc

#f= $s2 --> 12 base 10==0xc

