// Creacion de un vector como variable global y modificacion en una funcion
#include <stdio.h>

int lista[10]; 
main () {
    int a = 3, b = 5;
	lista[0] = a+b ;
	lista[3] = 50 ;
	puts("El primer elemento del vector es: ") ;
	printf ("%d", lista[0]) ;
	puts("El tercer elemento del vector es: ") ;
	printf ("%d", lista[3]) ;
}
//@(main)
