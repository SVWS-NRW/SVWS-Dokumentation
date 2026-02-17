#!/bin/bash
########################################################################################
### Das Skript installiert den SVWS-Servers auf Basis des angegebene Github Branches ###
########################################################################################
#  
# Copyright (c) $(date +%Y)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
########################################################################################

# Hilfe-Funktion
usage() {
  echo "Usage: $0 -p <mysql_root_pw> -b <branch> -m <servermode>"
  echo "  -p    Passwort für den MariaDB Root-User"
  echo "  -b    Git Branch (z.B. dev oder master)"
  echo "  -m    Server Mode (z.B. develop oder production)"
  exit 1
}

# Parameter mit getopts einlesen
while getopts "p:b:m:" opt; do
  case $opt in
    p) MYSQLROOTPW="$OPTARG" ;;
    b) BRANCH="$OPTARG" ;;
    m) SERVERMODE="$OPTARG" ;;
    *) usage ;;
  esac
done

# Prüfen, ob alle Variablen gesetzt sind
if [ z -z "$MYSQLROOTPW" ] || [ -z "$BRANCH" ] || [ -z "$SERVERMODE" ]; then
  echo "Fehler: Alle Parameter (-p, -b, -m) müssen angegeben werden."
  usage
fi

TEMURINVERSION=temurin-21-jdk
PORT=8443

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
rm mysql_secure_installation.sql

# user svws einrichten
if ! id "svws" &>/dev/null; then
    useradd -m -G users -s /bin/bash svws
fi

# SVWS-Server Quellen einrichten und Server bauen
mkdir -p /app/
chmod 777 /app
cd /app/
sudo -u svws git clone https://github.com/SVWS-NRW/SVWS-Server
cd /app/SVWS-Server
sudo -u svws git switch ${BRANCH}
sudo -u svws ./gradlew build
chown -R svws:svws /app/SVWS-Server

## Server einrichten
# keystore PW generieren
LENGTH=12
CHARS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
PASSWORD1=$(head /dev/urandom | tr -dc $CHARS | fold -w $LENGTH | head -n 1)

sudo -u svws keytool -genkey -noprompt -alias svws -dname "CN=test, OU=svws, O=svws, L=svws, S=NRW, C=DE" -keystore /app/SVWS-Server/keystore/keystore -storepass ${PASSWORD1} -keypass ${PASSWORD1} -keyalg RSA

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

echo "[Unit]
Description=SVWS Server

[Service]
User=svws
Type=simple
WorkingDirectory=/app/SVWS-Server/svws-server-app
ExecStart=/bin/bash /app/SVWS-Server/svws-server-app/start_server.sh
Restart=on-failure
RestartSec=5s
StandardOutput=journal

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/svws.service

systemctl daemon-reload
systemctl enable svws
systemctl start svws

echo "Installation abgeschlossen."