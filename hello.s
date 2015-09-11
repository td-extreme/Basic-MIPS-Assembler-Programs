# Tyler Decker -- 1/7/2014
# hello.s -- a traditional "Hello World" 1st program
#	$v0	syscall parameter and return value
#	$a0	syscall parameter

	.text
	.globl	main
main:
	la $a0, msg	# address of "Hello World" message
	li $v0, 4	# this is the print string option
	syscall		# perform the system call

	li $v0, 10	# this is the exit option
	syscall		# perform the system call

# Here is the data for the program

	.data
msg:	.asciiz		"Hello World\n"

# end hello.s
	