.data
	.globl answer
	# Mensagens
	msg_win:	.asciiz "\nYOU WIN\n"
	msg_lose:	.asciiz "\nYOU LOSE\n"
	msg_answer:	.asciiz "\na resposta correta era: "
	msg: 		.asciiz "\nDigite a sequencia: "
	right: 		.asciiz " certa(s)\n"
	wrong: 		.asciiz " errada(s)\n"

	# Buffers (Aumentados para 6 para evitar overflow do \0)
	answer:		.space 6
	copia: 		.space 6

.text
	.globl main_ef
	.globl check

# --- REQUISITO F: Loop do Jogo ---
main_ef:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s7, 0	# Contador de tentativas (0 a 9)
	move $s6, $a1	# Limite de tentativas (recebido do main)

loop_jogo:
	beq $s7, $s6, fim_perdeu	# Verifica se esgotou tentativas

	# 1. Pedir input
	li $v0, 4
	la $a0, msg
	syscall

	# 2. Ler string (Aumentado para 6 bytes para segurança)
	li $v0, 8
	la $a0, answer
	li $a1, 6
	syscall

	# 3. Converter para Maiúsculas
	la $t0, answer		# Carrega o endereço da string lida
	
loop_to_upper:
	lb $t1, 0($t0)		# Lê o caracter atual
	beq $t1, $zero, fim_upper	# Se for NULL (fim), para
	beq $t1, 10, fim_upper		# Se for \n (enter), para
	
	# Verifica se é minúscula
	li $t2, 97
	blt $t1, $t2, proximo_char
	li $t2, 122
	bgt $t1, $t2, proximo_char
	
	# Converte para maiúscula (-32)
	sub $t1, $t1, 32
	sb $t1, 0($t0)

proximo_char:
	addi $t0, $t0, 1
	j loop_to_upper

fim_upper:
	# --- CORREÇÃO DO ERRO AQUI ---
	# É obrigatório recarregar o endereço de 'answer' em $a0
	# antes de chamar o bitmap, pois $a0 foi alterado pelos syscalls.
	la $a0, answer		
	move $a1, $s7		# Passa o número da tentativa atual
	jal bitmap		# Chama a função de desenho (K.asm)

	# 4. Validar Jogada
	jal check

	# 5. Verificar Vitória (check retorna acertos em $v0)
	li $t9, 4
	beq $v0, $t9, fim_ganhou

	addi $s7, $s7, 1	# Incrementa tentativas
	j loop_jogo

fim_ganhou:
	li $v0, 4
	la $a0, msg_win
	syscall
	j sair

fim_perdeu:
	li $v0, 4
	la $a0, msg_lose
	syscall
	
	li $v0, 4
	la $a0, msg_answer
	syscall
	
	# Imprime a senha secreta (sequencia deve ser .globl no main)
	la $a0, sequencia
	li $v0, 4
	syscall
	j sair

sair:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# --- REQUISITO E: Validação ---
check:
	# 1. Copiar sequencia para buffer temporário
	la $t0, sequencia	# sequencia vem do main.asm
	la $t1, copia
	li $t2, 0
	
loop_copia:
	lb $t3, 0($t0)
	sb $t3, 0($t1)
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	blt $t2, 4, loop_copia

	li $s0, 0	# Certos (Posição exata)
	li $s1, 0	# Errados (Posição errada)
	li $t0, 0	# i = 0
	
	# 2. Verificar Posições EXATAS
loop_certo:
	bge $t0, 4, end_certo
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)
	
	la $t3, copia
	add $t3, $t3, $t0
	lb $t4, 0($t3)
	
	bne $t2, $t4, proximo_certo
	
	addi $s0, $s0, 1
	li $t5, 42		# '*'
	sb $t5, 0($t1)		# Marca na resposta
	sb $t5, 0($t3)		# Marca na cópia (correção: adicionei virgula)
	
proximo_certo:
	addi $t0, $t0, 1
	j loop_certo
	
end_certo:
	li $t0, 0	# Reset i
	
	# 3. Verificar Posições ERRADAS
loop_errado:
	bge $t0, 4, end
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)
	
	li $t9, 42
	beq $t2, $t9, proximo_errado	# Ignora se for '*'
	
	li $t3, 0	# j = 0
	
ciclo_err:
	bge $t3, 4, proximo_errado
	
	la $t4, copia
	add $t4, $t4, $t3
	lb $t5, 0($t4)
	
	beq $t5, $t9, prox_err		# Ignora se cópia tiver '*'
	bne $t2, $t5, prox_err		# Se letras diferentes, continua
	
	# Achou correspondência parcial
	addi $s1, $s1, 1
	sb $t9, 0($t4)			# Risca na cópia
	j proximo_errado		# Sai do loop interno (break)
	
prox_err:
	addi $t3, $t3, 1
	j ciclo_err
	
proximo_errado:
	addi $t0, $t0, 1
	j loop_errado

end:
	# Imprime nova linha
	li $a0, 10
	li $v0, 11
	syscall
	
	# Imprime resultados
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, right
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, wrong
	syscall
	
	move $v0, $s0	# Retorna número de certas
	jr $ra