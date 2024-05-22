.data
input:      .space 100              # Espacio para la entrada del usuario
msg:        .asciiz "Ingrese una cadena o el nombre de un archivo: "
newline:    .asciiz "\n"
error_msg:  .asciiz "Error al abrir el archivo.\n"
buffer:     .space 1000             # Buffer para el contenido del archivo

.text
.globl main

main:
    # Solicitar entrada al usuario
    li $v0, 4                       # Syscall para imprimir cadena
    la $a0, msg                     # Dirección del mensaje a imprimir
    syscall                         # Llamada al sistema

    # Leer la entrada del usuario
    li $v0, 8                       # Syscall para leer cadena
    la $a0, input                   # Dirección del buffer de entrada
    li $a1, 100                     # Tamaño máximo de la entrada
    syscall                         # Llamada al sistema

    # Determinar si es un archivo o una cadena
    la $t0, input                   # $t0 apunta al inicio de la entrada
    li $t1, 0                       # Inicializar el contador
    li $t2, 0                       # Bandera para el punto

check_extension:
    lb $t3, 0($t0)                  # Cargar un byte de la entrada
    beq $t3, 0, decide_action       # Si es el byte nulo, terminar
    beq $t3, '.', found_dot         # Si se encuentra un punto, marcar la bandera
    addi $t0, $t0, 1                # Avanzar al siguiente byte
    addi $t1, $t1, 1                # Incrementar el contador
    j check_extension               # Repetir

found_dot:
    li $t2, 1                       # Marcar que se encontró un punto
    j check_extension               # Continuar revisando

decide_action:
    beq $t2, 1, handle_file         # Si se encontró un punto, manejar como archivo
    j handle_string                 # Si no, manejar como cadena

handle_file:
    # Abrir el archivo
    li $v0, 13                      # Syscall para abrir archivo
    la $a0, input                   # Dirección del nombre del archivo
    li $a1, 0                       # Modo de apertura (lectura)
    li $a2, 0                       # Permisos (no aplicable)
    syscall                         # Llamada al sistema
    move $s0, $v0                   # Guardar el descriptor del archivo

    # Comprobar si el archivo se abrió correctamente
    bltz $s0, print_error           # Si hubo error, mostrar mensaje de error

    # Leer el contenido del archivo
    li $v0, 14                      # Syscall para leer archivo
    move $a0, $s0                   # Descriptor del archivo
    la $a1, buffer                  # Buffer donde se almacenará el contenido
    li $a2, 1000                    # Tamaño del buffer
    syscall                         # Llamada al sistema
    move $t1, $v0                   # Guardar la cantidad de bytes leídos

    # Cerrar el archivo
    li $v0, 16                      # Syscall para cerrar archivo
    move $a0, $s0                   # Descriptor del archivo
    syscall                         # Llamada al sistema

    # Aplicar reversa al contenido leído
    la $t0, buffer                  # $t0 apunta al inicio del buffer
    add $t3, $t0, $t1               # $t3 apunta al final del buffer
    subi $t3, $t3, 1                # Ajustar para el índice correcto

reverse_file:
    blt $t3, $t0, done              # Si $t3 es menor que $t0, terminar
    lb $a0, 0($t3)                  # Cargar el byte actual
    li $v0, 11                      # Syscall para imprimir carácter
    syscall                         # Llamada al sistema
    subi $t3, $t3, 1                # Decrementar el índice
    j reverse_file                  # Repetir

done:
    # Imprimir un salto de línea al final
    li $v0, 4                       # Syscall para imprimir cadena
    la $a0, newline                 # Dirección del mensaje de salto de línea
    syscall                         # Llamada al sistema

    # Salir del programa
    li $v0, 10                      # Syscall para terminar el programa
    syscall                         # Llamada al sistema

handle_string:
    # Calcular la longitud de la cadena
    la $t0, input                   # $t0 apunta al inicio de la cadena
    li $t1, 0                       # Inicializar longitud a 0
find_end:
    lb $t2, 0($t0)                  # Cargar un byte de la cadena
    beq $t2, 0, reverse_string      # Si es el byte nulo, salir del bucle
    addi $t1, $t1, 1                # Incrementar la longitud
    addi $t0, $t0, 1                # Avanzar al siguiente byte
    j find_end                      # Repetir el proceso

reverse_string:
    sub $t1, $t1, 1                 # Ajustar la longitud para obtener el índice del último carácter
    la $t0, input                   # Reiniciar $t0 al inicio de la cadena
    add $t3, $zero, $t1             # Copiar longitud en $t3 para usarla como índice inverso

print_reverse:
    blt $t3, $zero, done            # Si el índice es menor que 0, terminar
    add $t2, $t0, $t3               # Calcular la dirección del carácter actual (inicio + índice)
    lb $a0, 0($t2)                  # Cargar el carácter
    li $v0, 11                      # Syscall para imprimir carácter
    syscall                         # Llamada al sistema
    subi $t3, $t3, 1                # Decrementar el índice inverso
    j print_reverse                 # Repetir el proceso

print_error:
    # Imprimir mensaje de error
    li $v0, 4                       # Syscall para imprimir cadena
    la $a0, error_msg               # Dirección del mensaje de error
    syscall                         # Llamada al sistema
    j done                          # Saltar al final del programa
