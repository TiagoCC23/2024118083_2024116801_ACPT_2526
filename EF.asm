.data
	
.globl answer

msg_win:	.asciiz "\nYOU WIN\n"
msg_lose:	.asciiz "\nYOU LOSE\n"
msg_answer:	.asciiz "\na resposta correta era: "
msg: 	.asciiz "\nDigite a sequencia: "
right: 	.asciiz " certa(s)\n"
wrong: 	.asciiz " errada(s)\n"
answer:	.space 50
copia: 	.space 50
.text
	
.globl main_ef
.globl check

# Requisito F	
main_ef:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s7, 0	# vai de 0 ate 9
	move $s6, $a1

loop_jogo:
	beq $s7, $s6, fim_perdeu	# repete ate s7 chegar em s6

	li $v0, 4
	la $a0, msg
	syscall

	li $v0, 8
	la $a0, answer
	li $a1, 50
	syscall
	
	la $t0, answer		# Carrega o endereço da string lida
	
loop_to_upper:
	lb $t1, 0($t0)		# Lê o caracter atual
	beq $t1, $zero, fim_upper  # Se for NULL (fim), para
	beq $t1, 10, fim_upper     # Se for \n (enter), para
	
	# verifica se é minúscula
	li $t2, 97
	blt $t1, $t2, proximo_char	# se for menor que 'a', ignora
	li $t2, 122
	bgt $t1, $t2, proximo_char	# Se for maior que 'z', ignora
	
	# Se chegou aqui, é minúscula. Subtrai 32 para virar maiúscula.
	sub $t1, $t1, 32
	sb $t1, 0($t0)		# Salva a letra corrigida na memória

proximo_char:
	addi $t0, $t0, 1	# proxima letra
	j loop_to_upper

fim_upper:
	jal check


	beq $v0, $s3, fim_ganhou

	addi $s7, $s7, 1
	j loop_jogo

fim_ganhou:
	li $v0, 4
	la $a0, msg_win
	syscall
	j sair

fim_perdeu:
	li $v0, 4
	la $a0, msg_lose
	syscall
	
	li $v0, 4
	la $a0, msg_answer
	syscall
	
	la $a0, sequencia
    	li $v0, 4
    	syscall
	
	j sair

sair:
	lw $ra, 0($sp)	# restaurar o $ra para voltar pro main
	addi $sp, $sp, 4
	jr $ra

# Requisito E
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
	
	blt $t2, $s3, loop_copia

	li $s0, 0	# certos
	li $s1, 0	# errados
	li $t0, 0	# i = 0
	
loop_certo:
	bge $t0, $s3, end_certo
	
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
	sb $t5, 0($t3)	# a cópia da senha fica com '*' tbm
	
proximo_certo:
	addi $t0, $t0, 1
	j loop_certo
	
end_certo:
	li $t0, 0	# i = 0 dnv para poder usar no loop_errado
	
loop_errado:
	bge $t0, $s3, end
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)
	
	li $t9, 42	# para comparar com o '*'
	beq $t2, $t9, proximo_errado
	
	li $t3, 0
	
ciclo_err:
	bge $t3, $s3, proximo_errado
	
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
