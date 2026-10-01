# Einrichtung eines SVWS-Servers

## svwsconfig.json

Aus der Konfigurationsdatei  `svwsconfig.json` werden beim Start des SVWS-Server die individuellen Einstellungen der jeweiligen Umgebung eingelesen. In der Regel wurde bei Verwendung von einer der drei Installationmethoden (Docker, Linux-Installer oder Windows-Installer) eine sinnvolle svwsconfig.json Datei im Zuge der Installation automatisiert erstellt.

Dieser Artikel gibt nun eine umfassende Übersicht über alle Einstellungesmöglichkeiten durch die svwsconfig.json

### Wo wird die svws-config.json hinterlegt?

+ Bei Verwendung des Windows-Installers unter:  
`S:\SVWS-Server-Data\res\`
+ Bei Verwendung der Linux-Instalers unter:
`etc/app/svws/conf/svwsconfig.json`.

Grundsätzlich sucht der SVWS-Server die svwsconfig.json in der folgenden Reihenfolge:

+ Der Pfad wird beim Aufruf des Servers übergeben
(`... ---classpath "C://ProgrammData\SVWS-Server\res ...`)
+ Im Ausführungsverzeichniss des SVWS Server  
(`./svwsconfig.json`)
+ Im Homeverzeichnis des Users

### Beschreibung der Variablen

Die folgende Tabelle beschreibt die im Quellcode definierten
Konfigurationseinstellungen von `svwsconfig.json`.

| Variable | Default | Erläuterung |
| --- | --- | --- |
| `DisableDBRootAccess` | `false` | Deaktiviert den privilegierten bzw. Root-Zugriff auf die Datenbank- und Root-APIs. Ist die Einstellung `true`, werden die Root-API und der AdminClient nicht für den privilegierten Zugriff bereitgestellt. |
| `DisableAutoUpdates` | `false` | Deaktiviert automatische Aktualisierungen der Datenbank beim Start des SVWS-Servers. **Hinweis:** Einsatz wird eher in Endwicklungsumgebungen Zur Erprobung neuerer DB Versionen insbesondere zum manuellen Hochsetzten einzelner DBs. |
| `DisableTLS` | `false` | Deaktiviert TLS. Wenn TLS deaktiviert ist, verwendet der Server den HTTP-Port (`PortHTTP`) anstelle des HTTPS-Ports.  **Hinweis:** Der http Port bei Deaktivierung von TLS gesetzt sein. Es wird dann wird autamatisch Http1.1 verwendet. |
| `PortHTTP` | `8080` | Port für HTTP-Verbindungen. Bei Auslassen der Variablen oder beim Setzen von `null` wird als Default  `8080` verwendet . |
| `UseHTTPDefaultv11` | `false` | Setzt die Priorisierung der HTTP-Protokollversionen: Bei Aktivierung wird HTTP/1.1 gegenüber HTTP/2 bevorzugt. **Hinweis:** Die Einstellung bedeutet nicht, dass ausschließlich HTTP/1.1 verwendet wird. |
| `PortHTTPS` | `443` | Port für HTTPS-Verbindungen.  **Hinweis:** Unter Linux erfordern Ports < 1024 erhöhte Rechte; daher sollte in diesem Fall `8443` verwendet werden. |
| `PortHTTPPrivilegedAccess` | `null` | Optionaler zusätzlicher Port für den privilegierten Zugriff. Ein zweiter Connector wird nur eingerichtet, wenn DB-Root-Zugriff nicht deaktiviert ist und dieser Wert gesetzt wurde. |
| `UseCORSHeader` | `true` | Steuert, ob der Server CORS-Header verwendet. |
| `TempPath` | `./tmp` | Verzeichnis für temporäre Dateien des Servers. |
| `TLSKeyAlias` | `selfsigned` | Alias des für TLS verwendeten Zertifikats im Keystore **Hinweis:** beim Erstellen des Keystore **muss** der Alias im Keystore gesetzt sein. Ein leerer String ist nicht zulässig. |
| `TLSKeystorePath` | `.` | Verzeichnis, in dem der TLS-Keystore liegt. Der Server erwartet darin die Datei mit der Bezeichnung: `keystore`. |
| `TLSKeystorePassword` | `svwskeystore` | Kennwort des TLS-Keystores. **Hinweis:** Der Default Wert ist für Testumgebungen und Entwicklerversionen gesetzt und sollte nicht im Produktivbetrieb verwendet werden. |
| `ClientPath` | `client` | Pfad zum WebClient des SVWS-Servers. |
| `AdminClientPath` | `null` | Optionaler Pfad zum AdminClient. Ist der Wert leer bzw. nicht gesetzt, wird der AdminClient nicht über diesen Pfad registriert. Die Registrierung erfolgt zusätzlich nur, wenn `DisableDBRootAccess` nicht aktiviert ist. |
| `AppsPath` | `null` | Optionaler Pfad zum Einbinden externen Seiten z.B. [SVWS-Tools](../svws-tools/index.md). Ein leerer oder nicht gesetzter Wert wird als `null` behandelt. |
| `LoggingEnabled` | `false` | Aktiviert das Logging. |
| `LoggingPath` | `.` | Verzeichnis für die Logdateien. Hier werden u A.  Mirgations- und Requestlogs abgelegt. Die täglichen Request-Logs werden nach 90 Tage automatisch entfernt. |
| `ServerMode` | `stable` | Betriebsmodus des Servers im Produktivbetrieb: `stable`.  Weitere Einstellungen für die Entwicklungs- und Testsysteme: dev, alpha, beta |
| `PrivilegedDatabaseUser` | `root` | Benutzername für den privilegierten Datenbankzugriff. |
| `DBKonfiguration` | | Abschnitt mit der die zentrale Datenbankkonfiguration einschließlich DBMS, Serveradresse, Standardschema und der konfigurierten Schemata enthält. |

#### DBKonfigration

| Variable | Default | Erläuterung |
| ------------- | --------------- | --------------- |
| `dbms` | `MARIA_DB` | Verwendetes Datenbankmanagementsystem. Andere DB Systeme werden nicht unterstützt ISSUE: Kommentar in der svwsdatabasedto zeile 14 knunur MariaDB |
| `location` | localhost:3306 | Hostname bzw. Adresse des Datenbankservers, optional einschließlich Port, z. B. `MariaDBServer:3306`. (MariaDB default 3306 muss nicht explizit angegeben werden ) |
| `defaultschema` | `null` | Gibt den Namen des Schemas an, die als erstes im Client angezeigt werden soll, wird null angegeben ist der Standart der zuletzt aufgewählten konfigiuration |
| `SchemaKonfiguration` | -- | Abschnitt: Liste der konfigurierten Datenbankschemata. Es können mehrere Schema-Konfigurationen vorhanden sein. |
| `connectionRetries` | `0` | **DEPRECATED.** Wird im SVWS-Server nicht mehr verwendet. |
| `retryTimeout` | `0` | **DEPRECATED.** Wird im SVWS-Server nicht mehr verwendet. |

#### SchemaKonfiguration

Der SVWS-Server startet auch ohne einen Eintrag unter Schemakonfiguration und bietet dann beim Start keine Auswahl für eine Datenbank an.

| Variable | Default | Erläuterung |
| ------------- | --------------- | --------------- |
| `name` | | Der Name des Datenbankschemas (der Schule) wird erfragt bei Erzeugung einer Default-Konfiguration. |
| `svwslogin` | `false` | **DEPRECATED** Legt fest, ob der SVWS-Anmeldename und das zugehörige Kennwort auch für die Datenbankverbindung verwendet werden. **Hinweis**: Darf bei neueren SVWS-Server nicht auf true gesetzt werden! |
| `username` | | Der Benutzername für die Datenbankverbindung, wird erfragt bei Erzeugung einer Default-Konfiguration, sofern nicht `svwslogin` verwendet wird. |
| `password` | | Das Kennwort für die Datenbankverbindung, wird erfragt bei Erzeugung einer Default-Konfiguration, sofern nicht `svwslogin` verwendet wird. |

## Beispiel: svwsconfig.json

``` json
{
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

## Reverse-Proxy Einstellungen

Insbesonder bei größeren IT-Umgebungen kann ein nginx Als Reverse-Proxy eingesetzt werden.

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

## optional: weitere Netzwerkeinstellungen

Es folgt eine Übersicht über möglich Netzwerkeinstellungen, die ja nach Betriebsumfeld noch angepasst werden können.

### Portumleitung

Eine Möglichkeit den SVWS-Server unter einer "normalen" URL erreichen zu können und somit auf das Appendix der Ports verzichten zu können, wäre eine Portumleitung. Der bessere Weg, vor allem in größeren Netzwerken, wäre der Einsatz eines Reverse-Proxies.

In beiden Fällen könnte man statt zum Beispiel `https://meineServeradresse:8443/` dann unter `https://meineServeradresse/` den SVWS-Server direkt erreichen.

Umleiten des Ports 443 auf Port 8443 unter Ubuntu 22.04 mit `iptables`:

```bash
iptables -A PREROUTING -t nat -p tcp --dport 443 -j REDIRECT --to-port 8443
```

### UFW als Firewall einrichten

Für die Linuxmaschine im Livebetrieb empfiehlt sich eine Firewall einzurichten. Dazu ist bei vielen Distributionen die `ufw`-Firewall vorinstalliert.
