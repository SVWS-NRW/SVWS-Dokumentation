#!/bin/bash

# Entpacken der SVWS-Serverdateien

tar xzf ./linux-installer-0.7.8.tar.gz

# Erstelle Verzeichnisse

mkdir -p /opt/app/svws
mkdir /opt/app/svws/client
mkdir /opt/app/svws/conf
mkdir -p /etc/app/svws/conf/


# Kopiere App, Konfigurationen und Zertifikate

cp -r ./svws/app /opt/app/svws/
cp -r ./svws/conf /etc/app/svws/conf/

# Entpacke den Client in das Client-Verzeichnis

unzip -d /opt/app/svws/client  ./svws/app/SVWS-Client.zip

# Erstelle den SVWS-Keystore

keytool -genkey -noprompt -alias alias1 -dname "CN=test, OU=test, O=test, L=test, S=test, C=test" -ext "SAN=DNS:localhost,IP:127.0.0.1,IP:10.1.0.1,DNS:meinserver,DNS:meinserver.mydomain.de" -keystore /etc/app/svws/conf/keystore -storepass test123 -keypass test123  -keyalg RSA

# Erstelle svwsconfig.json im conf-Verzeichnis

echo '{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : false,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : "8443",
  "UseCORSHeader" : false,
  "TempPath" : "tmp",
  "TLSKeyAlias" : "",
  "TLSKeystorePath" : "/etc/app/svws/conf",
  "TLSKeystorePassword" : "test123",
  "ClientPath" : "./client",
  "AdminClientPath" : "./admin",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "ServerMode" : "stable",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "mariadbserver:port",
    "defaultschema" : "",
    "SchemaKonfiguration" : []
  }
}' > /etc/app/svws/conf/svwsconfig.json

# Erstelle einen symbolischen Link zur Konfigurationsdatei

ln /etc/app/svws/conf/svwsconfig.json /opt/app/svws/svwsconfig.json

# Erstelle Service-Datei für Systemd-Service

echo "[Unit]
Description=SVWS-Server

[Service]
WorkingDirectory=/opt/app/svws
ExecStart=java -cp "svws-server-app-*.jar:/opt/app/svws/app/*:/opt/app/svws/app/lib/*" de.svws_nrw.server.jetty.Main
User=svws
Type=simple
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/svws.service

# Einrichten des SVWS-Service als Systemd-Service

# Erstellen der Gruppe "svws" und des Nutzers "svws" ohne Login Shell (-s /bin/false)

Der Nutzer wird der Gruppe "svws" zugewiesen und besitzt Lese-/Schreibzugriff auf die relevanten Verzeichnisse

/usr/sbin/groupadd -r svws
/usr/sbin/useradd -r -s /bin/false -g svws svws

chown -R svws:svws /opt/app/svws
chown -R svws:svws /etc/app/svws/

# Aktualisieren der Systemd-Konfigurationen und Starten des Services
# Der Service wird automatisch gestartet, sobald das System hochfährt (systemctl enable)

systemctl daemon-reload
systemctl start svws.service
systemctl enable svws.service

## Überprüfen des Status des Services

systemctl status svws.service


