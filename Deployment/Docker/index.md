# Docker-Container 

## Betrieb von SVWS unter Docker

Es besteht die Möglichkeit, den SVWS-Server als Container zu betreiben. Für folgende Szenarien eignet sich dieser Ansatz grundsätzlich:

* Betrieb einer SVWS-Umgebung für die Entwicklung (PC, Notebook)
* Betrieb einer SVWS-Umgebung für Test oder Live-Betrieb (Server)

Die SVWS-Umgebung kann über mehrere Wege gestartet werden:
 * [SVWS-Umgebung mit docker-compose starten](#svws-umgebung-mit-docker-compose-starten)
 * [SVWS-Umgebung mit Gradle starten](#svws-umgebung-mit-gradle-starten)
 * [Ausgewählte Services einer SVWS-Umgebung starten](#ausgewahlte-services-einer-svws-umgebung-starten)


Die SVWS-Container-Images sind unter Docker (docker engine, docker desktop) lauffähig. Ein Betrieb unter anderen Container-Umgebungen wie z.B. [Podman](https://podman.io/), [Kubernetes](https://kubernetes.io/de/), [OpenShift](https://www.redhat.com/de/technologies/cloud-computing/openshift) ist grundsätzlich möglich, jedoch zum Zeitpunkt der Erstellung dieser Dokumentation nicht getestet (Stand 20.01.2023).

## Lokale SVWS-Umgebung für die Entwicklung
Im folgenden wird der Ansatz beschrieben, die SVWS-Images für die Entwicklung lokal zu betreiben. Dieser Ansatz bietet in der Entwicklung folgende Vorteile:
* Keine Notwendigkeit einer lokalen Installation von MariaDB
* Schnelles Rampup von SVWS-Datenbanken mit Testdaten
* Einfaches Zurücksetzen und Wiederherstellen der SVWS-Datenbanken auf definierte Zustände. Dies ist insbesondere für die Ausführung von automatisierten API- und Integrationstests mit Abhängigkeit zu Testdaten hilfreich.

Im Git-Repository von SVWS befinden sich Scripte und Image-Definitionen zum Aufbau von Docker-basierten SVWS-Systemumgebungen im Modul [./deployment/docker](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker).

## Systemvoraussetzungen
Für die lokale Inbetriebnahme ist eine Installation von [Docker-Desktop](https://docs.docker.com/desktop/) auf dem Entwickler-PC notwendig.


Wichtig: Bitte die [Nutzungsbedingungen](https://www.docker.com/legal/docker-subscription-service-agreement) der Fa. Docker Inc. für Docker Desktop beachten!

<a name="docker-compose-starten"></a>
## SVWS-Umgebung mit docker-compose starten
Die SVWS-Umgebung kann über die Konsole des verwendeten Betriebssystems mittels docker-compose gestartet werden. Dazu, ausgehend von dem Verzeichnis [./deployment/docker](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker/), folgenden Befehl auf der Konsole eingeben:

```bash
docker compose up
```

Es werden nun Services für eine komplette SVWS-Umgebung gestartet: Datenbank, SVWS-Anwendung (Backend, Frontend).

Achtung: Vor dem Start der SVWS-Umgebung muss zunächst die [Konfiguration der SVWS-Umgebung](#konfiguration-der-svws-umgebung) individuell angepasst werden.

Nach dem Start kann der SVWS-Server über den Port 8443 erreicht werden. Auf die Datenbank kann standardmäßig nicht außerhalb der Docker-Umgebung zugegriffen werden (not bound). Intern nutzt die Datenbank den Port 3306. Für den Zugriff von SchILD 3 ist ein Port-Binding auch außerhalb von Docker nötig, dies wird über die Angabe eines Port-Mappings (ports) Eintrag in der Datei erreicht:

Beispiel:
```yaml
version: "3"
services:
  mariadb:
    ...
    ports:
        - "3306:13306"
    ...
```
In diesem Beispiel wird der Port 3306 im Container auf den Port 13306 auf dem Host abgebildet.

<a name="gradle-starten"></a>
## SVWS-Umgebung mit Gradle starten
Es existieren vordefinierte Gradle-Tasks, mit denen eine komplette Umgebung, bestehend aus der SVWS-Anwendung und einer SVWS-Datenbank, aus der Entwicklungsumgebung heraus gestartet werden können.

Start einer Umgebung aus der Console:
```bash
./gradlew :deployment:docker:dockerComposeUp
```

Die Gradle-Tasks nutzen [docker-compose](https://docs.docker.com/compose/) in der Version 3.

Achtung: Vor dem Start der SVWS-Umgebung muss zunächst die [Konfiguration der SVWS-Umgebung](#konfiguration-der-svws-umgebung) individuell angepasst werden.

<a name="ausgewaehlte-services-starten"></a>
## Ausgewählte Services einer SVWS-Umgebung starten
Es besteht die Möglichkeit, nur einzelne ausgewählte Services einer SVWS-Umgebung über Docker zu betreiben. Also z.B. nur eine Datenbank oder nur die SVWS-Anwendung.

Beispiel "nur Datenbank":
```bash
docker compose start mariadb
```

Beispiel "nur SVWS-Anwendung":
```bash
docker compose start svws
```

<a name="konfiguration"></a>
## Konfiguration der SVWS-Umgebung 
Die Konfiguration der Docker-basierten SVWS-Umgebung erfolgt über Umgebungsvariablen. Die Werte dieser Variablen werden in der Datei [./deployment/docker/example/svws+db+init/.env](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/deployment/docker/example/svws%2Bdb%2Binit/.env) definiert.
Beispiel:
```bash
INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
TESTDB_PASSWORD=your-testdb-pw
MARIADB_ROOT_PASSWORD=your-mariadb-root-pw
MARIADB_DATABASE=your-svws-db-schema-name
MARIADB_HOST=mariadb
MARIADB_USER=your-mariadb-user
MARIADB_PASSWORD=your-mariadb-pw
MARIADB_DATA_DIR=/var/lib/mysql/data
MARIADB_LOG_DIR=/var/lib/mysql/log
SVWS_TLS_KEYSTORE_PATH=/etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD=your-keystore-pw
SVWS_TLS_KEY_ALIAS=your-keystore-key-alias
```

| Variable | Beschreibung |
| ----------- | ----------- |
| INIT_SCRIPTS_DIR | [Optional] Pfad zu einem Verzeichnis im SVWS-Container für Initialisierungsskripts. Alle Shell-Skripts in diesem Verzeichnis werden beim Hochfahren des SVWS-Containers ausgeführt. So können z.B. [automatische Testdatenimporte](#automatische-initialisierung-beim-start-testdatenimporte) in den Boot-Prozess integriert werden. |
| TESTDB_PASSWORD | [Optional] Passwort der Testdatenbank (MS Access, SqlLite), das im Rahmen der [automatische Testdatenimporte](#automatische-initialisierung) verwendet werden soll. |
| MARIADB_ROOT_PASSWORD | Passwort, das für den Root-User der MariaDB-Instanz verwendet werden soll |
| MARIADB_DATABASE | Name des Datenbankschemas, mit dem sich der SVWS-Server verbindet (z.B. "gymabi") |
| MARIADB_HOST | Name des Hosts, auf dem die SVWS-Datenbank läuft. Im Falle der Docker-Umgebung entspricht dieser Wert dem Service-Namen von docker-compose (also "mariadb"). |
| MARIADB_USER | Datenbank-Benutzer, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| MARIADB_PASSWORD | Passwort des Datenbank-Benutzers, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| MARIADB_DATA_DIR | Pfad zum Daten-Verzeichnis innerhalb der MariaDB-Instanz. Wird benötigt, um die Daten im Datenbank-Container auf einem Volume zu sichern (volume mount). Pfad hängt von dem verwendeten MariaDB Basis-Image ab. |
| MARIADB_LOG_DIR | Pfad zum Log-Verzeichnis innerhalb der MariaDB-Instanz. Wird benötigt, um die Logs im Datenbank-Container auf einem Volume zu sichern (volume mount). Pfad hängt von dem verwendeten MariaDB Basis-Image ab. |
| SVWS_TLS_KEYSTORE_PATH | Unter diesem Pfad erwartet der SVWS den Java-Keystore für die Terminierung von SSL am Server |
| SVWS_TLS_KEYSTORE_PASSWORD | Passwort des Keystores |
| SVWS_TLS_KEY_ALIAS | Alias des zu verwendenden Keys im Keystore  |


### Weitergehende, individuelle Konfigurationen
Weitergehende und individuelle Konfigurationen können in der `docker-compose.yml` vorgenommen werden. Die Konfigurationsmöglichkeiten sind den Dokumentationen der verwendeten Basis-Images zu entnehmen:

* [MariaDB](https://github.com/docker-library/docs/blob/master/mariadb/README.md)
* [Eclipse Temurin](https://github.com/docker-library/docs/tree/master/eclipse-temurin)

<a name="automatische-initialisierung"></a>
## Automatische Initialisierung beim Start, Testdatenimporte
Es besteht die Möglichkeit, beim Start der SVWS-Container die Datenbank mit Testdaten zu initialisieren. Es existiert ein [Beispiel-Script](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/testing/svws/init-scripts/001import-test-db.sh) für den Import einer Testdatenbank im Git-Repository.

Funktionsweise: Beim Start der SVWS-Container wird der Inhalt des Ordners [init-scripts](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/testing/svws/init-scripts) in den SVWS-Container eingebunden (per volume mount). Alle Shell-Scripts (*.sh) in diesem Ordner werden durch das Start-Script des Containers im Anschluss ausgeführt.

### Aktivierung der automatischen Initialisierung
Umgebungsvariable `INIT_SCRIPTS_DIR` muss gesetzt sein (vgl. [Konfiguration der SVWS-Umgebung](#Konfiguration-der-SVWS-Umgebung)). Sofern eine Testdatenbank importiert wird, muss zusätzlich das Passwort `TESTDB_PASSWORD` für die Quelldatenbank angegeben werden.

Datei [./deployment/docker/example/svws+db+init/.env](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/deployment/docker/example/svws%2Bdb%2Binit/.env):
```bash
INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
TESTDB_PASSWORD=your-testdb-pw
#...
```

### Deaktivierung der automatischen Initialisierung
Umgebungsvariable `INIT_SCRIPTS_DIR` muss auskommentiert sein (vgl. [Konfiguration der SVWS-Umgebung](#Konfiguration-der-SVWS-Umgebung)).

Datei [./deployment/docker/example/svws+db+init/.env](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/deployment/docker/example/svws%2Bdb%2Binit/.env):
```bash
#INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
#...
```
