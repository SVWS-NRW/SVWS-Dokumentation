# Installation auf Rocky-Linux 9 oder RedHat 9

## Installation openjdk

```
dnf install java-21-openjdk-devel.x86_64
java --version
```

## Installation benötigter Tools

```
dnf -y install unzip
dnf -y install tar
dnf -y install wget
dnf -y install net-tools
dnf -y install nmap
```

## Download der SVWS-Server Pakete

wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.x.x/linux-installer-0.x.x.tar.gz


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

```json
{
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
}
```

## Erstelle einen symbolischen Link zur Konfigurationsdatei

ln /etc/app/svws/conf/svwsconfig.json /opt/app/svws/svwsconfig.json

## Kopiere svws-template.service nach etc/systemd/system und dann Parameter darin (s.u.) ändern

cp ./svws/svws-template.service /etc/systemd/system/svws.service

## Oder ServiceDatei für Systemd ertsellen und in etc/systemd/system  ablegen

```
[Unit]
Description=SVWS-Server

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

### Erstellen der Gruppe "svws" und des Nutzers "svws" ohne Login Shell (-s /bin/false)

Der Nutzer wird der Gruppe "svws" zugewiesen und besitzt Lese-/Schreibzugriff auf die relevanten Verzeichnisse

```bash
/usr/sbin/groupadd -r svws
/usr/sbin/useradd -r -s /bin/false -g svws svws

chown -R svws:svws /opt/app/svws
chown -R svws:svws /etc/app/svws/
```

### Aktualisieren der Systemd-Konfigurationen und Starten des Services

Der Service wird automatisch gestartet, sobald das System hochfährt (systemctl enable)

```bash
systemctl daemon-reload
systemctl start svws.service
systemctl enable svws.service
```

### Überprüfen des Status des Services

```bash
systemctl status svws.service
```

## Lösche das Verzeichnis 'svws' im Home-Verzeichnis

```bash
rm -r ./svws
```

## Lösche das Verzeichnis 'init-scripts' im Home-Verzeichnis

```bash
rm -r ./init-scripts
```

## Firewall öffnen optional

```bash
firewall-cmd --add-port=8443/TCP
firewall-cmd --zone=public --permanent --add-port 8443/tcp
firewall-cmd --runtime-to-permanent
```

## User auf der MariaDB einrichten

Bei dieser Konstellation greift der SVWS-Server auf einen externen MariaDB-Server zu.
Hierfür wird dort ein user benötigt der Schemata anlegen/löschen darf und auch von außerhalb zugreifen darf.
Das Recht user anzulegen, die weniger Rechte haben wird auch benötigt. 
Sollte der User keine Rechte haben, Schemata anzulegen oder zu löschen, so muss das dann vorher vom Datenbankadministrator gemacht werden.


## Download des Scripts mit den Befehlen

[Download Script](redhat_installer.sh)