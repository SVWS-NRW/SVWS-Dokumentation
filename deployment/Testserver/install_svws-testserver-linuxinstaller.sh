#!/bin/bash
#########################################################################################
### Das Skript installiert den SVWS-Servers auf Basis des offiziellen Linuxinstallers ###
#########################################################################################
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
apt install -y unzip git curl net-tools wget jq

# Download des Installers
wget "https://github.com/SVWS-NRW/SVWS-Server/releases/download/v${SVWSVERSION}/install-${SVWSVERSION}.sh"

# Download des SVWS-Servers 
wget -q  https://github.com/SVWS-NRW/SVWS-Server/releases/download/v${SVWSVERSION}/linux-installer-${SVWSVERSION}.tar.gz

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