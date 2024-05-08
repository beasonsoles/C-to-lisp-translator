#!/bin/bash
archivos=$(ls pruebas/*.c)
for archivo in $archivos; do
	archivo=${archivo%.c}
	echo "Running $archivo..."
	./trad < $archivo.c > $archivo.l ; ./back < $archivo.l > $archivo.f ; gforth < $archivo.f
done
