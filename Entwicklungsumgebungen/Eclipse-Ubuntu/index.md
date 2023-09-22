# Installation auf einem Ubuntu

## Systemvoraussetzungen 
Installation unter Ubuntu 22.04

## Software Installation

### Curl, git, tools ... installieren

```bash
sudo apt update && apt upgrade -y
sudo apt install git curl net-tools dnsutils nmap 
cd ~
```

### Eclipse installieren

#### Download Eclipse  

https://www.eclipse.org/downloads/packages/

Die aktuelle Eclipse nehmen. November 22 zum Beispiel: 
eclipse-jee-2022-09-R-linux-gtk-x86_64.tar.gz 

#### Entpacken

```bash
tar -xvzf eclipse-jee-2022-09-R-linux-gtk-x86_64.tar.gz
```

#### Anpassungen

Es beitet sich an den Ordner mit der Eclipse umzubennen, da man so Konflikte mit möglichen späteren Versionen vermeidet.  

Die Datei eclipse.ini anpassen in den beiden Zeilen mit -Xms und -Xmx die folgenden Werte schreiben: 

```bash
...
-Xms2048m
-Xmx32768m
...
```

### MariaDB installieren

```bash
sudo apt install mariadb-server
mariadb --version
sudo mysql_secure_installation
```

Im Skript mysql_secure_installation sinngemäß die folgenden Angaben machen: 
```bash
switch to soket auth: no
change root pw: svwsadmin
remove user: yes
allow root access: yes
remove testusers: yes
reload: yes
```

#### DBeaver installieren
```bash
curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/dbeaver.gpg
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install dbeaver-ce
```

## Einrichtung 
In Eclipe eine GIT-Perspective öffnen und die Repositories in Eclipse oder im Terminal clonen.

Für den aktuellen Entwicklungs branch in den dev-Branch wechseln, wenn dev-Branch aktiv ist.
Check out as new Local Branch.

import -> gradle -> existing projekt
next next 

svws Ordner auswählen


#### SVWS Einstellungen

Die Beispiel-Config ins Zielverzeichnis kopieren und umbenennen.

```bash
cp ~/git/SVWS-Server/svws-server-app/src/main/resources/svwsconfig.json.example /git/SVWS-Server/svws-server-app/svwsconfig.json
```
		
In der 'svwsconfig.json' sollte der Port auf >=1024 (z.B. 3000) gesetzt werden. 
Eclipse benötigt beim Start des Servers auf Port 443 Root-Rechte. 
In der Entwicklungsumgebung kann das so vermieden werden. 

Beispiel einer svwsconfig.json, bitte die userdaten und Passwörter entspechend anpassen:
```bash
nano ~/git/SVWS-Server/svws-server-app/svwsconfig.json
```	


```json
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : false,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 3000,
  "UseCORSHeader" : true,
  "TempPath" : "tmp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : ".",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "/home/YOUR_USERNAME/git/SVWS-Server/svws-webclient/build/output/",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "localhost",
    "defaultschema" : "svwsdb",
    "SchemaKonfiguration" : []
  }
}

```


## Bau des SVWS-Servers und Clients

### Arbeiten in Eclipse

+ Gradle-Task SVWS-Server > clean > build
+ Gradle-Task SVWS-Client > clean > build

### Alternativ im Terminal

in den folgenden Unterverzeichnissen ausführen: 
+ ~/git/SVWS-Server

```bash
./gradlew clean
./gradlew build
```
		
 

