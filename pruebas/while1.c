// Loop while con condiciones simples y complejas
#include <stdio.h>

main () {
    int a = 3;
    int x = a * 10;
    int y = 0, i = 0, j = 0;
    printf("%s%d", "x=", x);
    printf("%s%d", ", y=", y);
    printf("%s%d%s%d", ", i=", i, ", j=", j);
    puts("");

    while (i < 10) {
        x = x - 1;
        y = y + 1;
        i = i + 1;
    }
    while ((i < 5 && j < 10) || (i < 20 && j < 5)) {
        i = i + 1;
        j = j + 2;
    }
    printf("%s%d", "x=", x);
    printf("%s%d", ", y=", y);
    printf("%s%d%s%d", ", i=", i, ", j=", j);
}

//@ (main)
