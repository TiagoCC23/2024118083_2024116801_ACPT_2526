.data

.globl Menu
.globl main

.globl sequencia
.globl tamanho

sequencia: 	.space 4	# espa�o seguro para a senha (cores e alfabeto)
tamanho: 	.word 4		# tamanho padrao (sera atualizado pelo settings por causa do alfabeto)

.align 2
	# mensagens #
MSGBemVindo1: .asciiz "Bem vindo ao Master Mind\n"
MSGBemVindo2: .asciiz "Jogo feito por: Rayssa Santos e Tiago Chousal\n"
MSGMenu1: .asciiz "| Jogar (0)|\n"
MSGMenu2: .asciiz "| Defini��es (1)|\n"
MSGMenu3: .asciiz "| Sair (2)|\n"
MSGMenu4: .asciiz "| Op��o inv�lida |\n Por favor insira 0, 1 ou 2 para realizar alguma a��o no menu\n"
MSGSettings1: .asciiz "| Selecione se quer:\n| jogo normal (0)|\n| jogo personalizado (1)|\n| Voltar para o menu (2)|\n"
MSGSettings2: .asciiz "| Insira um n�mero de colunas (M) >=4 |\n"
MSGSettings3: .asciiz "| Insira um n�mero de linhas (N) >=2 |\n"
MSGSettings4: .asciiz "| Jogo personalizado criado com sucesso|\n"
MSGSettings5: .asciiz "Nesta parte � poss�vel adicionar cores duplicadas ou remover Cores\n" # Depois vejo melhor essa parte
MSGSettings6: .asciiz "| Op��o Inv�lida |\n Por favor insira 0, 1, 2 ou 3 para realizar alguma a��o no menu\n"
MSGSettingsVer1: .asciiz "| Colunas inv�lidas\n Insira um n�mero inteiro de colunas v�lido\n"
MSGSettingsVer2: .asciiz "| Linhas inv�lidas\n Insira um n�mero inteiro de linhas v�lido\n"
MSGCores1Half1: .asciiz "Insira uma combina��o de "
MSGCores1Half2: .asciiz " cores para fazer uma tentativa\n"
MSGCores2: .asciiz "Possibilidades de escolhas: \n(B) \n(G) \n(R) \n(Y) \n(W) \n(O)\n"
MSGTentativaInvalida: .asciiz "Tentativa invalida.\n Fa�a uma tentativa que obede�a as seguintes condi��es:\n"
MSGTentativaIncorreta1: .asciiz "Oh que pena. N�o acertaste a combina��o. Volta a tentar\n"


	# matriz e Input #

MatrizLinhas: .word 10
MatrizColunas: .word 4
Input: .space 50
.text
.globl Menu
.globl main

main:
	# endere�os para se utilizar na matriz e no loop do jogo #
	add $s0, $0, $0 # i -> linhas percorridas
	add $s1, $0, $0 # j -> colunas percorridas
	addi $s2, $0, 10 # n -> linhas que podem ser escolhidas
	addi $s3, $0, 4  # m -> colunas que podem ser escolhidas
	move $a0, $s2
	move $a1, $s3
	jal TabuleiroDinamico
	move $s4, $v0    # matriz com 10 linhas e 4 colunas
	add $s5, $0, $0 # Pontua��o -> Depois ser� feita
	add $t2, $0, $0 # verifica��o da matriz
	

	# prints iniciais do joguinho lindo e maravilhoso feito pelos melhores devs do mundo #
	li $v0, 4
	la $a0, MSGBemVindo1
	syscall
	li $v0, 4
	la $a0, MSGBemVindo2
	syscall

Menu:
	# prints do menu onde t0 � o input dado #
	li $v0, 4
	la $a0, MSGMenu1
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
	# prints das defini��es onde t0 � o input #	
	li $v0, 4
	la $a0, MSGSettings1
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	beq $t0, 0, JogoPadrao # O user pode ter mudado de ideias e querer um jogo em vez de um jogo personalizado
	beq $t0, 1, SettingsJogoPersonalizado # O user queria settar um jogo personalizado
	beq $t0, 2, Menu # O user poderia quer voltar para o menu e manter o jogo personalizado
	# Falta adicionar a op��o das cores (al�nea J), mas ainda n�o entendi a lore
	j OpcaoInvalidaSettings
	
JogoPadrao:
	# setta as linhas para 10 (s2=10) e as colunas para 4 (s3=4) como um jogo default #
	li $s3, 4
	li $s2, 10
	move $a0, $s2
	move $a1, $s3
	jal TabuleiroDinamico
	move $s4, $v0
	j Menu
	
	
SettingsJogoPersonalizado:
	# permite o utiizador escolher como quer o tabuleiro onde s3 s�o as colunas e s2 as linhas #
	
	# colunas #
	li $v0, 4
	la $a0, MSGSettings2
	syscall
	li $v0, 5
	syscall
	move $s3, $v0
	blt $s3, 4, OpcaoInvalidaColunas
	
	# linhas #
	li $v0, 4
	la $a0, MSGSettings3
	syscall
	li $v0, 5
	syscall
	move $s2, $v0
	blt $s2, 2, OpcaoInvalidaLinhas
	
	move $a0, $s2
	move $a1, $s3
	jal TabuleiroDinamico
	move $s4, $v0
	
	# cria o jogo personalizado #
	li $v0, 4
	la $a0, MSGSettings4
	syscall
	j Settings
	
OpcaoInvalida:
	# caso a op��o no menu seja inv�lida, vai para esta label s� para avisar e volta para o menu #
	li $v0, 4
	la $a0, MSGMenu4
	syscall
	j Menu
	
OpcaoInvalidaSettings:

	# caso a op��o nas settings seja inv�lida, vai para esta label s� para avisar e depois volta para as settings #
	li $v0, 4
	la $a0, MSGSettings6
	syscall
	j Settings
	
OpcaoInvalidaColunas:
	
	# caso o n�meros de colunas (s3) seja menor que 4, ele vai para esta label e volta para o �nicio do jogo personalizado como consequ�ncia #
	li $v0, 4
	la $a0, MSGSettingsVer1
	syscall
	j SettingsJogoPersonalizado	
	
OpcaoInvalidaLinhas:

	# caso o n�meros de linhas (s2) seja menor que 4, ele vai para esta label e volta para o �nicio do jogo personalizado como consequ�ncia #
	li $v0, 4
	la $a0, MSGSettingsVer2
	syscall
	j SettingsJogoPersonalizado	
				
LoopIString2Matriz:

	beq $s0, $s2, Exit
	li $v0, 4
	la $a0, MSGCores1Half1
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	li $v0, 4
	la $a0, MSGCores1Half2
	syscall
	la $a0, MSGCores2
	syscall
	li $v0, 8
	la $a0, Input
	li $a1, 50
	syscall
	move $s1, $0
	move $t2, $0
	
IniciarJogo:
	sw $s3, tamanho
	
	jal gerador
	
	la $a0, sequencia
	li $v0, 4
	syscall
	
	move $a1, $s2
	
	jal main_ef
	
	j Menu
	
LoopVerificacaoString:

	beq $t2, $s3, StringCandidata
	lb $a0, Input($s1)	

	jal Verificacao
	move $t4, $v0
	beq $t4, $0, LoopJString2MatrizInvalida
	move $t4, $v1
	sb $t4, Input($s1)                        			                     
	j LoopJString2MatrizValida
	

LoopIString2MatrizInc:
	move $s1, $0
	move $t2, $0
	addi $s0, $s0, 1
	j LoopIString2Matriz


StringCandidata:
	lb $t5, Input($s1)
	beq $t5, 10, LoopMatriz2StringReset
	beq $t5, 0, LoopMatriz2StringReset
	j LoopJString2MatrizInvalida

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
	move $s1, $0
	
LoopMatriz2String:
	beq $t2, $s3, LoopJMasterMind
	lb $t4, Input($s1)
	mul $t1, $s0, $s3           # C�lculo: offset = [base + (i * M) + j] 
	add $t1, $t1, $s1
	add $t5, $s4, $t1
	sb $t4, 0($t5)
	addi $t2, $t2, 1
	addi $s1, $s1, 1
	j LoopMatriz2String
	
LoopJMasterMind:

Exit:
	li $v0, 10
	syscall

	# Fun��es #
Verificacao:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	la $t1, cores
	li $v0, 0
	blt $a0, 'a', VerificacaoCores
	bgt $a0, 'z', VerificacaoCores
	addi $a0, $a0, -32
	
VerificacaoCores:	
	lb $t3, 0($t1)
	beq $a0, $t3, Match
	beq $t3, $0,EndVerificacao 
	addi $t1, $t1, 1
	j VerificacaoCores
	
Match:
	addi $v0,$v0, 1
	move $v1, $a0
	j EndVerificacao
	
EndVerificacao:
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra


TabuleiroDinamico:
	mul $a0, $a0, $a1
	li $v0, 9
	syscall
	jr $ra
	


	
	
