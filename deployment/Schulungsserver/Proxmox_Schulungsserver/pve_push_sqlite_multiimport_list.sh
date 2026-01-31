#!/bin/bash

# --- KONFIGURATION ---
SOURCE_FILE="$(dirname "$0")/sqlite_db_sources.list"
TARGET_PATH="/root/sqlite_db_sources.list"

# 1. Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -nr) CONTAINER_ID="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 -nr <CONTAINER_ID>"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 2. Pflichtparameter prüfen
if [[ -z "$CONTAINER_ID" ]]; then
    echo "Fehler: Container-ID (-nr) muss angegeben werden."
    exit 1
fi

# 3. Prüfen, ob Quelldatei existiert
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "Fehler: Quelldatei $SOURCE_FILE nicht gefunden!"
    exit 1
fi

# 4. Datei in den Container kopieren
echo "Kopiere $SOURCE_FILE nach LXC $CONTAINER_ID:$TARGET_PATH ..."

if pct push "$CONTAINER_ID" "$SOURCE_FILE" "$TARGET_PATH"; then
    echo "ERFOLG: Datei wurde erfolgreich übertragen."
    
    # Optional: Rechte im Container korrigieren (Sicherheit)
    pct exec "$CONTAINER_ID" -- chmod 644 "$TARGET_PATH"
else
    echo "FEHLER: Übertragung fehlgeschlagen. Existiert der Container $CONTAINER_ID?"
    exit 1
fi