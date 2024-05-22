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
    	
    	# Si no encaja con ninguna de las opciones
	li $v0, 55
	la $a0, error_comando_no_encontrado
	li $a1 0
	syscall
	
	j main
	
# Función para comparar cadenas
comparacion_cadenas:
    	# Inicializar $v0 a 1 (asumir que las cadenas son iguales)
    	li $v0, 1
	
comparacion_bucle:
    	lb $t2, ($t7)            # Cargar el siguiente carácter del buffer
    	lb $t3, ($t8)            # Cargar el siguiente carácter de la cadena objetivo
    	beq $t2, $zero, fin_comparacion  # Si llegamos al final de la cadena del buffer, terminar comparación
    	bne $t2, $t3, cadenas_diferentes # Si los caracteres son diferentes, las cadenas no son iguales
    	addi $t7, $t7, 1         # Incrementar la dirección del buffer
    	addi $t8, $t8, 1         # Incrementar la dirección de la cadena objetivo
    	j comparacion_bucle      # Repetir el bucle de comparación
    	
cadenas_diferentes:
    	li $v0, 0                # Si encontramos caracteres diferentes, poner $v0 a 0 (cadenas diferentes)

fin_comparacion:
    	jr $ra                   # Volver a la dirección de retorno
		
chiste:
	li $v0, 55		#Codigo para imprimir una cadena
	la $a0, chiste1		#Guardamos el chiste1 en $a0
	la $a1 1		#El argumento 1 significa que es un aviso
	syscall			#Subimos el chiste como una ventana de aviso
	j main
	
fin:
	la $a0, pregunta_si_quiere_salir
	li $v0, 50
	syscall
	beq $a0 1 main
	beq $a0 2 main
	
	li $v0 10
	syscall
