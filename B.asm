.data


coresDefault: .asciiz "BGRYWO" # blue, green, red, yellow, white, orange	
cores:		.space 31
tamanho:	.word 4
numeroCores: .word 6 # quantidade de cores default
		
.text			
.globl gerador
.globl cores
.globl numeroCores
.globl UpdateCores


	# Esta função permite definir as cores do alfabeto após iniciar o jogo
UpdateCores:
	la $t0, coresDefault # origem
	la $t1, cores        # destino
	add $t3, $0, $0     # contador

LoopCores:
	lb $t2, 0($t0)
	beq $t2, $0, ExitCores 
	sb $t2, 0($t1)
	addi $t3, $t3, 1 # conta e avança a letra
	addi $t0, $t0, 1 # avança uma "caixa" na origem
	addi $t1, $t1, 1 # avança uma "caixa" no destino
	j LoopCores

ExitCores:
	sb $0, 0($t1)	    # \0
	sw $t3, numeroCores # atualiza o número de cores
	
	jr $ra

gerador:	 		#vai gerar a sequencia que precisamos para o jogo
	li $t0, 0 		# i = 0, para fazer o loop

loop:
	li $v0, 42 		# escolhe um numero
	add $a0, $0, $0
	lw $a1, numeroCores	# tamnho pode alterar!
	syscall
	
	la $t4, cores
    	add $t5, $t4, $a0
    	lb $t1, 0($t5)

    	la $t6, sequencia
    	add $t6, $t6, $t0
    	sb $t1, 0($t6)		# guarda a cor
	
	addi $t0, $t0, 1	# i = 1 + 1
	blt $t0, $s3, loop	# repete m vezes para obter a sequencia
	
	la $t6, sequencia
	add $t6, $t6, $t0
	sb $zero, 0($t6) # funciona como um '\0'
	
	jr $ra
