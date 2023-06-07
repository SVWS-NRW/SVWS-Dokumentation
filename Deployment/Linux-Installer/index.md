# Linux Installer


Download unter:   
https://storage.svws-nrw.de/linux_installer/  
oder  
https://www.svws.nrw.de/uploads/media/linux/0.6.2/install.zip  


Dieses Skript ist für die Installation des SVWS-Servers auf einem Debian-basierten System gedacht.  
Bisher getestet sind:  
- Debian 11
- Ubuntu 22.04 LTS 
- Ubuntu 22.10 


## Voraussetzungen

- Ein Debian-basiertes Betriebssystem
- Zugriff mit Root-Rechten

## Verwendung

- Laden Sie das Skript auf den Zielcomputer herunter.
- Öffnen Sie die Terminalanwendung und navigieren Sie zum Verzeichnis, in dem sich das Skript befindet.
- Geben Sie den Befehl ``chmod +x /install.sh`` ein und drücken Sie die Eingabetaste.
- Geben Sie den Befehl ``./install.sh ein`` und drücken Sie die Eingabetaste.
- Folgen Sie den Anweisungen im Skript.

## Konfiguration

Das Skript bietet verschiedene Optionen zur Konfiguration. Wenn Sie die Standardeinstellungen verwenden möchten, können Sie die Option **--default** verwenden, um die Konfiguration zu vereinfachen.

Folgende Konfigurationen können vorgenommen werden:

- MariaDB-Konfiguration
- Installationspfade
- Erstellung eines Keystores für TLS
- Import von Testdaten

Hier finden Sie einen beispielhaften Dialog: 

```
MariaDB-Konfiguration:
Möchten Sie die MySQL-Datenbank erstellen? (j/N): j
MYSQL_ROOT_PASSWORD (default: 'abcd1234'): abcd1234
MYSQL_DATABASE (default: 'svwsdb'): svwsdb
MYSQL_HOST (default: 'localhost'): localhost
MYSQL_USER (default: 'svwsadmin'): svwsadmin
MYSQL_PASSWORD (default: 'abcd1234'): abcd1234
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
Die Passwortvorschläge werden natürlich frisch generiert. Bitte sichern Sie unbedingt die verwendeten Passwörter: Diese Daten werden vom Skript nicht gespeichert!  

Erläuterungen zu den einzelnen Punkten: 
| Variable |Erläuterung|
|-------------|---------------|
| MARIAD_ROOT_PASSWORD | Das Datenbank Passwort der Datenbankadministratoren |
| MYSQL_DATABASE | Name der Datenbank |
| MYSQL_HOST | Bei kleinen Installationen wird die Mariadb i.d.R. auf dem localen System (localhost) liegen. Ggf. kann hier auch die url zu einem separaten MariaDB-Server eingetragen werden.| 
| MYSQL_USER | User mit Vollzugriff auf die o.g. Datenbank |
| APP_PATH | Installationsverzeichnis des SVWS-Servers|
| CONF_PATH | Hier finden Sie die Konfigurationsdatei des SVWS-Servers|
| APP_PORT | Auf diesem Port ist der SVWS-Server erreichbar. i.d.R ist dies einer der höheren Ports z.B. 8443, da hier keine root rechte benötigt werden. Hier muss ggf ein ReverseProxy oder eine Portumlenkung eingerichtet werden, wenn man eine einfache URL verwenden möchte. |
| SVWS_TLS_KEYSTORE_PATH | Es wird hier ein Keystore angelegt, um dieser Daten zu speichern |
| SVWS_TLS_KEY_ALIAS |  |

## Schuldaten anlegen 

### Testdatenbank 

### Migration der eigenen mdb

### Leeres Schema erzeugen



## Wichtige Hinweise

- Verwenden Sie dieses Skript auf eigene Gefahr.
- Führen Sie das Skript nur auf einem Testsystem durch, bevor Sie es auf einem Produktivsystem verwenden.
- Stellen Sie sicher, dass alle Konfigurationen und Passwörter sicher gespeichert und aufbewahrt werden.
- Beachten Sie, dass das Skript eine Internetverbindung benötigt, um bestimmte Pakete herunterzuladen und zu installieren.

## Umleiten des Ports 443 auf Port 8443 unter Ubuntu 22.04 mit Iptables

iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8080

