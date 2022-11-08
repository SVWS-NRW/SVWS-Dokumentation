``` bash
#!/bin/bash

echo "############################### update-svwsv-server-from-scratch #########################################"
echo ""
echo ""
#
#

echo "Sie müssen einen Git Token und das Schild MDB Passwort in ~/-gradle/gradle.properties angeben.  "

echo "Github-Zugang und das Schild MDB-Passwort aus ~/.gradle/gradle.properties:"

echo ""
while read LINE
do
     echo $LINE
done < ~/.gradle/gradle.properties


         echo ""
         echo "Achtung: alle Daten werden nun überschrieben!"
#       echo "Soll die Installation mit diesen Daten fortgesetzt werden? 
(y/n)"

read -r -p "Soll die Installation mit diesen Daten fortgesetzt werden? 
[y/N] " response
case "$response" in
     [yY][eE][sS]|[yY])



echo "++++ update ++++"


# teste, ob das script mit root-Rechten ausgefuehrt wird:
#

if [[ $EUID = 0 && "$(ps -o comm= | grep su | sed -n '1p')" = "su" ]]; then

    echo "This script must be run as root"

    exit 1

fi

#
#
systemctl stop svws

#
apt update && apt upgrade -y

#

# Bei Debian ist oft kein Sudo eingerichtet, so dass der build Prozess des Servers unter dem Installationsscript der Einfachheit halber als root ausgeführt wird.
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

;;
*)
echo "Installation abgebrochen!"
;;
esac

read -r -p "Soll die Datenbank neu aus der Testdatenbank migriert werden? [y/N] " response case "$response" in
     [yY][eE][sS]|[yY])


## ggf. die Datenbank neu migrieren - Dies könnte gerade bei den ersten, noch nicht ausgerollten Versionsnummern noch nötig sein

cd /root/SVWS-TestMDBs

git pull | tee -a ~/svws-update.log

curl --user "root:svwsadmin" -k -X "POST" "https://server.svws-nrw.de/api/schema/root/migrate/mdb/svwsdb" \
	-H "accept: application/json"  \
	-H "Content-Type: multipart/form-data" \
	-F "databasePassword=kannManWissen" \
	-F "schemaUsername=svwsadmin" \
	-F "schemaUserPassword=svwsadmin" \
	-F "database=@/root/SVWS-TestMDBs/GOST_Abitur/Abi-Test-Daten-01/GymAbi.mdb"

;;
*)
echo "Migration abgebrochen!"
;;
esac


```