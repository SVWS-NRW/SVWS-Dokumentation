# Template-Testserver SVWS-Server

Ziel ist es, ein Template für einen SVWS-Server zu erstellen. Anwendungen können hierbei sein:

+ Nightly Builds zu Testzwecken
+ Schnelle Verfügbarkeit verschiedener SVWS-Server unterschiedlicher Versionsnummern
+ Ausrollen auf Schulungsumgebungen
+ Nächtliche, automatische Zurücksetzung aller Datenbanken

Dies soll als Grundlage für die Schulungsclients oder zur Entwicklung eines Nightly-Servers dienen.

## Installation mit dem Linuxinstaller

Diese Methode benötigt ein Debian 13 als Basis und ist eine schnelle Methode, um einen Testserver im Betriebsstatus `stable` auf dem aktuellen Release zu erzeugen.

Das Skript `install.sh` ist in unseren [Githubquellen](https://github.com/SVWS-NRW/SVWS-Server/releases]) verfügbar.

Möchte man hier die Umgebungsvariablen z.B. beim Aufsetzen von mehreren Schulungsclients schon direkt mit übergeben, kann dies wie in dem folgenden Installationsskript umgesetzt werden:

[install_svws-testserver-linuxinstaller.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_svws-testserver-linuxinstaller.sh)

## Installation auf Basis eines Docker-Containers

Diese Methode ist im Vergleich zum Linux-Installer etwas aufwändiger. Sie ermöglicht aber das Ausrollen eines SVWS-Servers auf unterschiedlichen Releases und mit unterschiedlichen MariaDB Varianten. Ebenso ist das Wechseln zwischen den Releases zügig umsetzbar.

[install_svws-testserver-docker.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_svws-testserver-docker.sh)

## Installation auf Basis eines Builds aus den Github Quellen

Dies kann z.B. für einen nightly Build des SVWS-Server genutzt werden oder zum Austesten verschiedener Branches. Hier wird die aktuelle Version des Branches als Grundlage für den SVWS-Server genommen.

[install_svws-testserver-from-scratch.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_svws-testserver-docker.sh)


## `.env`-Datei

Die Skripte können alle auf eine `.env`-Datei zurückgreifen, die serverspezifisch eingerichtet werden kann.

Hier eine Übersicht über die gesetzten Variablen:

```bash
CREATE_MARIADB=j
CREATE_KEYSTORE=j
MARIADB_ROOT_PASSWORD=
APP_PATH=/opt/app/svws
CONF_PATH=/etc/app/svws/conf
APP_PORT=8443
SVWS_TLS_KEYSTORE_PATH=/etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD=
SVWS_TLS_KEY_ALIAS=svws
INPUT_COMMON_NAME=svws
INPUT_ORGANIZATIONAL_UNIT=svws
INPUT_ORGANIZATION=svws
INPUT_LOCALITY=NRW
INPUT_STATE=NRW
INPUT_COUNTRY=DE
validity_days=3650
MARIADB_ROOT_PW=
SCHEMA_USER=
SCHEMA_PW=
SERVERNAME=
```

Bei den Skripten zum Import, Vervielfältigen oder Löschen der Datenbanken wird, falls kein Parameter im Skriptaufruf übergeben wird, entweder die auf dem Proxmox bzw Dockersystem liegende `.env`-Datei oder danach die explizit im SVWS-Server vorgehaltene `.env´-Datei ausgelesen.
