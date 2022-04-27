#!/bin/bash
########################################################################
#
# geschrieben für LXC Container mit linux debian 11 auf einem Proxmox
#
#
	echo ""
	echo ""
	echo "#######################"
	echo "#SVWS Installer Script#"
	echo "#######################"
	echo ""
	echo ""
	echo "links zum repository: "
	echo ""
	echo "https://gitlab.svws-nrw.de/"
	echo "https://github.com/svws-nrw/"
	echo ""
	echo ""

	# Vorgaben:
	INST_PATH="/app"
	SCHILD_PW="DasUeblichSchildMDB-PW"
	SVWS_USER="svws"
	JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

	SVWS_PW="svwsadmin"
	SVWS_DB_PW="svwsadmin"

	#Abfragen der Einstellungen:
	read -rp "Bitte GITHUB Benutzernamen angeben: " -e -i "${GITHUB_ACTOR}" GITHUB_ACTOR
	read -rp "Bitte GITHUB Token angeben: " -e -i "${GITHUB_TOKEN}" GITHUB_TOKEN
	read -rp "Bitte SCHILD MDB Passwort angeben: " -e -i "${SCHILD_PW}" SCHILD_PW
	read -rp "Bitte das Passwort für den Benutzer svws, unter der der Dienst läuft, angeben: " -e -i "${SVWS_PW}" SVWS_PW
	read -rp "Bitte das Maria-DB root-Passwort angeben: " -e -i "${SVWS_DB_PW}" SVWS_DB_PW

echo "
Installationspfad des SVWS-Servers: '$INST_PATH'

Linux User 'svws' 
Passwort: '$SVWS_PW'

Maria-DB User 'root' 
Passwort: '$SVWS_DB_PW'

" > SVWS-Zugangsdaten.txt

chmod -r -w SVWS-Zugangsdaten.txt

  
#########################################################################
####################### install skript ##################################
#########################################################################


# teste, ob das script mit rootrechten ausgeführt wird:  
if [[ $EUID = 0 && "$(ps -o comm= | grep su | sed -n '1p')" = "su" ]]; then
   echo "This script must be run as root" 
   exit 1
fi




##########################################################
# user anlegen, der nicht root ist und den Dienst betreiben soll
useradd	-m -G users -s /bin/bash $SVWS_USER
echo -e '$SVWS_PW
$SVWS_PW
' | passwd $SVWS_USER

# kopiere die install.conf.sh in das Installationsverzeichnis für späteren Aufruf
# lege installationsverzeichnis an 
mkdir $INST_PATH
cd $INST_PATH


############################################
# upgrade und installiere die folgenden Pakete:

apt update -y
apt dist-upgrade -y

apt install ssh nmap curl git zip net-tools dnsutils software-properties-common dirmngr -y

# Maria DB (mind.) 10.6  unter debain 11 installieren: 
wget https://mariadb.org/mariadb_release_signing_key.asc
chmod -c 644 mariadb_release_signing_key.asc
mv -vi mariadb_release_signing_key.asc /etc/apt/trusted.gpg.d/

echo "deb [arch=amd64,arm64,ppc64el] https://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.6/debian bullseye main" | tee /etc/apt/sources.list.d/mariadb.list

apt update
apt install mariadb-server -y 

# Java (mind. 17) unter debain 11 installieren:
apt install openjdk-17-jdk-headless -y

# Path setzen, aktualisieren und dauehaft verfügbar machen:
PATH=/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH
export PATH
echo "JAVA_HOME:/usr/lib/jvm/java-17-openjdk-amd64" >> /etc/environment


# node (mind. 16) installieren
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

apt install nodejs -y
# npm install -g npm@7.20.5



######################################################
# richte die MariaDB ein und setze das root-Passwort

# alte syntax: 
# UPDATE mysql.user SET plugin = 'mysql_native_password', authentication_string = PASSWORD('$SVWS_USER'), Password=PASSWORD('$SVWS_PW') WHERE user = 'root';


echo "
ALTER USER 'root'@'localhost' IDENTIFIED BY '$SVWS_DB_PW';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
" > mysql_secure_installation.sql

mysql < mysql_secure_installation.sql


rm mysql_secure_installation.sql 
#####################################################
# 
#######################################################################
############ SVWS Software abholen ####################################
#######################################################################
# Stelle npm so ein, dass Module auf Benutzerebene installiert werden


echo "prefix=~/.npm" > ~/.npmrc

########### git clone #################################################

cd $INST_PATH



# TODO: git clone auf unserem Gitlab einrichten!!!!
# git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@git.svws-nrw.de/svws/SVWS-Server


git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/FPfotenhauer/SVWS-Server.git


#### token in gradle hinterlegen #############################
mkdir ~/.gradle

cat > ~/.gradle/gradle.properties  <<-EOF
github_actor=$GITHUB_ACTOR
github_token=$GITHUB_TOKEN
schild2_access_password=$SCHILD_PW
EOF


#######################################################################
# Baue den Server
#######################################################################
cd $INST_PATH/SVWS-Server
git checkout dev
./gradlew build
# falls es zu problemen kommt: kann man noch einen zweiten Durchgang machen: 
# ./gradlew svws-core-ts:assemble
# erstelle eine svwsconfig.json für den HTTP-Server mit Standardeinstellungen


cat > $INST_PATH/SVWS-Server/svwsconfig.json <<-EOF
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : null,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 443,
  "UseCORSHeader" : true,
  "TempPath" : "tmp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : "svws-server-app",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "../SVWS-Server/svws-webclient/build/output",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "127.0.0.1",
    "defaultschema" : null,
    "SchemaKonfiguration" : []
  }
}
EOF
# 




########################################################################
# svws als Dienst einrichten:
########################################################################

echo "
[Unit]
Description=SVWS Server

[Service]
User=svws
Type=simple
WorkingDirectory = $INST_PATH/SVWS-Server
ExecStart=/bin/bash $INST_PATH/SVWS-Server/start_server.sh
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target

" > /etc/systemd/system/svws.service


# die richtigen Rechte setzten: 
chown -R svws:svws /app/


########################################################################
# service starten: 
########################################################################
systemctl enable svws
systemctl start svws



################## End des Skripts ###########################
##############################################################
##############################################################

########################################################################
# Nützliche Hinweise:
########################################################################

# manueller Start des SVWS-Server:
#
# cd /$INST_PATH/SVWS-Server/
#./start_server.sh &
#

# im Journal nach Fehlermeldungen suchen: 
#
# journalctl  -f -u svws


# Testdatenbank importieren und Benutzernamen setzen:
#
# zuerst eine mdb "irgendwoher" runterladen
# über die Oberfläche: localhost/debug/