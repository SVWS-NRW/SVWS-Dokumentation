# Docker-Container 

Der SVWS-Server kann als Container betrieben werden. Dies eignet sich insbesondere für die folgenden beisen Szenarien:

* Betrieb einer SVWS-Umgebung für Produktiv- oder Test-Betrieb [per docker-compose](#svws-umgebung-mit-docker-compose-starten)


Die SVWS-Container-Images sind unter Docker (docker engine, docker desktop) lauffähig. Ein Betrieb unter anderen Container-Umgebungen wie z.B. 
[Podman](https://podman.io/), [Kubernetes](https://kubernetes.io/de/), [OpenShift](https://www.redhat.com/de/technologies/cloud-computing/openshift) 
ist grundsätzlich möglich, jedoch noch nicht getestet (Stand 27.09.2024).

Im Git-Repository von SVWS befinden sich [Beispiele, Scripte und Image-Definitionen](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker) 
zum Aufbau von Docker-basierten SVWS-Umgebungen.


## Systemvoraussetzungen Installation Docker-Umgebung
Für die lokale Inbetriebnahme ist eine Installation von [Docker](https://docs.docker.com) auf dem Entwickler-PC notwendig.
Bitte die [Nutzungsbedingungen](https://www.docker.com/legal/docker-subscription-service-agreement) der Fa. Docker Inc. für Docker beachten!

Bitte Informieren Sie sich auf der Dokumentationsseite von Docker über die notwendigen Schritte in Ihrer Umgebung.


## SVWS-Umgebung mit docker-compose starten

Die SVWS-Umgebung kann über die Konsole des verwendeten Betriebssystems mittels docker-compose gestartet werden. 
Beispiele zur dazu obligatorischen docker-compose.yml und Dateien befinden sich im [Github-Repository](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker/example) .

### Beipiel: aktuellen Testserver im Docker Container

[Beispiel einer vorbereiteten Docker-Compose](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Docker/svws-docker-example.zip)

Diese Datei muss in einem Order entpackt werden und legt damit die geforterte Ordnerumgebung an, so dass der Keystore beim ertsen Start des SVWS-Servers erzeugt wird und danach erhalten bleibt.

Außerdem werden Volumes für die Daten der MariaDB angelegt, die später ja auch erhalten beleiben müssen.

Es werden nun Services für eine komplette SVWS-Umgebung gestartet: Datenbank, SVWS-Anwendung (Backend, Frontend). Ebenso sind die Volumes für den Keystore gemounted. 

Nach dem Start kann der SVWS-Server über den Port 8443 erreicht werden. 
Auf die Datenbank kann standardmäßig nicht außerhalb der Docker-Umgebung zugegriffen werden (not bound). 
Intern nutzt die Datenbank den Port 3306. Für den Zugriff von SchILD 3 ist ein Port-Binding auch außerhalb von Docker nötig, 
dies wird über die Angabe eines Port-Mappings (ports) Eintrag in der Datei erreicht. 
In diesem Beispiel wird der Port 3306 im Container auf den Port 3306 auf dem Host abgebildet.:

Beispiel:
```yaml
...
services:
  mariadb:
    ...
    ports:
        - "3306:3306"
    ...
```
## Konfiguration der SVWS-Umgebung 
Die Konfiguration der Docker-basierten SVWS-Umgebung erfolgt über Umgebungsvariablen. 
Die Werte dieser Variablen werden in der Datei .env definiert. 

Hier ein Beispiel: 
```bash
INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
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


## Automatische Initialisierung beim Start, Testdatenimporte
Es besteht die Möglichkeit, beim Start der SVWS-Container die Datenbank mit Testdaten zu initialisieren. Es existiert ein [Beispiel-Script](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/testing/svws/init-scripts/001import-test-db.sh) für den Import einer Testdatenbank im Git-Repository.

Funktionsweise: Beim Start der SVWS-Container wird der Inhalt des Ordners [init-scripts](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/testing/svws/init-scripts) in den SVWS-Container eingebunden (per volume mount). Alle Shell-Scripts (*.sh) in diesem Ordner werden durch das Start-Script des Containers im Anschluss ausgeführt.

### Aktivierung der automatischen Initialisierung
Umgebungsvariable `INIT_SCRIPTS_DIR` muss gesetzt sein (vgl. [Konfiguration der SVWS-Umgebung](#Konfiguration-der-SVWS-Umgebung)). 

Datei [./deployment/docker/example/svws+db+init/.env](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/deployment/docker/example/svws%2Bdb%2Binit/.env):
```bash
INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
#...
```

### Deaktivierung der automatischen Initialisierung
Umgebungsvariable `INIT_SCRIPTS_DIR` muss auskommentiert sein (vgl. [Konfiguration der SVWS-Umgebung](#Konfiguration-der-SVWS-Umgebung)).

Datei [./deployment/docker/example/svws+db+init/.env](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/deployment/docker/example/svws%2Bdb%2Binit/.env):
```bash
#INIT_SCRIPTS_DIR=/etc/app/svws/init-scripts
#...
```
Diese Zeile sollte nach dem ersten Start immer auskommentiert werden, es sei denn man möchte einen Container erstellen, der nach dem Start immer "frische" Testdaten haben soll.

Sollten Sie auch beim ersten Start keine Testdaten wünschen, weil Sie mit Produktivdaten weiter arbeiten wollen. So benennen Sie bitte die im ZIP-Paket enthaltene svwsconfig-nodata.json >> svwsconfig-template.json um. Die ursprüngliche muss natürlich gelöscht oder auch umbenannt werden.

Es wird dann durch die Einträge in der .env ein leeres und nicht initialisiertes Schema angelegt, welches später über die API oder im Admin-Client mit Daten befüllt werden kann.

```bash
MARIADB_DATABASE=your-svws-db-schema-name
MARIADB_HOST=mariadb
MARIADB_USER=your-mariadb-user
MARIADB_PASSWORD=your-mariadb-pw
```

Wichtig! Momentan benötigt der SVWS-Server noch mindestens ein gültiges (leeres) Schema in der Mariadb. Das wird noch behoben.