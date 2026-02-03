#!/bin/bash

# --- KONFIGURATION ---
ENV_FILE=".env"
CONTAINER_NAME=""
MARIA_DB_PASS=""

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
# a) Falls nicht per Parameter (-p) gesetzt, suche in globaler .env
if [[ -z "$MARIA_DB_PASS" && -f "$ENV_FILE" ]]; then
    MARIA_DB_PASS=$(grep '^MARIADB_ROOT_PASSWORD=' "$ENV_FILE" | cut -d'=' -f2-)
fi

# b) Falls immer noch leer, prüfe Unterordner (CONTAINER_NAME)
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

# 5. Download/Update des Skripts im Docker-Container
echo "Bereite Skript im Container vor..."
docker exec -u root "$CONTAINER_NAME" bash -c "which wget > /dev/null || (apt-get update && apt-get install -y wget); wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/multimport_sqlite.sh"
 
# 6. Ausführung - Servername und Port fix auf localhost:8443 setzen weg Dockerumgebung
if [[ -n "$MARIA_DB_PASS" ]]; then
    echo "Info: MariaDB Passwort gefunden. Starte Import..."
    docker exec "$CONTAINER_NAME" bash multimport_sqlite.sh -rp "$MARIA_DB_PASS" -s localhost -p 8443
else
    echo "Info: Kein Passwort gefunden. Nutze interne Variablen..."
    docker exec "$CONTAINER_NAME" bash multimport_sqlite.sh -s localhost -p 8443
fi