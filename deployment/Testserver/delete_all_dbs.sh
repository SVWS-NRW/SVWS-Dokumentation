#!/bin/bash

# Variablen initialisieren
SERVERNAME=""
PORT=8443 # (üblicherweise)
MYSQLROOTPW=""

LOGFILE="svws-update.log"
#################################

echo "Lösche alle Datenbanken" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"

curl --user "root:${MYSQLROOTPW}" -k -s \
  "https://${SERVERNAME}:${PORT}/api/schema/liste/svws" \
  -H 'accept: application/json' \
| jq -r '.[].name' \
| while read -r SCHEMA_NAME; do
    echo "Lösche Schema: ${SCHEMA_NAME}"
    curl --user "root:${MYSQLROOTPW}" -k -X POST \
      "https://${SERVERNAME}:${PORT}/api/schema/root/destroy/${SCHEMA_NAME}" \
      -H "accept: application/json"
    echo "${SCHEMA_NAME} gelöscht" | tee -a "$LOGFILE"
  done

date | tee -a "$LOGFILE"
echo "Löschvorgang beendet!" | tee -a "$LOGFILE"

