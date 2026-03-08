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

# --- Default-Werte ---
SERVERNAME="localhost"
APP_PORT=8443
MARIADB_ROOT_PASSWORD=""
LOGFILE="svws-delete.log"

# Verzeichnis des Skripts ermitteln
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. .env laden, falls vorhanden
ENV_FILE="$SCRIPT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
    echo "Lade Konfiguration aus $ENV_FILE..."
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
fi

# 2. Kommandozeilen-Parameter parsen (überschreibt .env)
while getopts "p:s:h" opt; do
  case $opt in
    p) MARIADB_ROOT_PASSWORD="$OPTARG" ;;
    s) SERVERNAME="$OPTARG" ;;
    h) 
       echo "Nutzung: $0 [-p PASSWORT] [-s SERVERNAME]"
       echo "  -p  Passwort für den root-User des SVWS-Servers"
       echo "  -s  Hostname des Servers (Standard: localhost)"
       exit 0
       ;;
    *) echo "Ungültige Option. Nutze -h für Hilfe." >&2; exit 1 ;;
  esac
done

# 3. Credential-Check
if [[ -z "$MARIADB_ROOT_PASSWORD" ]]; then
    echo "#######################################################################"
    echo " FEHLER: Kein Passwort für den SVWS-Server gefunden!"
    echo "#######################################################################"
    echo ""
    echo "Bitte gib das Passwort auf eine der folgenden Arten an:"
    echo ""
    echo " 1. Per Parameter beim Aufruf:"
    echo "    $0 -p DEIN_PASSWORT"
    echo ""
    echo " 2. In der .env Datei im Verzeichnis $SCRIPT_DIR:"
    echo "    MARIADB_ROOT_PASSWORD=DEIN_PASSWORT"
    echo ""
    exit 1
fi

# --- Start des Löschvorgangs ---

echo "--------------------------------------------------------"
echo "Starte Löschvorgang auf ${SERVERNAME} am $(date)" | tee -a "$LOGFILE"
echo "--------------------------------------------------------"

# Abfrage der Schemata-Liste
# Wir speichern das JSON erst zwischen, um jq-Fehler bei falschem Login abzufangen
RESPONSE=$(curl --user "root:${MARIADB_ROOT_PASSWORD}" -k -s \
  "https://${SERVERNAME}:${APP_PORT}/api/schema/liste/svws" \
  -H 'accept: application/json')

# Prüfen, ob die Antwort valides JSON (ein Array) ist
if [[ ! "$RESPONSE" =~ ^\[ ]]; then
    echo "FEHLER: Konnte Schema-Liste nicht abrufen. Eventuell falsches Passwort?" | tee -a "$LOGFILE"
    echo "Server-Antwort: $RESPONSE" | tee -a "$LOGFILE"
    exit 1
fi

# Schemata extrahieren
SCHEMATA=$(echo "$RESPONSE" | jq -r '.[].name' 2>/dev/null)

if [[ -z "$SCHEMATA" ]]; then
    echo "Keine Datenbank-Schemata zum Löschen gefunden." | tee -a "$LOGFILE"
else
    for SCHEMA_NAME in $SCHEMATA; do
        echo "Lösche Schema: ${SCHEMA_NAME}..." | tee -a "$LOGFILE"
        
        # Lösch-Befehl absenden und HTTP-Statuscode prüfen
        HTTP_CODE=$(curl --user "root:${MARIADB_ROOT_PASSWORD}" -k -s -o /dev/null -w "%{http_code}" -X POST \
          "https://${SERVERNAME}:${APP_PORT}/api/schema/root/destroy/${SCHEMA_NAME}" \
          -H "accept: application/json")

        if [[ "$HTTP_CODE" == "203" ]]; then
            echo "[OK] ${SCHEMA_NAME} erfolgreich gelöscht." | tee -a "$LOGFILE"
        else
            echo "[FEHLER] Schema ${SCHEMA_NAME} konnte nicht gelöscht werden (HTTP-Status: $HTTP_CODE)." | tee -a "$LOGFILE"
        fi
    done
fi

echo "--------------------------------------------------------"
echo "Löschvorgang beendet um $(date)!" | tee -a "$LOGFILE"
echo "Details finden Sie in $LOGFILE"