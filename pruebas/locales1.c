// Declaracion multiple y simple de variables locales inicializadas y sin inicializar. Sin variables globales
#include <stdio.h>

main()
{
    int a = 3, b = 7;
    int c;
    int d = 1, mayor, e = 4;
    mayor = a; 
    if (b > mayor) {
        mayor = b;
    }
    if (c > mayor) {
        mayor = c;
    }
    if (d > mayor) {
        mayor = d;
    }
    if (e > mayor) {
        mayor = e;
    }
    printf("%d\n", mayor);
    puts("es el numero mayor");
}
//@(main)
