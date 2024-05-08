// Varias variables globales y locales con definicion multiple (asignaciones opcionales y no opcionales)
#include <stdio.h>

int a = 3, b = 7, c;

main()
{
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
