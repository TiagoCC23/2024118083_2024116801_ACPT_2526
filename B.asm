.data

.globl cores

coresPadrao: .asciiz "BGRYWO"	
cores:		.asciiz 	# blue, green, red, yellow, white, orange
tamanho:	.word 4
		
.text			
.globl gerador
.globl cores
.globl numeroDeCores
.globl resetCores


gerador:	 	#vai gerar a sequencia que precisamos para o jogo
	li $t0, 0 	# i = 0, para fazer o loop

loop:
	lw $a1, tamanho	# tamnho pode alterar!
	li $v0, 42 	# escolhe um numero
	syscall
	
	la $s0, cores
    	add $s0, $s0, $a0
    	lb $s1, 0($s0)

    	la $s2, sequencia
    	add $s2, $s2, $t0
    	sb $s1, 0($s2)	# guarda a cor
	
	addi $t0, $t0, 1	# i = 1 + 1
	blt $t0, 4, loop	# repete 4 vezes para obter a sequencia
	
	la $s2, sequencia
	add $s2, $s2, $t0
	sb $zero, 0($s2) # funciona como um '\0'
	
	jr $ra
