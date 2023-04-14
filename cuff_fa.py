#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""Script que lee un fichero fasta, generado a partir de los transcritos
en formato gtf de Cufflinks con el comando 'gffread' incluido en la suite de
Cufflinks, y obtiene la secuencia más larga.
"""


fasta = input("Introduce el fichero fasta:")

def maxlenseq(fasta):
	max_len = 0
	result = ""
	with open(fasta,"r", encoding="utf-8") as f:
		for line in f:
			wline = line.rstrip('\n')
			if len(wline) >= max_len:
				max_len = len(wline)
				result = wline
		print(f"\nLa longitud de la secuencia es: {max_len} pb\n")
		return result

print(maxlenseq(fasta))

