.data
coresPadrao: .asciiz "BGRYWO" # blue, green, red, yellow, white, orange
cores: .space 31			
sequencia:.space 4		# espaço para guardar a sequência de letras (pode haver repetições)
NumerodeCores: .word 6
.globl cores
.text

main:		# imprimir sequência gerada (para testar)
    	jal gerador
	
    	la $a0, sequencia
    	li $v0, 4
    	syscall

    	li $v0, 10
    	syscall

gerador:	 	#vai gerar a sequencia que precisamos para o jogo
	li $t0, 0 	# i = 0, para fazer o loop

loop:
	li $v0, 42 	# escolhe um num
	add $a0, $0, $0
	lw $a1, NumerodeCores
	syscall

	la $s0, cores
    	add $s0, $s0, $a0
    	lb $s1, 0($s0)

    	la $s2, sequencia
    	add $s2, $s2, $t0
    	sb $s1, 0($s2)		# guarda a cor

	addi $t0, $t0, 1		# i = 1 + 1
	blt $t0, $s3, loop		# repete m vezes para obter a sequencia

	jr $ra
