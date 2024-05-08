// Funciones con dos parametros
#include <stdio.h>

multiplo_o_divisor (int a, int b) {
    printf ("%d", a);
    if (a % b == 0) {
        puts(" es multiplo de");
    } else {
        puts("no es multiplo de");
    }
    printf ("%d", b);
    puts("");
    printf ("%d", a);
    if (b % a == 0) {
        puts(" es divisor de");
    } else {
        puts(" no es divisor de");
    }
    printf ("%d", b);
}

main() {
    int a, b;
    puts("Test 1");
    a = 4;
    b = 2;
    printf("%s%d%s%d", "a=",a,", b=",b);
    puts("");
    multiplo_o_divisor(a, b);
    puts("Test 2");
    a = 5;
    b = 17;
    printf("%s%d%s%d", "a=",a,", b=",b);
    puts("");
    multiplo_o_divisor(a, b);
}
//@ (main)
