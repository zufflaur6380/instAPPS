# But : Installation en powershell de la liste des applications traditionnelles UNIL
# Utilisation : A travers MDM/GDP et les scripts d'installation

Write-Host "******************************************************************"
Write-Host "********** Installation des logiciels traditionels UNIL **********"
Write-Host "******************************************************************"
Write-Host ""
Write-Host "Choix possible pour l'utilisation de ce script :"
Write-Host "1) Tout les logiciels"
Write-Host "2) Définir manuellement les logiciels"
Write-Host "3) Quitter"
$choiceInitial=Read-Host "Votre choix ? (1|2|3)"
$baseLogiciel="c:\installable\Windows"

function sevenZipInstall {
    Write-Host "Installation d'Adobe Reader"
    Start-Process -FilePath "$baseLogiciel\7-Zip\7z1900-x64.msi" /q -Wait
    Write-Host "Terminé !" -ForegroundColor Green
}

function googleChromeInstall {
    Write-Host "Installation Google Chrome"
    Start-Process -FilePath "$baseLogiciel\Google\ChromeSetup.exe" / q Wait
}
sevenZipInstall
googleChromeInstall
