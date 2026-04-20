#!/bin/bash

# --- Konfiguration ---
# Die Variablen SERVERNAME, APP_PORT, SCHEMA_NAME und MARIADB_ROOT_PASSWORD 
# sollten idealerweise als Umgebungsvariablen gesetzt sein. 
# Falls nicht, kann man sie hier definieren:
 SERVERNAME="localhost"
 APP_PORT="8443"
 SCHEMA_NAME=""
 MARIADB_ROOT_PASSWORD=""
 SVWS_ADMIN=""
 SVWS_ADMIN_PW=""

OUTPUT_FILE="Kennwoerter.txt"

# Falls die Datei existiert, leeren wir sie für einen sauberen Durchlauf
> "$OUTPUT_FILE"

echo "Starte Passwort-Update für Schema: ${SCHEMA_NAME}..."

# Erstellen einer temporäre Konfigurationsdatei
CONF_FILE=$(mktemp)
cat << EOF > "$CONF_FILE"
[client]
user=root
password="${MARIADB_ROOT_PASSWORD}"
host=localhost
EOF

# Sicherstellen, dass nur der aktuelle User die Datei lesen kann
chmod 600 "$CONF_FILE"

echo "Starte Passwort-Update für Schema: ${SCHEMA_NAME}..."

# Auslesen der User
USERS=$(mysql --defaults-extra-file="$CONF_FILE" -N -s -e "SELECT ID, Benutzername FROM ${SCHEMA_NAME}.Credentials WHERE Benutzername != 'Admin';")

# Prüfen ob der Befehl geklappt hat
if [ $? -ne 0 ]; then
    echo "[FEHLER] Datenbank-Zugriff verweigert. Prüfe das Passwort."
    rm -f "$CONF_FILE"
    exit 1
fi

# Falls keine User gefunden wurden
if [ -z "$USERS" ]; then
    echo "Keine passenden Benutzer gefunden."
    exit 0
fi

# Schleife über alle gefundenen User
echo "$USERS" | while read -r ID USERNAME; do

    # Passwort generieren (12 Zeichen, Alphanumerisch)
    PASSWORD=$(openssl rand -base64 12)

    # 3) In Datei schreiben
    echo "User: $USERNAME | Passwort: $PASSWORD" >> "$OUTPUT_FILE"


# Curl-Befehl zum Passwort setzen
CURL_COMMAND="curl --user \"${SVWS_ADMIN}:${SVWS_ADMIN_PW}\" -k -s -o /dev/null -w \"%{http_code}\" -X POST \
      \"https://${SERVERNAME}:${APP_PORT}/db/${SCHEMA_NAME}/benutzer/${ID}/password\" \
      -H \"accept: */*\" \
      -H 'Content-Type: application/json' \
      -d \"\\\"${PASSWORD}\\\"\""

# Optional: Den Befehl auf der Konsole anzeigen
#echo "Führe aus: $CURL_COMMAND"

# Passwort setzen
HTTP_CODE=$(eval $CURL_COMMAND)

    if [[ "$HTTP_CODE" =~ ^20[0-4]$ ]]; then
        echo -e "[OK] ID ${ID} ($USERNAME): Password erfolgreich gesetzt (Status: $HTTP_CODE).\n"
    else
        echo -e "[FEHLER] ID ${ID} ($USERNAME): Fehlgeschlagen (Status: $HTTP_CODE).\n"
    fi

done

echo "Alle Passwörter außer für "Admin" gesetzt. Die Passwörter wurden in $OUTPUT_FILE gespeichert."
