.data
buffer: .space 80   #Aparta 80 bytes de memoria como buffer para el input
prompt: .asciiz "\nEste es el prompt, escribe un comando:> "
error_comando_no_encontrado: .asciiz "Error, el comando introducido no existe.\nPor favor intenta de nuevo."
exit: .asciiz "exit"
help: .asciiz "help"
joke: .asciiz "joke"
song: .asciiz "song"
rev: .asciiz "rev"
cat: .asciiz "cat"
chiste1: .asciiz "Persona 1 - ¿Qué le dijo una papa a otra papa?\nPersona 2 - No sé, ¿qué le dijo?\nPersona 1 - Hola ( :,D )"
pregunta_si_quiere_salir: .asciiz "¿Seguro que quieres salir?"
mensaje_temporal: .asciiz "Comando por implementar"

.text
.globl main

#áéíóú   ¿?

main:
	# Imprimir el prompt
	li $v0, 4		# Código de syscall para imprimir una cadena
	la $a0, prompt 		# Cargar la dirección del prompt
	syscall			# Se imprime el prompt
	
	# Leer el input del usuario
	li $v0, 8 		# Código de syscall para leer una cadena
	la $a0, buffer		# Cargar la dirección del buffer
	li $a1, 81		# Tamaño máximo del buffer
	syscall			# Ahora lo que escribió el usuario está en buffer
	
	# Eliminar caracteres de nueva línea del buffer
    	jal eliminar_nueva_linea
	
	# Comparar el input con "joke"
    	la $t7, buffer           # Dirección del buffer de entrada
    	la $t8, joke             # Dirección de la cadena "joke"
    	jal comparacion_cadenas  # Llamar a la función de comparación de cadenas
    	beq $v0, 1, chiste       # Si son iguales, saltar a chiste
    	
    	# Comparar el input con "exit"
    	la $t7, buffer           # Dirección del buffer de entrada
    	la $t8, exit             # Dirección de la cadena "exit"
    	jal comparacion_cadenas  # Llamar a la función de comparación de cadenas
    	beq $v0, 1, fin          # Si son iguales, saltar a fin
    	
    	#Comparar el input con "song"
    	la $t7, buffer		# Dirección del buffer de entrada
    	la $t8, song		# Dirección de la cadena "song"
    	jal comparacion_cadenas  # Llamar a la función de comparación de cadenas
    	beq $v0, 1, cancion          # Si son iguales, saltar a cancion
    	
    	#Comparar el input con "help"
    	la $t7, buffer		# Dirección del buffer de entrada
    	la $t8, help		# Dirección de la cadena "help"
    	jal comparacion_cadenas  # Llamar a la función de comparación de cadenas
    	beq $v0, 1, ayuda          # Si son iguales, saltar a ayuda
    	
    	#Comparar el input con "rev"
    	la $t7, buffer		# Dirección del buffer de entrada
    	la $t8, rev		# Dirección de la cadena "rev"
    	jal comparacion_cadenas  # Llamar a la función de comparación de cadenas
    	beq $v0, 1, reversa          # Si son iguales, saltar a rev
    	
    	#Comparar el input con "cat"
    	la $t7, buffer		# Dirección del buffer de entrada
    	la $t8, cat		# Dirección de la cadena "cat"
    	jal comparacion_cadenas	# Llamar a la función de comparación de cadenas
    	beq $v0, 1, concatenar
    	
    	# Si no encaja con ninguna de las opciones
	li $v0, 55
	la $a0, error_comando_no_encontrado
	li $a1 0
	syscall
	
	# Volver a mostrar el prompt
	j main
	
# Función para comparar cadenas
comparacion_cadenas:
    	# Inicializar $v0 a 1 (asumir que las cadenas son iguales)
    	li $v0, 1
	
comparacion_bucle:
    	lb $t2, ($t7)            # Cargar el siguiente carácter del buffer
    	lb $t3, ($t8)            # Cargar el siguiente carácter de la cadena objetivo
    	beq $t3, $zero, fin_comparacion  # Si llegamos al final de la cadena del buffer, terminar comparación
    	bne $t2, $t3, cadenas_diferentes # Si los caracteres son diferentes, las cadenas no son iguales
    	addi $t7, $t7, 1         # Incrementar la dirección del buffer
    	addi $t8, $t8, 1         # Incrementar la dirección de la cadena objetivo
    	j comparacion_bucle      # Repetir el bucle de comparación
    	
cadenas_diferentes:
    	li $v0, 0                # Si encontramos caracteres diferentes, poner $v0 a 0 (cadenas diferentes)

fin_comparacion:
    	jr $ra                   # Volver a la dirección de retorno
    	
# Función para eliminar caracteres de nueva línea
eliminar_nueva_linea:
    la $t0, buffer           # Cargar la dirección del buffer
eliminar_bucle:
    lb $t1, ($t0)            # Cargar el siguiente carácter del buffer
    beq $t1, $zero, fin_eliminar  # Si llegamos al final de la cadena, terminar
    beq $t1, 10, poner_nulo  # Si encontramos un salto de línea (\n), reemplazar por nulo
    addi $t0, $t0, 1         # Incrementar la dirección del buffer
    j eliminar_bucle         # Repetir el bucle

poner_nulo:
    sb $zero, ($t0)          # Reemplazar el salto de línea con un nulo
fin_eliminar:
    jr $ra                   # Volver a la dirección de retorno

		
chiste:
	li $v0, 55		#Codigo para imprimir una cadena
	la $a0, chiste1		#Guardamos el chiste1 en $a0
	la $a1 1		#El argumento 1 significa que es un aviso
	syscall			#Subimos el chiste como una ventana de aviso
	j main
	
cancion:
	# Imprime mensaje temporal, pues esta funcion no esta implementada aun
	li $v0, 4			# Código de syscall para imprimir una cadena
	la $a0, mensaje_temporal	# Cargar la dirección del mensaje temporal
	syscall	
	j main
	
ayuda: 	
	# Imprime mensaje temporal, pues esta funcion no esta implementada aun
	li $v0, 4			# Código de syscall para imprimir una cadena
	la $a0, mensaje_temporal	# Cargar la dirección del mensaje temporal
	syscall	
	j main
	
reversa: 
	# Imprime mensaje temporal, pues esta funcion no esta implementada aun
	li $v0, 4			# Código de syscall para imprimir una cadena
	la $a0, mensaje_temporal	# Cargar la dirección del mensaje temporal
	syscall	
	j main
	
concatenar:
	# Imprime mensaje temporal, pues esta funcion no esta implementada aun
	li $v0, 4			# Código de syscall para imprimir una cadena
	la $a0, mensaje_temporal	# Cargar la dirección del mensaje temporal
	syscall	
	j main
		
fin:
	la $a0, pregunta_si_quiere_salir
	li $v0, 50
	syscall
	beq $a0 1 main
	beq $a0 2 main
	
	li $v0 10
	syscall
