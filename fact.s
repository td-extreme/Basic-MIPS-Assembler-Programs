# Tyler Decker - 2/1/2014
# fact.s - driver program that uses the supplyed fact: function
#
# Register use:
#	$a0	parameter for fact and syscall
#	$v0	syscall parameter
#	$t0	temp var to check if input is < 0
#	$s0	used to store return value from fact
#	





fact:	slti	$t0, $a0, 1	# test for n < 1
	beq	$t0, $zero, L1	# if n >= 1, go to L1

	li	$v0, 1		# return 1
	jr	$ra		# return to instruction after jal

L1:	addi	$sp, $sp, -8	# adjust stack for 2 items
	sw	$ra, 4($sp)	# save the return address
	sw	$a0, 0($sp)	# save the argument n

	addi	$a0, $a0, -1	# n >= 1; argument gets (n – 1)
	jal	fact		# call fact with (n – 1)

	lw	$a0, 0($sp)	# return from jal: restore argument n
	lw	$ra, 4($sp)	# restore the return address
	addi	$sp, $sp, 8	# adjust stack pointer to pop 2 items

	mul	$v0, $a0, $v0	# return n * fact (n – 1)

	jr	$ra		# return to the caller

main:
	la	$a0, intro	# intro message
	li	$v0, 4			
	syscall
	
loop:				# start of Loop
	
	la	$a0, askn	# display msg asking for n
	li	$v0, 4
	syscall
	
	li	$v0, 5		# read value of n
	syscall

	slt	$t0, $v0, $zero	# exit loop if n < 0 
	bne	$t0, $zero, exit	

	move 	$a0, $v0	# place value of n in $a0
	li	$v0, 1		# display n	
	syscall
	
	
	jal	fact		# invoke fact procedure

	move	$s0, $v0	# save value returned by fact
	
		
	la	$a0, ans	# load answer text 
	li	$v0, 4		# print answer text
	syscall

	move 	$a0, $s0	# move answer value into $a0
	li	$v0, 1		# display answer value
	syscall
	j loop			# loop

exit:

	la	$a0, goodby	# load good by message
	li	$v0, 4		# diplay good by message
	syscall
	
	li	$v0, 10		# exit from the program
	syscall	
	
	





	.data
intro:	.asciiz "Welcome to the factorial tester!"
askn:	.asciiz "\nEnter a value for n (or a negative value to exit): "
goodby: .asciiz "\nCome back soon!"
ans:	.asciiz "! is "


