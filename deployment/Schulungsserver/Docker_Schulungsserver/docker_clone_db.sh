#!/bin/bash

# --- KONFIGURATION ---
DB_NAME=""
COUNT=0
PASS=""
BASE_NAME=""

usage() {
    echo "Usage: $0 -c <CONTAINER_BASISNAME> -d <SCHEMATA_NAME> -n <ANZAHL> [-p <PASSWORD>]"
    echo "Beispiel: $0 -c svws3 -d Testdaten_GY -n 2"
    exit 1
}

# Parameter verarbeiten
while getopts "c:d:n:p:" opt; do
    case $opt in
        c) BASE_NAME="$OPTARG" ;;
        d) DB_NAME="$OPTARG" ;;
        n) COUNT="$OPTARG" ;;
        p) PASS="$OPTARG" ;;
        *) usage ;;
    esac
done

# Validierung der Pflichtparameter
if [[ -z "$BASE_NAME" || -z "$DB_NAME" || $COUNT -le 0 ]]; then
    usage
fi

# Dynamische Variablen basierend auf dem Container-Namen
APP_CONTAINER="$BASE_NAME"
DB_CONTAINER="${BASE_NAME}_mariadb"
ENV_FILE="./${BASE_NAME}/.env"
CONFIG_FILE="./${BASE_NAME}/volume/svws/svwsconfig.json"

# Passwort aus .env laden, falls nicht per Parameter übergeben
if [[ -z "$PASS" && -f "$ENV_FILE" ]]; then
    PASS=$(grep '^MARIADB_ROOT_PASSWORD=' "$ENV_FILE" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
fi

if [[ -z "$PASS" ]]; then
    echo "Fehler: Kein Passwort gefunden (weder per -p noch in $ENV_FILE)."
    exit 1
fi

# 1. Quelldaten aus lokaler JSON extrahieren
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Fehler: Konfigurationsdatei nicht gefunden unter $CONFIG_FILE"
    exit 1
fi

SOURCE_USER=$(jq -r ".DBKonfiguration.SchemaKonfiguration[] | select(.name==\"$DB_NAME\") | .username" "$CONFIG_FILE")
SOURCE_PW=$(jq -r ".DBKonfiguration.SchemaKonfiguration[] | select(.name==\"$DB_NAME\") | .password" "$CONFIG_FILE")

if [[ -z "$SOURCE_USER" || "$SOURCE_USER" == "null" ]]; then
    echo "Fehler: Schema $DB_NAME nicht in $CONFIG_FILE gefunden!"
    exit 1
fi

# 2. Datenbank-Operationen vorbereiten (Dump-Befehl prüfen)
DUMP_CMD="mariadb-dump"
if ! docker exec "$DB_CONTAINER" which mariadb-dump > /dev/null 2>&1; then
    DUMP_CMD="mysqldump"
fi

DUMP_FILE="temp_${DB_NAME}.sql"
echo "Erstelle Dump im Container $DB_CONTAINER mit $DUMP_CMD..."
docker exec -e MYSQL_PWD="$PASS" "$DB_CONTAINER" $DUMP_CMD -u root "$DB_NAME" > "$DUMP_FILE"

if [[ ! -s "$DUMP_FILE" ]]; then
    echo "Fehler: Dump-Datei ist leer. Prüfe Passwort oder Datenbankname."
    rm "$DUMP_FILE"
    exit 1
fi

for i in $(seq 1 "$COUNT"); do
    NEW_DB="${DB_NAME}_$i"
    echo "--------------------------------------"
    echo "Erzeuge Klon: $NEW_DB"

    # Datenbank anlegen und Dump einspielen
    docker exec -e MYSQL_PWD="$PASS" "$DB_CONTAINER" mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`$NEW_DB\`;"
    docker exec -i -e MYSQL_PWD="$PASS" "$DB_CONTAINER" mariadb -u root "$NEW_DB" < "$DUMP_FILE"

    # Rechte setzen
    USER_HOSTS=$(docker exec -e MYSQL_PWD="$PASS" "$DB_CONTAINER" mariadb -u root -N -e "SELECT Host FROM mysql.user WHERE User='$SOURCE_USER';")
    
    for U_HOST in $USER_HOSTS; do
        echo "Berechtigung für $SOURCE_USER@$U_HOST auf $NEW_DB"
        docker exec -e MYSQL_PWD="$PASS" "$DB_CONTAINER" mariadb -u root -e "GRANT ALL PRIVILEGES ON \`$NEW_DB\`.* TO '$SOURCE_USER'@'$U_HOST';"
    done

    # 3. JSON auf dem Host aktualisieren
    EXISTS=$(jq ".DBKonfiguration.SchemaKonfiguration | any(.name == \"$NEW_DB\")" "$CONFIG_FILE")
    if [[ "$EXISTS" == "false" ]]; then
        echo "Füge $NEW_DB zur svwsconfig.json hinzu..."
        NEW_ENTRY=$(jq -n --arg name "$NEW_DB" --arg user "$SOURCE_USER" --arg pw "$SOURCE_PW" \
            '{name: $name, svwslogin: false, username: $user, password: $pw}')
        jq ".DBKonfiguration.SchemaKonfiguration += [$NEW_ENTRY]" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    else
        echo "Eintrag für $NEW_DB existiert bereits in JSON."
    fi
done

rm "$DUMP_FILE"
docker exec -e MYSQL_PWD="$PASS" "$DB_CONTAINER" mariadb -u root -e "FLUSH PRIVILEGES;"

# 4. SVWS Server Container neu starten
echo "--------------------------------------"
echo "Starte App-Container $APP_CONTAINER neu..."
docker restart "$APP_CONTAINER"

echo "Vorgang abgeschlossen. $COUNT Klone erstellt."