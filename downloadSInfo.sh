#!/bin/bash

# Initialisation des variables globales
sysLang=fr
nbErreurs=0
userAdmin="laurent.zufferey@unil.ch"
BASE="/root/dwnapps/sInf"

source "./functions.sh"

cat /dev/null > ${BASE}/retour.txt
cat /dev/null > ${BASE}/versions.txt
echo "Salle Informatique UNIL" > ${BASE}/versions.txt


./fichier.sh

echo "depuis downloadSInfo"