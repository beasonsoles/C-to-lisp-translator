/* Beatriz Sonsoles Encinas Muñoz
100451169@alumnos.uc3m.es */
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
int isParam (char *var) ;

char temp [2048] ;
char func_name [256] = ""; // para identificar variables locales por el nombre de la funcion
char* params [256] ;
int params_index = 0 ;


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
%token STRING        // identifica una cadena
%token MAIN          // identifica el comienzo del proc. main
%token DEFUN         // identifica la definición de una función
%token LOOP          // identifica la palabra 'loop' del bucle while
%token WHILE         // identifica la palabra 'while' del bucle while 
%token DO            // identifica las acciones a realizar dentro del bucle while
%token PRINT         // identifica la funcion prin1
%token PUTS          // identifica la funcion print
%token SETQ          // identifica la declaración de una variable
%token SETF          // identifica la asignación de una variable
%token VALUES        // identifica un conjunto de variables
%token MAKE          // identifica la palabra 'make' en la creación de un vector
%token ARRAY         // identifica la palabra 'array' en la creación de un vector
%token AREF          // identifica el acceso a un vector
%token IF            // identifica el if
%token PROGN         // identifica las ramas del if 
%token RETURN        // identifica el return
%token FROM          // identifica el from


%left OR                        // menor orden de precedencia
%left AND                       // mayor orden de precedencia que OR
%left EQUAL NOTEQUAL            // mayor orden de precedencia que AND
%left GREATEREQUAL SMALLEREQUAL '<' '>'  // mayor orden de precedencia que EQUAL y NOTEQUAL
%left '+' '-'                   // mayor orden de precedencia que GREATEREQUAL y SMALLEREQUAL
%left '*' '/' MOD               // mayor orden de precedencia que '+' y '-'
%left UNARY_SIGN NOT            // orden de precedencia más alto
                            // Seccion 3 Gramatica - Semantico
%%

axioma:         decl_def                                            { ; }
            ;
      
decl_def:       '(' r_decl_def ')'                                  { ; }
            |   '(' r_decl_def ')' decl_def                         { ; }
            ;

r_decl_def:     SETQ variable                                       { printf ("%s\n", $2.code) ; }
            |   DEFUN nombre_func '(' params ')' codigo             { printf (": %s\n%s ;\n", $2.code, $6.code) ;
                                                                      for (int i = 0; i < params_index; i++) { params[i] = NULL; }
                                                                      params_index = 0 ; }    
            |   MAIN                                                { printf ("%s\n", $1.code) ; }
            ;

nombre_func:    IDENTIF                                             { strcpy (func_name, $1.code) ; 
                                                                      sprintf (temp, "%s", $1.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   MAIN                                                { strcpy (func_name, $1.code) ; 
                                                                      sprintf (temp, "%s", $1.code) ; 
                                                                      $$.code = gen_code (temp) ; }

variable:       IDENTIF expresion                                   { sprintf (temp, "variable %s\n%s %s !", $1.code, $2.code, $1.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF '(' MAKE '-' ARRAY NUMBER ')'               { sprintf (temp, "variable %s %d cells allot", $1.code, $6.value) ; 
                                                                      $$.code = gen_code (temp) ; }
            ; 

params:         /* lambda */                                        { $$.code = gen_code ("") ; }
            |   r_params                                            { printf ("%s", $1.code) ; }
            ;

r_params:       IDENTIF                                             { sprintf (temp, "variable %s\n", $1.code) ; // AÑADIR %s ! PERO DENTRO DE LA FUNCION
                                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF r_params                                    { sprintf (temp, "variable %s\n%s", $1.code, $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;

/*params:         /* lambda                                         { ; }
            |   r_params                                            { ; }
            ;

r_params:       IDENTIF                                             { params[params_index] = $1.code ; 
                                                                      params_index++; }
            |   IDENTIF                                             { params[params_index] = $1.code ; 
                                                                      params_index++; 
                                                                      $$.code = gen_code ("") ; }
                    r_params                                        { ; }
            ;
*/

codigo:         '(' r_codigo ')'                                    { sprintf (temp, "%s", $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' r_codigo ')' codigo                             { sprintf (temp, "%s%s", $2.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;

r_codigo:       local_var                                           { printf ("%s\n", $1.code) ; 
                                                                      $$.code = gen_code("") ; }
            |   sentencia                                           { sprintf (temp, "%s\n", $1.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;

local_var:      SETQ variable                                       { sprintf (temp, "%s", $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   SETQ variable local_var                             { sprintf (temp, "%s\n%s", $2.code, $3.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;

sentencia:      llamada                                             { sprintf (temp, "%s", $1.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   SETF IDENTIF expresion                              { sprintf (temp, "%s %s !", $3.code, $2.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   SETF '(' AREF IDENTIF expresion ')' expresion       { sprintf (temp, "%s %s %s cells + !", $7.code, $4.code, $5.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   PUTS STRING                                         { sprintf (temp, ".\" %s\" cr", $2.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   PRINT STRING                                        { sprintf (temp, ".\" %s\"", $2.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   PRINT expresion                                     { sprintf (temp, "%s .", $2.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   LOOP WHILE expresion DO codigo                      { sprintf (temp, "begin \n%s\nwhile \n%srepeat", $3.code, $5.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   IF expresion '(' PROGN codigo ')' resto_if          { sprintf (temp, "%s if\n%s %sthen", $2.code, $5.code, $7.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            |   RETURN '-' FROM IDENTIF expresion                   { if (params_index > 0) {
                                                                            sprintf (temp, "drop\n%s exit", $5.code) ; 
                                                                      } else {
                                                                            sprintf (temp, "%s exit", $5.code) ; 
                                                                      }
                                                                      $$.code = gen_code (temp) ; }
            |   RETURN '-' FROM MAIN expresion                      { if (params_index > 0) {
                                                                            sprintf (temp, "drop\n%s exit", $5.code) ; 
                                                                      } else {
                                                                            sprintf (temp, "%s exit", $5.code) ; 
                                                                      } 
                                                                      $$.code = gen_code (temp) ; }
            ;  

llamada:        IDENTIF                                             { if (strcmp ($1.code, func_name) == 0) {
                                                                            sprintf (temp, "recurse") ;
                                                                      } else {
                                                                            sprintf (temp, "%s", $1.code) ;
                                                                      }
                                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF argumentos                                  { if (strcmp ($1.code, func_name) == 0) {
                                                                            sprintf (temp, "%s recurse", $2.code) ;
                                                                      } else {
                                                                            sprintf (temp, "%s %s", $2.code, $1.code) ;
                                                                      }
                                                                      $$.code = gen_code (temp) ; }
            ;

argumentos:     expresion                                           { sprintf (temp, "%s", $1.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   expresion argumentos                                { sprintf (temp, "%s %s", $1.code, $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;       

resto_if:       /* lambda */                                        { $$.code = gen_code ("") ; }
            |   '(' PROGN codigo ')'                                { sprintf (temp, "else \n%s", $3.code) ;
                                                                      $$.code = gen_code (temp) ; } 
            ;

expresion:      termino                                             { $$ = $1 ; }
            |   '(' '+' expresion expresion ')'                     { sprintf (temp, "%s %s +", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' '-' expresion expresion ')'                     { sprintf (temp, "%s %s -", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' '*' expresion expresion ')'                     { sprintf (temp, "%s %s *", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' '/' expresion expresion ')'                     { sprintf (temp, "%s %s /", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' MOD expresion expresion ')'                     { sprintf (temp, "%s %s mod", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' AND expresion expresion ')'                     { sprintf (temp, "%s %s and", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' OR expresion expresion ')'                      { sprintf (temp, "%s %s or", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' '=' expresion expresion ')'                     { sprintf (temp, "%s %s =", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' NOTEQUAL expresion expresion ')'                { sprintf (temp, "%s %s = 0=", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' '<' expresion expresion ')'                     { sprintf (temp, "%s %s <", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' '>' expresion expresion ')'                     { sprintf (temp, "%s %s >", $3.code, $4.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' GREATEREQUAL expresion expresion ')'            { sprintf (temp, "%s %s %s", $3.code, $4.code, $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '(' SMALLEREQUAL expresion expresion ')'            { sprintf (temp, "%s %s %s", $3.code, $4.code, $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;


termino:        operando                                            { $$ = $1 ; }                          
            |   '+' operando %prec UNARY_SIGN                       { sprintf (temp, "%s", $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            |   '-' operando %prec UNARY_SIGN                       { sprintf (temp, "%s negate", $2.code) ;
                                                                      $$.code = gen_code (temp) ; }  
            |   '(' NOT expresion ')'                               { sprintf (temp, "%s 0=", $3.code) ;
                                                                      $$.code = gen_code (temp) ; } 
            |   '(' AREF IDENTIF expresion ')'                      { sprintf (temp, "%s %s cells + @", $3.code, $4.code) ; 
                                                                      $$.code = gen_code (temp) ; }   
            |   '(' llamada ')'                                     { sprintf (temp, "%s", $2.code) ;
                                                                      $$.code = gen_code (temp) ; }
            ;

operando:       IDENTIF                                             { if (isParam($1.code) == 1) {
                                                                            if (params_index > 1) {
                                                                                sprintf (temp, "over") ;
                                                                            } else {
                                                                                sprintf (temp, "dup") ;
                                                                            }
                                                                      } else {
                                                                            sprintf (temp, "%s @", $1.code) ;
                                                                      }
                                                                      $$.code = gen_code (temp) ; }
            |   NUMBER                                              { sprintf (temp, "%d", $1.value) ;
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

int isParam (char *var) 
{
    for (int i = 0; i < params_index; i++) {
        if (strcmp(var, params[i]) == 0) {
            return 1;
        }
    }
    return 0;
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
    "defun",       DEFUN,
    "loop",        LOOP,
    "while",       WHILE,
    "do",          DO,
    "if",          IF,
    "progn",       PROGN,
    //"return",      RETURN,
    //"from",        FROM,
    "setq",        SETQ,
    "setf",        SETF,
    //"make",        MAKE,
    //"array",       ARRAY,
    "aref",        AREF,
    "prin1",       PRINT,
    "print",       PUTS,
    "values",      VALUES,
    "and",  	   AND,
    "or",  	       OR,
    "not",         NOT,
    "/=",  	       NOTEQUAL,
    "<=",  	       SMALLEREQUAL,
    ">=",  	       GREATEREQUAL,
    "mod",         MOD,
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
    int j ;
    unsigned char c ;
    unsigned char cc ;
    char ops_expandibles [] = "!<=>|%/&+-*" ;
    char temp_str [256] ;
    char str_main [256] ;
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
            (c >= '0' && c <= '9') || c == '_' ) && i < 255) {
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
