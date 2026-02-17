#!/bin/bash
#########################################################
### Das Skript löscht alle Datenbank des SVWS-Servers ###
#########################################################
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
#########################################################

set -e

SERVERNAME=""
APP_PORT=8443 # (üblicherweise)
MARIADB_ROOT_PASSWORD=""
LOGFILE="svws-update.log"

# Verzeichnis des Skripts ermitteln
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# .env laden, falls vorhanden
ENV_FILE="$SCRIPT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
    echo "Loading .env from $ENV_FILE"
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
fi

# Default-Werte (falls weder .env noch CLI gesetzt)
: "${SERVERNAME:=localhost}"



#################################

echo "Lösche alle Datenbanken" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"

curl --user "root:${MARIADB_ROOT_PW}" -k -s \
  "https://${SERVERNAME}:${APP_PORT}/api/schema/liste/svws" \
  -H 'accept: application/json' \
| jq -r '.[].name' \
| while read -r SCHEMA_NAME; do
    echo "Lösche Schema: ${SCHEMA_NAME}"
    curl --user "root:${MARIADB_ROOT_PASSWORD}" -k -X POST \
      "https://${SERVERNAME}:${APP_PORT}/api/schema/root/destroy/${SCHEMA_NAME}" \
      -H "accept: application/json"
    echo "${SCHEMA_NAME} gelöscht" | tee -a "$LOGFILE"
  done

date | tee -a "$LOGFILE"
echo "Löschvorgang beendet!" | tee -a "$LOGFILE"

