// Definicion de una sola funcion ademas del main
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

main () {
    media_piramide();
}
//@ (main)
