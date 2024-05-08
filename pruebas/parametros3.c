// Funciones con mas de dos parametros
#include <stdio.h>

maximo (int a, int b, int c) {
    int mayor ;
    mayor = a;
    if (b > mayor) {
        mayor = b;
    }
    if (c > mayor) {
        mayor = c;
    }
    printf("%d\n", mayor);
    puts("es el numero mayor");
}

main()
{
    int a = 10, b = 3, c = 6;
    
    maximo (a, b, c);
}
//@(main)
