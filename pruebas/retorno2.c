// Retorno al final y entre medias del codigo de una funcion
#include <stdio.h>

retorno (int n) {
    if (n == 0) {
        return 0;
    }
    if (n == 1) {
        return 1;
    }
    return 2;
}

main () {
    int num; 
    num = 0;
    printf("%s %d %s", "Test 1 --> Numero: ", num, " ");
    printf("%d", retorno(num));
    puts("");
    num = 1;
    printf("%s %d %s", "Test 2 --> Numero: ", num, " ");
    printf("%d", retorno(num));    
    puts("");
    num = 3;
    printf("%s %d %s", "Test 3 --> Numero: ", num, " ");
    printf("%d", retorno(num));
}
//@ (main)
