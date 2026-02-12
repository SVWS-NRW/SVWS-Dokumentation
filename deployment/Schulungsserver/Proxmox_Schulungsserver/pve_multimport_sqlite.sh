#!/bin/bash

# --- KONFIGURATION ---
# Standardwert aus .env im Proxmox laden (falls vorhanden)
if [[ -f "$ENV_FILE" ]]; then
    MARIA_DB_PASS=$(grep '^MARIADB_ROOT_PASSWORD=' "$ENV_FILE" | cut -d'=' -f2-)
fi

# Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)  MARIA_DB_PASS="$2"; shift 2 ;; # Überschreibt .env Passwort
        -nr) CONTAINER_ID="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-nr CONTAINER_ID] [-p MARIADB_ROOT_PASSWORD]"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# Pflichtparameter prüfen
if [[ -z "$CONTAINER_ID" ]]; then
    echo "Fehler: Container-ID (-nr) muss angegeben werden."
    exit 1
fi

# Download/Update des Skripts im LXC
pct exec $CONTAINER_ID -- wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/multimport_sqlite.sh

# Ausführung
echo "Konfiguriere Container $CONTAINER_ID..."

if [[ -n "$MARIA_DB_PASS" ]]; then
    echo "Info: MariaDB Passwort gefunden. Übergebe an LXC $CONTAINER_ID..."
    # Wir übergeben das Passwort an das Skript im Container
    pct exec "$CONTAINER_ID" -- bash multimport_sqlite.sh -rp "$MARIA_DB_PASS"
else
    echo "Info: Kein Passwort angegeben. LXC-Skript nutzt eigene .env..."
    pct exec "$CONTAINER_ID" -- bash multimport_sqlite.sh
fi