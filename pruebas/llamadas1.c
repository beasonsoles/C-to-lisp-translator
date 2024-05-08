// Llamada a una funcion con retorno y asignacion de ese retorno a una variable
#include <stdio.h>

int n1 = 13, n2 = 8, compuesto;

es_compuesto ( int n ) {
    int i ;
    int booleano = 0;
	if (n <= 1) {
        booleano = 0;
    } else {
        for (i = 2; n >= i * i; i = i + 1) {
            if (n % i == 0) {
                booleano = 1;
            }
        }
    }
    return booleano;
}

main () {
	compuesto = es_compuesto(n1);
    if (compuesto == 1) {
        printf("%d %s", n1, "es un numero compuesto");
    } else {
        printf("%d %s", n1, "no es un numero compuesto");
    }
    puts("");
	compuesto = es_compuesto(n2);
    if (compuesto == 1) {
        printf("%d %s", n2, "es un numero compuesto");
    } else {
        printf("%d %s", n2, "no es un numero compuesto");
    }
    puts("");
}
//@ (main)
