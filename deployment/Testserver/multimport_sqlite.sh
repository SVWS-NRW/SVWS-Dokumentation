#!/bin/bash

set -e

# Verzeichnis des Skripts ermitteln
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# .env laden, falls vorhanden
ENV_FILE="$SCRIPT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
    echo "Loading .env from $ENV_FILE"
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
fi

# Default-Werte (falls weder .env noch CLI gesetzt)
: "${SERVERNAME:=localhost}"



usage() {
    echo "Usage: $0 -rp <MARIADB_ROOT_PW> -u <SCHEMA_USER> -p <SCHEMA_PW> -s <SERVERNAME>"
    exit 1
}

# CLI-Argumente (überschreiben .env)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -rp)
            MARIADB_ROOT_PW="$2"
            shift 2
            ;;
        -u)
            SCHEMA_USER="$2"
            shift 2
            ;;
        -p)
            SCHEMA_PW="$2"
            shift 2
            ;;
        -s)
            SERVERNAME="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Pflichtparameter prüfen
if [[ -z "$SCHEMA_USER" || -z "$SCHEMA_PW" ]]; then
    SCHEMA_USER=svwsadmin
    SCHEMA_PW=svwsadmin
    echo "Achtung: unsicheres Passwort für die Schulungsdatebank gesetzt: svwsadmin. "
    echo "Achtung: Bitte nach der Schulung löschen! "
    usage
fi
# Pflichtparameter prüfen
if [[ -z "$MARIADB_ROOT_PW" ]]; then
    echo "Error: Maria DB Root Passwort muss übermittelt werden "
    usage
fi



# Pflichtparameter prüfen
if [[ -z "$MARIADB_ROOT_PW" || -z "$SCHEMA_USER" || -z "$SCHEMA_PW" || -z "$SERVERNAME" ]]; then
    echo "Error: Missing required configuration"
    usage
fi


echo "Importiere SQLITE Datenbanken" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"
echo "Servername:  $SERVERNAME" | tee -a "$LOGFILE"
echo "Schema User: $SCHEMA_USER" | tee -a "$LOGFILE"



# Prüfen, ob die Liste existiert
if [[ ! -f "$LISTFILE" ]]; then
  echo "Fehler: Datei $LISTFILE nicht gefunden!" | tee -a "$LOGFILE"
  exit 1
fi

while read -r DBNAME DB_PATH; do
  # Leere Zeilen oder Kommentare überspringen
  [[ -z "$DBNAME" || "$DBNAME" == \#* ]] && continue

  # Prüfen, ob die SQLite-Datei existiert
  if [[ ! -f "$DB_PATH" ]]; then
    echo "WARNUNG: Datei $DB_PATH nicht gefunden – überspringe $DBNAME" | tee -a "$LOGFILE"
    continue
  fi

  echo "Importiere Datenbank $DBNAME aus $DB_PATH ..." | tee -a "$LOGFILE"

  curl --user "root:${MARIADB_ROOT_PW}" -k -X POST \
    "https://${SERVERNAME}:${PORT}/api/schema/root/import/sqlite/${DBNAME}" \
    -H 'accept: application/json' \
    -H 'Content-Type: multipart/form-data' \
    -F "database=@${DB_PATH}" \
    -F "schemaUsername=${SCHEMA_USER}" \
    -F "schemaUserPassword=${SCHEMA_PW}"

  if [[ $? -eq 0 ]]; then
    echo "$DBNAME importiert" | tee -a "$LOGFILE"
    date | tee -a "$LOGFILE"
  else
    echo "FEHLER beim Import von $DBNAME" | tee -a "$LOGFILE"
  fi

  echo "----------------------------------------" | tee -a "$LOGFILE"

done < "$LISTFILE"

echo "Import SQLITE Datenbanken beendet" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"