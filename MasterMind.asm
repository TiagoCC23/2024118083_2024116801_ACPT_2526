.data

.globl Menu
.globl main
.globl sequencia
.globl Verificacao
sequencia: 	.space 31	# espaço seguro para a senha

.align 2
	# mensagens #
MSGBemVindo1: .asciiz "Bem vindo ao Master Mind\n"
MSGBemVindo2: .asciiz "Jogo feito por: Rayssa Santos e Tiago Chousal\n"
MSGMenu1: .asciiz "| Jogar (0)|\n"
MSGMenu2: .asciiz "| Definicoes (1)|\n"
MSGMenu3: .asciiz "| Sair (2)|\n"
MSGMenu4: .asciiz "| Opcao invalida |\n"
MSGSettings1: .asciiz "| Selecione se quer:\n| Jogo normal (0)|\n| Mudar o tabuleiro (1)|\n| Mudar o alfabeto (2)|\n| Voltar para o menu (3)|\n"
MSGSettings2: .asciiz "| Insira um numero de colunas (M) >=4 |\n"
MSGSettings3: .asciiz "| Insira um numero de linhas (N) >=2 |\n"
MSGSettings4: .asciiz "| Jogo personalizado criado com sucesso|\n"
MSGSettings6: .asciiz "| Opcao Invalida |\n"
MSGSettingsVer1: .asciiz "| Colunas invalidas\n"
MSGSettingsVer2: .asciiz "| Linhas invalidas\n"
MSGCores1Half1: .asciiz "Insira uma combinação de "
MSGCores1Half2: .asciiz " cores para fazer uma tentativa\n"
MSGCores2: .asciiz "Possibilidades de escolhas: \n"
MSGCores3: .asciiz " "
MSGCores4: .asciiz "\n"


 # matriz e Input #
MatrizLinhas: .word 10
MatrizColunas: .word 4
Input: .space 50

.text

main:	
	# Função que já atualiza as cores #
	jal UpdateCores
	
	# endereços para se utilizar na matriz e no loop do jogo #
	add $s0, $0, $0 # i -> linhas percorridas
	add $s1, $0, $0 # j -> colunas percorridas
	addi $s2, $0, 10 # n -> linhas que podem ser percorridas
	addi $s3, $0, 4  # m -> colunas que podem ser percorridas

	move $a0, $s2
	move $a1, $s3
	jal TabuleiroDinamico
	move $s4, $v0 
	
		# prints iniciais do joguinho lindo e maravilhoso feito pelos melhores devs do mundo #
	li $v0, 4
	la $a0, MSGBemVindo1
	syscall
	li $v0, 4
	la $a0, MSGBemVindo2
	syscall

Menu:
	# prints do menu onde t0 é o input dado #
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
	
	beq $t0, 0, IniciarJogo  
	beq $t0, 1, Settings
	beq $t0, 2, Exit
	j OpcaoInvalida
	
Settings:	
	# prints das definições onde t0 é o input #	
	li $v0, 4
	la $a0, MSGSettings1
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	beq $t0, 0, JogoPadrao # O user pode ter mudado de ideias e querer um jogo normal em vez de um jogo personalizado
	beq $t0, 1, SettingsTabuleiroPersonalizado # O user queria settar um tabuleiro personalizado
	beq $t0, 2, SettingsAlfabetoPersonalizado # O user queria settar um alfabeto personalizado
	beq $t0, 3, Menu # O user poderia quer voltar para o menu e manter o jogo personalizado
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

SettingsAlfabetoPersonalizado:
	jal AlterarAlfabeto  
	j Settings
	
SettingsTabuleiroPersonalizado:
	# permite o utiizador escolher como quer o tabuleiro onde s3 são as colunas e s2 as linhas #
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
	
	li $v0, 4
	la $a0, MSGSettings4
	syscall
	j Settings
	
OpcaoInvalida:

	# caso a opção no menu seja inválida, vai para esta label só para avisar e volta para o menu #
	li $v0, 4
	la $a0, MSGMenu4
	syscall
	j Menu
	
OpcaoInvalidaSettings:

	# caso a opção nas settings seja inválida, vai para esta label só para avisar e depois volta para as settings #
	li $v0, 4
	la $a0, MSGSettings6
	syscall
	j Settings
	
OpcaoInvalidaColunas:
	# caso o números de colunas (s3) seja menor que 4, ele vai para esta label e volta para o inicio do jogo personalizado como consequêcia #
	li $v0, 4
	la $a0, MSGSettingsVer1
	syscall
	j SettingsTabuleiroPersonalizado	
	
OpcaoInvalidaLinhas:

	# caso o números de linhas (s2) seja menor que 4, ele vai para esta label e volta para o inicio do jogo personalizado como consequência #
	li $v0, 4
	la $a0, MSGSettingsVer2
	syscall
	j SettingsTabuleiroPersonalizado	


IniciarJogo:
	# prints que indicam o alfabeto para o utilizador escolher #
	li $v0, 4
	la $a0, MSGCores1Half1
	syscall
	
	li $v0,1
	move $a0, $s3
	syscall
	
	la $v0, 4
	la $a0, MSGCores1Half2
	syscall
	jal TextoInicial
	 
	# gera o combinação correta #
	jal gerador
	
	# mostra a combinação correta o que deu jeito no debug #
	la $a0, sequencia
	li $v0, 4
	syscall
	
	
	move $a1, $s2  # manda o número de linhas para a função do loop do jogo
	
	
	jal main_ef
	
	# fim do jogo e volta ao menu #
	j Menu

Exit:
	li $v0, 10
	syscall

# FUNÇÕES #
# Função que permite ver se o input é válido ou não #
# Função Verificacao (Versão Compacta)
# Função que permite ver se o input é válido ou não #
Verificacao:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	la $t1, cores
	li $v0, 0
	
	# o objetivo é usar letras MAIÚSCULAS no projeto, logo ele vê se estamos a lidar com elas ou não e caso contrário converte #
	blt $a0, 'a', VerificacaoCores
	bgt $a0, 'z', VerificacaoCores
	addi $a0, $a0, -32
	
VerificacaoCores:	
	lb $t3, 0($t1)
	beq $t3, $0, EndVerificacao
	
	move $t8, $t3            # copia para $t8 (temporário)
	blt $t8, 'a', Comparar   # se for < 'a', não mexe
	bgt $t8, 'z', Comparar   # se for > 'z', não mexe
	addi $t8, $t8, -32       # converte 'a' -> 'A'
	

Comparar:

	beq $a0, $t8, Match # comparação entre o input ($a0) e alfabeto ($t8) já convertidos para maiúsculo  
	
	addi $t1, $t1, 1
	j VerificacaoCores
	
Match:
	addi $v0, $v0, 1
	move $v1, $a0
	j EndVerificacao
	
EndVerificacao:
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
# Função que cria um tabuleiro dinâmico usando malloc (li $v0, 9) e $a0 é a multiplicação das linhas e colunas #
TabuleiroDinamico:
	mul $a0, $a0, $a1
	li $v0, 9
	syscall
	jr $ra

# Função que cria o print do alfabeto personalizado onde imprime caracter a caracter até chegar a \0 ou \n #
TextoInicial:
	la $t0, cores
LoopPrintCores:
	lb $t1, 0($t0)
	beq $t1, $0, ExitTexto
	beq $t1, 10, ExitTexto
	li $v0, 11
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, MSGCores3
	syscall
	li $v0, 4
	la $a0, MSGCores4
	syscall
	addi $t0, $t0, 1
	j LoopPrintCores
ExitTexto:
	jr $ra
