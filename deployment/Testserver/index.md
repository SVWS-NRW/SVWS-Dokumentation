# Template Testserver SVWS-Server

Ziel ist es ein Template für einen SVWS-Server zu erstellen. Anwendungen können hierbei sein: 

+ Nightly builds zu Testzwecken
+ Schnelle Verfügbarkeit verschiedener SVWS-server unterschiedlicher Versionsnummern
+ Ausrollen auf Schulungsumgebungen
+ nächtlichen automatischen Zurücksetzung aller Datenbanken

Dies soll als Grundlage für die Schulungsclients oder zur Entwicklung eine Nightly-Servers dienen.

## Installation auf Basis eines Builds aus den Github Quellen

Dies kann z.B. für einen nightly build SVWS-Server genutzt werden oder zum Austesten verschiedener Branches

```bash 
#!/bin/bash
############################################
#### Installationvariablen festlegen #######
SERVERNAME=nightly.svws-devops.de
PORT=8443
MYSQLROOTPW=svwsadmin
BRANCH=dev
TEMURINVERSION=temurin-21-jdk
BERTIEBSMODUS=develop
############################################

# Softwarequellen einbinden & Softwareupdate
apt update && apt upgrade -y
apt install -y wget apt-transport-https gpg
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt update 
apt install -y git zip ${TEMURINVERSION} mariadb-server

# MariaDB Server konfigurieren
echo "
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQLROOTPW}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
" > mysql_secure_installation.sql
mysql < mysql_secure_installation.sql

# SVWS-Server Quellen einrichten und Server bauen
mkdir -p /opt/app/
cd /opt/app/
git clone https://github.com/SVWS-NRW/SVWS-Server
cd /opt/app/SVWS-Server
git switch ${BRANCH}
./gradlew build
```

## Server einrichten, als Dienst einrichten und starten

```bash
cp /app/SVWS-Server/svws-server-app/src/main/resources/svwsconfig.json.example /app/SVWS-Server/svws-server-app/svwsconfig.json

nano /app/SVWS-Server/svws-server-app/svwsconfig.json
```

