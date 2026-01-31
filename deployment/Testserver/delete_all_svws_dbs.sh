#!/bin/bash

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

