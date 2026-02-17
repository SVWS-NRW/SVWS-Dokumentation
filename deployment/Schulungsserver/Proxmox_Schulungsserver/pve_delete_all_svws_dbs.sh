#!/bin/bash
########################################################################
### Das Skript löscht alle SVWS-Datenbanken auf den angegebenen LXCs ###
########################################################################
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
#########################################################################


# Standard-Dateiname für Umgebungsvariablen
ENV_FILE=".env"

# 1. .env Datei robust laden
if [[ -f "$ENV_FILE" ]]; then
    echo "Lade Konfiguration aus $ENV_FILE..."
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        # Ignoriere Kommentare und leere Zeilen
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue

        # Entferne Inline-Kommentare und trimme Leerzeichen
        value=$(echo "$value" | cut -d'#' -f1 | xargs)
        export "$key=$value"
    done < "$ENV_FILE"
fi

# 2. Parameter einlesen (Überschreibt Werte aus der .env)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p) MARIADB_ROOT_PASSWORD="$2"; shift 2 ;;
        -nr) SNR="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-p MARIADB_ROOT_PASSWORD] [-nr SNR] "
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 3. Pflichtparameter prüfen
if [[ -z "$CONTAINER_ID" ]] || [[ -z "$MARIADB_ROOT_PASSWORD" ]]; then
    echo "Fehler: Container-Nummer (-nr) und das Mariadb-Root-Passwort(-p) müssen angegeben werden. Ggf über die .env Datei."
    exit 1
fi

# 4. Passwort fallback
if [[ -z "$SCHEMA_PW" ]]; then
    SCHEMA_PW=svwsadmin
    SCHEMA_USER=svwsadmin
    echo "unsicheres Passwort für die Schulungsdatenbank wurde gesetzt: svwsadmin"
    echo "Bitte nach der Schulung die Datenbanken löschen."
fi

echo "Konfiguriere Container $CONTAINER_ID..."

# -----------------------------------------------------------
# Befehle im Proxmox Container ausführen
# -----------------------------------------------------------

# update Skriptversion
pct exec $CONTAINER_ID -- wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/delete_all_svws_dbs.sh 


# Installer ausführen
pct exec $CONTAINER_ID -- bash  delete_all_svws_dbs.sh  -p "$MARIADB_ROOT_PASSWORD" -