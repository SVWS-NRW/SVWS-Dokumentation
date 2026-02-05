#!/bin/bash

# --- KONFIGURATION ---
ENV_FILE=".env"
CONTAINER_NAME=""
MARIA_DB_PASS=""
DB_NAME=""
COUNT=""

# 1. Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)  MARIA_DB_PASS="$2"; shift 2 ;; 
        -nr) CONTAINER_NAME="$2"; shift 2 ;;
        -d)  DB_NAME="$2"; shift 2 ;;
        -n)  COUNT="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 -nr CONTAINER_NAME -d DB_NAME -n COUNT [-p MARIADB_ROOT_PASSWORD]"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 2. Pflichtparameter prüfen
if [[ -z "$CONTAINER_NAME" || -z "$DB_NAME" || -z "$COUNT" ]]; then
    echo "Fehler: Die Parameter -nr (Container), -d (Datenbankname) und -n (Anzahl) sind erforderlich."
    echo "Nutzen Sie -h für die Hilfe."
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


# 5. Download/Update des Skripts im Docker-Container
echo "Bereite Skript im Container vor..."
docker exec -u root "$CONTAINER_NAME" bash -c "
    which wget > /dev/null || (apt-get update && apt-get install -y wget);
    which jq > /dev/null || (apt-get update && apt-get install -y jq);
    which mysqldump > /dev/null || (apt-get update && apt-get install -y mariadb-client);
    wget -q -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/clone_db.sh;
"


# 6. Ausführung
if [[ -n "$MARIA_DB_PASS" ]]; then
    echo "Info: MariaDB Passwort gefunden. Starte Klonen für Datenbank '$DB_NAME' ($COUNT Instanzen)..."
    docker exec "$CONTAINER_NAME" bash clone_db.sh -d "$DB_NAME" -n "$COUNT" -p "$MARIA_DB_PASS" 
else
    echo "Info: Kein Passwort gefunden. Versuche Ausführung mit internen Variablen..."
    docker exec "$CONTAINER_NAME" bash clone_db.sh -d "$DB_NAME" -n "$COUNT"
fi