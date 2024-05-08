// If sin else
#include <stdio.h>

int num, n_divisors ;

divisores () {
    int i; 

    printf("%s %d %s","divisores de ", num, ": ");
    for (i = 1; i <= num; i = i + 1) {
        if (num % i == 0) {
            printf("%d %s", i, ", ");
            puts("");
            n_divisors = n_divisors + 1 ;
        }
    }
}
main () {
	num = 60;
	divisores();
	printf("%s %d", "numero de divisores: ", n_divisors);
}
//@(main)
