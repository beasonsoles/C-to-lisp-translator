// Varios loops for anidados
#include <stdio.h>

main () {
    int i, j;

    for (i = 1; i <= 10; i = i + 1) {
        for (j = 1; j <= 10; j = j + 1) {
            printf("%d %s", i * j, ", ");
        }
        puts("");
    }
}
//@(main)
