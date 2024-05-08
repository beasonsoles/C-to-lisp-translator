// If con else (con parentesis en las comparaciones)
#include <stdio.h>

int year ;

is_leap_year() {
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        printf("%d %s", year, "is a leap year");
    } 
    else {
        printf("%d %s", year, "is not a leap year");
    }
}

main() {
    year = 2012 ;
    is_leap_year();
}
//@(main)
