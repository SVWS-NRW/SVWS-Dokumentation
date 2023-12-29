# Einrichten der Dockerumgebung unter Ubuntu

## Installation von Docker

https://docs.docker.com/engine/install/ubuntu/

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Rootless Zugriff für Eclipse

Damit Eclispe auf die lokale Docker-Instanz zugreifen kann:

```bash
apt install uidmap

/ect/subuid
user:100000:65536
/etc/subgid
user:100000:65536

sudo systemctl disable --now docker
dockerd-rootless-setuptool.sh install
systemctl --user status docker
```

## Erzeugen eines lokalen Containers in Eclipse

Starten des Gradle-Tasks "docker > dockerbuildLatestTag"

Hier wird in der lokaen Docker-Installation der Container zur Verfügung gestellt.

```bash
docker images

REPOSITORY            TAG              IMAGE ID       CREATED         SIZE
svwsnrw/svws-server   0.8.6-SNAPSHOT   44245f584675   16 hours ago    639MB
svwsnrw/svws-server   latest           44245f584675   16 hours ago    639MB
mariadb               10.7.3           daf0f023c28d   20 months ago   414MB
```

## Erzeugen eines eigenen keystore

```bash
keytool -genkey -noprompt -alias alias1 -dname "CN=test, OU=test, O=test, L=test, S=test, C=test" -keystore ./keystore -storepass "test123" -keypass "test123"  -keyalg RSA
```

## Starten mit Docker-Compose

Verzeichnis für das Dockerfile anlegen.
In diesem Verszeichnis ein weiteres Verzeichnis keystore anlegen und dne selbst erzeugten keystore hinein kopieren.

docker-compose.yml im Verzeichnis anlegen.

```yml
version: "3"
services:
  mariadb:
    restart: always
    image: mariadb:10.7.3
    environment:
      MARIADB_ROOT_PASSWORD: "${MariaDB_ROOT_PASSWORD}"
      MARIADB_DATABASE: "${MariaDB_DATABASE}"
      MARIADB_USER: "${MariaDB_USER}"
      MARIADB_PASSWORD: "${MariaDB_PASSWORD}"

    env_file:
      - .env
    healthcheck:
      test: mysqladmin ping -h 127.0.0.1 -u $$MariaDB_USER --password=$$MariaDB_PASSWORD
      interval: 1s
      timeout: 5s
      retries: 10

  svws-server:
    image: svwsnrw/svws-server:latest
    depends_on:
      mariadb:
        condition: service_healthy
    links:
      - mariadb
    ports:
      - "8443:8443"
    environment:
      MariaDB_HOST: "${MariaDB_HOST}"
      MariaDB_ROOT_PASSWORD: "${MariaDB_ROOT_PASSWORD}"
      MariaDB_DATABASE: "${MariaDB_DATABASE}"
      MariaDB_USER: "${MariaDB_USER}"
      MariaDB_PASSWORD: "${MariaDB_PASSWORD}"
      SVWS_TLS_KEY_ALIAS: "${SVWS_TLS_KEY_ALIAS}"
      SVWS_TLS_KEYSTORE_PATH: "${SVWS_TLS_KEYSTORE_PATH}"
      SVWS_TLS_KEYSTORE_PASSWORD: "${SVWS_TLS_KEYSTORE_PASSWORD}"
    volumes:
      - ./init-scripts:/etc/app/svws/init-scripts
      - ./keystore:/etc/app/svws/conf/keystore/
    env_file:
      - .env
```

Eine Datei ".env" im Verzeichnis anlegen und die Parameter auf die eigene Umgebung anpassen.

```
INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
TESTDB_PASSWORD=Schild2AccessKennwort
MariaDB_ROOT_PASSWORD=test
MariaDB_DATABASE=gymabi
MariaDB_HOST=mariadb
MariaDB_USER=test
MariaDB_PASSWORD=test
SVWS_TLS_KEYSTORE_PASSWORD=test123
SVWS_TLS_KEY_ALIAS=alias1
SVWS_TLS_KEYSTORE_PATH=/etc/app/svws/conf/keystore
```

Starten des Containers:

```bash
docker compose up -d
```