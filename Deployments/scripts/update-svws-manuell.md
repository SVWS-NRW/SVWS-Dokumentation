``` bash

#!/bin/bash

echo "############################### update-svwsv-server-from-scratch #########################################"
echo ""
echo ""
#
#

echo "Sie mÃ¼ssen einen Git Token und das Schild MDB Passwort in ~/-gradle/gradle.properties angeben.  "

echo "Github-Zugang und das Schild MDB-Passwort aus ~/.gradle/gradle.properties:"

echo ""
while read LINE
do
    echo $LINE
done < ~/.gradle/gradle.properties


	echo ""
	echo "Achtung: alle Daten werden nun Ã¼berschrieben!"
#	echo "Soll die Installation mit diesen Daten fortgesetzt werden? (y/n)"

read -r -p "Soll die Installation mit diesen Daten fortgesetzt werden? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 



echo "++++ update ++++"


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

# Bei Debian ist oft kein Sudo eingerichtet, so dass der buil Prozess des Servers unter dem installationsscript der Einfachheit halber als root ausgefÃ¼hrt wird.
# daher muss man kurz die Rechte zurÃ¼ckholen und anschlieÃŸend wieder dem svws-User das Verzeichnis als Besitzer zurÃ¼ckgeben.
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

;;
*)
echo "Installation abgebrochen!"
;;
esac

read -r -p "Soll die Datenbank neu aus der Testdatenbank migriert werden? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 


## ggf. die Datenbank neu migrieren - Dies kÃ¶nnte gerade bei den ersten, noch nicht ausgerollten Versionsnummern noch nÃ¶tig sein
curl --user "root:svwsadmin" -k -X 'POST' 'https://nightly.svws-nrw.de/api/schema/root/migrate/mdb/svws'  -H 'accept: application/json'  -H 'Content-Type: multipart/form-data'  -F 'database=~/SVWS-TestMDBs/GOST_Abitur/Abi-Test-Daten-01/GymAbi.mdb'  -F 'databasePassword=kannManWissen'  -F 'schemaUsername=svwsadmin'   -F 'schemaUserPassword=svwsadmin'

;;
*)
echo "Migration abgebrochen!"
;;
esac


```