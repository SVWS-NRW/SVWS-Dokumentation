#!/bin/bash
########################################################################################
### Das Skript installiert den SVWS-Servers auf Basis des angegebene Github Branches ###
########################################################################################

# Hilfe-Funktion
usage() {
  echo "Usage: $0 [-p <mysql_root_pw>] -b <branch> -m <servermode>"
  echo "  -p    Passwort für den MariaDB Root-User (optional, sonst Zufallsgenerierung)"
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

# Prüfen, ob Pflicht-Variablen gesetzt sind
if [ -z "$BRANCH" ] || [ -z "$SERVERMODE" ]; then
  echo "Fehler: Die Parameter -b (Branch) und -m (Mode) sind Pflicht."
  usage
fi

# Passwort generieren, falls nicht angegeben
if [ -z "$MYSQLROOTPW" ]; then
    GENERATED_PW=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 16)
    MYSQLROOTPW="$GENERATED_PW"
    PW_WAS_GENERATED=true
else
    PW_WAS_GENERATED=false
fi

TEMURINVERSION=temurin-21-jdk
PORT=8443

############################################
# Softwarequellen einbinden & Softwareupdate
apt update && apt upgrade -y
apt install -y sudo wget apt-transport-https gpg git zip mariadb-server

# Java (Adoptium) Setup
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt update
apt install -y ${TEMURINVERSION}

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
chown svws:svws /app
cd /app/
sudo -u svws git clone https://github.com/SVWS-NRW/SVWS-Server
cd /app/SVWS-Server
sudo -u svws git switch ${BRANCH}

# Build ohne Tests, inklusive explizitem OpenAPI-Schritt für Stabilität
sudo -u svws ./gradlew :svws-openapi:assembleTranspiled assemble -x test

## Server einrichten
# keystore PW generieren
PASSWORD1=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 12)
sudo -u svws keytool -genkey -noprompt -alias svws -dname "CN=test, OU=svws, O=svws, L=svws, S=NRW, C=DE" -keystore /app/SVWS-Server/svws-server-app/keystore -storepass ${PASSWORD1} -keypass ${PASSWORD1} -keyalg RSA -validity 1000

# svwsconfig.json erstellen
cp /app/SVWS-Server/svws-server-app/src/main/resources/svwsconfig.json.example /app/SVWS-Server/svws-server-app/svwsconfig.json

# svwsconfig Eintragungen anpassen
sed -i \
  -e '/"PrivilegedDatabaseUser"[[:space:]]*:[[:space:]]*"root",/d' \
  -e 's|"PortHTTPS"[[:space:]]*:[[:space:]]*null|"PortHTTPS" : '"$PORT"'|' \
  -e 's|"ServerMode"[[:space:]]*:[[:space:]]*"[^"]*"|"ServerMode" : "'"${SERVERMODE}"'"|' \
  -e 's|"TLSKeystorePassword"[[:space:]]*:[[:space:]]*"[^"]*"|"TLSKeystorePassword" : "'"${PASSWORD1}"'"|' \
  -e 's|"defaultschema"[[:space:]]*:[[:space:]]*"[^"]*"|"defaultschema" : null|' \
  -e 's|"ClientPath"[[:space:]]*:[[:space:]]*"[^"]*"|"ClientPath" : "/app/SVWS-Server/svws-webclient/client/build/output"|' \
  -e 's|"AdminClientPath"[[:space:]]*:[[:space:]]*"[^"]*"|"AdminClientPath" : "/app/SVWS-Server/svws-webclient/admin/build/output"|' \
  -e '/"SchemaKonfiguration"[[:space:]]*:/,/]/c\    "SchemaKonfiguration" : [],' \
  /app/SVWS-Server/svws-server-app/svwsconfig.json
  
# SVWS-Server als Dienst einrichten
chown -R svws:svws /app/SVWS-Server/

echo "[Unit]
Description=SVWS Server
After=network.target mariadb.service

[Service]
User=svws
Type=simple
WorkingDirectory=/app/SVWS-Server/svws-server-app
ExecStart=/bin/bash /app/SVWS-Server/svws-server-app/start_server.sh
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/svws.service

systemctl daemon-reload
systemctl enable svws
systemctl start svws

echo "------------------------------------------------"
echo "Installation abgeschlossen."
if [ "$PW_WAS_GENERATED" = true ]; then
    echo "WICHTIG: Das generierte MariaDB-Root-Passwort lautet: $MYSQLROOTPW"
fi
echo "------------------------------------------------"