.data
.align 2
MSGAlfabetoPersonalizado1: .asciiz "| Insira um alfabeto personalizado |\n"
MSGAlfabetoPersonalizado2: .asciiz "| Caso não insira nada, o alfabeto será o padrão |\n"
MSGAlfabetoPersonalizadoSuc: .asciiz "| Alfabeto atualizado com sucesso |\n| Jogo personalizado criado com sucesso |"
MSGAlfabetoPersonalizadoRes: .asciiz "| Alfabeto clássico definido com sucesso |\n"
MSGAlfabetoPersonalizadoErr: .asciiz "| Alfabeto inválido |\n| O alfabeto tem de ter mais de uma letra diferente |\n"
.text
.globl AlterarAlfabeto

AlterarAlfabeto:
	# guarda o $ra, já que ele vai ser preciso chamar o UpdateCores #
	addi $sp, $sp, -4
	sw $ra, 0($sp)

InputAlfabeto:
	# prints para o input #
	li $v0, 4
	la $a0, MSGAlfabetoPersonalizado1
	syscall
	li $v0, 4
	la $a0, MSGAlfabetoPersonalizado2
	syscall
	
	# input para o alfabeto #
	li $v0, 8
	la $a0, cores
	la $a1, 30
	syscall
	
	# carrega a string do alfabeto para depois ser analisada #
	la $t0, cores
	add $t1, $0, $0 # i=0
	 
	
LoopAnaliseString:
	lb $t2,0($t0)
	beq $t2, $0, AnaliseAlfabeto
	beq $t2, 10, FimString # usa-se o 10, porque em código ASCII corresponde ao \n, aka enter
	
	addi $t0, $t0, 1 # avança para o próximo endereço da string para se ver o conteúdo
	addi $t1, $t1, 1 # i++
	
	j LoopAnaliseString

FimString:
	sb $0, 0($t0) # tira o \n, fechando a string
	
AnaliseAlfabeto:
	# caso não haja input, o alfabeto leva reset e fica: BGRYWO
	beq $t1, $0, AlfabetoDefault
	
	# caso o alfabeto seja só uma letra, dá erro de input
	blt $t1, 2, ErroInput
	
	# voltamos a carregar o alfabeto para ver se existe só uma letra #
	la $t0, cores
	lb $t4, 0($t0) # guarda a primeira letra para depois percorrer o alfabeto e verificar se é só uma letra
	addi $t0, $t0, 1 

LoopAlfabetoRepetidos:
	lb $t2, 0($t0)
	beq $t2, $0, ErroInput
	bne $t2, $t4, AlfabetoValido
	addi $t0, $t0, 1
	j LoopAlfabetoRepetidos

AlfabetoDefault:
	jal UpdateCores
	li $v0, 4
	la $a0, MSGAlfabetoPersonalizadoRes
	j ExitAlfabeto
	
AlfabetoValido:
	sw $t1, numeroCores # vai guardar o tamanho do alfabeto no número de cores
	
	li $v0, 4
	la $a0, MSGAlfabetoPersonalizadoSuc
	syscall
	j ExitAlfabeto

ErroInput:
	li $v0, 4
	la $a0, MSGAlfabetoPersonalizadoErr
	syscall
	j InputAlfabeto

ExitAlfabeto:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

	
	