#Programa en MIPS que lee un archivo.
.data
archivo: .asciiz "Prueba.txt"
buffer: .space  256 # Buffer que contiene los datos del archivo.

.text
.globl main

main:
  # Abrimos el archivo para leer
  li $v0, 13 # Syscall para abrir un archivo
  la $a0, archivo #Nombre del archivo a leer
  li $a1, 0 # read mode: 0 para leer, 1 para escribir, en este caso 0.
  li $a2, 0 # Permisos por defecto
  syscall
  move $s0, $v0 # Descriptor del archivo.

  # Lee los contenidos del archivo.
  li $v0, 14 # Syscall para leer un archivo
  move $a0, $s0 # Movemos el descriptor al $a0
  la $a1, buffer # Carga la direccion del buffer a $a1
  li $a2, 256# Limite de lectura, lee hasta 256 bytes.
  syscall

  # Imprimir los contenidos del buffer.
  li $v0, 4 # Codigo para imprimir string
  la $a0, buffer # Cargamos la direccion del buffer
  syscall                 

  # Cerramos el archivo.
  li $v0, 16 # Syscall para cerrar un archivo.
  move $a0, $s0 # Movemos el descriptor del archivo a $a0
  syscall

  # Bai Bai
  li $v0, 10
  syscall
