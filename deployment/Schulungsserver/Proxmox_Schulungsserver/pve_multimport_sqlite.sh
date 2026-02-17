#!/bin/bash
####################################################################################
### Das Skript importiert mehrere Datenbanken auf dem angegebenen SVWS-LXC       ###
####################################################################################
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
######################################################################################


# --- KONFIGURATION ---
ENV_FILE=".env"
# Standardzielpfad im Container für die Liste
TARGET_PATH_IN_LXC="/root/sqlite_db_sources.list"

# MariaDB-Passwort aus lokaler .env laden (falls vorhanden)
if [[ -f "$ENV_FILE" ]]; then
    MARIA_DB_PASS=$(grep '^MARIADB_ROOT_PASSWORD=' "$ENV_FILE" | cut -d'=' -f2-)
fi

# --- PARAMETER EINLESEN ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)  MARIA_DB_PASS="$2"; shift 2 ;; 
        -nr) CONTAINER_ID="$2"; shift 2 ;;
        -l)  SQLITE_DB_SOURCE_LIST="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 -nr <CONTAINER_ID> [-p <MARIADB_PASS>] [-l <SQLITE_DB_SOURCE_LIST>]"
            echo ""
            echo "Optionen:"
            echo "  -nr  ID des Proxmox Containers (LXC)"
            echo "  -p   MariaDB Root Passwort (optional, überschreibt .env)"
            echo "  -l   Pfad zur lokalen .list Datei mit DB-Quellen (optional)"
            exit 0
            ;;
        *) echo "Fehler: Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# --- VALIDIERUNG ---
if [[ -z "$CONTAINER_ID" ]]; then
    echo "Fehler: Container-ID (-nr) muss angegeben werden."
    exit 1
fi

# --- OPTIONAL: SQLITE LISTE ÜBERTRAGEN ---
if [[ -n "$SQLITE_DB_SOURCE_LIST" ]]; then
    if [[ -f "$SQLITE_DB_SOURCE_LIST" ]]; then
        echo "Info: Kopiere Quellenliste $SQLITE_DB_SOURCE_LIST nach LXC $CONTAINER_ID..."
        if pct push "$CONTAINER_ID" "$SQLITE_DB_SOURCE_LIST" "$TARGET_PATH_IN_LXC"; then
            pct exec "$CONTAINER_ID" -- chmod 644 "$TARGET_PATH_IN_LXC"
            echo "ERFOLG: Liste wurde übertragen."
        else
            echo "FEHLER: Übertragung der Liste fehlgeschlagen!"
            exit 1
        fi
    else
        echo "Fehler: Die angegebene Datei '$SQLITE_DB_SOURCE_LIST' wurde nicht gefunden!"
        exit 1
    fi
fi

# --- VORBEREITUNG IM LXC ---
echo "Update das Import-Skript im LXC $CONTAINER_ID..."
pct exec $CONTAINER_ID -- wget -q -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/multimport_sqlite.sh

# --- AUSFÜHRUNG ---
echo "Starte Import-Prozess in Container $CONTAINER_ID..."

if [[ -n "$MARIA_DB_PASS" ]]; then
    echo "Info: MariaDB Passwort wird übergeben..."
    pct exec "$CONTAINER_ID" -- bash multimport_sqlite.sh -rp "$MARIA_DB_PASS"
else
    echo "Info: Kein Passwort angegeben. LXC-Skript nutzt interne Konfiguration..."
    pct exec "$CONTAINER_ID" -- bash multimport_sqlite.sh
fi