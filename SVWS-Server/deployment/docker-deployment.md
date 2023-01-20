***Betrieb des SVWSs unter Docker***
=========================================================
Es besteht die Möglichkeit, den SVWS als Container zu betreiben. Für folgende Szenarien eignet sich dieser Ansatz grundsätzlich:

* Betrieb einer lokalen SVWS-Umgebung für die Entwicklung (PC, Notebook), siehe [Start einer lokalen SVWS-Umgebung](#Start-einer-lokalen-SVWS-Umgebung)
* Aufbau einer kompletten SVWS-Umgebung für Test oder Live-Betrieb (Server), siehe [Start einer serverseitigen SVWS-Umgebung](#Start-einer-lokalen-SVWS-Umgebung)

Die SVWS-Container-Images sind unter Docker (docker engine, docker desktop) lauffähig. Ein Betrieb unter anderen Container-Umgebungen wie z.B. [Podman](https://podman.io/), [Kubernetes](https://kubernetes.io/de/), [OpenShift](https://www.redhat.com/de/technologies/cloud-computing/openshift) ist grundsätzlich möglich, jedoch zum Zeitpunkt der Erstellung dieser Dokumentation nicht getestet (Stand 20.01.2023).

# Lokale SVWS-Umgebung für die Entwicklung
Im folgenden wird der Ansatz beschrieben die SVWS-Images für die Entwicklung lokal zu betreiben. Dieser Ansatz bietet in der Entwicklung folgende Vorteile:
* Keine Notwendigkeit einer lokalen Installation von MariaDB
* Schnelles Rampup von SVWS-Datenbanken mit Testdaten
* Einfaches Zurücksetzen und Wiederherstellen der SVWS-Datenbanken auf definierte Zustände. Dies ist insbesondere für die Ausführung von automatisierten API- und Integrationstests mit Abhängigkeit zu Testdaten hilfreich.

Im Git-Repository des SVWSs befinden sich Scripts und Image-Definitionen zum Aufbau von docker-basierten SVWS-Systemumgebungen im Modul [deployment/docker](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker).

## Systemvoraussetzungen
Für die lokale Inbetriebnahme ist eine Installation von [Docker-Desktop](https://docs.docker.com/desktop/) auf dem Entwickler-PC notwendig.


Wichtig: Bitte die [Nutzungsbedingungen](https://www.docker.com/legal/docker-subscription-service-agreement) der Fa. Docker Inc. für Docker Desktop beachten!

## Start einer lokalen SVWS-Umgebung
Es gibt Gradle-Tasks, mit denen eine komplette Umgebung bestehend aus der SVWS-Anwendung und einer SVWS-Datenbank gestartet werden.

Start einer Umgebung aus der Console:
```
./gradlew :deployment:docker:dockerComposeUp
```

Die Gradle-Tasks nutzen [docker-compose](https://docs.docker.com/compose/) in der Version 3.

Achtung: Vor dem Start der SVWS-Umgebung müssen zunächst die [Konfiguration der SVWS-Umgebung](#Konfiguration-der-SVWS-Umgebung) individuell angepasst werden.


## Konfiguration der SVWS-Umgebung 
Die Konfiguration der Docker-basierten SVWS-Umgebung erfolgt über Umgebungsvariablen. Die Werte dieser Variablen werden in der Datei [.env]((https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker/.env) definiert.
Beispiel:
```
INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
TESTDB_PASSWORD=your-testdb-pw
MYSQL_ROOT_PASSWORD=your-mariadb-root-pw
MYSQL_DATABASE=your-svws-db-schema-name
MYSQL_HOST=mariadb
MYSQL_USER=your-mariadb-user
MYSQL_PASSWORD=your-mariadb-pw
MARIADB_DATA_DIR=/var/lib/mysql/data
MARIADB_LOG_DIR=/var/lib/mysql/log
SVWS_TLS_KEYSTORE_PATH=/etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD=your-keystore-pw
SVWS_TLS_KEY_ALIAS=your-keystore-key-alias
```
| Variable | Beschreibung |
| ----------- | ----------- |
| INIT_SCRIPTS_DIR | [Optional] Pfad zu einem Verzeichnis im SVWS-Container für Initialisierungsscripts. Alle Shell-Scripts in diesem Verzeichnis werden beim Hochfahren des SVWS-Containers ausgeführt. So können z.B. [automatische Testdatenimporte](#Automatische-Testdatenimporte) in den Boot-Prozess integriert werden. |
| TESTDB_PASSWORD | [Optional] Passwort der Testdatenbank (MS Access, SqlLite), das im Rahmen der [automatischen Testdatenimporte](#Automatische-Testdatenimporte) verwendet werden soll. |
| MYSQL_ROOT_PASSWORD | Passwort, das für den Root-User der MariaDB-Instanz verwendet werden soll |
| MYSQL_DATABASE | Name des Datenbankschemas, mit dem sich der SVWS-Server verbindet (z.B. "gymabi") |
| MYSQL_HOST | Name des Hosts, auf dem die SVWS-Datenbank läuft. Im Falle der Docker-Umgebung entspricht dieser Wert dem Service-Namen von docker-compose (also "mariadb"). |
| MYSQL_USER | Datenbank-Benutzer, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| MYSQL_PASSWORD | Passwort des Datenbank-Benutzers, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| MARIADB_DATA_DIR | Pfad zum Daten-Verzeichnis innerhalb der MariaDB-Instanz. Wird benötigt, um die Daten im Datenbank-Container auf einem Volume zu sichern (volume mount). Pfad hängt von dem verwendeten MariaDB Basis-Image ab. |
| MARIADB_LOG_DIR | Pfad zum Log-Verzeichnis innerhalb der MariaDB-Instanz. Wird benötigt, um die Loags im Datenbank-Container auf einem Volume zu sichern (volume mount). Pfad hängt von dem verwendeten MariaDB Basis-Image ab. |
| SVWS_TLS_KEYSTORE_PATH | Unter diesem Pfad erwartet der SVWS den Java-Keystore für die Terminierung von SSL am Server |
| SVWS_TLS_KEYSTORE_PASSWORD | Passwort des Keystores |
| SVWS_TLS_KEY_ALIAS | Alias des zu verwendenden Keys im Keystore  |


### Weitergehende, individuelle Konfigurationen
Weitergehende und individuelle Konfigurationen können in der docker-compose.yml vorgenommen werden. Die Konfigurationsmöglichkeiten sind den Dokumentationen der verwendeten Basis-Images zu entnehmen:

* [MariaDB](https://github.com/docker-library/docs/blob/master/mariadb/README.md)
* [Eclipse Temurin](https://github.com/docker-library/docs/tree/master/eclipse-temurin)

### Automatische Testdatenimporte
TBD


## Start einer serverseitigen SVWS-Umgebung
TBD
