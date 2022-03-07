#!/bin/bash
############################### update-svwsv-server-from-scratch #########################################
#
#
# teste, ob das script mit rootrechten ausgefuehrt wird:
#
if [[ $EUID = 0 && "$(ps -o comm= | grep su | sed -n '1p')" = "su" ]]; then
   echo "This script must be run as root" 
   exit 1
fi
#
read -rp "Bitte GITHUB Benutzernamen angeben: " -e -i "${GITHUB_ACTOR}" GITHUB_ACTOR
read -rp "Bitte GITHUB Token angeben: " -e -i "${GITHUB_TOKEN}" GITHUB_TOKEN
#
systemctl stop svws
#
apt update
apt upgrade -y
#
#
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ~/svws-update.log
echo "++++++++++++++++++ updating SVWS-Server +++++++++++++++++++" >> ~/svws-update.log
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ~/svws-update.log
cd /app/SVWS-Server
git pull >> ~/svws-update.log
./gradlew clean build >> ~/svws-update.log
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ~/svws-update.log
echo "+++++++++++++++ updating SVWS-UI-Framewortk ++++++++++++++++" >> ~/svws-update.log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ~/svws-update.log
cd /app/SVWS-UI-Framework
git pull >> ~/svws-update.log
./gradlew clean build >> ~/svws-update.log
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ~/svws-update.log
echo "++++++++++++++++++ updating SVWS-Client ++++++++++++++++++++" >> ~/svws-update.log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ~/svws-update.log
cd /app/SVWS-Client
git pull >> ~/svws-update.log
./gradlew clean build >> ~/svws-update.log
#
# die richtigen Rechte setzten: 
chown -R svws:svws /app/
#
sytemctl start svws
sytemctl status svws >> update.log