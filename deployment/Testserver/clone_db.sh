#!/bin/bash

# --- Dynamische Konfiguration ---
# Liste möglicher Pfade für die svwsconfig.json
POSSIBLE_PATHS=(
    "/opt/app/svws/conf/svwsconfig.json"
    "/opt/app/svws/svwsconfig.json"
    "/etc/svws/svwsconfig.json"
)

CONFIG_FILE=""

# Suche nach der ersten existierenden Datei
for path in "${POSSIBLE_PATHS[@]}"; do
    if [[ -f "$path" ]]; then
        CONFIG_FILE="$path"
        break
    fi
done

# --- Validierung der Konfigurationsdatei ---
if [[ -z "$CONFIG_FILE" ]]; then
    echo "Fehler: svwsconfig.json wurde in keinem der Standardpfade gefunden!"
    exit 1
else
    echo "Info: Konfiguration gefunden unter: $CONFIG_FILE"
fi

# Konfiguration
DB_NAME=""
COUNT=0
PASS=""

usage() {
    echo "Usage: $0 -d <SCHEMATA_NAME> -n <ANZAHL> [-p <PASSWORD>]"
    exit 1
}

# Parameter verarbeiten (nur -d, -n, -p)
while getopts "d:n:p:" opt; do
    case $opt in
        d) DB_NAME="$OPTARG" ;;
        n) COUNT="$OPTARG" ;;
        p) PASS="$OPTARG" ;;
        *) usage ;;
    esac
done

# Validierung
if [[ -z "$DB_NAME" || $COUNT -le 0 ]]; then
    usage
fi

# Passwort ermitteln (Priorität: Parameter -> .env Datei)
if [[ -z "$PASS" ]]; then
    if [[ -f .env ]]; then
        PASS=$(grep '^MARIADB_ROOT_PASSWORD=' .env | cut -d '=' -f2 | tr -d '"' | tr -d "'")
    fi
fi

if [[ -z "$PASS" ]]; then
    echo "Fehler: Kein MariaDB-Passwort gefunden (weder über -p noch in .env)."
    exit 1
fi

export MYSQL_PWD="$PASS"

# 1. Quelldaten aus JSON extrahieren
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Fehler: Konfigurationsdatei $CONFIG_FILE nicht gefunden!"
    exit 1
fi

SOURCE_USER=$(jq -r ".DBKonfiguration.SchemaKonfiguration[] | select(.name==\"$DB_NAME\") | .username" "$CONFIG_FILE")
SOURCE_PW=$(jq -r ".DBKonfiguration.SchemaKonfiguration[] | select(.name==\"$DB_NAME\") | .password" "$CONFIG_FILE")

if [[ -z "$SOURCE_USER" || "$SOURCE_USER" == "null" ]]; then
    echo "Fehler: User für ${DB_NAME} nicht in $CONFIG_FILE gefunden. Abbruch!"
    exit 1
fi

# 2. Datenbank-Dump erstellen
DUMP_FILE="temp_${DB_NAME}.sql"
echo "Erstelle Dump von $DB_NAME..."
if mysqldump -h localhost -u root "$DB_NAME" > "$DUMP_FILE"; then
    
    for i in $(seq 1 "$COUNT"); do
        NEW_DB="${DB_NAME}_$i"
        echo "--------------------------------------"
        echo "Erstelle Klon: $NEW_DB"
        
        # Datenbank in MariaDB anlegen
        mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`$NEW_DB\`;"
        
        # Daten importieren
        mariadb -u root "$NEW_DB" < "$DUMP_FILE"

        # Berechtigungen dynamisch für alle Hosts des Users setzen
        echo "Setze Berechtigungen für User '$SOURCE_USER' auf '$NEW_DB'..."
        USER_HOSTS=$(mariadb -u root -N -e "SELECT Host FROM mysql.user WHERE User='$SOURCE_USER';")
        
        if [[ -z "$USER_HOSTS" ]]; then
            echo "WARNUNG: User '$SOURCE_USER' wurde in der MariaDB user-Tabelle nicht gefunden!"
        else
            for U_HOST in $USER_HOSTS; do
                mariadb -u root -e "GRANT ALL PRIVILEGES ON \`$NEW_DB\`.* TO '$SOURCE_USER'@'$U_HOST';"
            done
            mariadb -u root -e "FLUSH PRIVILEGES;"
        fi

        # 3. JSON Eintrag in svwsconfig.json hinzufügen
        EXISTS=$(jq ".DBKonfiguration.SchemaKonfiguration | any(.name == \"$NEW_DB\")" "$CONFIG_FILE")
        
        if [[ "$EXISTS" == "false" ]]; then
            echo "Füge $NEW_DB zur JSON-Konfiguration hinzu..."
            NEW_ENTRY=$(jq -n --arg name "$NEW_DB" --arg user "$SOURCE_USER" --arg pw "$SOURCE_PW" \
                '{name: $name, svwslogin: false, username: $user, password: $pw}')
            
            jq ".DBKonfiguration.SchemaKonfiguration += [$NEW_ENTRY]" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
        else
            echo "Eintrag für $NEW_DB existiert bereits in JSON."
        fi
    done
    
    # Aufräumen
    rm "$DUMP_FILE"
else
    echo "Fehler: Dump von $DB_NAME konnte nicht erstellt werden."
    exit 1
fi

unset MYSQL_PWD

echo "--------------------------------------"
echo "Restart SVWS-Server..."
if systemctl restart svws; then
    echo "Server erfolgreich neu gestartet."
else
    echo "Fehler beim Neustart des SVWS-Servers."
fi

echo "Vorgang abgeschlossen."