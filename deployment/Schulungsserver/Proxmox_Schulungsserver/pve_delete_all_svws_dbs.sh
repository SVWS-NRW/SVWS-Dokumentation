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
        -p) MARIADB_ROOT_PW="$2"; shift 2 ;;
        -nr) SNR="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-p MARIADB_ROOT_PW] [-nr SNR] "
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 3. Pflichtparameter prüfen
if [[ -z "$SNR" ]] || [[ -z "$MARIADB_ROOT_PW" ]]; then
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

echo "Konfiguriere Container $SNR..."

# -----------------------------------------------------------
# Befehle im Proxmox Container ausführen
# -----------------------------------------------------------

# update Skriptversion
pct exec $SNR -- wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/delete_all_svws_dbs.sh 

# .env im Container sauber neu erstellen (überschreiben mit '>')
pct exec $SNR -- bash -c "echo 'SERVERNAME=$SERVERNAME' > .env"
pct exec $SNR -- bash -c "echo 'PORT=$PORT' >> .env"
pct exec $SNR -- bash -c "echo 'MARIADB_ROOT_PW=$MARIADB_ROOT_PW' >> .env"

# Installer ausführen
pct exec $SNR -- bash  delete_all_svws_dbs.sh  -p "$MARIADB_ROOT_PW"