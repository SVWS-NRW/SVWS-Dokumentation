#!/bin/bash
############################################
#### Installationvariablen festlegen #######
SERVERNAME=nightly.example.com
PORT=8443
MYSQLROOTPW=
BRANCH=dev
TEMURINVERSION=temurin-21-jdk
SERVERMODE=develop
############################################

# Softwarequellen einbinden & Softwareupdate
apt update && apt upgrade -y
apt install -y sudo wget apt-transport-https gpg
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt update
apt install -y git zip ${TEMURINVERSION} mariadb-server

# MariaDB Server konfigurieren
echo "
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQLROOTPW}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
" > mysql_secure_installation.sql
mysql < mysql_secure_installation.sql

# user svws einrichten
useradd	-m -G users -s /bin/bash svws

# SVWS-Server Quellen einrichten und Server bauen
mkdir -p /app/
chmod 777 /app
cd /app/
sudo -u svws git clone https://github.com/SVWS-NRW/SVWS-Server
cd /app/SVWS-Server
sudo -u svws git switch ${BRANCH}
./gradlew build
chown -R svws:svws /app/SVWS-Server

## Server einrichten
# keystore PW generieren
LENGTH=12
CHARS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
PASSWORD1=$(head /dev/urandom | tr -dc $CHARS | fold -w $LENGTH | head -n 1)

keytool -genkey -noprompt -alias svws -dname "CN=test, OU=svws, O=svws, L=svws, S=NRW, C=DE" -keystore /app/SVWS-Server/keystore/keystore -storepass ${PASSWORD1} -keypass ${PASSWORD1} -keyalg RSA

# svwsconfig.json erstellen
cp /app/SVWS-Server/svws-server-app/src/main/resources/svwsconfig.json.example /app/SVWS-Server/svws-server-app/svwsconfig.json
# svwsconfig Eintragungen anpassen
sed -i \
  -e 's/"PortHTTPS"[[:space:]]*:[[:space:]]*null/"PortHTTPS" : '"$PORT"'/' \
  -e 's/"ServerMode"[[:space:]]*:[[:space:]]*"[^"]*"/"ServerMode" : "'"${SERVERMODE}"'"/' \
  -e 's/"TLSKeystorePassword"[[:space:]]*:[[:space:]]*"[^"]*"/"TLSKeystorePassword" : "'"${PASSWORD1}"'"/' \
  -e 's/"defaultschema"[[:space:]]*:[[:space:]]*"[^"]*"/"defaultschema" : null/' \
  -e '/"SchemaKonfiguration"[[:space:]]*:/,/]/c\    "SchemaKonfiguration" : [],' \
  /app/SVWS-Server/svws-server-app/svwsconfig.json

# SVWS-Server als Dienst einrichten
chown -R svws:svws /app/SVWS-Server/


#Erstelle eine Datei zur Beschreibung und Bedienung des Dienstes per systemd:

echo "
[Unit]
Description=SVWS Server

[Service]
User=svws
Type=simple
WorkingDirectory = /app/SVWS-Server/svws-server-app
ExecStart=/bin/bash /app/SVWS-Server/svws-server-app/start_server.sh
Restart=on-failure 	# optional-auskommentieren, wenn gewünscht
RestartSec=5s 		# optional-auskommentieren, wenn gewünscht
StandardOutput=journal

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/svws.service


# Den Dienst nun noch fest einbinden, so dass er beim Neustart gestartet wird: 
systemctl enable svws
# Nun noch den Server folgenden Befehlen starten:

systemctl start svws
