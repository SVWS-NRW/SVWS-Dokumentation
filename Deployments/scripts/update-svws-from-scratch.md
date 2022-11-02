```
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
# Bei Debian ist oft kein Sudo eingerichtet, so dass der buil Prozess des Servers unter dem installationsscript der Einfachheit halber als root ausgeführt wird. 
# daher muss man kurz die Rechte zurückholen und anschließend wieder dem svws-User das Verzeichnis als Besitzer zurückgeben. 
#
chown -R root:root /app/
#
#
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a ~/svws-update.log
echo "++++++++++++++++++ updating SVWS-Server +++++++++++++++++++" | tee -a ~/svws-update.log
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a ~/svws-update.log
cd /app/SVWS-Server
git pull | tee -a ~/svws-update.log
git checkout dev | tee -a ~/svws-update.log
./gradlew clean build | tee -a ~/svws-update.log
#
#
# die richtigen Rechte setzten: 
chown -R svws:svws /app/
#
#
systemctl start svws 
systemctl status svws | tee -a ~/svws-update.log
```