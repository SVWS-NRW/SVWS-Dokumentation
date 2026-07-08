# Docker-Container

Der SVWS-Server kann in einem Docker-Container betrieben werden.

Die bereitgestellten SVWS-Container-Images sind mit Docker (Docker Engine und Docker Desktop) kompatibel. Der Einsatz in anderen Container-Umgebungen wie Podman, Kubernetes oder OpenShift ist grundsätzlich möglich, wurde jedoch bislang nicht getestet (Stand: Mitte 2026).

## Systemvoraussetzungen Installation Docker-Umgebung

Für die lokale Inbetriebnahme ist eine Installation von Docker auf dem Zielsystem erforderlich.

Bitte beachten Sie die Nutzungsbedingungen der [Docker Inc.](https://docs.docker.com) sowie die aktuelle Dokumentation von Docker zur Installation und Konfiguration in Ihrer jeweiligen Umgebung.

### Kurzanleitung

+ Installieren Sie Docker auf ihrem System.
+ Erstellen Sie einen Ordner für ihrem SVWS-Container.
+ Erstellen Sie dort die Datei `docker-compose.yml`
+ Erstellen Sie dort die Datei `.env` und geben Sie die ihre Passwörter ein.
+ Erstellen Sie dort die laut `docker-compose.ylm` benötigten Unterordner.

Starten Sie den SVWS-Server (und ggf. den intergrierten MariaDB-Server) mit `docker compose up -d`.

### Beispiel: `docker-compose.yml`

Beispielkonfigurationen für die erforderliche `docker-compose.yml`:

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
    image: svwsnrw/svws-server:1.3.2
    depends_on:
      mariadb:
        condition: service_healthy
    container_name: svws1_server
    ports:
      - "8443:8443"
    volumes:
      - ./volume/svws:/opt/app/svws/conf
    env_file:
      - .env
```

Mit dieser Konfiguration werden folgende Dienste gestartet:

+ MariaDB-Datenbank
+ SVWS-Server einschließlich des bereitgestellten SVWS-Clients

## Beispiel .env Datei

In der Environment-Datei, kurz `.env` werden die individuellen Passwörter bzw. Pfade gespeichert. Diese ist in der Regel versteckt und wird vom Dateisystem nicht direkt angezeigt.

Beispiel einer `.env`-Datei zu dem o.g. `docker-compose.yml`

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

Vor dem ersten Start müssen geeignete Passwörter gesetzt werden.

Beim ersten Start werden im Verzeichnis `volume` die Unterverzeichnisse `mariadb` und `svws` angelegt.

Im Verzeichnis `svws` werden automatisch die Datei `svwsconfig.json` sowie ein Java-Keystore erzeugt. Alternativ können dort bereits vorhandene Konfigurationsdateien oder eigene Zertifikate hinterlegt werden. Sofern die Standardkonfiguration verwendet wird, werden die Log-Dateien im Verzeichnis `svws/logs` gespeichert.

Zusätzlich werden die erforderlichen Volumes für Konfiguration und Zertifikate eingebunden.

Nach dem erfolgreichen Start ist der SVWS-Server über Port 8443 erreichbar.

### Kommunikation mit Schild3

Standardmäßig ist die Datenbank ausschließlich innerhalb des Docker-Netzwerks erreichbar. Intern verwendet MariaDB den Port 3306.

Soll SchILD-NRW 3 direkt auf die Datenbank zugreifen, muss ein entsprechendes Port-Mapping konfiguriert werden. Dies erfolgt über den Eintrag ports in der docker-compose.yml.

```yaml
#...
services:
  mariadb:
#    ...
    ports:
        - "3306:3306"
#    ...
```

Diese Ports müssen auf Ihre Umgebung angepasst bzw. ergänzt werden, je nach Anforderung.

### weitere Beispiele

Im Git-Repository des SVWS-Server befinden sich [Beispiele, Skripte und Image-Definitionen](https://github.com/SVWS-NRW/SVWS-Server/tree/dev/deployment/docker) zum Aufbau von Docker-basierten SVWS-Umgebungen.

## Konfiguration der SVWS-Umgebung

Die Konfiguration der Docker-basierten SVWS-Umgebung erfolgt über das Setzen der folgenden Umgebungsvariablen in der `.env`-Datei.

| Variable | Beschreibung |
| ----------- | ----------- |
| MARIADB_ROOT_PASSWORD | Passwort, das für den Root-User der MariaDB-Instanz verwendet werden soll |
| MARIADB_DATABASE | Name des Datenbankschemas, mit dem sich der SVWS-Server verbindet (z.B. "gymabi") |
| MARIADB_HOST | Name des Hosts, auf dem die SVWS-Datenbank läuft. Im Falle der Docker-Umgebung entspricht dieser Wert dem Service-Namen von docker-compose (also "mariadb"). |
| MARIADB_USER | Datenbank-Benutzer, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| MARIADB_PASSWORD | Passwort des Datenbank-Benutzers, unter dem sich der SVWS-Server mit der Datenbank verbindet. |
| SVWS_TLS_KEYSTORE_PATH | Unter diesem Pfad erwartet der SVWS-Server den Java-Keystore für die Terminierung von SSL am Server |
| SVWS_TLS_KEYSTORE_PASSWORD | Passwort des Keystores |
| SVWS_TLS_KEY_ALIAS | Alias des zu verwendenden Keys im Keystore |
| SVWS_TLS_CERT_CN | Name des selbstsignierten Zertifikats Default:SVWSCERT |
| SVWS_TLS_CERT_OU | Name der Organistationseinheit Default: SVWSOU |
| SVWS_TLS_CERT_O | Name der Organisation Default:SVWSO |
| SVWS_TLS_CERT_L=CITY | Name des Ortes Default: Duesseldorf |
| SVWS_TLS_CERT_S=STATE | Name des Bundeslands Name Default: NRW |
| SVWS_TLS_CERT_C=COUNTRY | Name des Staates Default: Germany |
