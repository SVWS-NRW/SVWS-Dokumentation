# Einrichtung eines SVWS-Servers

## Konfigurationsdatei svwsconfig.json

Aus der `svwsconfig.json` werden beim Start des SVWS-Server die individuellen Einstellungen der jeweiligen Umgebung eingelesen.

Die `svwsconfig.json` muss unter Windows im `res`-Verzeichnis des Datenverzeichnis des SVWS-Servers liegen (z.B. `S:\SVWS-Server-Data\res\`). Unter Linux ist des das Verzeichnis  `etc/app/svws/conf/svwsconfig.json`.
Es kann auch, wie im Linux-Installer, ein symbolischer Link erstellt werden. 

Ein Beispiel-Template der [svwsconfig.json](https://github.com/SVWS-NRW/SVWS-Server/blob/dev/svws-server-app/src/main/resources/svwsconfig.json.example) liegt in unserem Github

Der SVWS-Server startet auch ohne einen Eintrag unter Schemakonfiguration und bietet dann beim Start keine Auswahl für eine Datenbank an.

Unter `https://meinserver/admin` steht dann ein AdminClient zur Verfügung, mit dem man erste Datenbanken migrieren oder Backups erstellen kann.

### Beschreibung der Variablen

Die folgende Tabelle beschreibt die im Quellcode definierten
Konfigurationseinstellungen von `svwsconfig.json`.


| Variable | Default | Erläuterung |
| --- | --- | --- |
| `EnableClientProtection` | `false` | Aktiviert den Schutz der WebClient-Dateien über eine Datenbank-Authentifizierung. |
| `DisableDBRootAccess` | `false` | Deaktiviert den privilegierten bzw. Root-Zugriff auf die Datenbank- und Root-APIs. Ist die Einstellung `true`, werden die Root-API und der AdminClient nicht für den privilegierten Zugriff bereitgestellt. |
| `DisableAutoUpdates` | `false` | Deaktiviert automatische Aktualisierungen der Datenbank beim Start des SVWS-Servers. |
| `DisableTLS` | `false` | Deaktiviert TLS. Wenn TLS deaktiviert ist, verwendet der Server den HTTP-Port (`PortHTTP`) anstelle des HTTPS-Ports. |
| `PortHTTP` | `8080` | Port für HTTP-Verbindungen. Der aktuelle Quellcode verwendet `8080` als Default. |
| `UseHTTPDefaultv11` | `false` | Beeinflusst die Priorisierung der HTTP-Protokollversionen. Bei Aktivierung wird HTTP/1.1 gegenüber HTTP/2 bevorzugt. Die Einstellung bedeutet nicht, dass ausschließlich HTTP/1.1 verwendet wird. |
| `PortHTTPS` | `443` | Port für HTTPS-Verbindungen. |
| `PortHTTPPrivilegedAccess` | `null` | Optionaler zusätzlicher Port für den privilegierten Zugriff. Ein zweiter Connector wird nur eingerichtet, wenn DB-Root-Zugriff nicht deaktiviert ist und dieser Wert gesetzt wurde. |
| `UseCORSHeader` | `true` | Steuert, ob der Server CORS-Header verwendet. |
| `TempPath` | `./tmp` | Verzeichnis für temporäre Dateien des Servers. |
| `TLSKeyAlias` | `selfsigned` | Alias des für TLS verwendeten Schlüssels/Zertifikats im Keystore (required). |
| `TLSKeystorePath` | `.` | Verzeichnis, in dem der TLS-Keystore liegt. Der Server erwartet darin die Datei `keystore`. |
| `TLSKeystorePassword` | `svwskeystore` | Kennwort des TLS-Keystores. |
| `ClientPath` | `webclient` | Pfad zum WebClient. |
| `AdminClientPath` | `null` | Optionaler Pfad zum AdminClient. Ist der Wert leer bzw. nicht gesetzt, wird der AdminClient nicht über diesen Pfad registriert. Die Registrierung erfolgt zusätzlich nur, wenn `DisableDBRootAccess` nicht aktiviert ist. |
| `AppsPath` | `null` | Optionaler Pfad für die Apps. Ein leerer oder nicht gesetzter Wert wird als `null` behandelt. |
| `LoggingEnabled` | `false` bzw. abhängig von der Konfiguration | Aktiviert das Request-Logging. Für das Laden einer vorhandenen Konfiguration ist Logging nur aktiviert, wenn `LoggingEnabled` explizit auf `true` gesetzt ist. Beim Erzeugen einer Default-Konfiguration wird die Einstellung aus dem Vorhandensein eines Logging-Pfades abgeleitet. |
| `LoggingPath` | `.` | Verzeichnis für die Logdateien. Der Jetty-Request-Logger legt dort tägliche Request-Logs ab. Die Logs werden 90 Tage aufbewahrt. |
| `ServerMode` | `stable` | Betriebsmodus des Servers. Der Getter verwendet `STABLE` als Default, wenn kein gültiger Wert angegeben ist. Weitere Einstellungen: dev=Developermode alpha=Alphamode, beta=Betamode |
| `PrivilegedDatabaseUser` | `root` | Benutzername für den privilegierten Datenbankzugriff. Der aktuelle Getter verwendet `root` als Default. |
| `DBKonfiguration` | -- | Enthält die zentrale Datenbankkonfiguration einschließlich DBMS, Serveradresse, Standardschema und der konfigurierten Schemata. |



#### DBKonfigration

| Variable |Default |Erläuterung|
|-------------|---------------|---------------|
| `dbms` | `MARIA_DB` | Verwendetes Datenbankmanagementsystem. Im DTO sind `MARIA_DB`, `MYSQL` und `MSSQL` als gültige Werte dokumentiert. |
| `location` | abhängig von der Default-Konfiguration | Hostname bzw. Adresse des Datenbankservers, optional einschließlich Port, z. B. `localhost:3403`. Wird kein Port angegeben, wird der Standardport des jeweiligen DBMS verwendet. |
| `defaultschema` | `null` / erstes Schema | Gibt das Standardschema an, das verwendet wird, wenn in einem Pfad kein Schema angegeben ist. Ist kein passendes Standardschema konfiguriert, kann das erste konfigurierte Schema als Default verwendet werden. |
| `SchemaKonfiguration` | -- | Liste der konfigurierten Datenbankschemata. Es können mehrere Schema-Konfigurationen vorhanden sein. |
| `connectionRetries` | `0` | **DEPRECATED.** Anzahl der wiederholten Verbindungsversuche zur Datenbank. |
| `retryTimeout` | `0` | **DEPRECATED.** Wartezeit zwischen zwei Verbindungsversuchen in Millisekunden. |


#### SchemaKonfiguration 



| Variable |Default |Erläuterung|
|-------------|---------------|---------------|
| `name` |  | Der Name des Datenbankschemas (der Schule) wird erfragt bei Erzeugung einer Default-Konfiguration. |
| `svwslogin` | `false` | Legt fest, ob der SVWS-Anmeldename und das zugehörige Kennwort auch für die Datenbankverbindung verwendet werden. Bei `true` ist für jeden SVWS-Benutzer ein entsprechender Datenbankbenutzer erforderlich. Die Einstellung ist im aktuellen Konfigurationscode als veraltet/deprecated behandelt; beim Einlesen wird ein fehlender Wert auf `false` normalisiert. |
| `username` |  | Der Benutzername für die Datenbankverbindung, wird erfragt bei Erzeugung einer Default-Konfiguration, sofern nicht `svwslogin` verwendet wird. |
| `password` | | Das Kennwort für die Datenbankverbindung, wird erfragt bei Erzeugung einer Default-Konfiguration, sofern nicht `svwslogin` verwendet wird. |

### Beispieldatei für eine svwsconfig.json (mit einem Schema)

``` json
{
  "EnableClientProtection" : false,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : false,
  "DisableTLS" : false,
  "PortHTTP" : null,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 8443,
  "PortHTTPPrivilegedAccess" : null,
  "UseCORSHeader" : true,
  "TempPath" : "./tmp",
  "TLSKeyAlias" : "svws",
  "TLSKeystorePath" : ".",
  "TLSKeystorePassword" : "$SVWSKEYSTOREPASSWORD",
  "ClientPath" : "./client",
  "AdminClientPath" : "./adminclient",
  "AppsPath": "./apps",
  "LoggingEnabled" : true,
  "LoggingPath" : "./logs",
  "ServerMode" : "stable",
  "PrivilegedDatabaseUser" : null,
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "localhost",
    "defaultschema" : "svwsdb",
    "connectionRetries" : 0,
    "retryTimeout" : 5000,
    "SchemaKonfiguration" : [ {
      "name" : "svwsdb",
      "svwslogin" : false,
      "username" : "svwsuser",
      "password" : "$SVWSUSERPASSWORD""
    } ]
  }
}
```

### Servermode

Der Servermode bestimmt, welche Komponenten im Web-Client gezeigt werden:

- **dev**: Es werden alle Komponenten gezeigt, auch die, die noch in Entwicklung sind.
- **alpha**: Es werden die Komponenten gezeigt, die für Alpha-Tester benötigt werden.
- **beta**: Es werden die Komponenten gezeigt, die für Beta-Tester benötigt werden.
- **stable**: Es werden nur Komponenten gezeigt, die für das Release freigegegeben wurden.

## Netzwerkeinstellungen (optional)

Es folgt eine Übersicht über möglich Netzwerkeinstellungen, die ja nach Betriebsumfeld noch angepasst werden können.

## Portumleitung

Eine Möglichkeit den SVWS-Server unter einer "normalen" URL erreichen zu können und somit auf das Appendix der Ports verzichten zu können, wäre eine Portumleitung. Der bessere Weg, vor allem in größeren Netzwerken, wäre der Einsatz eines Reverse-Proxies.

In beiden Fällen könnte man statt zum Beispiel `https://meineServeradresse:8443/` dann unter `https://meineServeradresse/` den SVWS-Server direkt erreichen.

Umleiten des Ports 443 auf Port 8443 unter Ubuntu 22.04 mit `iptables`:

```bash
iptables -A PREROUTING -t nat -p tcp --dport 443 -j REDIRECT --to-port 8443
```

## Reverse-Proxy einrichten

Alternativ zu einer direkten Portweiterleitung kann nginx als Reverse-Proxy für den SVWS-Server eingesetzt werden.

Für den Betrieb hinter einem Reverse-Proxy werden insbesondere folgende Einstellungen empfohlen:

```nginx
client_max_body_size 100M;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto https;
proxy_http_version 1.1;
proxy_read_timeout 300;
proxy_connect_timeout 300;
proxy_send_timeout 300;
```

Zusätzlich können Sicherheits-Header wie `Content-Security-Policy`, `X-Content-Type-Options` und `X-Frame-Options` gesetzt werden,  wie in diesem Beispiel: 

```nginx
# Security Header
add_header Content-Security-Policy "upgrade-insecure-requests" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
```

### TLS und HTTP

Der SVWS-Client verwendet für die Verbindung ausschließlich HTTPS. Daher sollte die TLS-Verschlüsselung am Reverse-Proxy erfolgen. Ein Betrieb des SVWS-Servers ohne TLS (`DisableTLS`/`PortHTTP`) ist möglich und für Reverse-Proxy-Szenarien vorgesehen, jedoch nicht zwingend erforderlich.

Alternativ kann der SVWS-Server intern mit einem selbstsignierten Zertifikat betrieben werden. Die Zertifikatsprüfung für die interne Verbindung zwischen Reverse-Proxy und SVWS-Server kann dabei deaktiviert werden. Die Verbindung vom Client zum Reverse-Proxy bleibt über dessen gültiges TLS-Zertifikat geschützt.

Ein reiner HTTP-Betrieb wird nicht empfohlen, da moderne Browser Funktionen ohne HTTPS zunehmend einschränken.

### Beispielkonfiguration

Bei einem SVWS-Server unter `10.0.0.1:8443` kann nginx beispielsweise wie folgt konfiguriert werden:

```nginx
server {
    listen 443 ssl;
    http2 on;
    server_name svws.example.org;

    ssl_certificate /etc/letsencrypt/live/svws.example.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/svws.example.org/privkey.pem;

    location / {
        proxy_pass https://10.0.0.1:8443;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

server {
    listen 80;
    server_name svws.example.org;
    return 301 https://$host$request_uri;
}
```

Die Werte für Paketgröße und Timeouts können abhängig von Schulgröße und verfügbarer Internetgeschwindigkeit angepasst werden. Für Produktivumgebungen sollte auf sichere und aktuelle TLS-Konfiguration geachtet werden.

## UFW als Firewall einrichten

Für die Linuxmaschine im Livebetrieb empfiehlt sich eine Firewall einzurichten. Dazu ist bei vielen Distributionen die `ufw`-Firewall vorinstalliert.





## AdminClient Web-Applikation zur Verwaltung von Datenbank-Schemata

Der *AdminClient* bietet eine Web-Applikation, die die Verwaltung von Datenbank-Schemata innerhalb eines grafischen Frontends ermöglicht.

Folgende Prozesse werden vom Admin-Client unterstützt:
- Anlegen von neuen (leeren) Schemata
- Löschen von Schemata
- Migration einer Schild-NRW 2-Datenbank in ein neues oder bestehendes Schema
- Erstellen eines Backups aus einem bestehenden Schema (SQLite-Format)
- Einspielen eines Backups in ein bestehendes oder ein neues Schema
- Setzen eines Schemas in die `svwsconfig.json`

Die Anmeldung am AdminClient erfolgt mit Benutzername und Passwort eines MariaDB-Benutzers.

Dabei muss nicht zwingend der Root-Benutzer genommen werden. Der Benutzer sieht die Datenbank-Schemata, auf die er entsprechende Rechte hat.

### Symbole unter der Schemaliste (nur für root)

Entsprechend der Beschreibung, die als Tooltip erscheinen, können Schemata wie o.a. erstellt, verändert oder entfernt werden.

Für diese Aktionen, die unter der Schemataliste dargestellt werden, werden grundsätzlich Datenbankserver-root-Rechte benötigt. Die Symbole zum Verwalten der Schemata an sich werden auch nur dem root-Benutzer angezeigt.

#### Migration in ein neues Schema

Hier wird automatisch ein neues Schema angelegt und mit den erforderlichen Tabellen befüllt.

Es öffnet sich ein Dialog, in dem die erforderlichen Angaben zur Migration abgefragt werden.

Es kann aus folgenden Datenbankformaten importiert werden:
- Access
- MySQL
- MariaDB
- SQL-Server (MSSQL)

**1. Access:**

**Quelldatenbank:**

Wählen Sie hier eine Schild-NRW 2 Access-Datenbank (Endung .mdb) aus. Es gibt vereinzelt noch Datenbanken im Access98-Format. Diese können nicht migriert werden. Kontaktieren Sie Ihren Fachberater!

**Zieldatenbank**

**Schema**

Name des neuen Schemas im SVWS-Server.

**Name des Schema-Datenbanknutzers**

Schema-Datenbankbenutzer in der MariaDB des SVWS-Servers. Dieser kann für jedes Schema anders gewählt werden. Somit kann man schon auf Datenbankebene verhindern, dass Schulen auf die Daten von anderen Schulen zugreifen können. Es können auch mehrere Schulen mit dem gleichen Schema-Admin etwa durch IT-Dienstleister verwaltet werden.

Wenn man einen bestehenden Schema-Datenbankbenutzer noch einmal verwenden möchte, muss natürlich das korrekte Passwort verwendet werden.

Wenn der Datenbankbenutzer noch nicht existiert, wird er vor der Migration angelegt.

**Passwort des Schema-Datenbankbenutzers**

Das Passwort des Schema-Datenbankbenutzers.

**2. Alle anderen DBMS:**

**Angabe einer Schulnummer**

Diese Funktion ist für die Migration aus *Schild-Zentral* geschaffen worden.

Durch die Angabe der Schulnummer werden nur die Daten dieser Schule in das neue Schema migriert. Der SVWS-Server unterstützt die Haltung von mehreren Schulen in einem Schema aus Datenschutzgründen nicht mehr.

**Quelldatenbank:**

**Datenbankhost**

Name oder IP-Adresse unter der der Datenbankserver erreichbar ist. (hostname:port oder IP:port)

Bei SQL-Server (MSSQL) muss das TCP-Protokoll aktiviert und freigegeben sein.

**Datenbank-Schema**

Name des Quellschemas auf dem Datenbankserver, der als Quelle dient.

**Name des Datenbankbenutzers**

Name des Benutzers auf dem Datenbankserver, der als Quelle dient.

**Passwort des Datenbankbenutzers**

Passwort des Benutzers auf dem Datenbankserver, der als Quelle dient.

**Zieldatenbank**

**Schema**

Name des neuen Schemas im SVWS-Server. Dieses Schema wird automatisch erstellt.

**Name des Datenbanknutzers**

Datenbankbenutzer in der MariaDB des SVWS-Servers. Dieser kann für jedes Schema anders gewählt werden. Somit kann man schon auf Datenbankebene verhindern, dass Schulen auf die Daten von anderen Schulen zugreifen können. Wenn man einen bestehenden Datenbankbenutzer noch einmal verwenden möchte, so muss natürlich das korrekte Passwort verwendet werden.

Wenn der Datenbankbenutzer noch nicht existiert, so wird er vor der Migration angelegt.

**Passwort des Datenbankbenutzers**

Das Passwort des Datenbankbenutzers.

#### SQLite Schema importieren

Ein aus einer anderen Datenbank erzeugtes SQLite-Backup kann hier in ein neu angelegtes Schema importiert werden.

#### Schema duplizieren

Erzeugt eine Kopie eines Schemas in einem neuen Schema. Diese Funktion soll es erleichtern, eine Testdatenbank zu erstellen, wenn z.B. komplexere Arbeiten im Vorfeld getestet werden sollen.

#### Anlegen eines neuen SVWS-Schema

Unter der Liste der Schemata kann mit dem Plus-Symbol ein neues SVWS-Schema angelegt werden.

Das Schema wird dabei automatisch mit den erforderlichen Tabellen gefüllt und in der `svwsconfig.json` registriert.

Man erhält somit eine leere Datenbank, die man mit einer Schulnummer initialisieren kann.


## Menüpunkte im rechten Fensterbereich

Diese Menüpunkte haben die gleichen Funktionen, wie die Menüpunkte unter der Schema-Liste.

Nur werden diese Funktionen immer auf das ausgewählte und bestehende Schema ausgeführt und können somit auch von anderen Benutzern außer root verwendet werden. Diese Menüpunkte sind immer verfügbar.

**In Config setzen**

Diese Funktion setzt ein bestehendes Schema in die `svwsconfig.json`, so dass dieses Schema beim nächsten Start des SVWS-Servers mit in die Auswahlliste aufgenommen wird.

::: warning Schema initialisieren
Achtung! Dieses Schema muss initialisiert werden, also die Datenbankstruktur des SVWS-Servers haben!
:::

Sollte ein Datenbankadministrator keine Rechte besitzen, Schemata anzulegen oder zu löschen, so kann dieser dann aber so angelegte, leere Schemata verwalten.
