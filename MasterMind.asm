.data
.align 2
MSGBemVindo1: .asciiz "Bem vindo ao Master Mind\n"
MSGBemVindo2: .asciiz "Jogo feito por: Rayssa Santos e Tiago Chousal\n"
MSGCores1: .asciiz "Insira uma combinação de 4 cores para fazer uma tentativa\n"
MSGCores2: .asciiz "Possibilidades de escolhas: \nBlue (B) \nGreen (G) \nRed(R) \nYellow(Y') \nWhite(W) \nOrange(O)\n"
MSGTentativaInvalida: .asciiz "Tentativa invalida.\n Faça uma tentativa que obedeça as seguintes condições:\n"
MSGTentativaIncorreta1: .asciiz "Oh que pena. Não acertaste a combinação. Volta a tentar\n"
MSGTentativaIncorreta2: .asciiz "Tivestes " # O espaço é para o inteiro que seria ou para as bolas corretas ou incorretas
MSGTentativaIncorreta3: .asciiz "bolas incorretas\n"
MSGTentativaCorreta: .asciiz "bolas corretas\n"
MSGVitoria: .asciiz "PARABÉNS!!! Acertaste a combinação.\nMuito Inteligente"
MSGDerrota1: .asciiz "Oh que pena. Nao acertaste a cobinação ao fim de 10 tentativas\n"
MSGDerrota2: .asciiz "A sequencia correta de cores era: \n"
MSGPontuacao: .asciiz "Pontuação: \n"
MSGSettings1: .asciiz "Nesta parte é possível adicionar cores duplicadas ou remover Cores\n" # Depois vejo melhor essa parte
Matriz: .word 0:40
MatrizLinhas: .word 10
MatrizColunas: .word 4
Input: .space 6
.text
.globl main

main:

	# endereços para se utilizar na matriz e no loop do jogo #
	
	add $t0, $0, $0 # i -> linhas
	add $t1, $0, $0 # j -> colunas
	lw $s2, MatrizColunas # nome totalmente explicativo
	la $t2, Matriz # nome totalmente explicativo
	add $s0, $0, $0 # verificação da matriz
	
	# prints iniciais do joguinho lindo e maravilhoso feito pelos melhores devs do mundo #
	
	li $v0, 4
	la $a0, MSGBemVindo1
	syscall
	li $v0, 4
	la $a0, MSGBemVindo2
	syscall
	
Exit:
	li $v0, 10
	syscall
				
LoopIString2Matriz:
	beq $s0, 10, Exit
	li $v0, 4
	la $a0, MSGCores1
	syscall
	la $a0, MSGCores2
	syscall
	li $v0, 8
	la $a0, Input
	li $a1, 6
	syscall
	
LoopJString2Matriz:

	beq $s1, 4, LoopIString2MatrizInc
	lb $t3, Input($t1)	
	beq $t3, 'B', LoopJString2MatrizValida                                     #mul $t1, $s0, $s2			# Cálculo: offset = [(i * 4) + j] * 4 onde a 4 seria o sll
	beq $t3, 'b', LoopJString2MatrizValida                                   #add $t1, $t1, $s1
	beq $t3, 'G', LoopJString2MatrizValida	                                    #sll $t1, $t0, 2
	beq $t3, 'g', LoopJString2MatrizValida	                                    #add $t2, $t1, $t0
	beq $t3, 'R', LoopJString2MatrizValida
	beq $t3, 'r', LoopJString2MatrizValida
	beq $t3, 'W', LoopJString2MatrizValida
	beq $t3, 'w', LoopJString2MatrizValida
	beq $t3, 'O', LoopJString2MatrizValida
	beq $t3, 'o', LoopJString2MatrizValida	                                    #sw $s0, 0($t2)
	addi $s1, $s1, 1
	j LoopJString2Matriz

LoopIString2MatrizInc:
	move $0, $s1
	addi $s0, $s0, 1
	j LoopIString2Matriz
LoopJString2MatrizInv:
	li $s2, $0
	j LoopJString2Matriz

LoopJString2MatrizValida:


