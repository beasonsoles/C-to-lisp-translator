// Loops for con condiciones complejas
#include <stdio.h>

main () {
	int a = 3, b = 6, i;

    for ( i = 0 ; i <= a && i * i <= a ; i = i + 1 ) {
        printf("%s %d %s\n", "el loop es ejecutado", i, "veces");
        puts("");
		b=b-2;
	}
	puts("El resultado es:");
	printf("%d",b);
}
//@(main)
