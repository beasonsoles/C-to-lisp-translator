// Funciones con un solo parametro
#include <stdio.h>

int r;

multiplica_por_2 (int n) {
    r = n * 2;
    printf("%d", r);
}

main() {
    int n = 58;

    puts("El resultado es: ");
    multiplica_por_2(n);
}
//@ (main)
