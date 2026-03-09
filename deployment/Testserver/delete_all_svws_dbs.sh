#!/bin/bash
###########################################################
### Das Skript löscht alle Datenbanken des SVWS-Servers ###
###########################################################
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

# --- 0. Abhängigkeiten prüfen (jq) ---
if ! command -v jq &> /dev/null; then
    echo "HINWEIS: 'jq' ist nicht installiert. Versuche Installation..."
    if [ "$EUID" -ne 0 ]; then
        echo "FEHLER: 'jq' fehlt und ich habe keine Root-Rechte zur Installation."
        echo "Bitte manuell installieren: sudo apt-get update && sudo apt-get install -y jq"
        exit 1
    fi
    apt-get update && apt-get install -y jq
fi

# --- 1. Default-Werte & Konfiguration ---
SERVERNAME="localhost"
APP_PORT=8443
MARIADB_ROOT_PASSWORD=""
LOGFILE="svws-delete.log"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ -f "$ENV_FILE" ]]; then
    echo "Lade Konfiguration aus $ENV_FILE..."
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
fi

# Parameter parsen
while getopts "p:s:h" opt; do
  case $opt in
    p) MARIADB_ROOT_PASSWORD="$OPTARG" ;;
    s) SERVERNAME="$OPTARG" ;;
    h) 
       echo "Nutzung: $0 [-p PASSWORT] [-s SERVERNAME]"
       exit 0
       ;;
    *) exit 1 ;;
  esac
done

if [[ -z "$MARIADB_ROOT_PASSWORD" ]]; then
    echo "FEHLER: Kein Passwort angegeben! Nutze -p oder die .env Datei."
    exit 1
fi

# --- 2. Start des Löschvorgangs ---

echo "--------------------------------------------------------"
echo "Starte Löschvorgang auf ${SERVERNAME} am $(date)" | tee -a "$LOGFILE"
echo "--------------------------------------------------------"

# Abfrage der Schemata-Liste
RESPONSE=$(curl --user "root:${MARIADB_ROOT_PASSWORD}" -k -s \
  "https://${SERVERNAME}:${APP_PORT}/api/schema/liste/svws" \
  -H 'accept: application/json')

# Prüfen, ob die Antwort valides JSON (ein Array) ist
if [[ ! "$RESPONSE" =~ ^\[ ]]; then
    echo "FEHLER: Konnte Schema-Liste nicht abrufen. Antwort war kein JSON-Array." | tee -a "$LOGFILE"
    echo "Server-Antwort: $RESPONSE" | tee -a "$LOGFILE"
    exit 1
fi

# Schemata extrahieren (Dank 'jq -r' erhalten wir reine Strings ohne Anführungszeichen)
SCHEMATA=$(echo "$RESPONSE" | jq -r '.[] | .name' 2>/dev/null)

if [[ -z "$SCHEMATA" || "$SCHEMATA" == "null" ]]; then
    echo "Keine Datenbank-Schemata zum Löschen gefunden." | tee -a "$LOGFILE"
else
    for SCHEMA_NAME in $SCHEMATA; do
        [[ -z "$SCHEMA_NAME" ]] && continue
        
        echo "Lösche Schema: ${SCHEMA_NAME}..." | tee -a "$LOGFILE"
        
        # Lösch-Befehl absenden
        # Wir akzeptieren 200, 202, 203 und 204 als Erfolg
        HTTP_CODE=$(curl --user "root:${MARIADB_ROOT_PASSWORD}" -k -s -o /dev/null -w "%{http_code}" -X POST \
          "https://${SERVERNAME}:${APP_PORT}/api/schema/root/destroy/${SCHEMA_NAME}" \
          -H "accept: application/json")

        if [[ "$HTTP_CODE" =~ ^20[0-4]$ ]]; then
            echo "[OK] ${SCHEMA_NAME} erfolgreich gelöscht (Status: $HTTP_CODE)." | tee -a "$LOGFILE"
        else
            echo "[FEHLER] Schema ${SCHEMA_NAME} fehlgeschlagen (Status: $HTTP_CODE)." | tee -a "$LOGFILE"
        fi
    done
fi

echo "--------------------------------------------------------"
echo "Fertig am $(date)!" | tee -a "$LOGFILE"