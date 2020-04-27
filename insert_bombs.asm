#
#
#A função insere_bombas necessita os seguintes rótulos
# e espaços de memória reservados
#
#
		.data
campo:			.space		324
semente:		.asciiz		"\nEntre com a semente da funcao Rand: "
espaco:			.asciiz		" "
nova_linha:		.asciiz		"\n"
posicao:		.asciiz		"\nPosicao: "
salva_S0:		.word		0
salva_ra:		.word		0
salva_ra1:		.word		0


#
#
#A função insere_bombas está implementada 
# abaixo. Todo o código a seguir deve ser 
# colocado junto a implentação feita.
#
#

	.text

#########################
#     Insere Bomba      #
#########################			
#
#Le Numero de bombas (x)
#Le semente (a)
#while (bombas < x) 
#   sorteia linha
#   sorteia coluna
#   le posição pos = (L X tam + C) * 4
#   if(pos != 9)
#    	grava posicao pos = 9
#   bombas++  
#	
INSERE_BOMBA:
		la	$t0, salva_S0
		sw  $s0, 0($t0)		# salva conteudo de s0 na memoria
		la	$t0, salva_ra
		sw  $ra, 0($t0)		# salva conteudo de ra na memoria
		
		add $t0, $zero, $a0	# salva a0 em t0
		add $t1, $zero, $a1	# salva a1 em t1

		li	$v0, 1
		add $a0, $zero, $a1 #
		syscall		
		
		li	$v0, 4			# 
		la	$a0, nova_linha
		syscall			

verifica_menor_que_5:
		slti $t3, $t1, 5
		beq	 $t3, $0, verifica_maior_que_9
		addi $t1, $0, 5			#se tamanho do campo menor que 5 atribui 5
		add  $a1, $0, $t1
verifica_maior_que_9:
		slti $t3, $t1, 9
		bne	 $t3, $0, testa_5
		addi $t1, $0, 9			
		add  $a1, $0, $t1
testa_5:
		addi $t3, $0, 5
		bne  $t1, $t3, testa_7
		addi $t2, $0, 10 # 10 bombas no campo 5x5
		j	 pega_semente
testa_7:
		addi $t3, $0, 7
		bne  $t1, $t3, testa_9
		addi $t2, $0, 20 # 20 bombas no campo 7x7
		j	 pega_semente
testa_9:
		addi $t3, $0, 9
		bne  $t1, $t3, else_qtd_bombas
		addi $t2, $0, 40 # 40 bombas no campo 9x9
		j	 pega_semente
else_qtd_bombas:
		addi $t2, $0, 25 # seta para 25 bomas no else		
pega_semente:
		jal SEED
		add $t3, $zero, $zero # inicia contador de bombas com 0
INICIO_LACO:
		beq $t2, $t3, FIM_LACO
		
		add $a0, $zero, $t1 # carrega limite para %
		jal PSEUDO_RAND
		add $t4, $zero, $v0	# pega linha sorteada e coloca em t4
   		jal PSEUDO_RAND
		add $t5, $zero, $v0	# pega coluna sorteada e coloca em t5

################ imprime valores na tela (para debug somente)
	
#		li	$v0, 4			# mostra linha sorteada
#		la	$a0, posicao
#		syscall
#		li	$v0, 1
#		add $a0, $zero, $t4 #linha
#		syscall
#
#		add $a0, $zero, $t5 #coluna
#		syscall
#		
#		li	$v0, 4			# mostra coluna sorteada
#		la	$a0, espaco
#		syscall
#		li	$v0, 1		
#		add $a0, $zero, $t3 #linha
#		syscall
		
#######################	
	
		mult $t4, $t1
		mflo $t4
		add  $t4, $t4, $t5  # calcula (L * tam) + C
		add  $t4, $t4, $t4  # multtiplica por 2
		add  $t4, $t4, $t4  # multtiplica por 4
		add	 $t4, $t4, $t0	# calcula Base + deslocamento
		lw	$t5, 0($t4)		# Le posicao de memoria LxC

		
		addi $t6, $zero, 9	
		beq  $t5, $t6, PULA_ATRIB
		sw   $t6, 0($t4)
		addi $t3, $t3, 1		
PULA_ATRIB:
		j	INICIO_LACO
FIM_LACO:


#		la   $a0, campo
#		addi $a1, $zero, 7
#		jal MOSTRA_CAMPO	
		
		la	$t0, salva_S0
		lw  $s0, 0($t0)		# recupera conteudo de s0 da memória
		la	$t0, salva_ra
		lw  $ra, 0($t0)		# recupera conteudo de ra da memória		
		jr $ra
		



SEED:
	li	$v0, 4			# lendo semente da funcao rand
	la	$a0, semente
	syscall
	li	$v0, 5		#
	syscall
	add	$a0, $zero, $v0	# coloca semente de bombas em a0
	bne  $a0, $zero, DESVIA
	lui  $s0,  1		# carrega semente 100001
 	ori $s0, $s0, 34465	# 
	jr $ra	
DESVIA:
	add	$s0, $zero, $a0		# carrega semente passada em a0
	jr $ra
	


#
#função que gera um número randomico
#
 #int rand1(int lim) {
 # static long a = 100001; 
 #a = (a * 125) % 2796203; 
 #return ((a % lim) + 1); 
 #} // 
  
PSEUDO_RAND:
	addi $t6, $zero, 125  	# carrega 125
	lui  $t5,  42			# carrega fator: 2796203
	ori $t5, $t5, 43691 	#-
	
	mult  $s0, $t6			# a * 125
	mflo $s0				# a = (a * 125)
	div  $s0, $t5			# a % 2796203
	mfhi $s0				# a = (a % 2796203)
	div  $s0, $a0			# a % lim
	mfhi $v0                # v0 = a % lim
	jr $ra
	
	