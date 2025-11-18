.data
.align 2
MSGBemVindo1: .asciiz "Bem vindo ao Master Mind\n"
MSGBemVindo2: .asciiz "Jogo feito por: Rayssa Santos e Tiago Chousal\n"
MSGCores1: .asciiz "Insira uma combinação de 4 cores para fazer uma tentativa\n"
MSGCores2: .asciiz "Possibilidades de escolhas: \nBlue (B) \nGreen (G) \nRed(R) \nYellow(Y) \nWhite(W) \nOrange(O)"
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
.text
.globl main

main:

	# endereços para se utilizar na matriz #
	
	add $s0, $0, $0 # i -> linhas
	add $s1, $0, $0 # j -> colunas
	lw $s2, MatrizColunas
	la $t0, Matriz
	
LoopI:
	beq $s0, 10, Exit

LoopJ:
	beq $s1, 4, LoopIncrement
	mul $t1, $s0, $s2			# Cálculo: offset = [(i * 4) + j] * 4 onde a 4 seria o sll
	add $t1, $t1, $s1
	sll $t1, $t0, 2
	add $t2, $t1, $t0
	sw $s0, 0($t2)
	addi $s1, $s1, 1
	j LoopJ

LoopIncrement:
	move $0, $s1
	addi $s0, $s0, 1
	j LoopI

Exit: