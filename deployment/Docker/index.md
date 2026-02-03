# Docker-Container 

Der SVWS-Server kann als Container betrieben werden. Dies eignet sich insbesondere für die folgenden beiden Szenarien:

* Betrieb einer SVWS-Umgebung für Produktiv- oder Test-Betrieb [per docker-compose](#svws-umgebung-mit-docker-compose-starten)


Die SVWS-Container-Images sind unter Docker (docker engine, docker desktop) lauffähig. Ein Betrieb unter anderen Container-Umgebungen wie z.B. 
[Podman](https://podman.io/), [Kubernetes](https://kubernetes.io/de/), [OpenShift](https://www.redhat.com/de/technologies/cloud-computing/openshift) 
ist grundsätzlich möglich, jedoch noch nicht getestet (Stand 27.09.2024).

Im Git-Repository von SVWS befinden sich [Beispiele, Skripte und Image-Definitionen](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker) 
zum Aufbau von Docker-basierten SVWS-Umgebungen.


## Systemvoraussetzungen Installation Docker-Umgebung
Für die lokale Inbetriebnahme ist eine Installation von [Docker](https://docs.docker.com) auf dem Entwickler-PC notwendig.
Bitte die [Nutzungsbedingungen](https://www.docker.com/legal/docker-subscription-service-agreement) der Fa. Docker Inc. für Docker beachten!

Bitte informieren Sie sich auf der Dokumentationsseite von Docker über die notwendigen Schritte in Ihrer Umgebung.


## SVWS-Umgebung mit docker-compose starten

Die SVWS-Umgebung kann über die Konsole des verwendeten Betriebssystems mittels docker-compose gestartet werden. 
Beispiele zur dazu obligatorischen docker-compose.yml und Dateien befinden sich im [Github-Repository](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker/example) .

### Beispiel: Testserver im Docker Container

Beispiel einer vorbereiteten Docker-Compose:

```yaml
services:
  mariadb:
    restart: always
    image: mariadb:latest
    container_name: svws1_mariadb
    env_file:
      - .env
    healthcheck:
      test: ["CMD-SHELL", "mariadb-admin ping -h localhost -u root -p20742{MARIADB_ROOT_PASSWORD}"]
      start_period: 20s
      interval: 5s
      timeout: 5s
      retries: 3
    volumes:
      - ./volume/mariadb:/var/lib/mysql

  svws-server:
    image: svwsnrw/svws-server:1.2.1
    depends_on:
      mariadb:
        condition: service_healthy
    container_name: svws1
    ports:
      - "8443:8443"
    volumes:
      - ./volume/svws:/opt/app/svws/conf
    env_file:
      - .env

```
Beispiel der zugehörigen .env Datei wird weiter unten aufgeführt
```bash 
IMPORT_TEST_DATA=false
MARIADB_ROOT_PASSWORD=
MARIADB_HOST=mariadb
SVWS_TLS_KEYSTORE_PASSWORD=
SVWS_TLS_KEY_ALIAS=svws
SVWS_TLS_KEYSTORE_PATH=.
SVWS_TLS_CERT_CN=SVWSTESTSERVER
SVWS_TLS_CERT_OU=SVWSOU
SVWS_TLS_CERT_O=SVWSO
SVWS_TLS_CERT_L=D
SVWS_TLS_CERT_S=NRW
SVWS_TLS_CERT_C=DE
```
Es müssen natürlich noch entsprechende Passwörter generiert bzw. in die .env Datei eingetragen werden. 
Im Ordner Volume werden dann für svws und mariadb entsprechende Ordner angelegt.

Im Ordner svws werden beim ersten Hochfahren des Containers die svwsconfig.json und der Keystore angelegt. Diese können dort auch mit einer eigenen Konfiguration bzw. eigenen Zertifikatseinstellungen abgelegt werden. Im Ordner svws/logs werden später die LOG-Dateien erscheinen, wenn der logging-Pfad auf Defaulteinstellung bleibt.

Es werden nun Services für eine komplette SVWS-Umgebung gestartet: Datenbank, SVWS-Anwendung (Backend, Frontend). Ebenso sind die Volumes für den Keystore gemountet. 

Nach dem Start kann der SVWS-Server über den Port 8443 erreicht werden. 
Auf die Datenbank sollte standardmäßig nicht außerhalb der Docker-Umgebung zugegriffen werden.  Intern nutzt die Datenbank den Port 3306. Für den Zugriff von SchILD 3 ist ein Port-Binding auch außerhalb von Docker nötig, 
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

Diese Ports müssen auf Ihre Umgebung angepasst werden, je nach Anforderung.

## Konfiguration der SVWS-Umgebung 
Die Konfiguration der Docker-basierten SVWS-Umgebung erfolgt über Umgebungsvariablen. 
Die Werte dieser Variablen werden in der Datei .env definiert. 

Hier ein weiteres Beispiel: 
```bash
IMPORT_TEST_DATA=true
MARIADB_ROOT_PASSWORD=
MARIADB_DATABASE=svwsdb
MARIADB_HOST=mariadb
MARIADB_USER=your-mariadb-user
MARIADB_PASSWORD=
SVWS_TLS_KEYSTORE_PATH=/etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD=
SVWS_TLS_KEY_ALIAS=svws
SVWS_TLS_CERT_CN=YOURCERTNAME
SVWS_TLS_CERT_OU=SVWSOU
SVWS_TLS_CERT_O=SVWSO
SVWS_TLS_CERT_L=CITY
SVWS_TLS_CERT_S=STATE
SVWS_TLS_CERT_C=COUNTRY
```

| Variable | Beschreibung |
| ----------- | ----------- |
| IMPORT_TEST_DATA | true Startet den automatischen Import, Default = false |
| MARIADB_ROOT_PASSWORD | Passwort, das für den Root-User der MariaDB-Instanz verwendet werden soll |
| MARIADB_DATABASE | Name des Datenbankschemas, mit dem sich der SVWS-Server verbindet (z.B. "gymabi") |
| MARIADB_HOST | Name des Hosts, auf dem die SVWS-Datenbank läuft. Im Falle der Docker-Umgebung entspricht dieser Wert dem Service-Namen von docker-compose (also "mariadb"). |
| MARIADB_USER | Datenbank-Benutzer, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| MARIADB_PASSWORD | Passwort des Datenbank-Benutzers, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| SVWS_TLS_KEYSTORE_PATH | Unter diesem Pfad erwartet der SVWS den Java-Keystore für die Terminierung von SSL am Server |
| SVWS_TLS_KEYSTORE_PASSWORD | Passwort des Keystores |
| SVWS_TLS_KEY_ALIAS | Alias des zu verwendenden Keys im Keystore  |
| SVWS_TLS_CERT_CN | Name des selbstsignierten Zertifikats Default:SVWSCERT|
| SVWS_TLS_CERT_OU | Name der Organistationseinheit Default: SVWSOU |
SVWS_TLS_CERT_O| Name der Organisation Default:SVWSO |
| SVWS_TLS_CERT_L=CITY | Name des Ortes Default: Duesseldorf |
| SVWS_TLS_CERT_S=STATE | Name des Bundeslands Name Default: NRW |
| SVWS_TLS_CERT_C=COUNTRY | Name des Staates Default: Germany |

## Automatische Initialisierung beim Start, Testdatenimporte
Es besteht die Möglichkeit, beim Start der SVWS-Container die Datenbank mit Testdaten zu initialisieren. Ansonsten kann anch dem Start des Containers der dmin-Client aufgerufen werden und weitere Daten können importiert werden.

Funktionsweise: Beim Start der SVWS-Container wird die Variable IMPORT_TEST_DATA ausgewertet. Wenn diese auf "true" steht, dann wird aus dem Repository von SVWS-NRW eine Testdatenbank heruntergeladen und importiert.

Achtung! Wenn die Variable auf "true" stehen bleibt geschieht dies bei jedem Start. Dies ist nur für Entwickler erforderlich, die immer eine frische Testdatenbank benötigen.

```bash
IMPORT_TEST_DATA=true
#...
```

### Deaktivierung der automatischen Initialisierung
Umgebungsvariable `INIT_SCRIPTS_DIR` muss auskommentiert sein (vgl. [Konfiguration der SVWS-Umgebung](#Konfiguration-der-SVWS-Umgebung)).

```bash
IMPORT_TEST_DATA=false
#...
```

Diese Zeile sollte nach dem ersten Start immer auskommentiert oder auf "false" gesetzt werden, es sei denn man möchte einen Container erstellen, der nach dem Start immer "frische" Testdaten haben soll.

Sie können in der .env Datei auch ein Schema ohne Migration angeben, dann wird dies beim ersten Start ohne Daten angelegt. Dies kann dann im Admin-Client befüllt werden.

```bash
MARIADB_DATABASE=your-svws-db-schema-name
MARIADB_HOST=mariadb
MARIADB_USER=your-mariadb-user
MARIADB_PASSWORD=
```


