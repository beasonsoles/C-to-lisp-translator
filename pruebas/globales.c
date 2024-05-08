// Una variable global sin inicializar, otra inicializada, ambas modificadas en una funcion
#include <stdio.h>

int a;
int b = 3;

cuadrado () {
    a = a * a;
    b = b * b;
}

main () {
    a = 5;
    printf("%s %d %s %d", "a: ", a, ", b: ", b);
    puts("");
    cuadrado();
    printf("%s %d %s %d", "El cuadrado de a es: ", a, ", el cuadrado de b es: ", b);
}
//@(main)
