# Installation auf Rocky-Linux 9 oder RedHat 9

## Installation openjdk

```
dnf install java-17-openjdk java-17-openjdk-devel
java --version
```

## Installation Zip und Wget

```
dnf -y install unzip
dnf -y install tar
dnf -y install wget
```

## Download der SVWS-Server Pakete

wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.7.8/linux-installer-0.7.8.tar.gz


## Entpacken der SVWS-Serverdateien

tar xzf ./linux-installer-0.7.8.tar.gz

## Erstelle Verzeichnisse

mkdir -p /opt/app/svws
mkdir /opt/app/svws/client
mkdir /opt/app/svws/conf
mkdir -p /etc/app/svws/conf/


## Kopiere App, Konfigurationen und Zertifikate
cp -r ./svws/app /opt/app/svws/
cp -r ./svws/conf /etc/app/svws/conf/

## Entpacke den Client in das Client-Verzeichnis
unzip -d /opt/app/svws/client  ./svws/app/SVWS-Client.zip

## Erstelle den SVWS-Keystore

keytool -genkey -noprompt -alias alias1 -dname "CN=test, OU=test, O=test, L=test, S=test, C=test" -keystore /etc/app/svws/conf/keystore -storepass test123 -keypass test123  -keyalg RSA

## Erstelle svwsconfig.json

cp ./svws/conf/svwsconfig-template-nodb.json /etc/app/svws/conf/svwsconfig.json

## Anpassen der Variablen in der svwsconfig.json

```
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : false,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : "8443",
  "UseCORSHeader" : false,
  "TempPath" : "tmp",
  "TLSKeyAlias" : "",
  "TLSKeystorePath" : "/etc/app/svws/conf/keystore",
  "TLSKeystorePassword" : "test123",
  "ClientPath" : "./client",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "ServerMode" : "stable",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "mariadbserver:port",
    "defaultschema" : "",
    "SchemaKonfiguration" : []
  }
}
```

# Erstelle einen symbolischen Link zur Konfigurationsdatei

ln /etc/app/svws/conf/svwsconfig.json /opt/app/svws/svwsconfig.json

## Kopiere svws-template.service nach etc/systemd/system und dann Parameter darin (s.u.) ändern

cp ./svws/svws-template.service /etc/systemd/system/svws.service

## Oder ServiceDatei für Systemd ertsellen und in etc/systemd/system  ablegen

```
[UNIT]
Descirption=SVWS-Server

[Service]
WorkingDirectory=/opt/app/svws
ExecStart=java -cp "svws-server-app-*.jar:/opt/app/svws/app/*:/opt/app/svws/app/lib/*" de.svws_nrw.server.jetty.Main
User=svws
Type=simple
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## Einrichten des SVWS-Service als Systemd-Service

## Erstellen der Gruppe "svws" und des Nutzers "svws" ohne Login Shell (-s /bin/false)

Der Nutzer wird der Gruppe "svws" zugewiesen und besitzt Lese-/Schreibzugriff auf die relevanten Verzeichnisse

/usr/sbin/groupadd -r svws
/usr/sbin/useradd -r -s /bin/false -g svws svws

chown -R svws:svws /opt/app/svws
chown -R svws:svws /etc/app/svws/

## Aktualisieren der Systemd-Konfigurationen und Starten des Services

Der Service wird automatisch gestartet, sobald das System hochfährt (systemctl enable)

systemctl daemon-reload
systemctl start svws.service
systemctl enable svws.service

## Überprüfen des Status des Services

systemctl status svws.service

## Lösche das Verzeichnis 'svws' im Home-Verzeichnis

rm -r ./svws

# Lösche das Verzeichnis 'init-scripts' im Home-Verzeichnis

rm -r ./init-scripts



