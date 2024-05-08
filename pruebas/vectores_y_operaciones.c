// Uso vectores locales y globales como operandos de una operacion matematica
#include <stdio.h>

int vect[20];

main()
{
    int i = 2, j = 3, sum[6];
    int x;
    for (x = 0; x < i + j; x = x + 1) {
        vect[x] = x;
        sum[x] = vect[x] + vect[0];
        printf("%d", sum[x]);
    }
}
//@ (main)
