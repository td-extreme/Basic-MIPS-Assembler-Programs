# Tyler Decker
# 1 April 2014
# 
#
#

main:	addi	$s0, $zero, 0	# Set s0 to 0
	addi	$s1, $zero, 1	# set S1 to 1
	addi	$s3, $zero, 0	# set s3 to 0
	addi	$s4, $zero, 5	# set S4 to 4

loop:	move 	$a0, $s1	# print number
	li 	$v0, 1
	syscall
	la	$a0, space	# print Space
	li	$v0, 4
	syscall
	negu	$t2, $s1	# put -$s1 into $t2
	addu	$t1, $s0, $t2	# sub $1 from $s0


	xor	$t3, $s0, $t2	# check if signs differ
	slt	$t3, $t3, $zero	# $t3 = 1 if signs differ
	bne 	$t3, $zero, No_Overflow	
			

	xor	$t3, $t1, $s0	# check to see if sign of sum = 
	slt	$t3, $t3, $zero	# $t3 is neg if sum sign different
	bne	$t3, $zero, Overflow

No_Overflow:
	
	move	$s0, $s1	# move s1 into s0
	move 	$s1, $t1	# move t1 into s1

	
	addi	$s3, $s3, 1	# add 1 to s3 increase counter
	slt	$t0, $s3, $s4	# if counter = 5 print new line
	beq	$t0, $zero, newline
	j loop

newline:
	addi	$s3, $zero, 0	# reset counter
	la	$a0, endl	# print new line
	li	$v0, 4	
	syscall	
	j loop


Overflow:
	la	$a0, error	# print error line
	li	$v0, 4
	syscall

	move	$a0, $t1	# print number causing overflow
	li	$v0, 1
	syscall
	
	


close:	li	$v0, 10		# exit from the program
	syscall



	.data
space:	.asciiz " "
endl:	.asciiz "\n"
error:	.asciiz "\n\nValue causing overflow = "