.data
buffer: .space 80   #Aparta 80 bytes de memoria como buffer para el input
prompt: .asciiz "\nEste es el prompt, escribe un comando:> "
error_comando_no_encontrado: .asciiz "Error, el comando introducido no existe.\nPor favor intenta de nuevo."
exit: .asciiz "exit"
chiste1: .asciiz "Persona 1 - ¿Qué le dijo una papa a otra papa?\nPersona 2 - No sé, ¿qué le dijo?\nPersona 1 - Hola ( :,D )"
pregunta_si_quiere_salir: .asciiz "¿Seguro que quieres salir?"

.text
.globl main

#áéíóú   ¿?

main:
	li $v0, 4		#Imprime una cadena
	la $a0, prompt 		#Se carga la cadena de prompt
	syscall			#Se imprime el prompt
	
fin:
	la $a0, pregunta_si_quiere_salir
	li $v0, 50
	syscall
	beq $a0 1 main
	beq $a0 2 main
	
	li $v0 10
	syscall
	
joke:
	li $v0, 55		#Codigo para imprimir una cadena
	la $a0, chiste1		#Guardamos el chiste1 en $a0
	la $a1 1		#El argumento 1 significa que es un aviso
	syscall			#Subimos el chiste como una ventana de aviso
	j main
