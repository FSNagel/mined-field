#
#	Aluno: Felipe S. Nagel
#	Professor: Luciano Caimi
#	Semestre 2019/1
#

.data
	campo:      	   	.space  324
	campo_jogado:      	.space  324
	tamanho_char: 	   	.space  1
	tamanho:             	.byte   4
	print_dificuldade:      .asciiz "Dificuldade (a = 5x5 | b = 7x7 | c = 9x9):" 
	print_leitura_linha:    .asciiz "\n Informe a linha: \n"
	print_leitura_coluna:   .asciiz "\n Informe a coluna: \n"

	print_texto_print:	.asciiz "\n== Imprimindo Matriz == \n\n"	
	print_space:            .asciiz " "
	print_newline: 	        .asciiz "\n"
	print_game_over:   	.asciiz "\n=========================\n=       GAME OVER       = \n=========================\n"
	print_winner:   	.asciiz "\n=========================\n=        VITÓRIA        = \n=========================\n"
	
	semente:		.asciiz		"\nEntre com a semente da funcao Rand: "
	espaco:			.asciiz		" "
	nova_linha:		.asciiz		"\n"
	posicao:		.asciiz		"\nPosicao: "
	salva_S0:		.word		0
	salva_ra:		.word		0
	salva_ra1:		.word		0


.text

	main:
	
#====================================== Inicio de Ler Ordem ==========================================================================
	
	la $t0, tamanho			#Le endereco tamanho.	
	la $t1, tamanho_char		#Le endereco char tamanho.
	
	la $a0, print_dificuldade 	#Carrega em $a0 que eh lido para aparecer na tela, o print da dificuldade.
      	li $v0, 4			#4 Operacao de print
      	syscall
      	
      	move    $a0, $t1 		# Endereço que sera carregada a informacao.
    	li      $a1, 2   		# Quantos caracteres letra mais 1 (enter).
    	li      $v0, 8   		#8 Operacao de leitura.
     	syscall
     	
     	lb $t2, ($t1) 			#Le um byte
     	
     	beq $t2, 97, tamanho_a		#Compara se o valor de $t2 = 97 que corresponde a A
     	beq $t2, 98, tamanho_b		#Mesma coisa de acima só que B
     	beq $t2, 99, tamanho_c		#Igual acima só que C
     	
     	j tamanho_c
     	
     	tamanho_a: 			#Rótulo tamanho A, atribui o 5 a $t1 e desvia para salvar
     		li $t1, 5
     		j armazena_tamanho
     	
     	tamanho_b:
     		li $t1, 7
     		j armazena_tamanho
     	
     	tamanho_c:
     		li $t1, 9
     	
     	armazena_tamanho:		#Armazena o valor do $t1 no endereço de $t0, ou seja no tamanho
     	sb $t1,($t0)			
     	
#====================================== Fim de Ler Ordem ============================================================================
     	
	la $a0, campo			#Lê o endereço o primeiro enderco da matriz e coloca em $a0
	lb $a1, tamanho			#Lê o tamanho e atribui a $a1
	li $a2, 0 			#Valor que tera em toda matriz
	jal altera_matriz		#Altera a matriz campo para zero
	
	la $a0, campo_jogado		#Lê o endereço o primeiro enderco da matriz e coloca em $a0
	lb $a1, tamanho			#Lê o tamanho e atribui a $a1
	li $a2, -1 			#Valor que tera em toda matriz
	jal altera_matriz		#Altera a matriz campo para zero
	
	la $a0, campo			#Lê o endereço o primeiro enderco da matriz e coloca em $a0
	lb $a1, tamanho			#Lê o tamanho e atribui a $a1
	jal INSERE_BOMBA

	la $a0, campo			#Lê o endereço o primeiro enderco da matriz e coloca em $a0
	lb $a1, tamanho			#Lê o tamanho e atribui a $a1	
	jal calcula_bombas
			
	la $a0, campo			#Lê o endereço o primeiro enderco da matriz e coloca em $a0
	lb $a1, tamanho			#Lê o tamanho e atribui a $a1	
	jal imprime_matriz		
		
	j jogar
		
	j fim
	
	
	
#=================================== Início altera matriz ============================================================================
	
	altera_matriz:
	
		li $s0, 0 #contador i
		li $s1, 0 #contador j
		
		loopI:
			beq $s0, $a1, fimLoopI 		#compara o tamanho

			add $s1, $zero, $zero
				
			loopJ:
				beq $s1, $a1, endLoopJ
			
				#( i * tamanho + posicao ) 
				mul $s2, $s0, $a1 #multiplica i com tamanho
				add $s2, $s2, $s1 #soma resultado com posicao
				sll $t0, $s2, 2	  #multiplica por 4
				add $t0, $t0, $a0 #adiciona no endereco original
				
				sw  $a2, 0($t0)   #le na memoria
	
				addi $s1, $s1, 1
			j loopJ
		
			endLoopJ:
			
			addi $s0, $s0, 1
		j loopI
	
		fimLoopI:
	
	jr $ra
	
#=================================== Fim altera matriz =============================================================================

#=================================== Início altera matriz ============================================================================
	
	imprime_matriz:
	
		li $s0, 0 #contador i
		li $s1, 0 #contador j
		
		move $t0, $a0 #salvando os parametros		
		move $t1, $a1 #salvando os parametros
		
		la $a0,  print_newline	#Carrega em $a0 o valor, para quebra de linha
      		li $v0, 4		#4 Codigo impressao
      		syscall
	
		la $a0,  print_texto_print	#Carrega em $a0 o valor, para quebra de linha
      		li $v0, 4			#4 Codigo impressao
      		syscall
				
		loopI2:
			beq $s0, $t1, fimLoopI2 		#compara o tamanho

			add $s1, $zero, $zero
				
			loopJ2:
				beq $s1, $t1, endLoopJ2
			
				#( i * tamanho + posicao ) 
				mul $s2, $s0, $t1 #multiplica i com tamanho
				add $s2, $s2, $s1 #soma resultado com posicao
				sll $t3, $s2, 2	  #multiplica por 4
				add $t3, $t3, $t0 #soma com o endereco original
				
				la $a0,  print_space	#Carrega em $a0 o valor para imprimir espaço.
      				li $v0, 4		#4 Codigo impressao
      				syscall

				lw $a0, 0($t3)	#Carrega em $a0 o valor para imprimir espaço.
				
				bne $a0, -1, imprime_normal
					li $a0, 'x' 	#carrega o x para ser impresso
					li $v0, 11	#11 código caracter
					j pula_normal	#pula pro else

				imprime_normal:
      					li $v0, 1	#1 Codigo impressao de inteiro
      				
      				pula_normal:
      
      				syscall
	
				addi $s1, $s1, 1
			j loopJ2
		
			endLoopJ2:
			
			la $a0,  print_newline	#Carrega em $a0 o valor, para quebra de linha
      			li $v0, 4		#4 Codigo impressao
      			syscall
			
			addi $s0, $s0, 1
		j loopI2
	
		fimLoopI2:
	
	jr $ra
	
#=================================== Fim altera matriz =============================================================================

#=================================== Insere Bombas =================================================================================
	insere_bombas:
		addi $t0, $zero, 9

		sw $t0, 0($a0)
		sw $t0, 4($a0)
		sw $t0, 32($a0)
		sw $t0, 128($a0)
		sw $t0, 136($a0)
		sw $t0, 140($a0)
		sw $t0, 256($a0)
		sw $t0, 260($a0)
		sw $t0, 264($a0)
		jr $ra
#=================================== Fim Bombas ====================================================================================

#=================================== Calcula Bombas ================================================================================
	calcula_bombas:
	
		move $t9, $ra
	
		li $s0, 0 #contador i
		li $s1, 0 #contador j
				
		loopI3:
			beq $s0, $a1, fimLoopI3  #compara o tamanho

			add $s1, $zero, $zero
				
			loopJ3:
				beq $s1, $a1, endLoopJ3
				
				#( i * tamanho + posicao ) 
				mul $s2, $s0, $a1 #multiplica i com tamanho
				add $s2, $s2, $s1 #soma resultado com posicao
				sll $t0, $s2, 2	  #multiplica por 4
				add $t0, $t0, $a0 #soma com o endereco original
				
				move $a2, $t0	  #passa por parametro
				
				lw $t0, 0($t0)	  #Pega valor no endereco
			
				beq $t0, 9, pula_calc
					jal area_bombas
					
				pula_calc:
				
				addi $s1, $s1, 1
			j loopJ3
		
			endLoopJ3:
			
			addi $s0, $s0, 1
		j loopI3
	
		fimLoopI3:
	
	jr $t9
#=================================== Fim Calcula Bombas ============================================================================

#=================================== Area Bombas ===================================================================================
	#REGs ocupados: 
	#$a0 = matriz
	#$a1 = tamanho 
	#$a2 = pos atual
	#$s0 = i
	#$s1 = j
	#$t9 = retorno Calcula Bombas
	
	area_bombas:
		move $t8, $ra
		
		add $t2, $zero, $zero
		
		#(i+1), j
		addi $t0, $s0, 1
		add $t1, $zero, $s1
		jal valida_bombas
		add $t2, $t2, $t3
		
		#(i-1), j
		subi $t0, $s0, 1
		add $t1, $zero, $s1
		jal valida_bombas
		add $t2, $t2, $t3
				
		#i, (j+1)
		add $t0, $zero, $s0
		addi $t1, $s1, 1
		jal valida_bombas
		add $t2, $t2, $t3
				
		#i, (j-1)
		add $t0, $zero, $s0
		subi $t1, $s1, 1
		jal valida_bombas
		add $t2, $t2, $t3

		#(i-1), (j-1)
		subi $t0, $s0, 1
		subi $t1, $s1, 1
		jal valida_bombas
		add $t2, $t2, $t3
		
		#(i-1), (j+1)
		subi $t0, $s0, 1
		addi $t1, $s1, 1
		jal valida_bombas
		add $t2, $t2, $t3
		
		#(i+1), (j-1)
		addi $t0, $s0, 1
		subi $t1, $s1, 1
		jal valida_bombas
		add $t2, $t2, $t3
		
		#(i+1), (j+1)
		addi $t0, $s0, 1
		addi $t1, $s1, 1
		jal valida_bombas
		add $t2, $t2, $t3
		
		sw $t2, 0($a2) #grava a soma das bombas

	jr $t8

#=================================== Fim Area Bombas ===============================================================================


#=================================== Valida Bombas =================================================================================
	#REGs ocupados: 
	#$a0 = matriz
	#$a1 = tamanho 
	#$a2 = pos atual
	#$s0 = i original
	#$s1 = j original
	#$t0 = i atual
	#$t1 = j atual
	#$t2 = soma das bombas
	#$t3 = retorno dessa funcao com 1 se tiver bomba e 0 se nao tiver
	#$t8 = retorno Area Bombas
	#$t9 = retorno Calcula Bombas
	
	valida_bombas:
		
		move $t7, $ra

		slt $t5, $t0, $zero
		bnez $t5, nao_bomba

		slt $t5, $t1, $zero
		bnez $t5, nao_bomba
			
		slt $t5, $t0, $a1
		beqz $t5, nao_bomba

		slt $t5, $t1, $a1
		beqz $t5, nao_bomba	
		
		#( i * tamanho + posicao ) 
		mul $t4, $t0, $a1 #multiplica i com tamanho
		add $t4, $t4, $t1 #soma resultado com posicao
		sll $t4, $t4, 2	  #multiplica por 4
		add $t4, $t4, $a0 #soma com o endereco original
		
		lw $t4, 0($t4)
		bne $t4, 9, nao_bomba
			addi $t3, $zero, 1
			jr $t7
		
		nao_bomba:
			add $t3, $zero, $zero
			jr $t7
			
#=================================== Fim Valida Bombas =============================================================================
	
#=================================== JOGAR =========================================================================================
	jogar:
		la $t0, campo
		la $t1, campo_jogado
		lb $t2, tamanho
		
		
	le_linha:
		la $a0, print_leitura_linha 	#Carrega em $a0 que eh lido para aparecer na tela, o print da dificuldade.
      		li $v0, 4			#4 Operacao de print String
      		syscall

    		li      $a1, 2   		# Quantos caracteres letra mais 1 (enter).
    		li      $v0, 5   		#8 Operacao de leitura Inteiro
     		syscall
     		la    $s0, 0($v0) 		# Endereço que sera carregada a informacao.
     		subi $s0, $s0, 1		#subtrai usuario nao uso o zero do vetor
     		
     		slt $t5, $s0, $zero		#compara se é menor que 0
		bnez $t5, le_linha		#se $t5 tiver um volta pra linha
			
		slt $t5, $s0, $t2		#compara se é menor que o tamanho
		beqz $t5, le_linha		#se $t5 tiver zero volta para o linha
     	
     le_coluna:	
     		la $a0, print_leitura_coluna 	#Carrega em $a0 que eh lido para aparecer na tela, o print da dificuldade.
      		li $v0, 4			#4 Operacao de print
      		syscall
      	
    		li      $a1, 2   		# Quantos caracteres letra mais 1 (enter).
    		li      $v0, 5   		#8 Operacao de leitura inteiro.
     		syscall
     		la    $s1, 0($v0) 		# Endereço que sera carregada a informacao.
     		subi $s1, $s1, 1		#subtrai usuario nao uso o zero do vetor
     		
     		slt $t5, $s1, $zero		#compara se é menor que 0
		bnez $t5, le_coluna		#se $t5 tiver um volta pra linha
			
		slt $t5, $s1, $t2		#compara se é menor que o tamanho
		beqz $t5, le_coluna		#se $t5 tiver zero volta para o linha
     		
     		    		
     		mul $t3, $s0, $t2 #multiplica i com tamanho
		add $t3, $t3, $s1 #soma resultado com posicao
		sll $t3, $t3, 2	  #multiplica por 4
		
		add $t4, $t3, $t0 #soma com o endereco original
		lw $t4, 0($t4)
		add $t5, $t3, $t1 #soma com o endereco original jogado
		lw $t6, 0($t5)
		
		beq $t4, 9, gameover
		
		sw $t4, 0($t5)
		
		la $a0, campo_jogado		#Lê o endereço o primeiro enderco da matriz e coloca em $a0
		lb $a1, tamanho			#Lê o tamanho e atribui a $a1
		
		jal imprime_matriz	
		
		la $a0, campo_jogado		#Lê o endereço o primeiro enderco da matriz e coloca em $a0
		lb $a1, tamanho			#Lê o tamanho e atribui a $a1
		la $a2, campo			#Lê o endereço o primeiro enderco da matriz e coloca em $a2
		
		j verifica_vitoria
		
		
#=================================== FIM JOGAR =====================================================================================
			
#=================================== VERIFICA VITÓRIA ==============================================================================
	#REGs ocupados: 
	#$t1 = matriz
	#$t2 = tamanho 
	#$a0 = matriz
	#$a1 = tamanho 
			
		verifica_vitoria:
			mul $t3, $a1, $a1
			add $s0, $zero, $zero
			
			loopVerifica:
		
				beq $s0, $t3, fimLoopVerifica  #compara o tamanho

				move $t4, $s0 		#copia valor do contador
				sll $t4, $t4, 2 	#multiplica o valor do contador por 4
				add $t5, $t4, $a0	#adiciona ao endereco original
			
				lw $t5, 0($t5) 		#le valor vetor
				
				bne $t5, -1, incrementa_verifica
					add $t5, $t4, $a2
					lw $t5, 0($t5)
					
					bne $t5, 9, jogar
				
				incrementa_verifica:
				addi $s0, $s0, 1
			j loopVerifica
			
			fimLoopVerifica:
			
			j winner #se chegou aqui ganhou
			
#=============================== FIM VERIFICA VITÓRIA ==============================================================================
		
#=================================== VITÓRIA OU DERROTA ============================================================================


		gameover:
		la $a0, print_game_over 	#Carrega em $a0 que eh lido para aparecer na tela, o print da dificuldade.
      		li $v0, 4			#4 Operacao de print
      		syscall
      		
      		j fim
      		
      	winner:
		la $a0, print_winner 	#Carrega em $a0 que eh lido para aparecer na tela, o print da dificuldade.
      		li $v0, 4			#4 Operacao de print
      		syscall
      		
      		j fim

#=================================== FIM VITÓRIA OU DERROTA ========================================================================

		      		
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
			
														
	fim:
	
