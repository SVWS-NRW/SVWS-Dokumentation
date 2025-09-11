# Schulungsserver mit Docker

Ziel dieses Artikels ist es auf einem host ein Dockersystem mit mehreren Docker Containern aufzusetzen. Diese Container sind leicht zu warten und können schnell wieder zurückgesetzt werden. 


## Beispiel: Ein Testserver per skript

```bash 

#!/bin/bash

# Ensure running with Bash
if [ -z "$BASH_VERSION" ]; then
    echo "This script must be run with Bash. Aborting."
    exit 1
fi

set -e  # Exit on any error

# Update and install prerequisites
apt update && apt upgrade -y
apt install -y ca-certificates curl gnupg lsb-release unzip p7zip-full software-properties-common net-tools

# Create keyring directory
install -m 0755 -d /etc/apt/keyrings

# Download Docker GPG key securely
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install Docker
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check Docker service status
systemctl is-active --quiet docker && echo "Docker is running." || echo "Docker is NOT running!"

# Create Docker project directory
mkdir -p docker
cd docker

# Download and extract SVWS Docker example
curl -L -o svws-docker-example.zip https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/main/deployment/Docker/svws-docker-example.zip
unzip svws-docker-example.zip

# .env Datei ggf. anpassen 

# Start the SVWS Server
docker compose up -d


```

## Beispiel: Mehrere Docker Container per conf.txt Datei

Ziel ist es mehrer Docker Container anzulegen. Das Skript ermöglicht es simple Schulungspasswörter zu nutzen oder 12 stellige Passwörter zu generieren. Alle Zugangsdaten werden dann in einem den .env Datei gespeichert. 

Vorbereitend soll eine conf.txt Datei erstellt werden, die die Serverbezeichnungen, Ports und Passwörter enthält, die zum Generieren der Server ausgelesen werden. 

Hier ein Beispiel zum Aufbau dieser Datei: 


```bash                                  
SERVERNAME="svws01" DB_ROOT_PASSWORD="geheim1" MYSQLPORT="3301" KEYSTORE_PASSWORD="keystore1" PORT="8441"
SERVERNAME="svws02" DB_ROOT_PASSWORD="geheim2" MYSQLPORT="3302" KEYSTORE_PASSWORD="keystore2" PORT="8442"
SERVERNAME="svws03" DB_ROOT_PASSWORD="geheim3" MYSQLPORT="3303" KEYSTORE_PASSWORD="keystore3"
PORT="8443"
```


```bash 

#!/bin/bash

# Ensure running with Bash
if [ -z "$BASH_VERSION" ]; then
    echo "Dieses Skript muss mit Bash ausgeführt werden. Abbruch."
    exit 1
fi

set -e  # Bei Fehler abbrechen

# Prüfen, ob ein Argument übergeben wurde
if [ -z "$1" ]; then
    echo "⚠️  Kein Konfigurationsfile angegeben – es wird nur ein SVWS-Server gestartet."
    SINGLE_SERVER_MODE=true
else
    filename="$(realpath "$1")"

    if [ ! -f "$filename" ]; then
        echo "❌ Fehler: Datei '$filename' existiert nicht."
        exit 1
    fi

    SINGLE_SERVER_MODE=false
fi

# Pakete installieren
apt update && apt upgrade -y
apt install -y ca-certificates curl gnupg lsb-release unzip p7zip-full software-properties-common net-tools

# Docker GPG Key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Docker Repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker installieren
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker-Status
systemctl is-active --quiet docker && echo "✅ Docker läuft." || echo "❌ Docker läuft NICHT!"

# Projektverzeichnis
mkdir -p docker
cd docker

# Docker-Beispiel herunterladen
curl -L -o svws-docker-example.zip https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/main/deployment/Docker/svws-docker-example.zip

# Einzeln oder mehrere Server starten
if [ "$SINGLE_SERVER_MODE" = true ]; then
    unzip svws-docker-example.zip
    docker compose up -d
    echo "✅ Ein SVWS Server wurde gestartet."
    exit 0
fi

# Mehrere Server aus Konfigurationsdatei
while IFS= read -r line; do
    # Variablen extrahieren
    SERVERNAME=$(echo "$line" | sed -n 's/.*SERVERNAME="\([^"]*\)".*/\1/p')
    DB_ROOT_PASSWORD=$(echo "$line" | sed -n 's/.*DB_ROOT_PASSWORD="\([^"]*\)".*/\1/p')
    KEYSTORE_PASSWORD=$(echo "$line" | sed -n 's/.*KEYSTORE_PASSWORD="\([^"]*\)".*/\1/p')

    if [[ -z "$SERVERNAME" || -z "$DB_ROOT_PASSWORD" || -z "$KEYSTORE_PASSWORD" ]]; then
        echo "⚠️  Ungültige Zeile übersprungen: $line"
        continue
    fi

    echo "➡️  Erstelle Server: $SERVERNAME"

    mkdir "svws-$SERVERNAME"
    cd "svws-$SERVERNAME"
    unzip ../svws-docker-example.zip

    # .env schreiben
    cat <<EOF > .env
IMPORT_TEST_DATA=false

MARIADB_ROOT_PASSWORD=$DB_ROOT_PASSWORD
MARIADB_HOST=mariadb

SVWS_TLS_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
SVWS_TLS_KEY_ALIAS=alias1
SVWS_TLS_KEYSTORE_PATH=.

SVWS_TLS_CERT_CN=$SERVERNAME
SVWS_TLS_CERT_OU=SVWSOU
SVWS_TLS_CERT_O=SVWSO
SVWS_TLS_CERT_L=CITY
SVWS_TLS_CERT_S=STATE
SVWS_TLS_CERT_C=DE
EOF

    docker compose up -d
    cd ..
done < "$filename"


```

