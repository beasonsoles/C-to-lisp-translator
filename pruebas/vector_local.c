// Declaracion de un vector como variable local y asignacion de una expresion
#include <stdio.h>

vectores () {
    int mivector[32];
    int n ;
    mivector [0] = 123 ;
	printf ("%s %d", "el primer elemento del vector es: ", mivector[0]) ;
    puts("");
    n = 5 ;
    printf("%s %d %s","asignando un valor al elemento numero ", n, "del vector...");
    puts("");
	mivector [n] = 56 ;
	printf ("%s %d %s %d", "el elemento numero ", n, "del vector es: ", mivector[n]) ;
}
main () {
	vectores();
}
//@ (main)
