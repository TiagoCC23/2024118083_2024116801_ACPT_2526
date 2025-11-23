		.data
cores:		.asciiz "BGRYWO"		# blue, green, red, yellow, white, orange
sequencia:	.space 4		# espaço para guardar a sequência de letras (pode haver repetições)
		.text

gerador:	 	#vai gerar a sequência que precisamos para o jogo
	li $t0, 0 	# i = 0, para fazer o loop

loop:
	li $v0, 42
	li $a0, 6	# vai de 0 à 5

	addi $t0, $t0, 1		# i = 1 + 1

	jr $ra
