// Ifs anidados
#include <stdio.h>

main() {
    int x = 3, y = -2, r;

    if (x >= 0) {
        if (y >= 0) {
            puts("El resultado de la multiplicacion es positivo: ");
        } else {
            puts("El resultado de la multiplicacion es negativo: ");
        }  
    } else {
        if (y >= 0) {
            puts("El resultado de la multiplicacion es negativo: ");
        } else {
            puts("El resultado de la multiplicacion es positivo: ");
        }
    }
    r = x * y ;
    printf("%d", r);
}
//@(main)
