#!/bin/bash

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
        -) SVWSVERSION="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-p MARIADB_ROOT_PASSWORD] [-nr SNR]"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 3. Pflichtparameter prüfen
if [[ -z "$SNR" ]] || [[ -z "$SVWSVERSION" ]]; then
    echo "Fehler: Container-Nummer (-nr) und SVWS-Version (-v) müssen angegeben werden."
    exit 1
fi

# 4. Passwort fallback
if [[ -z "$SCHEMA_PW" ]]; then
    SCHEMA_PW=svwsadmin
    SCHEMA_USER=svwsadmin
    echo "unsicheres Passwort für die Schulungsdatenbank wurde gesetzt: svwsadmin"
    echo "Bitte nach der Schulung die Datenbanken löschen."
fi

echo "Konfiguriere Container $SNR..."

# -----------------------------------------------------------
# Befehle im Proxmox Container ausführen
# -----------------------------------------------------------

# Download / update  des Skripts
pct exec $SNR -- wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/multimport_sqlite.sh 



# multiimport ausführen
pct exec $SNR -- bash install_svws-testserver-linuxinstaller.sh -p "$ROOTPW" -v "$SVWSVERSION"

echo "Installation abgeschlossen."