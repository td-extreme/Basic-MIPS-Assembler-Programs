# Tyler S. Decker -- 4/21/2014
# dpface.s - driver program that tests dpfact function
#
# Register use:
#		main			dpfact	
#		----------------	---------
#	$a0	syscall parameter	parameter
#	$v0 	syscall parameter
#	$12	syscall parameter
#	$f0				return value
#	$f2				used for calulating
#	$t0				used for counter
#


dpfact:	li 	$t0, 1
	mtc1.d 	$t0, $f0
	cvt.d.w $f0, $f0

again:	slti	$t0, $a0, 2	# i = $a0; i < 2; --i 
	bne	$t0, $zero, done 

	mtc1.d	$a0, $f2	# move i to floating register
	cvt.d.w	$f2, $f2	# convert to double

	mul.d	$f0, $f0, $f2	# multiply product by i

	addi	$a0, $a0, -1	# --i
	j	again		#loop

done:	jr	$ra		#return



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
	
	
	jal	dpfact		# invoke fact procedure

	move	$s0, $v0	# save value returned by fact
	
		
	la	$a0, ans	# load answer text 
	li	$v0, 4		# print answer text
	syscall

	mov.d 	$f12, $f0	# move answer value into $a0
	li	$v0, 3		# display answer value
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

