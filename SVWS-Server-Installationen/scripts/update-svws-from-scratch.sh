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
#
systemctl stop svws
#
apt update
apt upgrade -y
#
#
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee ~/svws-update.log
echo "++++++++++++++++++ updating SVWS-Server +++++++++++++++++++" | tee ~/svws-update.log
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee ~/svws-update.log
cd /app/SVWS-Server
git pull | tee ~/svws-update.log
git checkout dev | tee ~/svws-update.log
./gradlew clean build | tee ~/svws-update.log
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee ~/svws-update.log
echo "+++++++++++++++ updating SVWS-UI-Framewortk ++++++++++++++++" | tee ~/svws-update.log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee ~/svws-update.log
cd /app/SVWS-UI-Framework
git pull | tee ~/svws-update.log
git checkout dev | tee ~/svws-update.log
./gradlew clean build | tee ~/svws-update.log
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee ~/svws-update.log
echo "++++++++++++++++++ updating SVWS-Client ++++++++++++++++++++" | tee ~/svws-update.log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee ~/svws-update.log
cd /app/SVWS-Client
git pull | tee ~/svws-update.log
git checkout dev | tee ~/svws-update.log
./gradlew clean build | tee ~/svws-update.log
#
# die richtigen Rechte setzten: 
chown -R svws:svws /app/
#
systemctl start svws 
systemctl status svws | tee ~/svws-update.log