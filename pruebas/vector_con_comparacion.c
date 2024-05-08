// Uso de un vector en una comparacion de una estructura de control
#include <stdio.h>

int lista[5];

esta_en_vector (int n) {
    int encontrado;
    encontrado = 0;
    int i;

    for (i = 0; i < 5; i = i + 1) {
        if (n == lista[i]) {
            encontrado = 1;
        } 
    }
    if (encontrado == 1) {
        puts("El numero esta en el vector");
    } else {
        puts("El numero no esta en el vector");
    }
}

main () {
    int i, n;
    for (i = 0; i < 5; i = i + 1) {
        lista[i] = i*2;
    }
    n = 4;
    printf("%s %d", "Test 1 --> n=", n);
    puts("");
    esta_en_vector(n);
    n = 7;
    puts("");
    printf("%s %d", "Test 2 --> n=", n);
    puts("");
    esta_en_vector(n);
}
//@ (main)
