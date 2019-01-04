.data
	inputmsg: .asciiz "Input one number = "
	output: .asciiz "nearest prime number is "
	newLine:  .asciiz "\n"
.text
.globl main
main:
	li $v0, 4	#load syscall print string
	la $a0, inputmsg
	syscall
	li $v0, 5	#load syscall input integer
	syscall
	add $s0, $v0, $zero	#s0 store input number
######## preprocessing	
	and $t0, $s0, 1	# t0 determine input is odd | even. ( t0 == 1 -> input is odd, t0 == 0 -> input even )
	bne $t0, $zero, Start # if input != even, start, else input++ 
	addi $s0, $s0, 1
######## start calculate
Start:
	add $s1, $s0, $zero     # s0 store input, use s1 look for B 
	addi $s2, $zero, 2	# s2 = 2, loop for s1++ ==> look up prime number
	jal findPrime
	add $s1, $s0, $zero	# reset s1 as input
	addi $s2, $zero, -2     # s2 = -2, loop for s1-- ==> look down prime number
	jal findPrime
	li $v0, 10		# exit program
	syscall	
	
findPrime:
	add $s1, $s1, $s2	# s1 ++, continue find prime number
	addi $t1, $zero, 1	# t1 is inner loop index
innerloop1:
	addi $t1, $t1, 1	# t1++
	beq $s1, $t1, Exit1	# when index == s1, s1 is prime number
	add $t0, $s1, $zero     # t0 temp store s1	
modFun1:
	slt $t2, $t0, $t1	# if t0 < t1, t2 = 1, else t2 = 0
	bne $t2, $zero, modEnd1	# t0 < t1 t2 = 1, end mod
	sub $t0, $t0, $t1	# t0 - 2
	j   modFun1
modEnd1:				# free t1, t2
	bne $t0, $zero, innerloop1 	# if t0 != 0, index is not factor, index++
	j findPrime	# s1 have factor, is not a prime number, s1++

Exit1:
	li $v0, 4
	la $a0, output
	syscall
	li $v0, 1
	add $a0, $zero, $s1
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
