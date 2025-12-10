	.data
right:	.asciiz "certa(s)\n"
wrong: 	.asciiz "errada(s)\n"
answer:	.space
	.text

check:
	addi $sp, $sp, -32
    	sw   $ra, 28($sp)

end:
	li $v0, 1
	move $a0,
	syscall

	li $v0, 4
	la $a0, right
	syscall

	li $v0, 1
	move $a0,
	syscall

	li $v0, 4
	la $a0, wrong
	syscall