.data
input:      .space 100              # Reservar espacio para la cadena de entrada (máximo 100 caracteres)
msg:        .asciiz "Ingrese una cadena: "
newline:    .asciiz "\n"

.text
.globl main

# Is it possible to use this code for the standard input and file input ???
# I hope so, and I'll try to do that

main:
    # Solicitar cadena al usuario
    li $v0, 4                    # Código de syscall para imprimir cadena
    la $a0, msg                  # Dirección del mensaje a imprimir
    syscall                      # Llamada al sistema

    # Leer la cadena de entrada
    li $v0, 8                    # Código de syscall para leer cadena
    la $a0, input                # Dirección del espacio reservado para la cadena de entrada
    li $a1, 100                  # Tamaño máximo de la cadena
    syscall                      # Llamada al sistema

    # Calcular la longitud de la cadena
    la $t0, input                # $t0 apunta al inicio de la cadena
    li $t1, 0                    # Inicializar longitud a 0
find_end:
    lb $t2, 0($t0)               # Cargar un byte de la cadena
    beq $t2, 0, reverse          # Si es el byte nulo (fin de la cadena), salir del bucle
    addi $t1, $t1, 1             # Incrementar la longitud
    addi $t0, $t0, 1             # Avanzar al siguiente byte
    j find_end                   # Repetir el proceso

reverse:
    sub $t1, $t1, 1              # Ajustar la longitud para obtener el índice del último carácter
    la $t0, input                # Reiniciar $t0 al inicio de la cadena
    add $t3, $zero, $t1          # Copiar longitud en $t3 para usarla como índice inverso

print_reverse:
    blt $t3, $zero, done         # Si el índice es menor que 0, terminar
    add $t2, $t0, $t3            # Calcular la dirección del carácter actual (inicio + índice)
    lb $a0, 0($t2)               # Cargar el carácter
    li $v0, 11                   # Código de syscall para imprimir carácter
    syscall                      # Llamada al sistema
    subi $t3, $t3, 1             # Decrementar el índice inverso
    j print_reverse              # Repetir el proceso

done:
    # Imprimir un salto de línea al final
    li $v0, 4                    # Código de syscall para imprimir cadena
    la $a0, newline              # Dirección del mensaje de salto de línea
    syscall                      # Llamada al sistema

    # Salir del programa
    li $v0, 10                   # Código de syscall para terminar el programa
    syscall                      # Llamada al sistema

