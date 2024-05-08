// Loops while anidados
#include <stdio.h>

main () {
    int x = 0, y = 0, i = 0, j = 0;

    while (i < 10) {
        x = x - 1;
        y = y + 1;
        while (j < 10) {
            x = x - 1;
            y = y - 1;
            if (x < y) {
                printf("%d", x + y);
                puts("");
            } else {
                printf("%d", x - y);
                puts("");
            }
            j = j + 1;
        }
        i = i + 1;
    }
}

//@ (main)
