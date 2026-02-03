#!/bin/bash

# --- KONFIGURATION ---
# Die Quelldatei liegt im selben Verzeichnis wie das Skript
SOURCE_FILE="$(dirname "$0")/sqlite_db_sources.list"
# Zielpfad innerhalb des Docker-Containers
TARGET_PATH="/opt/app/svws/sqlite_db_sources.list"

# 1. Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -nr) CONTAINER_NAME_OR_ID="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 -nr <CONTAINER_NAME_OR_ID>"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 2. Pflichtparameter prüfen
if [[ -z "$CONTAINER_NAME_OR_ID" ]]; then
    echo "Fehler: Container-Name oder ID (-nr) muss angegeben werden."
    exit 1
fi

# 3. Prüfen, ob Quelldatei lokal existiert
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "Fehler: Quelldatei $SOURCE_FILE nicht gefunden!"
    exit 1
fi

# 4. Prüfen, ob der Docker-Container läuft
if ! docker ps --format '{{.Names}} {{.ID}}' | grep -q "$CONTAINER_NAME_OR_ID"; then
    echo "Fehler: Docker-Container '$CONTAINER_NAME_OR_ID' läuft nicht oder existiert nicht."
    exit 1
fi

# 5. Datei in den Docker-Container kopieren
echo "Kopiere $SOURCE_FILE nach Docker-Container $CONTAINER_NAME_OR_ID:$TARGET_PATH ..."

if docker cp "$SOURCE_FILE" "$CONTAINER_NAME_OR_ID:$TARGET_PATH"; then
    echo "ERFOLG: Datei wurde erfolgreich übertragen."
    
    # Optional: Rechte im Container anpassen
    # Wir nutzen 'docker exec', um den Befehl im Container auszuführen
    docker exec -u root "$CONTAINER_NAME_OR_ID" chmod 644 "$TARGET_PATH"
else
    echo "FEHLER: Übertragung fehlgeschlagen."
    exit 1
fi