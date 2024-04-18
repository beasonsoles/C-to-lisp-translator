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
void formatoLisp (char *) ;

char temp [2048] ;
char func_name [64] = ""; // para identificar variables locales por el nombre de la funcion
char* local_vars[256] ; // lista para guardar las variables declaradas localmente
int local_vars_index ; // indice usado para guardar las variables en la lista (incrementa por cada variable encontrada)

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
%left UNARY_SIGN NOT            // orden de precedencia más alto

%%                            // Seccion 3 Gramatica - Semantico

axioma:     decl_var_def_func                   { ; }
            ;

decl_var_def_func:      decl_var                { formatoLisp ($1.code) ; }
                        def_func                { ; }
                    |   def_func                { ; }
                    ;

decl_var:       INTEGER var_global ';'              { sprintf (temp, "%s\n", $2.code) ;  
                                                      $$.code = gen_code (temp) ; }
            |   INTEGER var_global ';' decl_var     { sprintf (temp, "%s\n%s", $2.code, $4.code) ;  
                                                      $$.code = gen_code (temp) ; }
            ;

var_global:     r_var_global                        { sprintf (temp, "%s", $1.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   r_var_global ',' var_global          { sprintf (temp, "%s\n%s", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            ;

r_var_global:   IDENTIF                             { sprintf (temp, "(setq %s 0)", $1.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF '=' NUMBER                  { sprintf (temp, "(setq %s %d)", $1.code, $3.value) ;
                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF '[' NUMBER ']'              { sprintf (temp, "(setq %s (make-array %d))", $1.code, $3.value) ;
                                                      $$.code = gen_code (temp) ; }
            ;

def_func:       funciones main_func                 { formatoLisp (strcat($1.code, $2.code)) ; }
            |   main_func                           { formatoLisp ($1.code) ; }
            ;

main_func:      main '(' params ')' '{' codigo '}'    { sprintf (temp, "(defun %s (%s)\n%s\n)\n", $1.code, $3.code, $6.code) ; 
                                                                      $$.code = gen_code (temp) ; }
            ;

main:           MAIN                                { strcpy (func_name, $1.code) ; 
                                                      sprintf (temp, "%s", $1.code) ; 
                                                      $$.code = gen_code (temp) ; }
            ;

funciones:      funcion r_func                      { sprintf (temp, "%s\n%s", $1.code, $2.code) ;
                                                      $$.code = gen_code (temp) ; }
            ;

r_func:         /* lambda */                        { $$.code = gen_code (""); }
            |   funciones                           { ; }
            ;

funcion:        nombre_func '(' params ')' '{' codigo '}'   { sprintf (temp, "(defun %s (%s)\n%s\n)", $1.code, $3.code, $6.code) ;
                                                              $$.code = gen_code (temp); }                                          
            ;

nombre_func:    IDENTIF                             { strcpy (func_name, $1.code) ; 
                                                      sprintf (temp, "%s", $1.code) ; 
                                                      $$.code = gen_code (temp) ; }                        
            ;                                   

params:         /* lambda */                        { $$.code = gen_code("") ; }
            |   INTEGER IDENTIF                     { sprintf (temp, "%s", $2.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   INTEGER IDENTIF ',' params          { sprintf (temp, "%s %s", $2.code, $4.code) ;
                                                      $$.code = gen_code (temp) ; }                                                   
            ;

codigo:         lineas                              { sprintf (temp, "%s", $1.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   codigo lineas                       { sprintf (temp, "%s\n%s", $1.code, $2.code) ;
                                                      $$.code = gen_code (temp) ; }
            ;

lineas:         sentencia                                                           { sprintf (temp, "%s", $1.code) ; 
                                                                                      $$.code = gen_code (temp) ; }
            |   INTEGER var_local ';'                                               { sprintf (temp, "%s", $1.code) ; 
                                                                                      $$.code = gen_code (temp) ; }
            |   llamada ';'                                                         { sprintf (temp, "%s", $1.code) ; 
                                                                                      $$.code = gen_code (temp) ; }  
            ;

var_local:      r_var_local                         { sprintf (temp, "%s\n", $1.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   r_var_local ',' var_local           { sprintf (temp, "%s\n%s", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            ;

r_var_local:    IDENTIF                             { local_vars[local_vars_index] = $1.code;
                                                      sprintf (temp, "(setq %s 0)", $1.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF '=' expresion               { local_vars[local_vars_index] = $1.code;
                                                      sprintf (temp, "(setq %s %s)", $1.code, $3.code) ;
                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF '[' NUMBER ']'              { local_vars[local_vars_index] = $1.code;
                                                      sprintf (temp, "(setq %s (make-array %d))", $1.code, $3.value) ;
                                                      $$.code = gen_code (temp) ; }
            ;

sentencia:      IDENTIF '=' expresion ';'                                           { sprintf (temp, "(setf %s_%s %s)", func_name, $1.code, $3.code) ; 
                                                                                      $$.code = gen_code (temp) ; }
            |   IDENTIF '[' expresion ']' '=' expresion ';'                         { sprintf (temp, "(setf (aref %s %s) %s)", $1.code, $3.code, $6.code) ; 
                                                                                      $$.code = gen_code (temp) ; }
            |   PRINTF expresion ';'                                                { sprintf (temp, "%s", $2.code) ;  
                                                                                      $$.code = gen_code (temp) ; }
            |   PUTS '(' STRING ')' ';'                                             { sprintf (temp, "(print \"%s\")", $3.code) ; 
                                                                                      $$.code = gen_code (temp) ; }
            |   WHILE '(' expresion ')' '{' codigo '}'                              { sprintf (temp, "(loop while %s do\n%s\n)", $3.code, $6.code) ;
                                                                                      $$.code = gen_code (temp) ; }
            |   IF '(' expresion ')' '{' codigo '}' resto_if                        { sprintf (temp, "(if %s\n(progn %s\n)\n%s\n)", $3.code, $6.code, $8.code) ; 
                                                                                      $$.code = gen_code (temp) ; } 
            |   FOR '(' inicializ ';' expresion ';' inc_dec ')' '{' codigo '}'      { sprintf (temp, "%s\n(loop while %s do\n%s\n%s\n)", $3.code, $5.code, $10.code, $7.code) ; 
                                                                                      $$.code = gen_code (temp) ; }
            |   RETURN retorno ';'                                                  { sprintf (temp, "(return-from %s %s)", func_name, $2.code) ; 
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

resto_if:       /* lambda */                    { $$.code = gen_code ("") ; }
            |   ELSE '{' codigo '}'             { sprintf (temp, "(progn %s\n)", $3.code) ;
                                                  $$.code = gen_code (temp) ; } 
            ;

inicializ:      IDENTIF '=' NUMBER              { sprintf (temp, "(setf %s_%s %d)", func_name, $1.code, $3.value) ;
                                                  $$.code = gen_code (temp) ; }
            ;

inc_dec:        IDENTIF '=' IDENTIF '+' expresion               { sprintf (temp, "(setq %s_%s (+ %s_%s %s))", func_name, $1.code, func_name, $3.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            |   IDENTIF '=' IDENTIF '-' expresion               { sprintf (temp, "(setq %s_%s (- %s_%s %s))", func_name, $1.code, func_name, $3.code, $5.code) ;
                                                                  $$.code = gen_code (temp) ; }
            ;

retorno:                                      
                expresion                       { sprintf (temp, "%s", $1.code) ;
                                                  $$.code = gen_code (temp) ; }
            |   expresion ',' retorno           { sprintf (temp, "(values %s %s)", $1.code, $3.code) ;
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
            |   '!' expresion %prec NOT             { sprintf (temp, "(not %s)", $2.code) ;
                                                      $$.code = gen_code (temp) ; }    
            ;

operando:       IDENTIF                  { sprintf (temp, "%s_%s", func_name, $1.code) ; //añadir condicion si func_name esta vacio
                                           $$.code = gen_code (temp) ; }
            |   NUMBER                   { sprintf (temp, "%d", $1.value) ;
                                           $$.code = gen_code (temp) ; }
            |   '(' print ')'            { $$ = $2 ; }
            ;

print:          expresion                               { sprintf (temp, "(prin1 %s)", $1.code) ;  
                                                          $$.code = gen_code (temp) ; }
            |   expresion ',' print                     { sprintf (temp, "(prin1 %s) %s", $1.code, $3.code) ;  
                                                          $$.code = gen_code (temp) ; }
            |   STRING ',' expresion                    { sprintf (temp, "(prin1 %s)", $3.code); 
                                                          $$.code = gen_code (temp) ; }
            |   STRING ',' llamada                      { sprintf (temp, "(prin1 %s)", $3.code); 
                                                          $$.code = gen_code (temp) ; }
            |   STRING ',' IDENTIF '[' expresion ']'    { sprintf (temp, "(prin1 (aref %s %s))", $3.code, $5.code); 
                                                          $$.code = gen_code (temp) ; }
            ;

/*definicion:     IDENTIF                                 { sprintf (temp, "(setq %s 0)", $1.code) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF '=' expresion                   { sprintf (temp, "(setq %s %d)", $1.code, $3.value) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF '=' expresion ',' definicion    { sprintf (temp, "(setq %s %d)\n%s", $1.code, $3.value, $5.code) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF ',' definicion                  { sprintf (temp, "(setq %s 0)\n%s", $1.code, $3.code) ;
                                                          $$.code = gen_code (temp) ; }
            |   IDENTIF '[' NUMBER ']'                  { sprintf (temp, "(setq %s %s)", $1.code, $2.code) ; 
                                                          $$.code = gen_code (temp) ; }
            ;*/

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

void formatoLisp(char *input) {
    int total_paren = 0;
    int indent = 0;
    int paren_count = 0;
    int is_loop = 0;
    int input_len = strlen(input);

    for (int i = 0; i < input_len; i++) { // analizamos la cadena entera
        if (input[i] == '(') {
            if (indent > 0 && paren_count == 0 && total_paren != 0) {
                for (int j = 0; j < indent; j++) { 
                    printf("\t");
                }
            }
            printf("(");
            total_paren++;
            paren_count++;
        }
        else if (input[i] == ')') {
            total_paren--;
            if (paren_count > 0) {
                paren_count--; 
            }
            if (indent > 0 && paren_count == 0) {
                if (total_paren == 0) {
                    indent--;
                } 
                if (input[i-1] == '\n' && is_loop) {
                    indent--;
                    for (int j = 0; j < indent; j++) { 
                        printf("\t");
                    }
                }
            }
            indent = indent < 0 ? 0 : indent;
            printf(")");
        } else {
            if (input[i] == '\n' && input[i+1] == '(') {
                paren_count = 0;
            }
            printf("%c", input[i]);
            if ((strncmp(input + i, "defun ", 6) == 0) || (strncmp(input + i, "if ", 3) == 0)
                || (strncmp(input + i, "while ", 6) == 0) || (strncmp(input + i, "for ", 4) == 0) 
                || (strncmp(input + i, "progn", 5) == 0)) {
                indent++; // si la siguiente palabra es alguna de las superiores, añadir un indent más
                paren_count = 1;
            }
            if ((strncmp(input + i, "while ", 6) == 0) || (strncmp(input + i, "for ", 4) == 0) 
                || (strncmp(input + i, "if ", 3) == 0)) {
                is_loop = 1;
            }
        }
    }
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
    "!",           NOT,
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
