.data
cores:          .asciiz "BGRYWO"
sequencia:      .space 5
tamanho:        .word 6
tentativas_max: .word 10

    .text
    .globl main

main:
	jal gerador	# requisito B
	jal main_ef	# requisito EF
	