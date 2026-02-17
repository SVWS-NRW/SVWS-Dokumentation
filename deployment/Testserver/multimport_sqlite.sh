#!/bin/bash
##################################################################################################
### Das Skript importiert die in der sqlite_db_sources.list angegebenen DBs in den SVWS-Server ###
##################################################################################################
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
##################################################################################################

# Example: sqlite_db_sources.list
# /app/SVWS-Testdaten/Testdaten_GY.sqlite https://github.com/SVWS-NRW/SVWS-TestMDBs/raw/refs/heads/main/GOST_Abitur/Abi-Test-Daten-04/Gym_22_23_1.sqlite
# /app/SVWS-Testdaten/Testdaten_G.sqlite https://github.com/SVWS-NRW/SVWS-TestMDBs/raw/refs/heads/main/Grundschule/Grundschule_Stundenplan.sqlite
# /app/SVWS-Testdaten/Testdaten_GE.sqlite https://github.com/SVWS-NRW/SVWS-TestMDBs/raw/refs/heads/main/GE_Prognose/GEPrognose.sqlite


set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. .env laden
ENV_FILE="$SCRIPT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
    echo "Info: Konfiguration aus .env geladen."
else
    echo "Warnung: .env Datei nicht gefunden."
fi

# 2. Default-Werte & Mapping (Nutzt Werte aus .env falls vorhanden)
: "${SERVERNAME:=localhost}"
: "${PORT:=${APP_PORT:-8443}}"
: "${LISTFILE:=$SCRIPT_DIR/sqlite_db_sources.list}"
: "${LOGFILE:=$SCRIPT_DIR/svws-update.log}"
: "${SCHEMA_USER:=svwsadmin}"
: "${MARIADB_ROOT_PW:=$MARIADB_ROOT_PASSWORD}"

# Generiere zufälliges Passwort für die Schemata, falls nicht gesetzt
if [[ -z "$SCHEMA_PW" ]]; then
    SCHEMA_PW=$(openssl rand -base64 12)
    echo "Info: Kein SCHEMA_PW gefunden. Generiere temporäres Passwort: $SCHEMA_PW"
fi

usage() {
    echo "Usage: $0 [-rp <MARIADB_ROOT_PW>] [-s <SERVERNAME>] [-p <PORT>]"
    echo "Falls das Passwort in der .env steht, ist -rp optional."
    exit 1
}

# 3. CLI-Argumente (überschreiben die .env Werte)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -rp) MARIADB_ROOT_PW="$2"; shift 2 ;;
        -s)  SERVERNAME="$2"; shift 2 ;;
        -p)  PORT="$2"; shift 2 ;;
        *)   usage ;;
    esac
done

# 4. Validierung
if [[ -z "$MARIADB_ROOT_PW" ]]; then
    echo "Error: MariaDB Root Passwort ist nicht gesetzt (weder in .env noch per -rp)."
    usage
fi

# 5. Import-Logik
{
    echo "===================================================="
    echo "Start SVWS Import: $(date)"
    echo "Ziel-Server: $SERVERNAME:$PORT"
    echo "===================================================="

    if [[ ! -f "$LISTFILE" ]]; then
        echo "Fehler: Liste $LISTFILE nicht gefunden!"
        exit 1
    fi

    while read -r TARGET_PATH DOWNLOAD_URL || [[ -n "$TARGET_PATH" ]]; do
        # Überspringe leere Zeilen und Kommentare
        [[ -z "$TARGET_PATH" || "$TARGET_PATH" == \#* ]] && continue

        # Verzeichnis-Check
        TARGET_DIR=$(dirname "$TARGET_PATH")
        if [[ ! -d "$TARGET_DIR" ]]; then
            echo "Erstelle Verzeichnis: $TARGET_DIR"
            mkdir -p "$TARGET_DIR"
        fi

        # Download mit wget
        echo "Prüfe Download: $DOWNLOAD_URL"
        wget -N -O "$TARGET_PATH" "$DOWNLOAD_URL" || { echo "Download fehlgeschlagen!"; continue; }

        # Schema-Name aus Dateiname extrahieren
        DB_SCHEMA_NAME=$(basename "$TARGET_PATH" .sqlite)

        echo "Importiere Schema '$DB_SCHEMA_NAME' nach MariaDB..."

        # API-Call
        HTTP_CODE=$(curl --user "root:${MARIADB_ROOT_PW}" -k -s -o /dev/null -w "%{http_code}" \
            -X POST "https://${SERVERNAME}:${PORT}/api/schema/root/import/sqlite/${DB_SCHEMA_NAME}" \
            -H 'accept: application/json' \
            -H 'Content-Type: multipart/form-data' \
            -F "database=@${TARGET_PATH}" \
            -F "schemaUsername=${SCHEMA_USER}" \
            -F "schemaUserPassword=${SCHEMA_PW}")

        if [[ "$HTTP_CODE" == "200" ]]; then
            echo "ERFOLG: $DB_SCHEMA_NAME importiert."
        elif [[ "$HTTP_CODE" == "401" ]]; then
            echo "FEHLER: Authentifizierung fehlgeschlagen (Root Passwort falsch?)."
        else
            echo "FEHLER: $DB_SCHEMA_NAME fehlgeschlagen (HTTP Status: $HTTP_CODE)."
        fi
        echo "------------------------------------------------"

    done < "$LISTFILE"

    echo "=== Import beendet: $(date) ==="
} | tee -a "$LOGFILE"