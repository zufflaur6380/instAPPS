#!/bin/bash
# But : Verification dernieres versions de logiciels et telechargement de cette version
# Utilisation : A travers MDM/GDP et les scripts d'installation

# Initialisation des variables globales 
sysLang=fr
nbErreurs=0
userAdmin="laurent.zufferey@unil.ch"
BASE="/root/dwnapps"

source "${BASE}/functions.sh"

# Initialisation du fichier des erreurs de download
cat /dev/null > retour.txt
cat /dev/null > versions.txt
echo "Liste des dernieres versions des logiciels pour l'UNIL" > versions.txt

# Appel d'une fonction 
getChoice "$1"

if [ -s "${BASE}/retour.txt" ]; then
  mutt -s "${HOSTNAME} - Erreur" -a ${BASE}/retour.txt -- ${userAdmin} < /dev/null
else 
  mutt -s "${HOSTNAME} - OK" -a ${BASE}/versions.txt -- ${userAdmin} < /dev/null
fi