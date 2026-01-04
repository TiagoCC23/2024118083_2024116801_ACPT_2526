.data
	
.globl answer

# Mensagens (Podes repor as tuas antigas aqui se quiseres)
msg_win:	.asciiz "\nYOU WIN\n"
msg_lose:	.asciiz "\nYOU LOSE\n"
msg_answer:	.asciiz "\na resposta correta era: "
msg: 	    .asciiz "\nDigite a sequencia: "
msg1: 	    .asciiz "\nTentativas restantes: "
MSGPontuacao: .asciiz "\nPontuacao: "
MSGNewLine: .asciiz "\n"
MSGTentativaInvalida:   .asciiz "Tentativa Inválida\n"

right: 	    .asciiz " certa(s)\n"
wrong: 	    .asciiz " errada(s)\n"

# Buffers (Tamanho 51 para segurança)
answer:	    .space 51   
copia: 	    .space 51   
pontuacao:  .word 0

.text
	
.globl main_ef
.globl check

# Requisito F	
main_ef:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	li $s7, 0	# vai de 0 ate 9
	move $s6, $a1   
	
	move $t7, $s6   # Contador visual
	
loop_jogo:
	beq $s7, $s6, fim_perdeu # repete ate s7 chegar em s6

	
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 1
	move $a0, $t7
	syscall
	li $v0, 4
	la $a0, MSGNewLine
	syscall

	li $v0, 4
	la $a0, msg
	syscall

	
	li $v0, 8
	la $a0, answer
	li $a1, 50
	syscall
	
	
	la $t0, answer	# Carrega o endereço da string lida	
loop_to_upper:
	lb $t1, 0($t0)		  # Lê o caracter atual
	beq $t1, $zero, fim_upper # Se for NULL (fim), para
	beq $t1, 10, fim_upper    # Se for \n (enter), para

	# verifica se é minúscula
	li $t2, 97
	blt $t1, $t2, proximo_char # se for menor que 'a', ignora
	li $t2, 122
	bgt $t1, $t2, proximo_char # Se for maior que 'z', ignora
	
	# Se chegou aqui, é minúscula. Subtrai 32 para virar maiúscula.
	sub $t1, $t1, 32   
	sb $t1, 0($t0)             # Salva a letra corrigida na memória

proximo_char:
	addi $t0, $t0, 1           # proxima letra
	j loop_to_upper

fim_upper:

    	la $s0, answer      # Ponteiro para a resposta
    	li $t2, 0           # Contador de tamanho do input
    
LoopValidacao:
    	lb $a0, 0($s0)      # Carrega letra
    
  
    	beq $a0, 10, FimCheckTamanho
    	beq $a0, $0, FimCheckTamanho
    

    	jal Verificacao
    

    	beq $v0, 0, ErroInput  
    
    	# Se válido, guarda a letra corrigida (Maiúscula) que veio em $v1
    	sb $v1, 0($s0)
    
   
    	addi $t2, $t2, 1    # avança o endereço da letra
    	addi $s0, $s0, 1    # avança o conteúdo letra
    	j LoopValidacao

FimCheckTamanho:
   	# se o contador ($t2) for diferente do número de colunas settado ($s3) temos um problema e é inválido
   	bne $t2, $s3, ErroInput  
    
	# É obrigatório recarregar o endereço de 'answer' em $a0

	# antes de chamar o bitmap, pois $a0 foi alterado pelos syscalls.

	la $a0, answer

	move $a1, $s7 # Passa o número da tentativa atual

	jal bitmap # Chama a função de desenho (K.asm)
    
    	# avança na jogada #
   	addi $t7, $t7, -1
    	jal check
    
    	beq $v0, $s3, fim_ganhou
    	addi $s7, $s7, 1
    	j loop_jogo


ErroInput:
    	li $v0, 4
    	la $a0, MSGTentativaInvalida
    	syscall
    	j loop_jogo         


fim_ganhou:
	li $v0, 4
	la $a0, msg_win
	syscall
	
	lw $t0, pontuacao
	addi $t0, $t0, 12
	sw $t0, pontuacao
	
	li $v0, 4
	la $a0, MSGPontuacao
	syscall
	li $v0, 1
	lw $a0, pontuacao
	syscall
	li $v0, 4
	la $a0, MSGNewLine
	syscall
	j sair

fim_perdeu:
	li $v0, 4
	la $a0, msg_lose
	syscall
	
	li $v0, 4
	la $a0, msg_answer
	syscall
	
	la $a0, sequencia
    	li $v0, 4
    	syscall
    
    
   	lw $t0, pontuacao
    	addi $t0, $t0, -3
    	bge $t0, 0, Compensacao
	li $t0, 0
	
Compensacao:
	mul $t1, $s0, 3
	add $t0, $t0, $t1
	sw $t0, pontuacao
	
	li $v0, 4
	la $a0, MSGPontuacao
	syscall
	li $v0, 1
	lw $a0, pontuacao
	syscall
	li $v0, 4
	la $a0, MSGNewLine
	syscall
	j sair

sair:
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	
	addi $sp, $sp, 8
	jr $ra


check:
	la $t0, sequencia
	la $t1, copia
	li $t2, 0
	
loop_copia:
	lb $t3, 0($t0)      # leitura da caixinha da sequencia
	
	li $t9, 97
	blt $t3, $t9, SalvaCopia  # Se for menor que 'a', não mexe
	li $t9, 122
	bgt $t3, $t9, SalvaCopia  # Se for maior que 'z', não mexe
	sub $t3, $t3, 32          # Converte para Maiúscula
	
SalvaCopia:
	sb $t3, 0($t1)      # Guarda na Copia
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	blt $t2, $s3, loop_copia

    
	li $s0, 0	# Certos (Pretos)
	li $s1, 0	# Errados (Brancos)
	li $t0, 0	
	
loop_certo:
	bge $t0, $s3, end_certo
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)  # carrega a letra do usuario
	
	la $t3, copia
	add $t3, $t3, $t0
	lb $t4, 0($t3)  # carrega a copia da senha
	
	bne $t2, $t4, proximo_certo
	
	addi $s0, $s0, 1 # count = count + 1
	li $t5, 42	 # coloca um '*'
	sb $t5, 0($t1)   # a resposta fica com '*'
	sb $t5, 0($t3)   # a cópia da senha fica com '*' tbm
	
proximo_certo:
	addi $t0, $t0, 1
	j loop_certo
	
end_certo:
	li $t0, 0        # i = 0 dnv para poder usar no loop_errado
	
loop_errado:
	bge $t0, $s3, end
	
	la $t1, answer
	add $t1, $t1, $t0
	lb $t2, 0($t1)
	
	li $t9, 42       # para comparar com o '*'
	beq $t2, $t9, proximo_errado
	
	li $t3, 0
	
ciclo_err:
	bge $t3, $s3, proximo_errado
	
	la $t4, copia
	add $t4, $t4, $t3
	lb $t5, 0($t4)
	
	beq $t5, $t9, prox_err
	bne $t2, $t5, prox_err
	
	addi $s1, $s1, 1
	sb $t9, 0($t4)
	j proximo_errado
	
prox_err:
	addi $t3, $t3, 1
	j ciclo_err
	
proximo_errado:
	addi $t0, $t0, 1
	j loop_errado

end:

	li $a0, 10
	li $v0, 11
	syscall
	
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
	
	move $v0, $s0
	jr $ra
