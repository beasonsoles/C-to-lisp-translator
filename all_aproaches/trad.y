/* Beatriz Sonsoles Encinas Muñoz, Marina Buitrago Pérez, 63-buitrago-encinas
100451169@alumnos.uc3m.es 100428967@alumnos.uc3m.es */
%{                          // SECCION 1 Declaraciones de C-Yacc

#include <stdio.h>
#include <ctype.h>            // declaraciones para tolower
#include <string.h>           // declaraciones para cadenas
#include <stdlib.h>           // declaraciones para exit ()

#define FF fflush(stdout);    // para forzar la impresion inmediata

int yylex () ;
int yyerror () ;
char *mi_malloc (int) ;
char *gen_code (char *) ;
char *int_to_string (int) ;
char *char_to_string (char) ;

char temp [2048] ;
char func_name [256] ; // para identificar variables locales por el nombre de la funcion

// Definitions for explicit attributes

typedef struct s_attr {
        int value ;
        char *code ;
} t_attr ;

#define YYSTYPE t_attr

%}

// Definitions for explicit attributes

%token NUMBER        
%token IDENTIF       // Identificador=variable
%token INTEGER       // identifica el tipo entero
%token STRING        // identifica una cadena
%token MAIN          // identifica el comienzo del proc. main
%token WHILE         // identifica el bucle while
%token PRINTF        // identifica la funcion printf 
%token PUTS          // identifica la funcion puts
%token FOR           // identifica el bucle for
%token IF            // identifica el if
%token ELSE          // identifica el else 
%token RETURN        // identifica el return



%right '='                      // es la ultima operacion que se debe realizar
%left OR                        // menor orden de precedencia
%left AND                       // mayor orden de precedencia que OR
%left EQUAL NOTEQUAL            // mayor orden de precedencia que AND
%left GREATEREQUAL SMALLEREQUAL '<' '>'  // mayor orden de precedencia que EQUAL y NOTEQUAL
%left '+' '-'                   // mayor orden de precedencia que GREATEREQUAL y SMALLEREQUAL
%left '*' '/' '%'               // mayor orden de precedencia que '+' y '-'
%left UNARY_SIGN                // orden de precedencia más alto

%%                            // Seccion 3 Gramatica - Semantico

axioma:         decl_var_def_func           { ; }
            ;

decl_var_def_func:      decl_var                { printf ("%s\n", $1.code) ; }
                        funciones               { ; }
                    |   funciones               { ; }
                    ;

decl_var:           INTEGER definicion ';'          { sprintf (temp, "%s", $2.code) ;  
                                                      $$.code = gen_code (temp) ; }
            |   INTEGER definicion ';' decl_var     { sprintf (temp, "%s\n%s", $2.code, $4.code) ;  
                                                        $$.code = gen_code (temp) ; }
            ;

funciones:      r_func                              { printf ("%s\n", $1.code) ; }
                funciones                           { ; }
            |   main_func '(' ')' '{' codigo '}'    { printf ("(defun main ()\n\t%s\n)\n", $5.code) ; }                                             
            ;

main_func:      MAIN                                            { strcpy(func_name, $1.code) ; }  
            ;

r_func:         nombre_func '(' ')' '{' codigo '}'              { sprintf (temp, "(defun %s ()\n%s\n)", $1.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   nombre_func '(' params ')' '{' codigo '}'       { sprintf (temp, "(defun %s (%s)\n%s\n)", $1.code, $3.code, $6.code) ;
                                                                  $$.code = gen_code (temp); }   
            ;

nombre_func:    IDENTIF                                         { strcpy(func_name, $1.code) ; }
            ;                                   

params:         INTEGER IDENTIF                                 { sprintf (temp, "%s", $2.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   INTEGER IDENTIF ',' params                      { sprintf (temp, "%s %s", $2.code, $4.code) ;
                                                                  $$.code = gen_code (temp) ; }                                                   
            ;

codigo:         lineas                                          { sprintf (temp, "%s", $1.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   codigo lineas                                   { sprintf (temp, "%s\n%s", $1.code, $2.code) ;
                                                                  $$.code = gen_code (temp) ; }
            ;

lineas:         sentencia ';'                                                           { sprintf (temp, "\t%s", $1.code) ; 
                                                                                          $$.code = gen_code (temp) ; }
            |   llamada ';'                                                             { sprintf (temp, "\t%s", $1.code) ; 
                                                                                          $$.code = gen_code (temp) ; }  
            |   WHILE '(' expresion ')' '{' codigo_loop '}'                             { sprintf (temp, "\t(loop while %s do\n%s\n\t)", $3.code, $6.code) ;
                                                                                          $$.code = gen_code (temp) ; }
            |   IF '(' expresion ')' '{' codigo_if '}' resto_if                         { sprintf (temp, "\t(if %s)\n\t(progn\n%s)\n%s", $3.code, $6.code, $8.code) ; 
                                                                                          $$.code = gen_code (temp) ; } 
            |   FOR '(' definicion ';' expresion ';' inc_dec ')' '{' codigo_loop '}'    { sprintf (temp, "\t%s\n\t(loop while %s do\n%s\n\t\t%s\n\t)", $3.code, $5.code, $10.code, $7.code) ; 
                                                                                          $$.code = gen_code (temp) ; } 
            |   INTEGER IDENTIF '=' expresion ';'                                       { sprintf (temp, "(setq %s-%s %s)", func_name, $2.code, $4.code) ; 
                                                                                          $$.code = gen_code (temp) ; }
            |   RETURN retorno ';'                                                      { sprintf (temp, "\t(return %s)", $2.code) ; 
                                                                                          $$.code = gen_code (temp) ; }
            ;

codigo_loop:   sentencia ';' codigo_loop                            { sprintf (temp, "\t\t%s\n%s", $1.code, $3.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   sentencia ';'                                       { sprintf (temp, "\t\t%s", $1.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   llamada ';' codigo_loop                             { sprintf (temp, "\t\t%s\n%s", $1.code, $3.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   llamada ';'                                         { sprintf (temp, "\t\t%s", $1.code) ; 
                                                                      $$.code = gen_code (temp) ; }  
            ;

llamada:        IDENTIF '(' ')'                 { sprintf (temp, "(%s)", $1.code) ;
                                                  $$.code = gen_code (temp) ; }
            |   IDENTIF '(' params_l ')'        { sprintf (temp, "(%s %s)", $1.code, $3.code) ;
                                                  $$.code = gen_code (temp) ; }
            ;

params_l:       IDENTIF                         { sprintf (temp, "%s", $1.code) ;
                                                  $$.code = gen_code (temp) ; }
            |   IDENTIF ',' params_l            { sprintf (temp, "%s %s", $1.code, $3.code) ;
                                                  $$.code = gen_code (temp) ; }                                                   
            ;

codigo_if:      sentencia ';' codigo_if                             { sprintf (temp, "\t\t%s\n%s", $1.code, $3.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   sentencia ';'                                       { sprintf (temp, "\t\t%s", $1.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   llamada ';' codigo_if                               { sprintf (temp, "\t\t%s\n%s", $1.code, $3.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   llamada ';'                                         { sprintf (temp, "\t\t%s", $1.code) ; 
                                                                      $$.code = gen_code (temp) ; }  
            ;

resto_if:   
            |   ELSE '{' codigo_if '}'          { sprintf (temp, "\t(progn\n%s)", $3.code) ;
                                                  $$.code = gen_code (temp) ; } 
            ;

inc_dec:        IDENTIF '=' IDENTIF '+' expresion               { sprintf (temp, "(setq %s-%s (+ %s-%s %s))", func_name, $1.code, func_name, $3.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   IDENTIF '=' IDENTIF '-' expresion               { sprintf (temp, "(setq %s-%s (- %s-%s %s))", func_name, $1.code, func_name, $3.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   IDENTIF '=' IDENTIF '*' expresion               { sprintf (temp, "(setq %s-%s (* %s-%s %s))", func_name, $1.code, func_name, $3.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   IDENTIF '=' IDENTIF '/' expresion               { sprintf (temp, "(setq %s-%s (/ %s-%s %s))", func_name, $1.code, func_name, $3.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            ;

retorno:                                        { sprintf (temp, "No se que debe retornear") ;
                                                  $$.code = gen_code (temp) ; }
            |   expresion                       { sprintf (temp, "%s", $1.code) ;
                                                  $$.code = gen_code (temp) ; }
            |   expresion ',' retorno           { sprintf (temp, "(values %s %s)", $1.code, $3.code) ;
                                                  $$.code = gen_code (temp) ; }
            ;

sentencia:      IDENTIF '=' expresion           { sprintf (temp, "(setf %s-%s %s)", func_name, $1.code, $3.code) ; 
                                                  $$.code = gen_code (temp) ; }
            |   PRINTF expresion                { sprintf (temp, "%s", $2.code) ;  
                                                  $$.code = gen_code (temp) ; }
            |   PUTS '(' STRING ')'             { sprintf (temp, "(print \"%s\")", $3.code) ; 
                                                  $$.code = gen_code (temp) ; }
            ;

expresion:      termino                             { $$ = $1 ; }
            |   expresion '+' expresion             { sprintf (temp, "(+ %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion '-' expresion             { sprintf (temp, "(- %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion '*' expresion             { sprintf (temp, "(* %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion '/' expresion             { sprintf (temp, "(/ %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion '%' expresion             { sprintf (temp, "(mod %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion AND expresion             { sprintf (temp, "(and %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion OR expresion              { sprintf (temp, "(or %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion EQUAL expresion           { sprintf (temp, "(= %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion NOTEQUAL expresion        { sprintf (temp, "(/= %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion '<' expresion             { sprintf (temp, "(< %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion '>' expresion             { sprintf (temp, "(> %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion GREATEREQUAL expresion    { sprintf (temp, "(%s %s %s)", $2.code, $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   expresion SMALLEREQUAL expresion    { sprintf (temp, "(%s %s %s)", $2.code, $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            ;


termino:        operando                            { $$ = $1 ; }                          
            |   '+' operando %prec UNARY_SIGN       { sprintf (temp, "(+ %s)", $2.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   '-' operando %prec UNARY_SIGN       { sprintf (temp, "(- %s)", $2.code) ;
                                                      $$.code = gen_code (temp) ; }    
            ;

operando:       IDENTIF                  { sprintf (temp, "%s-%s", func_name, $1.code) ;
                                           $$.code = gen_code (temp) ; }
            |   NUMBER                   { sprintf (temp, "%d", $1.value) ;
                                           $$.code = gen_code (temp) ; }
            |   '(' print ')'            { $$ = $2 ; }
            ;

print:          expresion                { sprintf (temp, "(prin1 %s)", $1.code) ;  
                                           $$.code = gen_code (temp) ; }
            |   expresion ',' print      { sprintf (temp, "(prin1 %s) %s", $1.code, $3.code) ;  
                                           $$.code = gen_code (temp) ; }
            |   STRING ',' expresion     { sprintf (temp, "(prin1 %s)", $3.code); 
                                           $$.code = gen_code (temp) ; }
            ;

definicion:     IDENTIF                                 { sprintf (temp, "(setq %s 0)", $1.code) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF '=' expresion                   { sprintf (temp, "(setq %s %d)", $1.code, $3.value) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF '=' expresion ',' definicion    { sprintf (temp, "(setq %s %d) %s", $1.code, $3.value, $5.code) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF ',' definicion                  { sprintf (temp, "(setq %s 0) %s", $1.code, $3.code) ;
                                                          $$.code = gen_code (temp) ; }
            ;

%%                            // SECCION 4    Codigo en C

int n_line = 1 ;

int yyerror (mensaje)
char *mensaje ;
{
    fprintf (stderr, "%s en la linea %d\n", mensaje, n_line) ;
    printf ( "\n") ;	// bye
}

char *int_to_string (int n)
{
    sprintf (temp, "%d", n) ;
    return gen_code (temp) ;
}

char *char_to_string (char c)
{
    sprintf (temp, "%c", c) ;
    return gen_code (temp) ;
}

char *my_malloc (int nbytes)       // reserva n bytes de memoria dinamica
{
    char *p ;
    static long int nb = 0;        // sirven para contabilizar la memoria
    static int nv = 0 ;            // solicitada en total

    p = malloc (nbytes) ;
    if (p == NULL) {
        fprintf (stderr, "No queda memoria para %d bytes mas\n", nbytes) ;
        fprintf (stderr, "Reservados %ld bytes en %d llamadas\n", nb, nv) ;
        exit (0) ;
    }
    nb += (long) nbytes ;
    nv++ ;

    return p ;
}


/***************************************************************************/
/********************** Seccion de Palabras Reservadas *********************/
/***************************************************************************/

typedef struct s_keyword { // para las palabras reservadas de C
    char *name ;
    int token ;
} t_keyword ;

t_keyword keywords [] = { // define las palabras reservadas y los
    "main",        MAIN,           // y los token asociados
    "while",       WHILE,
    "for",         FOR,
    "if",          IF,
    "else",        ELSE,
    "return",      RETURN,
    "int",         INTEGER,
    "printf",      PRINTF,
    "puts",        PUTS,
    "&&",  	       AND,
    "||",  	       OR,
    "!=",  	       NOTEQUAL,
    "==",  	       EQUAL,
    "<=",  	       SMALLEREQUAL,
    ">=",  	       GREATEREQUAL,
    NULL,          0               // para marcar el fin de la tabla
} ;

t_keyword *search_keyword (char *symbol_name)
{                                  // Busca n_s en la tabla de pal. res.
                                   // y devuelve puntero a registro (simbolo)
    int i ;
    t_keyword *sim ;

    i = 0 ;
    sim = keywords ;
    while (sim [i].name != NULL) {
	    if (strcmp (sim [i].name, symbol_name) == 0) {
		                             // strcmp(a, b) devuelve == 0 si a==b
            return &(sim [i]) ;
        }
        i++ ;
    }

    return NULL ;
}

 
/***************************************************************************/
/******************* Seccion del Analizador Lexicografico ******************/
/***************************************************************************/

char *gen_code (char *name)     // copia el argumento a un
{                                      // string en memoria dinamica
    char *p ;
    int l ;
	
    l = strlen (name)+1 ;
    p = (char *) my_malloc (l) ;
    strcpy (p, name) ;
	
    return p ;
}


int yylex ()
{
    int i ;
    unsigned char c ;
    unsigned char cc ;
    char ops_expandibles [] = "!<=>|%/&+-*" ;
    char temp_str [256] ;
    t_keyword *symbol ;

    do {
        c = getchar () ;

        if (c == '#') {	// Ignora las lineas que empiezan por #  (#define, #include)
            do {		//	OJO que puede funcionar mal si una linea contiene #
                c = getchar () ;
            } while (c != '\n') ;
        }

        if (c == '/') {	// Si la linea contiene un / puede ser inicio de comentario
            cc = getchar () ;
            if (cc != '/') {   // Si el siguiente char es /  es un comentario, pero...
                ungetc (cc, stdin) ;
            } else {
                c = getchar () ;	// ...
                if (c == '@') {	// Si es la secuencia //@  ==> transcribimos la linea
                    do {		// Se trata de codigo inline (Codigo embebido en C)
                        c = getchar () ;
                        putchar (c) ;
                    } while (c != '\n') ;
                } else {		// ==> comentario, ignorar la linea
                    while (c != '\n') {
                        c = getchar () ;
                    }
                }
            }
        } else if (c == '\\') c = getchar () ;
		
        if (c == '\n')
            n_line++ ;

    } while (c == ' ' || c == '\n' || c == 10 || c == 13 || c == '\t') ;

    if (c == '\"') {
        i = 0 ;
        do {
            c = getchar () ;
            temp_str [i++] = c ;
        } while (c != '\"' && i < 255) ;
        if (i == 256) {
            printf ("AVISO: string con mas de 255 caracteres en linea %d\n", n_line) ;
        }		 	// habria que leer hasta el siguiente " , pero, y si falta?
        temp_str [--i] = '\0' ;
        yylval.code = gen_code (temp_str) ;
        return (STRING) ;
    }

    if (c == '.' || (c >= '0' && c <= '9')) {
        ungetc (c, stdin) ;
        scanf ("%d", &yylval.value) ;
//         printf ("\nDEV: NUMBER %d\n", yylval.value) ;        // PARA DEPURAR
        return NUMBER ;
    }

    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
        i = 0 ;
        while (((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
            (c >= '0' && c <= '9') || c == '_') && i < 255) {
            temp_str [i++] = tolower (c) ;
            c = getchar () ;
        }
        temp_str [i] = '\0' ;
        ungetc (c, stdin) ;

        yylval.code = gen_code (temp_str) ;
        symbol = search_keyword (yylval.code) ;
        if (symbol == NULL) {    // no es palabra reservada -> identificador antes vrariabre
//               printf ("\nDEV: IDENTIF %s\n", yylval.code) ;    // PARA DEPURAR
            return (IDENTIF) ;
        } else {
//               printf ("\nDEV: OTRO %s\n", yylval.code) ;       // PARA DEPURAR
            return (symbol->token) ;
        }
    }

    if (strchr (ops_expandibles, c) != NULL) { // busca c en ops_expandibles
        cc = getchar () ;
        sprintf (temp_str, "%c%c", (char) c, (char) cc) ;
        symbol = search_keyword (temp_str) ;
        if (symbol == NULL) {
            ungetc (cc, stdin) ;
            yylval.code = NULL ;
            return (c) ;
        } else {
            yylval.code = gen_code (temp_str) ; // aunque no se use
            return (symbol->token) ;
        }
    }

//    printf ("\nDEV: LITERAL %d #%c#\n", (int) c, c) ;      // PARA DEPURAR
    if (c == EOF || c == 255 || c == 26) {
//         printf ("tEOF ") ;                                // PARA DEPURAR
        return (0) ;
    }

    return c ;
}


int main ()
{
    yyparse () ;
}
