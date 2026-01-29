# Template Testserver SVWS-Server

Ziel ist es ein Template für einen SVWS-Server zu erstellen. Anwendungen können hierbei sein: 

+ Nightly builds zu Testzwecken
+ Schnelle Verfügbarkeit verschiedener SVWS-server unterschiedlicher Versionsnummern
+ Ausrollen auf Schulungsumgebungen
+ nächtlichen automatischen Zurücksetzung aller Datenbanken

Dies soll als Grundlage für die Schulungsclients oder zur Entwicklung eine Nightly-Servers dienen.

## Installation mit dem Linuxinstaller

Diese recht einfache Methode benötigt ein Debian 12 oder 13 als Basis und ist eine schnelle Methode, um einen Testserver im Betriebsstatus "stable" auf dem aktuellen Release zu erzeugen. 
Das Skript install.sh ist in unseren [Githubquellen](https://github.com/SVWS-NRW/SVWS-Server/releases]) verfügbar.

Möchte man hier z.B. die Environmet Variablen z.B. beim Aufsetzen von mehreren Schulungsclients schon direkt mit übergeben, kann dies wie in dem folgenden Installationsscript beispielsweise umgesetzt werden:

[install_svws-testserver-linuxinstaller.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_svws-testserver-linuxinstaller.sh)

## Installation auf Basis eines Docker Containers

Diese etwas Methode ist im Vergleich zum Linuxinstaller etwas aufwändiger. Sie ermöglicht aber das schnelle Ausrollen eines SVWS-Server auf unterschiedlichen Releases und mit unterschiedlichen Mariadb Varianten. Ebenso ist das Wechseln zwischen den Releases zügig umsetzbar.

[install_svws-testserver-docker.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_svws-testserver-docker.sh)

## Installation auf Basis eines Builds aus den Github Quellen

Dies kann z.B. für einen nightly build SVWS-Server genutzt werden oder zum Austesten verschiedener Branches. Hier wird die aktuellste Version des branches als Grundlage für den SVWS-Server genommen. 

[install_svws-testserver-from-scratch.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_svws-testserver-docker.sh)

## Einspielen der Datenbanken

Das Einspielen der Datenbanken kann in einem separaten Skript erfolgen:

load_testdbs.sh


## Zurücksetzen der Datenbanken per Skript

Mit dem Skript update_dbs.sh 

können alle Datenbanken gelöscht werden und neu eingespielt werden. 


## .env Datei

Die Sktipte können alle auf eine .env Datei zurückgreifen, die serverspezifisch eingerichtet werden kann. 

hier eine Übersicht über die gesetzten Variablen:

MARIADB_ROOT_PW=
SCHEMA_USER=myuser
SCHEMA_PW=
SERVERNAME=localhost