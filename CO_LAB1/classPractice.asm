.data 
	ans: .asciiz "The ANS is:"
	inputa: .asciiz "The first number = "
	inputb: .asciiz "The second number = " 
.text
.globl main 
main:
	li $v0, 4
	la $a0, inputa
	syscall
	li $v0, 5
	syscall
	add $t1, $zero, $v0
	
	li $v0, 4
	la $a0, inputb
	syscall
	li $v0, 5
	syscall
	add $t2, $zero, $v0

	sub $t1, $t1, $t2
	li $v0, 4
	la $a0, ans
	syscall
	add $a0,$zero $t1
	li $v0, 1
	syscall
	li $v0, 10
	syscall