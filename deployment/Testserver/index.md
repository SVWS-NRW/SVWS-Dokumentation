# Template Testserver SVWS-Server

Ziel ist es ein Template für einen SVWS-Server zu erstellen. Anwendungen können hierbei sein: 

+ Nightly builds zu Testzwecken
+ Schnelle Verfügbarkeit verschiedener SVWS-server unterschiedlicher Versionsnummern
+ Ausrollen auf Schulungsumgebungen
+ nächtlichen automatischen Zurücksetzung aller Datenbanken

Dies soll als Grundlage für die Schulungsclients oder zur Entwicklung eine Nightly-Servers dienen.

## Installation auf Basis eines Builds aus den Github Quellen

Dieses Skript kann z.B. für einen nightly build SVWS-Server genutzt werden oder zum Austesten verschiedener Branches: 

[install_testserver.sh](install_testserver.sh)

Es installiert einen SVWS-Testserver basierens auf den Github Quellen. 

## Update per Skipt

Mit dem Skript 

[update_testserver.sh](update_testserver.sh) 

## Zurücksettzen der Datenbanken per Skript

Mit dem Skript

[update_dbs.sh](update_dbs.sh)

können alle Datenbanken gelöscht werden und neu eingespielt werden. Diese Skript kann zum Beispiel 