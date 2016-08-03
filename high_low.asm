# Christen Reinbeck
# high low program

.data
# Create a string to separate the 100 numbers with a space
spacestr: 	.asciiz " " 
higher:		.asciiz "HIGHER\n"
lower:		.asciiz "LOWER\n"
correct:	.asciiz "CORRECT\n"
guess:		.asciiz "Please guess a number between 1-10: "

.text
##############################################################################
# seed the random number generator
##############################################################################

# get the time
li	$v0, 30		# get time in milliseconds (as a 64-bit value)
syscall

move	$t0, $a0	# save the lower 32-bits of time

# seed the random generator (just once)
li	$a0, 1		# random generator id (will be used later)
move 	$a1, $t0	# seed from time
li	$v0, 40		# seed random number generator syscall
syscall

##############################################################################
# seeding done
##############################################################################

# generate 10 random integers in the range 100 from the 
# seeded generator (whose id is 1)
li	$t2, 2		# max number of iterations + 1 -> want five number to print so 5+1=6
li	$t3, 0		# current iteration number

# LOOP: 		# dont need to loop through because only generating one random number, not multiple
li	$a0, 1		# as said, this id is the same as random generator id
li	$a1, 10		# upper bound of the range
li	$v0, 42		# random int range
syscall

# $a0 now holds the random number

# loop terminating condition
addi	$t3, $t3, 1	# increment the number of iterations
beq	$t3, $t2, EXIT	# branch to EXIT if iterations is 10 -> now 5 for our purposes

# $a0 still has the random number
add 	$a0, $a0, 1	# adds 1 to the output so that our range starts at one instead of zero
move 	$t9, $a0	# moves our computer guess to $t9

LOOP:
# print guess statement
li	$v0, 4		# print string syscall
la	$a0, guess	# load address of string guess
syscall
# ask user for their guess
li	$v0, 5		# get value from user
syscall
move	$t8, $v0	# move value of user guess into $t8
# if loop for if equal
bne	$t9, $t8, INCORRECT	# if values NOT EQUAL, go to ELSE1
li	$v0, 4		# print string
la	$a0, correct	# load string, correct
syscall
j EXIT			# if it is correct, exit after printing correct
INCORRECT:
	slt $t7, $t8, $t9	# checks if user (t8) HIGHER than comp (t9) - if true then t1=1, if false then t1=0
	beq $t7, $zero, LOWER
	li $v0, 4	# print string
	la $a0, higher	# load string, higher
	syscall
	j LOOP
LOWER:
	li $v0, 4	# print string
	la $a0, lower	#load string, lower
	syscall
	j LOOP

# print a space		# dont need to print a space bc dont have multiple values of integers
#la	$a0, spacestr	# load the address of the string (pseudo-op)	
#li	$v0, 4		# print string syscall
#syscall

# Do another iteration 
# j	LOOP		# don't need to iterate through another loop to print another random int

##############################################################################
# Tell MARS to exit the program
##############################################################################
EXIT:
li	$v0, 10		# exit syscall
syscall
