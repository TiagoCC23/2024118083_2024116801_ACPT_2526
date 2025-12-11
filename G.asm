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
	# print da mensagem de vitória com a soma de 12 pontos #
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
	# print da mensagem de derrota #
	li $v0, 4
	la $a0, MSGDerrota1
	syscall
	
	# print do número de tentativas que seria equivalente ao número de linhas percorridas #
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, MSGDerrota2
	syscall
	
	# print da string que corresponderia á sequência correta gerada aleatoriamente #
	li $v0, 4
	la $a0, MSGDerrota3
	syscall
	li $v0, 4
	la $ao, cores
	syscall
	
	# print da pontuação onde perde 3 pontos #
	
	addi $s5, $s5, -3
	slt $t0, $s5, $0
	beq $t0, $0, PontuacaoNegativa # se a pontuação for negativa, ela fica a 0 #
	
	li $v0, 4
	la $a0, MSGPontuacao
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	j Menu
	
PontuacaoNegativa:
	
	# passa a pontuação para 0 e volta para o menu #
	move $s5, $0 
	li $v0, 4
	la $a0, MSGPontuacao
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	j Menu