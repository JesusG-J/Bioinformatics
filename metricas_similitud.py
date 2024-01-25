#!/usr/bin/python3.9
# -*- coding: utf-8 -*-


genA = [1,0,1,1,0]
genB = [1,0,1,1,0]
genC = [1,1,0,0,1]
genD = [0,1,0,1,0]

genes = {"genA": genA, "genB": genB, "genC": genC}

scoreAB = 0
scoreAC = 0
scoreAD = 0
scoreBC = 0
scoreBD = 0
scoreCD = 0

interact_AB = 0
interact_AC = 0
interact_AD = 0
interact_BC = 0
interact_BD = 0
interact_CD = 0

metric = input("What metric do you want to calculate? [bit-score|hamming|jaccard]  ").lower()

if metric == "bit-score":
    
    #Similitud en bit-score: número de bits compartidos por dos vectores binarios
    for name, gen in genes.items():
    		if name == "genA":
    			for i, bit in enumerate(gen):
    				if bit == genB[i]:
    					scoreAB += 1
    				if bit == genC[i]:
    					scoreAC += 1
    				if bit == genD[i]:
    					scoreAD += 1
    		if name == "genB":
    			for i, bit in enumerate(gen):
    				if bit == genC[i]:
    					scoreBC += 1
    				if bit == genD[i]:
    					scoreBD += 1
    		if name == "genC":
    			for i, bit in enumerate(gen):
    				if bit == genD[i]:
    					scoreCD += 1

    print(f"Entre los genes A y B hay una similitud de {scoreAB} bits")
    print(f"Entre los genes A y C hay una similitud de {scoreAC} bits")
    print(f"Entre los genes A y D hay una similitud de {scoreAD} bits")
    print(f"Entre los genes B y C hay una similitud de {scoreBC} bits")
    print(f"Entre los genes B y D hay una similitud de {scoreBD} bits")
    print(f"Entre los genes C y D hay una similitud de {scoreCD} bits")

elif metric == "hamming":
    
    # Distancia de Hamming: número de bits en que difieren dos vectores binarios
    for name, gen in genes.items():
            if name == "genA":
                for i, bit in enumerate(gen):
                    if bit != genB[i]:
                        scoreAB += 1
                    if bit != genC[i]:
                        scoreAC += 1
                    if bit != genD[i]:
                        scoreAD += 1
            if name == "genB":
                for i, bit in enumerate(gen):
                    if bit != genC[i]:
                        scoreBC += 1
                    if bit != genD[i]:
                        scoreBD += 1
            if name == "genC":
                for i, bit in enumerate(gen):
                    if bit != genD[i]:
                        scoreCD += 1

    print(f"Entre los genes A y B hay una distancia de {scoreAB} bits")
    print(f"Entre los genes A y C hay una distancia de {scoreAC} bits")
    print(f"Entre los genes A y D hay una distancia de {scoreAD} bits")
    print(f"Entre los genes B y C hay una distancia de {scoreBC} bits")
    print(f"Entre los genes B y D hay una distancia de {scoreBD} bits")
    print(f"Entre los genes C y D hay una distancia de {scoreCD} bits")

elif metric == "jaccard":

    # Índice Jaccard: grado de similitud entre entre dos conjuntos
    # Número de interacciones compartidas entre dos vectores binarios / Número de interacciones totales
    for name, gen in genes.items():
            if name == "genA":
                for i, bit in enumerate(gen):
                    if bit == genB[i] and bit == 1:
                         scoreAB += 2
                    elif (bit != genB[i] and bit == 1) or (bit != genB[i] and genB[i] == 1):
                        interact_AB += 1
                    if bit == genC[i] and bit == 1:
                        scoreAC += 2
                    elif (bit != genC[i] and bit == 1) or (bit != genC[i] and genC[i] == 1):
                        interact_AC += 1
                    if bit == genD[i] and bit == 1:
                        scoreAD += 2
                    elif (bit != genD[i] and bit == 1) or (bit != genD[i] and genD[i] == 1):
                        interact_AD += 1
            if name == "genB":
                for i, bit in enumerate(gen):
                    if bit == genC[i] and bit == 1:
                        scoreBC += 2
                    elif (bit != genC[i] and bit == 1) or (bit != genC[i] and genC[i] == 1):
                        interact_BC += 1
                    if bit == genD[i] and bit == 1:
                        scoreBD += 2
                    elif (bit != genD[i] and bit == 1) or (bit != genD[i] and genD[i] == 1):
                        interact_BD += 1
            if name == "genC":
                for i, bit in enumerate(gen):
                    if bit == genD[i] and bit == 1:
                        scoreCD += 2
                    elif (bit != genD[i] and bit == 1) or (bit != genD[i] and genD[i] == 1):
                        interact_CD += 1

print(f"J(A,B)={scoreAB/(scoreAB + interact_AB)}")
print(f"J(A,C)={scoreAC/(scoreAC + interact_AC)}")
print(f"J(A,D)={scoreAD/(scoreAD + interact_AD)}")
print(f"J(B,C)={scoreBC/(scoreBC + interact_BC)}")
print(f"J(B,D)={scoreBD/(scoreBD + interact_BD)}")
print(f"J(C,D)={scoreCD/(scoreCD + interact_CD)}")





