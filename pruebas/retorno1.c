// Retorno de una expresion y una variable en una funcion
#include <stdio.h>

suma (int a, int b) {
	return a + b ;
}
resta (int a, int b) {
    int resta ;
    resta = a - b ;
	return resta ;
}
main () {
	int a = 4, b = 8;
    int plus, minus;
	plus = suma (a, b) ;
    minus = resta(a, b) ;
    printf("%s %d","El resultado de la suma es: ", plus);
    puts("");
    printf("%s %d","El resultado de la resta es: ", minus);
}
//@(main)
