#!/bin/bash

# La función de este script es separar un archivo multifasta en fastas individuales


# Seleccionamos fichero multifasta:
echo "Estos son los ficheros disponibles en el actual directorio:"
ls
echo
echo "Escriba el fichero multifasta:"
read MULTIFASTA
echo
echo "Escriba el nombre del fichero multifasta sin saltos de línea que va ser creado:"
read FICHERO_OUT
echo

# Utilizando el código del script Fasta_lineal eliminamos los saltos
# de línea del multifasta
echo "Eliminando los saltos de líneas del fichero multifasta..."
while 
	read line
do
if [ "${line:0:1}" == ">" ]; then
	echo -e "\n"$line
else
	echo $line | tr -d '\n'
fi
done < $MULTIFASTA > $FICHERO_OUT 

echo
echo "El fichero $FICHERO_OUT ha sido creado"
echo
echo "Introduzca una expresión regular (sin comillas) que le permita visualizar de cuantos fasta se compone el fichero $FICHERO_OUT:"
read REGEXP
echo "Mostrando..."
echo
egrep "$REGEXP" $FICHERO_OUT --color
CUENTA=`egrep "$REGEXP" $FICHERO_OUT | wc -l` 
echo
echo "El número de fasta que se podrían extraer de este fichero es $CUENTA"


# Uso bucle while para ir extrayendo los múltiples fasta individuales
while :
	do
		# Menu
		echo "Seleccione una opción:"
		echo "1) Extraer fasta individual del multifasta"
		echo "2) Salir"
		read OPCION

		# Opciones
		case $OPCION in
			1) echo "Escribe el identificador:"
			   read ID
			   echo
			   echo "Escribe el nombre del fichero de salida:"
			   read ONEFASTA
                           touch $ONEFASTA
			   echo "El fichero $ONEFASTA ha sido creado"
			   echo
                           grep -A1 "$ID" $FICHERO_OUT | tee -a $ONEFASTA
			   echo
			   echo "Hecho"
			;;
			2) echo "Cerrando el programa..."
                           echo
			   exit
			;;
			*) echo "Opción no reconocida" 
		esac
	done


