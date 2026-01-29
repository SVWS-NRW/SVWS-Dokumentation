#!/bin/bash

# Standard-Hilfefunktion
usage() {
  echo "Usage: $0 -p <password> -v <serverversion>"
  echo "  -p  Passwort für MariaDB und Keystore"
  echo "  -v  SVWS-Server Version (z.B. 1.1.1)"
  exit 1
}

# Parameter auslesen
while getopts "p:v:" opt; do
  case $opt in
    p) PASSWORD="$OPTARG" ;;
    v) SVWSVERSION="$OPTARG" ;;
    *) usage ;;
  esac
done

# Pflichtfelder prüfen
if [ -z "$PASSWORD" ] || [ -z "$SVWSVERSION" ]; then
  echo "Fehler: Passwort (-p) und Version (-v) müssen angegeben werden."
  usage
fi

# System-Updates und Abhängigkeiten
apt update && apt upgrade -y 
apt install -y unzip git curl net-tools wget

# Download des Installers
wget "https://github.com/SVWS-NRW/SVWS-Server/releases/download/v${SVWSVERSION}/install-${SVWSVERSION}.sh"

# Fehlersuche
wget -q  https://github.com/SVWS-NRW/SVWS-Server/releases/download/v1.1.1/linux-installer-1.1.1.tar.gz

# Konfigurationsdatei (.env) erstellen
cat <<EOF > .env
CREATE_MARIADB=j
CREATE_KEYSTORE=j
MARIADB_ROOT_PASSWORD=${PASSWORD}
APP_PATH=/opt/app/svws
CONF_PATH=/etc/app/svws/conf
APP_PORT=8443
SVWS_TLS_KEYSTORE_PATH=/etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD=${PASSWORD}
SVWS_TLS_KEY_ALIAS=svws
INPUT_COMMON_NAME=svws
INPUT_ORGANIZATIONAL_UNIT=svws
INPUT_ORGANIZATION=svws
INPUT_LOCALITY=NRW
INPUT_STATE=NRW
INPUT_COUNTRY=DE
validity_days=3650
EOF

# Installation starten
bash "install-${SVWSVERSION}.sh"