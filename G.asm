.data
.align 2
MSGVitoria: .asciiz "PARABÉNS!!! Acertaste a combinação.\nMuito Inteligente"
MSGDerrota1: .asciiz "Oh que pena. Não acertaste a cobinação ao fim de "
MSGDerrota2: .asciiz " tentativas\n"
MSGDerrota3: .asciiz "A sequencia correta de cores era: \n"
MSGPontuacao: .asciiz "Pontuação: \n"
.text


	
	# endereços a utilizar #
	add $s5, $0, $0 # Pontuação
	
VitoriaMasterMind:
	li $v0, 4
	la $a0, MSGVitoria
	syscall
	addi $s5, $0, 12
	
	li $v0, 4
	la $a0, MSGPontuacao
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	j Menu

DerrotaMasterMind:
	li $v0, 4
	la $a0, MSGDerrota1
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, MSGDerrota2
	syscall
	
	li $v0, 4
	la $a0, MSGDerrota3
	syscall
	li $v0, 