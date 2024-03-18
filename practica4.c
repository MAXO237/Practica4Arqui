#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <math.h>

void adicion(char opA[], char opB[], int lA, int lB){
  int acarreo = 0, auxiliar;
  char resultado[32];
  
  while  (lB > 0){    
    auxiliar = (opA[lA-1] - '0') + (opB[lB-1] - '0') + acarreo;
    if (auxiliar >= 2){
      acarreo = 1;
      auxiliar = auxiliar-2;
    }
    else{
      acarreo = 0;
    }
    resultado[lA] = auxiliar + '0';
    lA--;
    lB--;  
  }

  if (acarreo == 1){
    resultado[0] = '1';
  }
  else{
    for (int i = 0; i < strlen(resultado)-1; i++){
      resultado[i] = resultado[i+1];
    }
    resultado[strlen(resultado) - 1] = '\0';
  }
  
  printf("La suma de los números es %s\n", resultado);
}

void resta(char opA[], char opB[]){
  return;
}

void bitwiseAnd(char opA[], char opB[]){
  printf("\nAND de los números es ");
  for (int i = 0; i < 32; i++){
    if (opA[i] == '1' && opB[i] == '1'){
      printf("%d",1);
    }
    else{
      printf("%d",0);
    }
  }
  printf("\n");
}

void bitwiseOr(char opA[], char opB[]){
  printf("\nOR de los números es ");
  for (int i = 0; i < 32; i++){
    if (opA[i] == '1' || opB[i] == '1'){
      printf("%d",1);
    }
    else{
      printf("%d",0);
    }
  }
  printf("\n");
}

void igualdad(char opA[], char opB[]){
  printf("\nLa igualdad de los números se evalúa ");
  if (strcmp(opA,opB) == 0){
    printf("11111111111111111111111111111111\n");
  }
  else{
    printf("00000000000000000000000000000000\n");
  }
}

void menorQue(char opA[], char opB[]){
  printf("\nLa comparación opA < opB se evalúa ");
  for (int i = 0; i < 32; i++){
    if (opA[i] == '0' && opB[i] == '1'){
      printf("11111111111111111111111111111111\n");
      return;
    }
    if (opA[i] == '1' && opB[i] == '0'){
      break;
    }
  }
  printf("00000000000000000000000000000000\n");
  
}

int main(int argc, char *argv[]){
  int lengthA = strlen(argv[2]);
  int lengthB = strlen(argv[3]);
  int lengthOp = strlen(argv[1]);
  
  if (argc != 4){
    printf("\nNúmero no válido de argumentos. Ingresar la clave de la operación a realizar seguida de los operandos (32 bits)");
    return 0;
  }
  if (lengthA != 32 || lengthB != 32 || lengthOp != 3){
    printf("\nLos operandos deben ser cadenas de 32 bits y la operación a realizar debe tener 3 bits.");
    return 0;
  }

  //Función AND completa
  if (strcmp("000",argv[1]) == 0){
    bitwiseAnd(argv[2],argv[3]);
  }
  //Función OR completa
  if (strcmp("001",argv[1]) == 0){
    bitwiseOr(argv[2],argv[3]);
  }
  //No funciona bien para casos de desbordamiento y de complemento a dos
  if (strcmp("010",argv[1]) == 0){
    adicion(argv[2],argv[3],lengthA,lengthB);
  }
  //Pendiente
  if (strcmp("011",argv[1]) == 0){
    resta(argv[2],argv[3],lengthA,lengthB);
  }
  //Función de igualdad completa
  if (strcmp("100",argv[1]) == 0){
    igualdad(argv[2],argv[3]);
  }
  //No funciona para complemento a dos
  if (strcmp("101",argv[1]) == 0){
    menorQue(argv[2],argv[3]);
  }
  return 0;
}
