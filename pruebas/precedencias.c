// Verificar el funcionamiento de las precedencias (signos unarios también)
#include <stdio.h>

main () {
    int a = 2, b = 5, c = 4, d = 1;
    int resultado; 
    puts("*, / y /%/ tienen mayor precedencia que + y -");
    resultado = d + b * c / a % 2;
    puts("");
    printf("%s %d", "Resultado:", resultado);
    puts("! tiene la precedencia mas alta...");
    puts("... <, >, <= y >= tienen mayor precedencia que == y !=");
    puts("or y and tienen menor precedencia que los demas");    
    if (resultado != 0 && c >= d || !b == 0) {
        puts("La condicion se cumple");
    }
    puts("Los signos unarios  y ! tienen mayor precedencia que el resto de los operadores");
    resultado = b * -2;
    puts("");
    printf("%s %d", "Resultado:", resultado);
}
//@ (main)
