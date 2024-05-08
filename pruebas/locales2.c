// Asignacion de una expresion a una variable local
#include <stdio.h>

main()
{
    int a = 5, b = 10, c = 15;
    int resultado;

    resultado = (a * b) - (b + (c % 2)) * (a + b) ;
    
    puts("El resultado es: ");
    printf("%d\n", resultado);
    puts("Y las variables valen: ");
    printf("%s%d%s%d%s%d", " a=", a, " b=", b, " c=", c);
}
//@(main)
