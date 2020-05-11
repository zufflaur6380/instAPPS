
<b>Date initiale</b> : 2020/04/20<br>
<b>Release du projet</b> : 2020/04/30

# Listing des actions du script
- Vérification (latest release) et éléchargements des applications OSX et Windows traditionnelles pour l'UNIL
- Création d'un fichier en cas d'échec d'un téléchargement
- Creation d'un fichier texte avec les versions sur le serveur
- Envoi email à l'admin dès que le script est terminé 
    - OK - joint le fichier avec le numéro de version de chaque logiciel
    - NOK - joint le fichier d'erreur
- Image de l'arborescence crée avec les installables triés

# Fonctions externalisees dans un fichier séparé
    - downloadAndCheck() : Download les installeurs selon link défini
    - getChoice() : Choix de l'utilisation du script
    - getVariable() : definit des variables spécifiques (Latest version de logiciels)
    - getAppsAll() : Toutes les applications (OX + Windows)
    - getAppsOSX() : Toutes les applications OSX
    - getAppsWin() : Toutes les applications Windows


# Listing des catégories de machines
- <b>PC pour utilisateur défini</b>
- <b>PC pour salles infromatique</b>

# Listing evolutif des applications
- <b>Compression / Decompression</b>
    - The Unarchiver
    - 7-Zip
- <b>Bureautique</b>
    - LibreOffice : Application
    - LibreOffice (language pack : French, English, German)
- <b>Navigateur Internet</b>
    - Mozilla Firefox
    - Google Chrome
- <b>Multimedia</b>
    - VLC Player
- <b>Scientifique</b>
    - QsrInternational Nvivo
- <b>Divers</b>
    - TeamViewer
    - Adobe Reader DC
    - GrandPerspectives
    - WindirStat
    - SwitchDrive
    - Webex
    - Zoom
    - Skype Enterprise
    - Notepad++
    - PDF Creator
    - VirtualBox
    - ImgBurn
    - Inkscape
    - IrfanView + plugins
    - Zotero (à voir pour faire les plugins)
    - WinSCP
    - Virtual Clone Driver
    - Audacity
    - Google Earth Desktop Pro
    - Gimp
    - Blender
    - Orfeo ToolBox
    - Sublime Text
    - PyCharm
    - Python Orange
    - pgAdmin
    - Adobe Acrobat DC
    - Adobe Illustrator CC
    - Adobe InDesign CC
    - Adobe Photoshop CC

# Next step
- fichier des logiciels des salles informatiques (OSX, Windows)
- Zotero (les plugins)