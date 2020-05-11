#!/bin/bash

# Fonction : Télécharge les logiciels et check que tout est ok
# Input : "Lien de téléchargement" "Nom du logiciel" "plateforme"
downloadAndCheck() {
  wget --timestamping "${1}" -P ${BASE}"/"${3}"/"${2// /}"/"
  if [ $? -ne 0 ]
  then 
    {
      echo "Erreur de téléchargement de ${2}" >> /root/retour.txt
      nbErreurs=$((nbErreurs+=1))
      break
    }
  fi
  echo "${2} : ${theUnarchiverLatestVersion} - FilePath=${BASE}/${3}/TheUnarchiver/TheUnarchiver.dmg" >> versions.txt
}
 
# Fonction : Permet de choisir quel update est voulu
# Input : Argument en ligne de commande ou en choix
getChoice () {

  choiceDwnl=$1
    
  if test -z $choiceDwnl
  then 
    {
      echo "Choisir entre différentes version de téléchargement (1:OSX, 2:Windows, 3:All)"
      read choiceDwnl 
      # if (($choiceDwnl != (1|2|3)))
      # then 
      #   getChoice
      #   break
      # fi
    }
  elif (($choiceDwnl != (1|2|3)))
  then
    {
      echo "Choisir entre différentes version de téléchargement (1:OSX, 2:Windows, 3:All)"
      read choiceDwnl 
    }
  fi
  
  # Selon choix effectué
  case ${choiceDwnl} in
    1)
      echo "Initialisation des variables utiles pour la suite"
      getVariable
      echo "Telechargement des applications pour macOS"
      getAppsOSX
    ;;
    2)
      echo "Initialisation des variables utiles pour la suite"
      getVariable
      echo "Telechargement des applications pour Windows"
      getAppsWin
    ;;
    3)
      echo "Initialisation des variables utiles pour la suite"
      getVariable
      echo "Telechargement des applications pour macOS et pour Windows"
      getAppsAll
    ;;
    *)
      echo "Choix hors des limites acceptees (uniquement un chiffre de 1 à 3)"
      getChoice
    esac

  # # Ligne de fin du fichier version.txt
  echo "Toutes les applications sont downloades" >> /root/dwnapps/versions.txt
}

# Fonction : Fonction allant chercher les dernière version des logiciles multi-OS
# Input : Aucun input
getVariable () {
 # Initialisation des "Latest Version" utilisées dans toutes les fonctions de téléchargement
 # Untilisation des variables pour macOS ou Windows
 libreOfficeLatestVersion=$(curl -s https://www.libreoffice.org/download/release-notes/ | grep "Fresh Branch</h4>" | awk {'print $9'})
 firefoxLatestVersion=$(curl -s https://www.mozilla.org/en-US/firefox/releases/ | grep data-latest-firefox | awk {'print $7'} | sed 's/[^0-9.]*//g')
 vlcLatestVersion=$(curl -s https://www.videolan.org/vlc/download-macosx.html | grep "downloadOS" | awk -F '<' '{print $1}' | sed 's/[^0-9.]*//g')
 teamViewerOSXLatestVersion=$(curl -s https://community.teamviewer.com/t5/forums/filteredbylabelpage/board-id/Change_Logs_EN/label-name/macos|grep "(Full) - Change Log"|sed -n 1p|awk {'print $2'}|sed 's/^.//')
 adobeReaderDCLatestVersion=$(curl -s https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html |grep 'title="next chapter'| awk '{print $5}')
 virtualBoxLatestVersion=$(curl -s "https://www.virtualbox.org/wiki/Downloads" | grep "platform packages" | awk '{print $5}')
 vBoxOSX=$(curl -s "https://download.virtualbox.org/virtualbox/${virtualBoxLatestVersion}/" | grep "VirtualBox-${virtualBoxLatestVersion}" | grep "dmg" | awk '{print $2}' | sed -n 1p | cut -d "<" -f1 | cut -d ">" -f2)
 nvivoLatestVersion=$(curl -s https://www.qsrinternational.com/nvivo-qualitative-data-analysis-software/support-services/nvivo-downloads | grep "for Windows" | sed -n 1p | awk '{print $3}')
 zoteraLatestVersion=$(curl -s https://www.zotero.org/support/changelog | grep "Changes in" | sed -n 2p | awk {'print $5'})
 audacityLatestVersion=$(curl -s https://www.audacityteam.org/ | grep "Latest version" | awk {'print $5'} | cut -d "<" -f1)
 googleEarthLatestVersion=$(curl -s https://support.google.com/earth/answer/168344 | grep "for Windows (64-bit)" | sed -n 1p| awk {'print $3'} | cut -d ">" -f2 | cut -d "v" -f2)
 gimpBranche=$(curl -s https://www.gimp.org/downloads/ | grep "Source for version" | awk {'print $4'})
 blenderLatestVersion=$(curl -s https://www.blender.org/download/ | grep "New in Blender" | awk {'print $4'} | cut -d "<" -f1)
 blenderBranche=$(echo $blenderLatestVersion | sed 's/[a-z]//g' )
 orfeoToolBoxLatestVersion=$(curl -s https://www.orfeo-toolbox.org/ | grep "Download OTB" |awk {'print $10'} | cut -d "<" -f1)
 sublimeTextBranche=$(curl -s https://www.sublimetext.com/3 | grep "is the current version of Sublime Text" | awk {'print $4'})
 sublimeTextBuild=$(curl -s https://www.sublimetext.com/3 | grep "Version:</i> Build" | awk {'print $4'} | cut -d "<" -f1)
 pyCharmLatestVersion=$(curl -s https://www.jetbrains.com/fr-fr/pycharm/whatsnew/ | grep "<title>Nouveautés de PyCharm" | awk {'print $8'} | cut -d "<" -f1)
 pgAdminLatestVersion=$(curl -s https://www.pgadmin.org | grep " Released</h2>" | sed -n 1p | awk {'print $5'} | cut -d "v" -f2)
 pgAdminBranche=$(curl -s https://www.pgadmin.org | grep " Released</h2>" | sed -n 1p | awk {'print $4'})
}

# Fonction : Télécharge toutes les applications (OSX et Windows)
# Input : Aucun input
getAppsAll () {
  echo "Logiciel OSX" >> versions.txt
  getAppsOSX
  echo "Logiciels Windows" >> versions.txt
  getAppsWin
}

# Fonction : Télécharge toutes les applications OSX
# Input : Aucun input
getAppsOSX () {
  OS="macOS"
  # The Unarchiver
  theUnarchiverLatestVersion=$(curl -s https://theunarchiver.com | grep "Latest version" | awk '{print $4}' | sed -n 1p)
  downloadAndCheck "https://dl.devmate.com/com.macpaw.site.theunarchiver/TheUnarchiver.dmg" "The Unarchiver" ${OS}
  # echo "The Unarchiver : ${theUnarchiverLatestVersion} - FilePath=${BASE}/${OS}/TheUnarchiver/TheUnarchiver.dmg" >> versions.txt

  # LibreOffice + Pack de langues
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/mac/x86_64/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64.dmg" "LibreOffice" ${OS}
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/mac/x86_64/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64_langpack_fr.dmg" "LibreOffice" ${OS}
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/mac/x86_64/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64_langpack_en-GB.dmg" "LibreOffice" ${OS}
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/mac/x86_64/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64_langpack_de.dmg" "LibreOffice" ${OS}
  echo "Libre Office (Application) : ${libreOfficeLatestVersion} - FilePath=${BASE}/${OS}/LibreOffice/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64.dmg" >> versions.txt
  echo "Libre Office (Pack FR) : ${libreOfficeLatestVersion} - FilePath=${BASE}/${OS}/LibreOffice/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64_langpack_fr.dmg" >> versions.txt
  echo "Libre Office (Pack EN) : ${libreOfficeLatestVersion} - FilePath=${BASE}/${OS}/LibreOffice/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64_langpack_en-GB.dmg" >> versions.txt
  echo "Libre Office (Pack DE) : ${libreOfficeLatestVersion} - FilePath=${BASE}/${OS}/LibreOffice/LibreOffice_${libreOfficeLatestVersion}_MacOS_x86-64_langpack_de.dmg" >> versions.txt

  # Firefox
  downloadAndCheck "http://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=${sysLang}" "Firefox OSX" "OSX"
  mv 'index.html?product=firefox-latest-ssl&os=osx&lang=fr' 'Firefox-'$firefoxLatestVersion'.dmg'

  # VLC
  downloadAndCheck "https://get.videolan.org/vlc/$vlcLatestVersion/macosx/vlc-$vlcLatestVersion.dmg" "VLC" ${OS}
  echo "VLC Video Player : ${vlcLatestVersion} - FilePath=${BASE}/${OS}/VLC/vlc-$vlcLatestVersion.dmg" >> versions.txt

  # Google Chrome 
  downloadAndCheck "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg" "Google_Chrome" ${OS}
  echo "Google Chrome : toujours la derniere version - FilePath=${BASE}/${OS}/Google_Chrome/googlechrome.dmg" >> versions.txt

  # TeamViewer
  downloadAndCheck "http://download.teamviewer.com/download/TeamViewerQS.dmg" "TeamViewer" ${OS}
  echo "TeamViewer : ${teamViewerOSXLatestVersion} - FilePath=${BASE}/${OS}/TeamViewer/TeamViewerQS.dmg" >> versions.txt

  # Adobe Reader - Download OSX/Windows : Dernières versions disponibles
  downloadAndCheck "https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/"${adobeReaderDCLatestVersion//./}"/AcroRdrDC_"${adobeReaderDCLatestVersion//./}"_MUI.dmg" "Adobe_Reader_DC" ${OS}
  downloadAndCheck "http://ardownload.adobe.com/pub/adobe/reader/mac/AcrobatDC/"${adobeReaderDCLatestVersion//./}"/AcroRdrDCUpd"${adobeReaderDCLatestVersion//./}"_MUI.dmg" "Adobe_Reader_DC_Update" ${OS}
  echo "Adobe Reader DC Installable : ${adobeReaderDCLatestVersion} - FilePath=${BASE}/${OS}/Adobe_Reader_DC/AcroRdrDC_"${adobeReaderDCLatestVersion//./}"_MUI.dmg" >> versions.txt
  echo "Adobe Reader DC Update : ${adobeReaderDCLatestVersion} - FilePath=${BASE}/${OS}/Adobe_Reader_DC_Update/AcroRdrDCUpd"${adobeReaderDCLatestVersion//./}"_MUI.dmg" >> versions.txt

  # GrandPersepctives
  grandPerspectivesOSXLatestVersion=$(curl -s http://grandperspectiv.sourceforge.net|grep 'has been released'| sed -n 1p | awk {'print $5'})
  downloadAndCheck "https://sourceforge.net/projects/grandperspectiv/files/grandperspective/${grandPerspectivesOSXLatestVersion}/GrandPerspective-${grandPerspectivesOSXLatestVersion//./_}.dmg" "Grand_Perspectives" ${OS}
  echo "GrandPerspective : ${grandPerspectivesOSXLatestVersion} - FilePath=${BASE}/${OS}/Grand_Perspectives/GrandPerspective-${grandPerspectivesOSXLatestVersion//./_}.dmg" >> versions.txt

  # SwitchDrive - Download OSX/Windows : Dernières versions disponibles
  switchdriveLatestVersion=$(curl -s https://help.switch.ch/fr/drive/downloads/|grep pkg|awk -F'SWITCHdrive-' '{print $2}'|awk -F '\\.pkg' '{print $1}' )
  downloadAndCheck "https://misc.www.switch.ch/drive/SWITCHdrive-${switchdriveLatestVersion}.pkg" "SwitchDrive" ${OS}
  echo "SwitcDrive : ${switchdriveLatestVersion} - FilePath=${BASE}/${OS}/SwitchDrive/SWITCHdrive-${switchdriveLatestVersion}.pkg" >> versions.txt

  # WebEx
  downloadAndCheck "https://akamaicdn.webex.com/client/webexapp.dmg" "WebEx_Meetings" ${OS}
  downloadAndCheck "https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/WebexTeams.dmg" "WebEx_Teams" ${OS}
  echo "WebEx Meetings : toujours la derniere version - FilePath=${BASE}/${OS}/WebEx_Meetings/webexapp.dmg" >> versions.txt
  echo "WebEx Teams : toujours la derniere version - FilePath=${BASE}/${OS}/WebEx_Teams/WebexTeams.dmg" >> versions.txt

  # Client Zoom
  downloadAndCheck "https://zoom.us/client/latest/Zoom.pkg" "Zoom" ${OS}
  echo "Zoom : toujours la derniere version - FilePath=${BASE}/${OS}/Zoom/Zoom.pkg" >> versions.txt

  # Skype Enterprise
  skypeLatestVersion=$(curl -sS 'https://www.microsoft.com/fr-FR/download/details.aspx?id=54108' | grep -i "Version :" | awk -F '<p>' '{print $2}' | awk -F '</p>' '{print $1}')
  downloadAndCheck "https://download.microsoft.com/download/D/0/5/D055DA17-C7B8-4257-89A1-78E7BBE3833F/SkypeForBusinessInstaller-${skypeLatestVersion}.pkg" "Skype_Entreprise" ${OS}
  echo "Skype Entreprise : ${skypeLatestVersion} - FilePath=${BASE}/${OS}/Skype_Entreprise/SkypeForBusinessInstaller-${skypeLatestVersion}.pkg" >> versions.txt

  # VirtualBox
  downloadAndCheck "http://download.virtualbox.org/virtualbox/${virtualBoxLatestVersion}/${vBoxOSX}" "VirtualBox" ${OS}
  echo "VirtualBox : ${virtualBoxLatestVersion} - FilePath=${BASE}/${OS}/VirtualBox/${vBoxOSX}" >> versions.txt

  # NVivo
  downloadAndCheck "https://download.qsrinternational.com/Software/NVivo${nvivoLatestVersion}forMac/NVivo%20${nvivoLatestVersion}.dmg" "NVivo" ${OS}
  echo "NVivo : ${nvivoLatestVersion} - FilePath=${BASE}/${OS}/NVivo/NVivo%20${nvivoLatestVersion}.dmg" >> versions.txt

  # Zotero
  downloadAndCheck "https://download.zotero.org/client/release/${zoteraLatestVersion}/Zotero-${zoteraLatestVersion}.dmg" "Zotero" ${OS}
  echo "Zotero : ${zoteraLatestVersion} - FilePath=${BASE}/${OS}/Zotero/Zotero-${zoteraLatestVersion}.dmg" >> versions.txt

  # Audacity
  downloadAndCheck "https://www.fosshub.com/Audacity.html/audacity-macos-${audacityLatestVersion}.dmg" "Audacity" ${OS}
  echo "Audacity : ${audacityLatestVersion} - FilePath=${BASE}/${OS}/Audacity/audacity-macos-${audacityLatestVersion}.dmg" >> versions.txt
  
  # Google Earth Desktop Pro
  downloadAndCheck "https://dl.google.com/dl/earth/client/advanced/current/googleearthpromac-intel-${googleEarthLatestVersion}.dmg" "Google_Earth" ${OS}
  echo "Google Earth Desktop Pro : ${googleEarthLatestVersion} - FilePath=${BASE}/${OS}/Google_Earth/googleearthpromac-intel-${googleEarthLatestVersion}.dmg" >> versions.txt

  # Gimp
  gimpLatestVersionOSX=$(curl -s https://www.gimp.org/downloads/ | grep "The SHA256 hash sum for" | awk {'print $6'} | cut -d ">" -f2 | cut -d "<" -f1 | sed -n 1p)
  downloadAndCheck "https://download.gimp.org/mirror/pub/gimp/v${gimpBranche}/osx/${gimpLatestVersionOSX}" "Gimp" ${OS}
  echo "Gimp : ${gimpBranche} - ${gimpLatestVersionOSX} - FilePath=${BASE}/${OS}/Gimp/${gimpLatestVersionOSX}" >> versions.txt

  # Blender
  downloadAndCheck "https://ftp.nluug.nl/pub/graphics/blender/release/Blender${blenderBranche}/blender-${blenderLatestVersion}-macOS.dmg" "Blender" ${OS}
  echo "Blender : ${nvivoLatestVersion} - FilePath=${BASE}/${OS}/Blender/blender-${blenderLatestVersion}-macOS.dmg" >> versions.txt

  # Orfeo ToolBox
  downloadAndCheck "https://www.orfeo-toolbox.org/packages/OTB-${orfeoToolBoxLatestVersion}-Darwin64.run" "Orfeo_ToolBox" ${OS}
  echo "Orfeo ToolBox : ${blenderBranche} - ${blenderLatestVersion} - FilePath=${BASE}/${OS}/Orfeo_ToolBox/OTB-${orfeoToolBoxLatestVersion}-Darwin64.run" >> versions.txt

  # Sublime Text
  downloadAndCheck "https://download.sublimetext.com/Sublime%20Text%20Build%20${sublimeTextBuild}.dmg" "Sublime_Text" ${OS}
  echo "Sublime Text : ${sublimeTextBuild} - FilePath=${BASE}/${OS}/Sublime_Text/Sublime%20Text%20Build%20${sublimeTextBuild}.dmg" >> versions.txt

  # PyCharm
  downloadAndCheck "https://download.jetbrains.com/python/pycharm-community-${pyCharmLatestVersion}.dmg" "PyCharm" ${OS}
  echo "PyCharm : ${pyCharmLatestVersion} - FilePath=${BASE}/${OS}/PyCharm/pycharm-community-${pyCharmLatestVersion}.dmg" >> versions.txt

  # Python Orange
  pythonOrangeLatestVersionOSX=$(curl -s https://orange.biolab.si/download/ | grep "dmg" | cut -d "/" -f6 | cut -d '"' -f1 | sed -n 1p)
  downloadAndCheck "https://download.biolab.si/download/files/${pythonOrangeLatestVersionOSX}" "Python_Orange" ${OS}
  echo "Python Orange : ${pythonOrangeLatestVersionOSX} - FilePath=${BASE}/${OS}/Python_Orange/${pythonOrangeLatestVersionOSX}" >> versions.txt

  # pgAdmin
  downloadAndCheck "https://ftp.postgresql.org/pub/pgadmin/pgadmin${pgAdminBranche}/v${pgAdminLatestVersion}/macos/pgadmin${pgAdminBranche}-${pgAdminLatestVersion}.dmg" "pgAdmin" ${OS}
  echo "pgAdmin : ${pgAdminBranche} - ${pgAdminLatestVersion} - FilePath=${BASE}/${OS}/pgAdmin/pgadmin${pgAdminBranche}-${pgAdminLatestVersion}.dmg" >> versions.txt
}

# Fonction : Télécharge toutes les applications Windows
# Input : Aucun input
getAppsWin () {
  # 7-Zip
  sevenZipLatestVersion=$(curl -s https://www.7-zip.org/download.html | grep "Download 7-Zip" | awk {'print $3'} | sort -nr | sed -n 1p) 
  downloadAndCheck "https://www.7-zip.org/a/7z"${sevenZipLatestVersion//./}"-x64.msi" "7-Zip" "Windows"
  echo "7-Zip : ${sevenZipLatestVersion}" >> versions.txt

  # LibreOffice + Pack de langues
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/win/x86_64/LibreOffice_${libreOfficeLatestVersion}_Win_x64.msi" "LibreOffice Windows" "Windows"
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/win/x86_64/LibreOffice_${libreOfficeLatestVersion}_Win_x64_helppack_fr.msi" "LibreOffice Windows - Pack FR" "Windows"
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/win/x86_64/LibreOffice_${libreOfficeLatestVersion}_Win_x64_helppack_en-GB.msi" "LibreOffice Windows - Pack EN" "Windows"
  downloadAndCheck "https://download.documentfoundation.org/libreoffice/stable/${libreOfficeLatestVersion}/win/x86_64/LibreOffice_${libreOfficeLatestVersion}_Win_x64_helppack_de.msi" "LibreOffice Windows - Pack DE" "Windows"
  echo "Libre Office : ${libreOfficeLatestVersion}" >> versions.txt

  # Firefox
  downloadAndCheck "http://download.mozilla.org/?product=firefox-latest-ssl&os=win&lang=${sysLang}" "Firefox Windows" "Windows"
  mv 'index.html?product=firefox-latest-ssl&os=win&lang=fr' 'Firefox-'$firefoxLatestVersion'.exe'
  echo "Firefox : ${firefoxLatestVersion}" >> versions.txt

  # VLC
  downloadAndCheck "https://get.videolan.org/vlc/$vlcLatestVersion/win64/vlc-$vlcLatestVersion-win64.exe" "VLC Windows" "Windows"
  echo "VLC Video Player : ${vlcLatestVersion}" >> versions.txt

  # Google Chrome 
  downloadAndCheck "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BBBC93456-F723-D38C-0317-C5980B66B0F0%7D%26lang%3Dfr%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe" "Google Chrome Windows" "Windows"
  echo "Google Chrome : toujours la derniere version" >> versions.txt

  # TeamViewer
  downloadAndCheck "http://download.teamviewer.com/download/TeamViewerQS.exe" "TeamViewer Windows" "Windows"
  echo "TeamViewer : ${teamViewerOSXLatestVersion}" >> versions.txt

  # Adobe Reader - Download OSX/Windows : Dernières versions disponibles
  downloadAndCheck "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/"${adobeReaderDCLatestVersion//./}"/AcroRdrDC"${adobeReaderDCLatestVersion//./}"_MUI.exe" "Adobe Acrobat Reader DC" "Windows"
  downloadAndCheck "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/"${adobeReaderDCLatestVersion//./}"/AcroRdrDCUpd"${adobeReaderDCLatestVersion//./}"_MUI.msp" "Adobe Acrobat Reader Update" "Windows"
  echo "Adobe Reader : ${adobeReaderDCLatestVersion}" >> versions.txt

  # WinDirStat - Download Windows : Dernière Version Disponible
  winDirStatWinLatestVersion=$(curl -s https://windirstat.net/download.html|grep 'Download WinDirStat'| awk {'print $17'} | cut -d "<" -f1)
  downloadAndCheck "https://windirstat.net/wds_current_setup.exe" "WinDirStat Windows" "Windows"
  echo "WinDirStat : ${winDirStatWinLatestVersion}" >> versions.txt

  # WebEx
  downloadAndCheck "https://akamaicdn.webex.com/client/webexapp.msi" "WebEx Meetings Windows" "Windows"
  downloadAndCheck "https://binaries.webex.com/WebexTeamsDesktop-Windows-Gold/WebexTeams.msi" "WebEx Teams Windows" "Windows"
  echo "Webex : toujours la derniere version" >> versions.txt

  # Client Zoom
  downloadAndCheck "https://zoom.us/client/latest/ZoomInstaller.exe" "Zoom Windows" "Windows"
  echo "Zoom : toujours la derniere version" >> versions.txt

  # Notepad++
  notepadppLatestVersion=$(curl -s https://notepad-plus-plus.org/downloads/ | grep "Notepad&#43;&#43;" | sed -n 3p | awk '{print $2}')
  downloadAndCheck "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${notepadppLatestVersion}/npp.${notepadppLatestVersion}.Installer.x64.exe" "Notepad++ Windows" "Windows"
  echo "Notepad++ : ${notepadppLatestVersion}" >> versions.txt

  # PDF Creator
  pdfCreatorLatestVersion=$(curl -s "http://download.pdfforge.org/download/pdfcreator" | grep "Stable Release" | sed -n 2p | awk '{print $3}')
  downloadAndCheck "https://silver.download.pdfforge.org/pdfcreator/${pdfCreatorLatestVersion}/PDFCreator-${pdfCreatorLatestVersion//./_}-Setup.exe" "PdfCreator Windows" "Windows"
  echo "PDF Creator : ${pdfCreatorLatestVersion}" >> versions.txt

  # VirtualBox
  downloadAndCheck "http://download.virtualbox.org/virtualbox/${virtualBoxLatestVersion}/${vBoxOSX//OSX.dmg/Win.exe}" "VirtualBox Windows" "Windows"
  echo "VirtualBox : ${virtualBoxLatestVersion}" >> versions.txt

  # ImgBurn + Pack de langues (French + German)
  imgBurnLatestVersion=$(curl -s "https://www.imgburn.com/" | grep "Current version:" | awk '{print $5}' | cut -d "<" -f1)
  downloadAndCheck "http://download.imgburn.com/SetupImgBurn_${imgBurnLatestVersion}.exe" "ImgBurn Windows" "Windows"
  downloadAndCheck "http://download.imgburn.com/translations/french.zip" "ImgBurn Pack French" "Windows"
  downloadAndCheck "http://download.imgburn.com/translations/german.zip" "ImgBurn Pack German" "Windows"
  echo "ImgBurn : ${imgBurnLatestVersion}" >> versions.txt

  # Inkscape
  inkScapeLatestVersion=$(curl -s https://inkscape.org/fr/release/inkscape-0.92.5/ | grep "is a stability and bugfix release" | awk '{print $2}')
  downloadAndCheck "https://inkscape.org/fr/gallery/item/18066/inkscape-${inkScapeLatestVersion}-x64.msi" "Inkscape" "Windows"
  echo "Inkscape : ${inkScapeLatestVersion}" >> versions.txt

  # NVivo
  downloadAndCheck "https://download.qsrinternational.com/Software/NVivo${nvivoLatestVersion}/NVivo${nvivoLatestVersion}.x64.exe" "NVivo" "Windows"
  echo "NVivo : ${nvivoLatestVersion}" >> versions.txt

  # IrfanView + plugins
  irfanViewLatestVersion=$(curl -s https://www.irfanview.com/ | grep "Get IrfanView" | awk {'print $4'} | cut -d "<" -f1)
  downloadAndCheck "https://www.fosshub.com/IrfanView.html?dwl=iview${irfanViewLatestVersion//./}_x64_setup.exe" "IrfanView" "Windows"
  downloadAndCheck "https://www.fosshub.com/IrfanView.html/iview${irfanViewLatestVersion//./}_plugins_x64_setup.exe" "IrfanView/Plugins" "Windows"
  echo "IrfanView + Plugins : ${irfanViewLatestVersion}" >> versions.txt

  # Zotero
  downloadAndCheck "https://download.zotero.org/client/release/${zoteraLatestVersion}/Zotero-${zoteraLatestVersion}_setup.exe" "Zotero" "Windows"
  echo "Zotero : ${zoteraLatestVersion}" >> versions.txt

  # WinSCP
  winSCPLatestVersion=$(curl -s https://winscp.net/eng/news.php | grep "WinSCP" | sed -n 5p | awk {'print $3'})
  downloadAndCheck "https://winscp.net/download/WinSCP-${winSCPLatestVersion}-Setup.exe" "WinSCP" "Windows"
  echo "WinSCP : ${winSCPLatestVersion}" >> versions.txt

  # Virtual Clone Driver
  virtualCloneDriveLatestVersion=$(curl -s https://www.elby.ch/fr/download.html | grep "Virtual CloneDrive Nouveautés" | awk {'print $9'} | cut -d ">" -f2 | cut -d "<" -f1)
  downloadAndCheck "https://www.elby.ch/download/SetupVCD.exe" "Virtual_CloneDrive" "Windows"
  echo "Virtual Clone Driver : ${virtualCloneDriveLatestVersion}" >> versions.txt

  # Audacity
  downloadAndCheck "https://www.fosshub.com/Audacity.html/audacity-win-${audacityLatestVersion}.exe" "Audacity" "Windows"
  echo "Audacity : ${audacityLatestVersion}" >> versions.txt

  # Google Earth Desktop Pro
  downloadAndCheck "https://dl.google.com/dl/earth/client/advanced/current/googleearthprowin-${googleEarthLatestVersion}-x64.exe" "Google_Earth" "Windows"
  echo "Gogle Earth Desktop Pro : ${googleEarthLatestVersion}" >> versions.txt

  # Gimp
  gimpLatestVersionWindows=$(curl -s https://www.gimp.org/downloads/ | grep "The SHA256 hash sum for" | awk {'print $6'} | cut -d ">" -f2 | cut -d "<" -f1 | sed -n 2p)
  downloadAndCheck "https://download.gimp.org/mirror/pub/gimp/v${gimpBranche}/windows/${gimpLatestVersionWindows}" "Gimp" "Windows"
  echo "Gimp : ${gimpBranche} - ${gimpLatestVersionWindows}" >> versions.txt

  # Blender
  downloadAndCheck "https://ftp.nluug.nl/pub/graphics/blender/release/Blender${blenderBranche}/blender-${blenderLatestVersion}-windows64.msi" "Blender" "Windows"
  echo "Blender : ${blenderBranche} - ${blenderLatestVersion}" >> versions.txt

  # Orfeo ToolBox
  downloadAndCheck "https://www.orfeo-toolbox.org/packages/OTB-${orfeoToolBoxLatestVersion}-Win64.zip" "Orfeo_ToolBox" "Windows"
  echo "Orfeo ToolBox : ${orfeoToolBoxLatestVersion}" >> versions.txt

  # Sublime Text
  downloadAndCheck "https://download.sublimetext.com/Sublime%20Text%20Build%20${sublimeTextBuild}%20x64%20Setup.exe" "Sublime_Text" "Windows"
  echo "Sublime Text : ${sublimeTextBuild}" >> versions.txt

  # PyCharm
  downloadAndCheck "https://download.jetbrains.com/python/pycharm-community-${pyCharmLatestVersion}.exe" "PyCharm" "Windows"
  echo "PyCharm : ${pyCharmLatestVersion}" >> versions.txt

  # Python Orange
  pythonOrangeLatestVersionWin=$(curl -s https://orange.biolab.si/download/ | grep "exe" | cut -d "/" -f6 | cut -d '"' -f1 | sed -n 1p)
  downloadAndCheck "https://download.biolab.si/download/files/${pythonOrangeLatestVersionWin}" "Python_Orange" "Windows"
  echo "Python Orange : ${pythonOrangeLatestVersionWin}" >> versions.txt

  # pgAdmin
  downloadAndCheck "https://ftp.postgresql.org/pub/pgadmin/pgadmin${pgAdminBranche}/v${pgAdminLatestVersion}/windows/pgadmin${pgAdminBranche}-${pgAdminLatestVersion}-x86.exe" "pgAdmin" "Windows"
  echo "pgAdmin : ${pgAdminBranche} - ${pgAdminLatestVersion}" >> versions.txt
}