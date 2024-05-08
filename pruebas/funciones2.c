// Definicion de multiples funciones ademas del main
#include <stdio.h>

int rows = 7;

media_piramide () {
    int i, j;
    
    for ( i = 1; i <= rows; i = i + 1) {
        for (j = 1; j <= i; j = j + 1) {
            printf("%d%s", i, " ");
        }
        puts("");
    }
}

media_piramide_invertida () {
    int i, j;
    
    for ( i = 7; i >= 1; i = i - 1) {
        for (j = 1; j <= i; j = j + 1) {
            printf("%d%s", i, " ");
        }
        puts("");
    }
}

main () {
    media_piramide();
    media_piramide_invertida();
}
//@ (main)
