# Tyler S. Decker -- 4/21/2014
# sin.s - driver program that tests Sin function
#
# Register use:
#	
#	$a0	syscall parameter	
#	#v0 	syscall parameter
#	$f0	sin return  	syscall return value
#	$f12	sin parameter 	syscall parameter
#		
#	$f16	sin check for exit			main check for exit
#	$s0	sin counter
#	$s1	sin counter top value
#	$s2	sin used to check if sub.d (0) or add.d (1)
#	$t0	used to check for loop
#	
#	$f2	sin denomonator ie 3!
#	$f4	sin numerator 	ie x^3
#	$f6	sin hold current value x while calulating 
#	$f8	sin counter for2: / used for absolute value 
#	$f10	sin holds original value passed 


sin:
	addi 	$sp, $sp, -4	# adjust stack for $ra
	sw	$ra, 0($sp)	# save the return address to stack
	

	addi	$s1, $zero, 1	# set $s1 (counter to 1)
	add	$s2, $zero, $zero
	mov.d	$f6, $f12
	mov.d	$f10, $f12	

loopsin:
	mov.d	$f4, $f12	# (re)set $f4 = $f0 = x 
	addi	$s0, $zero, 1	# (re)set $s0 to 2
	addi	$s1, $s1, 2	# add 2 to counter


for1:	slt	$t0, $s0, $s1	#loop x^y
	beq	$t0, $zero, exit1	

	mul.d	$f4, $f4, $f12	# $f4 = $f4 x $f4  
	
	addi	$s0, $s0, 1	

	j 	for1 


exit1:

	move	$s0, $s1	# set counter to high value
	addi	$t1, $zero, 1	# set $t1 to 1
	
	l.d	$f2, const1





for2:	slt	$t0, $s0, $t1
	bne	$t0, $zero, exit2
	
	mtc1.d	$s0, $f8
	cvt.d.w	$f8, $f8

	mul.d	$f2, $f2, $f8

	addi	$s0, $s0 -1
	j	for2
	


exit2:


	
	div.d	$f4, $f4, $f2	# $f4 = (x^y) / y!
		


	abs.d	$f8, $f4
	
	l.d	$f16, test	# exit if $f4 < 1.0e-15
	c.lt.d	$f8, $f16
	bc1t	exitsin
	

	bne	$s2, $zero, goadd # if $s2 != 0 goadd
	

	sub.d	$f6, $f6, $f4	# x = x - ((x^y) / y!)
	addi	$s2, $s2, 1	# add 1 to $s2 add next round

	j	loopsin	

goadd:
	add.d	$f6, $f6, $f4	# x = x + ((x^y) / y!)
	add	$s2, $zero, $zero	# reset $s2 to 0 sub next round
		
	j	loopsin		
	
	
	
exitsin:	

	
	mov.d	$f0, $f6
	lw	$ra, 0($sp)	# restore the return address
	addi	$sp, $sp, 4	# adjust stack pointer to pop item


	jr 	$ra		# return



main:	la 	$a0, intro	# output intro
	li 	$v0, 4
	syscall

loop:	la 	$a0, req	# output request radian 
	li 	$v0, 4
	syscall

	li 	$v0, 7		# input value
	syscall
	
	l.d	$f16, flag	# exit if 999 was entered
	c.eq.d	$f16, $f0
	bc1t	out
	
	la	$a0, ans1	# output text part(1) of answer
	li	$v0, 4
	syscall
		
	mov.d	$f12, $f0	# move input into $f12 print and to pass to sin
	li	$v0, 3
	syscall

	la	$a0, ans2	# output text part(2) of answer
	li	$v0, 4
	syscall
	
	jal	sin		# call function sin

	mov.d	$f12, $f0	# move return $f0 into $f12 to print
	li	$v0, 3
	syscall

	j loop




out: 	la $a0, bye # display closing
	li $v0, 4
	syscall
	
	li $v0, 10 # exit from the program
	syscall




	.data
intro:	.asciiz "Let's test our sin function!\n"
req:	.asciiz "\nEnter a (radian) value for x (or 999 to exit): "
ans1:	.asciiz "Our approximation for sin("	 
ans2:	.asciiz ") is "
line:	.asciiz "\n" 	
bye:	.asciiz "Come back soon!"
const1:	.double 1.0
test:	.double 0.000000000000001
flag:	.double 999.0
