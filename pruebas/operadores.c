// Operadores logicos y de comparacion
#include <stdio.h>

int a = 1;
int b = 2;
int c; 
int d;
int e;
int r;
main () {
    c = (a * b) / (3 % 2) ;
    d = (a + d) * (a + b) + (a % b) * (a - b) ;
    printf("%s%d%s%d","c=",c,", d=",d);
    puts("");

    if (b % c == 0) {
        r = 1;
    } 
    printf("%s%d","r=",r);
    printf("%s%d",", not r=", !r);
    puts("");

    if (a % c != 0) {
        r = 2;
    }
    printf("%d",r);
    puts("");
    
    if ((a >= b && b <= c) || (c < d + 1)) {
        puts("Se cumple la condicion");
    }
    printf("%s%d", "3 positivo menos 4 negativo es: ", +3 - -4);
}
//@ (main)
