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
	li $v0, 4		#Imprime una cadena
	la $a0, prompt 		#Se carga la cadena de prompt
	syscall			#Se imprime el prompt
	
	li $v0, 8 		#Lee un String del usuario
	la $a0, buffer		#Aparta en $a0 un buffer de tamanio 80
	li $a1, 81		#Tamanio maximo de la cadena
	syscall			#Ahora lo que escribio el usuario esta en buffer
	
	la $t7, buffer		#Cargamos a $s2 la direccion del buffer
	la $t8, joke		#Cargamos a $s3 la direccion de joke
	
comparacion_joke:		#Esta no necesita argumento, se debe de tomar en cuenta
	lb $t2, ($t7)		#Siguiente char de lo que escribio el usuario
	lb $t3, ($t8)		#Siguiente char de la opcion analizada
	bne $t2, $t3, comparacion_exit	 	#luego le cambio a comparacion_help
	beq $t3, $zero, chiste
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	j comparacion_joke
	
comparacion_exit:
	la $t7, buffer
	la $t8, exit
	
comparacion_exit2:		#Tampoco necesita argumentos
	lb $t2, ($t7)		#Siguiente char de lo que escribio el usuario
	lb $t3, ($t8)		#Siguiente char de la opcion analizada
	bne $t2, $t3, comparacion_no_encaja_con_ninguna
	beq $t3, $zero, fin
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	j comparacion_exit2
	
comparacion_no_encaja_con_ninguna:
	li $v0, 55
	la $a0, error_comando_no_encontrado
	li $a1 0
	syscall
	j main
		
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
