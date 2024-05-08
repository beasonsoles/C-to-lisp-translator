// Retorno con vectores asignado a una variable e impreso
#include <stdio.h>

retorno () {
    int v[3];
    v[2] = 7;
    return v[2];
}

main () {
    int num ;
    num = retorno();
    printf("%d", num);
    puts("Debería salir el mismo resultado que antes");
    printf("%d", retorno());
}
//@ (main)
