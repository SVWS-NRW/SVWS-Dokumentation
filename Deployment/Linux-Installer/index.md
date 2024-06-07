# Linux Installer

## Download

Download unter:   
https://github.com/SVWS-NRW/SVWS-Server/releases


Dieses Skript ist für die Installation des SVWS-Servers auf einem Debian-basierten System gedacht.  
Bisher getestet sind:  

- Debian 11
- Debian 12
- Ubuntu 22.04 LTS 
- Ubuntu 22.10 

RedHat basierte Systeme benötigen andere Befehle:

[Installation Redhat](RedHat-Linux.md)

## Wichtige Hinweise

- Verwendung des Skripts geschieht auf eigene Gefahr.
- Führen Sie das Skript nur auf einem Testsystem durch, bevor Sie es auf einem Produktivsystem verwenden.
- Stellen Sie sicher, dass alle Konfigurationen und Passwörter sicher gespeichert und aufbewahrt werden.
- Beachten Sie, dass das Skript eine Internetverbindung benötigt, um bestimmte Pakete herunterzuladen und zu installieren.


## Voraussetzungen

- Ein Debian-basiertes Betriebssystem
- Zugriff mit root-Rechten

## Installation  

- Laden Sie das Skript auf den Zielcomputer herunter.
- Öffnen Sie die Terminalanwendung und navigieren Sie zum Verzeichnis, in dem sich das Skript befindet.
- Geben Sie den Befehl ``chmod +x /install-0.x.x.sh`` ein und drücken Sie die Eingabetaste.
- Geben Sie den Befehl ``./install-0.x.x.sh``  ein und drücken Sie die Eingabetaste.
- Folgen Sie den Anweisungen im Skript.

Nach dem Durchlauf des Skript haben Sie einen aktiv laufenden SVWS-Server!

## Update der Linux-Installation

- Laden Sie das Skript auf den Zielcomputer herunter.
- Öffnen Sie die Terminalanwendung und navigieren Sie zum Verzeichnis, in dem sich das Skript befindet.
- Geben Sie den Befehl ``chmod +x /install-0.x.x.sh`` ein und drücken Sie die Eingabetaste.
- Achten Sie darauf, dass die Datei ``.env`` aus der Installation neben dem Install-Script liegt.
- Geben Sie den Befehl ``./install-0.x.x.sh --update``  ein und drücken Sie die Eingabetaste.
- Danach sollte der SVWS-Server in der aktuelen Version laufen.

## Konfiguration

Das Skript bietet verschiedene Optionen zur Konfiguration, die hier vorgestellt werden sollen. Es werden Standardeinstellungen vorgeschlagen, um eine einfache Installation zu ermöglichen. Sie können die Einstellungen aber auch nach Bedarf individuell anpassen.

Die gewählten Parameter werden in die Datei ``.env`` geschrieben.
Aus dieser Datei werden die Werte für die Installation dann entnommen.
Auch das Update bedient sich aus dieser Datei, um die Installationspfade zu ermitteln.
Wenn diese Datei schon exiateirt, dann werden die Parameter nicht mehr abgefragt und die Installation startet sofort.
Auf diese Weise kann also auch eine scriptgesteuerte Installation realisisert werden.

Folgende Konfigurationen können vorgenommen werden:

- MariaDB-Konfiguration
- Installationspfade
- Erstellung eines Keystores für TLS
- Import von Testdaten

Hier finden Sie einen beispielhaften Dialog: 

```bash
MariaDB-Konfiguration:
Möchten Sie MariaDB installieren? (j/N): j
MARIADB_ROOT_PASSWORD (default: 'abcd1234'): abcd1234
MARIADB_DATABASE (default: 'svwsdb'): svwsdb
MARIADB_HOST (default: 'localhost'): localhost
MARIADB_USER (default: 'svwsadmin'): svwsadmin
MARIADB_PASSWORD (default: 'abcd1234'): abcd1234
Installationspfade:
APP_PATH (default: '/opt/app/svws'): /opt/app/svws
CONF_PATH (default: '/etc/app/svws/conf'): /etc/app/svws/conf
APP_PORT (default: 8443): 8443
Möchten Sie einen Keystore erstellen? (j/N): j
Keystore für TLS:
SVWS_TLS_KEYSTORE_PATH (default: '/etc/app/svws/conf/keystore'): /etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD (default: 'abcd1234'): abcd1234
SVWS_TLS_KEY_ALIAS (default: ''): 
Möchten Sie Testdaten importieren? (j/N): N

```
Die Passwortvorschläge werden vom Skript generiert. Bitte sichern Sie unbedingt die verwendeten Passwörter.  
**Diese Daten werden vom Skript nicht gespeichert!**

Erläuterungen zu den einzelnen Punkten: 

| Variable |Erläuterung|
|-------------|---------------|
| MariaDB_ROOT_PASSWORD | Das Datenbank Passwort der Datenbankadministratoren |
| MariaDB_DATABASE | Name der Datenbank |
| MariaDB_HOST | Bei kleinen Installationen wird die Mariadb i.d.R. auf dem localen System (localhost) liegen. Ggf. kann hier auch die url zu einem separaten MariaDB-Server eingetragen werden.| 
| MariaDB_USER | User mit Vollzugriff auf die o.g. Datenbank |
| MariaDB_PASSWORD | Das Datenbank Passwort für MariaDB_USER |
| APP_PATH | Installationsverzeichnis des SVWS-Servers|
| CONF_PATH | Hier finden Sie die Konfigurationsdatei des SVWS-Servers|
| APP_PORT | Auf diesem Port ist der SVWS-Server erreichbar. i.d.R. ist dies einer der höheren Ports z.B. 8443, da für diese keine root-Rechte benötigt werden. Hier muss ggf. ein ReverseProxy oder eine Portumleitung eingerichtet werden, wenn man eine einfache URL verwenden möchte. |
| SVWS_TLS_KEYSTORE_PATH | Der Pfad des angelegten Keystores, um dort Daten zu speichern |
| SVWS_TLS_KEY_ALIAS | Alias des zu verwendenden Keys im Keystore |


## Daten einpflegen

### Testdatenbank anlegen

Wenn Sie im Installer-Dialog die Frage nach den Testdaten mit "Ja" beantworten und den vorgeschlagenen Pfad nicht verändern, wird eine mitgelieferte Beispieldatenbank mit Dummy-Daten eingespielt.
Weitere Testdatenbanken finden Sie in unserem Repository auf Github:  

https://github.com/SVWS-NRW/SVWS-TestMDBs

### Migration der eigenen Access Datenbank im Skript

Wählen Sie im Installer-Dialog "Ja" bei der Frage "Möchten Sie Testdaten importieren?" und ändern Sie den vorgeschlagenen Pfad so, dass dieser auf Ihre Accessdatenbank zeigt, die Sie migrieren wollen.
Per Skript ist nur die Migration aus einer Accessdatenbank möglich. Die Migration aus anderen DBMS kann aber nachträglich ausgeführt werden. Ebenso ist eine nächträgliche Migration einer bestehenden DB per Weboberfläche möglich (s.u).

### Migration der eigenen Access Datenbank per Weboberfläche

Wenn Sie bei der Installation der MariaDB-Datenbank im Skripe keine Testdaten importieren, wird automatisch eine leere SVWS-Datenbank erzeugt. Beim Start des Web-Client erkennt die Applikation, dass die Datenbank leer ist und bietet entsprechende Menüpunkte zur Einrichtung, Backup und Migration an. 

### weitere Möglichkeiten

Es gibt weitere Möglichkeiten zur Erstellung neuer Datenbanken bzw. zur Migration: 

+ per Swagger Oberfläche
+ per curl Befehl
+ per bash Skript
+ ... 

siehe dazu: [Datenmigration](https://doku.svws-nrw.de/Deployment/Datenmigration/)

## Sinnvolle Konfigurationen

## MariDB für Schild-NRW3 zugänglich machen

Solange Schild-NRW3 benötigt wird, muss die Datenbank und der Server für das Progrmm zugänglich gemacht werden.

Erreichbarkeit des MariaDB-Server auch außerhalb von localhost setzen:
```
/etc/mysql/mariadb.conf.d/50-server.cnf
bind-address 127.0.0.1 >> 0.0.0.0
```

Unter Umständen muss auch noch Port 3306 nach außen geöffnet werden, wenn eine Firewall eingerichtet ist.


## Portumleitung

Eine einfache Möglichkeit den SVWS-Server unter einer "normalen" URL erreichen zu können und somit auf das Apendix der Ports verzichten zu können, wäre eine Portumleitung. Der bessere Weg, vor allem in größeren Netzwerken, wäre der Einsatz eines ReverseProxies.   

In beiden Fällen könnte man statt zum Beispiel ```https://meineServeradresse:8443/``` dann unter ```https://meineServeradresse/``` den SVWS-Server direkt erreichen.


Umleiten des Ports 443 auf Port 8443 unter Ubuntu 22.04 mit iptables:

```bash iptables -A PREROUTING -t nat -p tcp --dport 443 -j REDIRECT --to-port 8443 ```

## ReverseProxy einrichten

Alternativ zur Portumleitung kann der nginx Webserver als ReverseProxy eingesetzt werden.


## UFW als Firewall einrichten

Für die Linuxmaschine im Livebetrieb empfiehlt sich eine Firewall einzurichten. Dies ist unterveieln anderen Möglichkeiten schnell und einfach mit ```ufw``` zu erreichen. 
