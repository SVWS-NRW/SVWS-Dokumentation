#!/bin/bash
###########################################################################################
### Das Skript importiert mehrere Datenbanken auf dem angegebenen SVWS-Docker-Container ###
###########################################################################################
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
###########################################################################################

# --- KONFIGURATION ---
ENV_FILE=".env"
CONTAINER_NAME=""
MARIA_DB_PASS=""
# Pfade für die sqlite_db_sources.list
SOURCE_FILE="$(dirname "$0")/sqlite_db_sources.list"
TARGET_PATH="/opt/app/svws/sqlite_db_sources.list"

# 1. Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)  MARIA_DB_PASS="$2"; shift 2 ;; 
        -nr) CONTAINER_NAME="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-nr CONTAINER_NAME] [-p MARIADB_ROOT_PASSWORD]"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 2. Pflichtparameter prüfen
if [[ -z "$CONTAINER_NAME" ]]; then
    echo "Fehler: Container-Name oder ID (-nr) muss angegeben werden."
    exit 1
fi

# 3. Passwort-Logik
if [[ -z "$MARIA_DB_PASS" && -f "$ENV_FILE" ]]; then
    MARIA_DB_PASS=$(grep '^MARIADB_ROOT_PASSWORD=' "$ENV_FILE" | cut -d'=' -f2-)
fi

if [[ -z "$MARIA_DB_PASS" ]]; then
    if [[ -d "$CONTAINER_NAME" && -f "$CONTAINER_NAME/.env" ]]; then
        echo "Info: Passwort nicht in globaler .env gefunden. Suche in $CONTAINER_NAME/.env..."
        MARIA_DB_PASS=$(grep '^MARIADB_ROOT_PASSWORD=' "$CONTAINER_NAME/.env" | cut -d'=' -f2-)
    fi
fi

# 4. Prüfen, ob der Docker-Container existiert und läuft
CONTAINER_STATUS=$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)

if [[ "$CONTAINER_STATUS" != "true" ]]; then
    echo "Fehler: Der Container '$CONTAINER_NAME' läuft nicht oder existiert nicht."
    exit 1
fi

echo "Check: Container '$CONTAINER_NAME' ist aktiv."

---

# 5. NEU: sqlite_db_sources.list übertragen (falls vorhanden)
if [[ -f "$SOURCE_FILE" ]]; then
    echo "Info: Lokale Quelldatei gefunden. Kopiere nach $CONTAINER_NAME:$TARGET_PATH ..."
    if docker cp "$SOURCE_FILE" "$CONTAINER_NAME:$TARGET_PATH"; then
        docker exec -u root "$CONTAINER_NAME" chmod 644 "$TARGET_PATH"
        echo "ERFOLG: sqlite_db_sources.list wurde übertragen."
    else
        echo "WARNUNG: Übertragung der sqlite_db_sources.list fehlgeschlagen."
    fi
else
    echo "Info: Keine lokale sqlite_db_sources.list gefunden. Überspringe Kopiervorgang."
fi

# 6. Download/Update des Import-Skripts im Docker-Container
echo "Bereite Import-Skript im Container vor..."
docker exec -u root "$CONTAINER_NAME" bash -c "which wget > /dev/null || (apt-get update && apt-get install -y wget); wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/multimport_sqlite.sh"
 
# 7. Ausführung des Imports
if [[ -n "$MARIA_DB_PASS" ]]; then
    echo "Info: MariaDB Passwort gesetzt. Starte Import..."
    docker exec "$CONTAINER_NAME" bash multimport_sqlite.sh -rp "$MARIA_DB_PASS" -s localhost -p 8443
else
    echo "Info: Kein Passwort explizit gesetzt. Nutze interne Variablen des Containers..."
    docker exec "$CONTAINER_NAME" bash multimport_sqlite.sh -s localhost -p 8443
fi