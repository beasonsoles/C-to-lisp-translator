# C-to-Lisp and Lisp-to-FORTH Translator
- El archivo trad.y consiste en un compilador que traduce sentencias en C a Lisp (código intermedio)
- El archivo back.y toma la salida traducida a Lisp y la traduce a Forth (código final)

*Para compilar el frontend:*

**bison trad.y**

**gcc trad.tab.c -o trad**


*Para ejecutar los tests del frontend*

**bash front_script_pruebas.sh**

*Para compilar el backend:*

**bison back.y**

**gcc back.tab.c -o back**


*Para ejecutar los tests del backend*

**bash back_script_pruebas.sh**
