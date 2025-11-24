.data
.align 2
	# mensagens #
MSGBemVindo1: .asciiz "Bem vindo ao Master Mind\n"
MSGBemVindo2: .asciiz "Jogo feito por: Rayssa Santos e Tiago Chousal\n"
MSGMenu1: .asciiz "| Jogar (0)|\n"
MSGMenu2: .asciiz "| Definições (1)|\n"
MSGMenu3: .asciiz "| Sair (2)|\n"
MSGMenu4: .asciiz "| Opção inválida |\n Por favor insira 0, 1 ou 2 para realizar alguma ação no menu\n"
MSGSettings1: .asciiz "| Selecione se quer um jogo normal (0) ou se quer um jogo personalizado (1)|\n"
MSGSettings2: .asciiz "| Insira um número de colunas (M) >=4 |\n"
MSGSettings3: .asciiz "| Insira um número de linhas (N) >=2 |\n"
MSGSettings4: .asciiz "| Jogo personalizado criado com sucesso|\n"
MSGSettingsVer1: .asciiz "| Colunas inválidas\n Insira um número inteiro de colunas válido\n"
MSGSettingsVer1: .asciiz "| Linhas inválidas\n Insira um número inteiro de linhas válido\n"
MSGCores2: .asciiz "Possibilidades de escolhas: \nBlue (B) \nGreen (G) \nRed(R) \nYellow(Y) \nWhite(W) \nOrange(O)\n"
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
MSGSettings2: .asciiz "Nesta parte é possível escolher quantas linhas e quantas colunas\n"
	# matriz e Input #
Matriz: .space 400
MatrizLinhas: .word 10
MatrizColunas: .word 4
Input: .space 50
.text
.globl main

main:

	# endereços para se utilizar na matriz e no loop do jogo #
	
	add $s0, $0, $0 # i -> linhas percorridas
	add $s1, $0, $0 # j -> colunas percorridas
	addi $s2, $0, 10 # n -> linhas que podem ser escolhidas
	addi $s3, $0, 4  # m -> colunas que podem ser escolhidas
	add $t2, $0, $0 # verificação da matriz
	la $s4, Matriz # nome totalmente explicativo

	
	# prints iniciais do joguinho lindo e maravilhoso feito pelos melhores devs do mundo #
	
	li $v0, 4
	la $a0, MSGBemVindo1
	syscall
	li $v0, 4
	la $a0, MSGBemVindo2
	syscall


Menu:
	li $v0, 4
	la $a0,MSGMenu1
	syscall
	li $v0, 4
	la $a0, MSGMenu2
	syscall
	li $v0, 4
	la $a0, MSGMenu3
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	beq $t0, 0, LoopIString2Matriz
	beq $t0, 1, Settings
	beq $t0, 2, Exit
	j OpcaoInvalida
	
Settings:		
	li $v0, 4
	la $a0, MSGSettings1
	syscall
	beq $t0, 0, Menu
	beq $t0, 1, SettingsJogoPersonalizado
	j Opcao
SettingsJogoPersonalizado:
	li $v0, 4
	la $a0, MSGSettings2
	syscall
	li $v0, 5
	syscall
	move $s3, $a0
	blt $s3, 4, OpcaoInvalidaColunas
	
	li $v0, 4
	la $a0, MSGSettings3
	syscall
	li $v0, 5
	syscall
	move $s2, $a0
	blt $s3, 2, OpcaoInvalidaLinhas
	li $v0, 4
	la $a0, MSGSettings4
	syscall
	j Settings
	
OpcaoInvalida:
	li $v0, 4
	la $a0, MSGMenu4
	syscall
	j Menu
					
LoopIString2Matriz:
	beq $s0, $s2, Exit
	li $v0, 4
	la $a0, MSGCores1
	syscall
	la $a0, MSGCores2
	syscall
	li $v0, 8
	la $a0, Input
	li $a1, 50
	syscall
	move $s1, $0
	move $t2, $0
	
LoopVerificacaoString:

	beq $t2, $s3, LoopMatriz2StringReset
	lb $t4, Input($s1)	
	beq $t4, 'B', LoopJString2MatrizValida                                     			
	beq $t4, 'b', LoopJString2MatrizValida                                   
	beq $t4, 'G', LoopJString2MatrizValida	                                    
	beq $t4, 'g', LoopJString2MatrizValida	                                    
	beq $t4, 'R', LoopJString2MatrizValida
	beq $t4, 'r', LoopJString2MatrizValida
	beq $t4, 'Y', LoopJString2MatrizValida
	beq $t4, 'y', LoopJString2MatrizValida
	beq $t4, 'W', LoopJString2MatrizValida
	beq $t4, 'w', LoopJString2MatrizValida
	beq $t4, 'O', LoopJString2MatrizValida
	beq $t4, 'o', LoopJString2MatrizValida	                                    
	j LoopJString2MatrizInvalida

LoopIString2MatrizInc:
	move $s1, $0
	move $t2, $0
	addi $s0, $s0, 1
	j LoopIString2Matriz

LoopJString2MatrizValida:
	addi $t2, $t2, 1
	addi $s1, $s1, 1
	j LoopVerificacaoString

LoopJString2MatrizInvalida:
	li $v0, 4
	la $a0, MSGTentativaInvalida
	syscall
	j LoopIString2Matriz
	
LoopMatriz2StringReset:
	move $t2,$0	
LoopMatriz2String:
	beq $t2, $s3, LoopJMasterMind
	lb $t4, Input($s1)
	mul $t1, $s0, $s3           # Cálculo: offset = [base + (i * M) + j] 
	add $t1, $t1, $s1
	add $t5, $s4, $t1
	sb $t4, 0($t5)
	addi $t2, $t2, 1
	j LoopMatriz2String
LoopJMasterMind:
Exit:
	li $v0, 10
	syscall
	
