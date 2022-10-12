***SonarQube-Server***
=========================================================
# Statische Codeanalyse mit SonarQube
Die statische Codeanalyse ist ein wichtiges Werkzeug zur Beurteilung der Code-Qualität in Bezug auf Wartbarkeit und Sicherheit. Sie wendet vordefinierte Regelprüfungen auf den Quellcode an und hilft dabei, potenzielle Problemstellen zu identifizieren. Den Regelprüfungen liegen Regelwerke zugrunde. Das Regelwerk definiert, welche Prüfregeln auf den Quellcode angewendet werden und mit welchem Schweregrad Regelverstöße zu bewerten sind. In der derzeitigen Konfiguration von SonarQube wird für den SVWS-Server das Default-Regelwerk für Java-Projekte von SonarQube verwendet (Name "sonar way"). Dieses Regelwerk beinhaltet die vom SonarQube-Hersteller SonarSource empfohlenen Prüfungen.

# Installation
Alle für die Installation erforderlichen Informationen können der offiziellen Dokumentation des Herstellers entnommen werden:

* [Systemvoraussetzungen](https://docs.sonarqube.org/latest/requirements/requirements/)
* [Server Installation](https://docs.sonarqube.org/latest/setup/install-server/)

Die Installation von SonarQube Server gliedert sind grundsätzlich in zwei Schritte:
* Installation einer relationalen Datenbank (für SVWS wird PostgreSQL verwendet)
* Installation der Anwendung (SonarQube Server)

Für den SVWS-Server wurde SonarQube auf einem Debian-Container in der Proxmox-Umgebung bereitgestellt.

## Installation PostgreSQL-Datenbank
```
apt update
apt -y install postgresql

# change default password for user postgres
passws postgres
# >> this will stop script at console. type in new password.

# add new database user for SonarQube
su - postgres
psql
ALTER USER sonar WITH ENCRYPTED PASSWORD '<JDCB_PASSWORD>';

# WORKAROUND: Debian uses default locale to create database templates. This might not be UTF-8, which ist required by SonarQube
UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
\c template1
VACUUM FREEZE;
# END WORKAROUND

# add new database user and database for SonarQube
CREATE DATABASE sonarqube WITH ENCODING 'UTF8' OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;
\q
exit
```

## Installation SonarQube-Server
```
#!/bin/bash
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
PATH="/usr/lib/jvm/java-11-openjdk-amd64/bin:$PATH"
SONARQUBE_VERSION="9.6.1.59531"
SONARQUBE_ZIP_URL=https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip
SONARQUBE_HOME=/opt/sonarqube
SONAR_VERSION="${SONARQUBE_VERSION}"
SQ_DATA_DIR="/opt/sonarqube/data"
SQ_EXTENSIONS_DIR="/opt/sonarqube/extensions"
SQ_LOGS_DIR="/opt/sonarqube/logs"
SQ_TEMP_DIR="/opt/sonarqube/temp"

# update packages, install packages
set -eux
apt update
apt install openjdk-11-jdk wget unzip

# download and unzip SonarQube binaries
mkdir --parents /opt
cd /opt
wget "${SONARQUBE_ZIP_URL}" -O sonarqube.zip
unzip -q sonarqube.zip
mv "sonarqube-${SONARQUBE_VERSION}" sonarqube
rm sonarqube.zip*

# add user sonarqube and set privileges
addgroup --system --gid 1000 sonarqube
adduser --system --disabled-password --uid 1000 --ingroup sonarqube sonarqube
chown -R sonarqube:sonarqube ${SONARQUBE_HOME}

# create a systemd service file
cat >> /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=sonarqube
Group=sonarqube
PermissionsStartOnly=true
ExecStart=/bin/nohup ${JAVA_HOME}/bin/java -Xms32m -Xmx32m -Djava.net.preferIPv4Stack=true -jar /opt/sonarqube/lib/sonar-application-${SONARQUBE_VERSION}.jar
StandardOutput=syslog
LimitNOFILE=131072
LimitNPROC=8192
TimeoutStartSec=5
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# configure jdbc connection params for PostgreSQL database
cd /opt/sonarqube
cp sonar.properties sonar-default.properties
cp sonar.properties sonar-postgres.properties
sed -i "s/#sonar.jdbc.username=.*/sonar.jdbc.username=sonar/g" sonar-postgres.properties
sed -i "s/#sonar.jdbc.password=.*/sonar.jdbc.password='<JBDC_PASSWORD>'/g" sonar-postgres.properties
sed -i "s|#sonar.jdbc.url=jdbc:postgresql.*|sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube|g" sonar-postgres.properties
sed -i "s|#sonar.search.javaOpts=.*|sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError|g" sonar-postgres.properties
cp sonar-postgres.properties sonar.properties

# start SonarQube server as deamon
systemctl enable sonarqube.service
systemctl start sonarqube.service
```
