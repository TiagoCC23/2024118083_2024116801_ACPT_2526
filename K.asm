.data

.globl RED
.globl GREEN
.globl BLUE
.globl WHITE
.globl YELLOW
.globl ORANGE

RED: 	.word 0x00FF0000
GREEN: 	.word 0x0000FF00
BLUE: 	.word 0x000000FF
WHITE: 	.word 0x00FFFFFF
YELLOW: .word 0x00FFFF00
ORANGE: .word 0x00FFA500 

.text
.globl bitmap

bitmap:
	addi $sp, $sp, -16
    	sw $ra, 0($sp)
    	sw $s0, 4($sp)      # indice i
    	sw $s1, 8($sp)      # y calculado
    	sw $s2, 12($sp)     # endereco da string

    	move $s2, $a0       # $s2 = String
    
    	# y = 28 - (tentativa * 2)
    	mul $t0, $a1, 2
    	li $t1, 28
    	sub $s1, $t1, $t0

	li $s0, 0	# i = 0

loop_desenho:
    	bge $s0, 4, fim_desenho

    	add $t2, $s2, $s0
    	lb $t3, 0($t2)

    	beq $t3, 'R', cor_red
    	beq $t3, 'G', cor_green
    	beq $t3, 'B', cor_blue
    	beq $t3, 'Y', cor_yellow
    	beq $t3, 'W', cor_white
    	beq $t3, 'O', cor_orange
    
    	li $a2, 0
    	j desenhar_pixel

cor_red:
	lw $a2, RED
	j desenhar_pixel
cor_green:
	lw $a2, GREEN
	j desenhar_pixel
cor_blue:
	lw $a2, BLUE
	j desenhar_pixel
cor_yellow: 
	lw $a2, YELLOW
	j desenhar_pixel
cor_white:  
	lw $a2, WHITE
	j desenhar_pixel
cor_orange:
	lw $a2, ORANGE
	j desenhar_pixel

desenhar_pixel:
    	# x = 10 + (i * 2) -> Colunas 10, 12, 14, 16
    	mul $t4, $s0, 2
    	addi $a0, $t4, 10 
    
    	move $a1, $s1
    
    	jal pintar_pixel

    	addi $s0, $s0, 1
    	j loop_desenho

fim_desenho:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	addi $sp, $sp, 16
    	jr $ra
    	
pintar_pixel:
	li $t0, 0x10008000 	# Endereço base do Bitmap Display
	
	mul $t1, $a1, 32	# y * Largura
	add $t1, $t1, $a0	# + x
	mul $t1, $t1, 4		# * 4 (bytes por word)
	
	add $t0, $t0, $t1
	
	sw $a2, 0($t0)
	
	jr $ra