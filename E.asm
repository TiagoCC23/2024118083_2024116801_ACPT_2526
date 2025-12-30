	.data
	
	.globl answer
	
msg: .asciiz "\nDigite a sequencia: "
right: .asciiz " certa(s)\n"
wrong: .asciiz " errada(s)\n"
answer: .space 5
copia: .space 5
	.text
	
	.globl main_e
	.globl check
	
main_e:
	li $v0, 4
	la $a0, msg
	syscall

	li $v0, 8 # para ler string
	la $a0, answer
	li $a1, 5 # para ler 4 letras e o '\0'
	syscall
	
	jal check
	
	li $v0, 10
	syscall

check:
	la $t0, sequencia
	la $t1, copia
	li $t2, 0
	
loop_copia:
	lb $t3, 0($t0)	# leitura da caixinha da sequencia
	sb $t3, 0($t1)	# guarda na caixinha da copia
	
	addi $t0, $t0, 1	# proxima letraa
	addi $t1, $t1, 1	# proxima caixinha para a outra letra
	addi $t2, $t2, 1	# i = i +1
	
	blt $t2, 4, loop_copia

	li $s0, 0	# certos
	li $s1, 0	# errados -> subtração do total com os certos
	li $t0, 0	# i = 0
	
loop_certo:
	bge $t0, 4, end_certo
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)	# carrega a letra do usuario
	
	la $t3, copia
	add $t3, $t3, $t0
	lb $t4, 0($t3)	# carrega a copia da senha
	
	bne $t2, $t4, proximo_certo
	
	addi $s0, $s0, 1	# count = count + 1
	li $t5, 42	# coloca um '*'
	sb $t5, 0($t1)	# a resposta fica com '*'
	sb $t5 0($t3)	# a cópia da senha fica com '*' tbm
	
proximo_certo:
	addi $t0, $t0, 1
	j loop_certo
	
end_certo:
	li $t0, 0	# i = 0 dnv para poder usar no loop_errado
	
loop_errado:
	bge $t0, 4, end
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)
	
	li $t9, 42	# para comparar com o '*'
	beq $t2, $t9, proximo_errado
	
	li $t3, 0
	
ciclo_err:
	bge $t3, 4, proximo_errado
	
	la $t4, copia
	add $t4, $t4, $t3
	lb $t5, 0($t4)
	
	beq $t5, $t9, prox_err
	bne $t2, $t5, prox_err
	
	addi $s1, $s1, 1
	sb $t9, 0($t4)
	j proximo_errado
	
prox_err:
	addi $t3, $t3, 1
	j ciclo_err
	
proximo_errado:
	addi $t0, $t0, 1
	j loop_errado

end:
	li $a0, 10
	li $v0, 11
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, right
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, wrong
	syscall
	
	move $v0, $s0
	jr $ra
