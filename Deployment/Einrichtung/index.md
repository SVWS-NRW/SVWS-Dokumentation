# Einrichtung eines SVWS-Servers

## Konfigurationsdatei svwsconfig.json

Aus der svwsconfig.json werden beim Start des SVWS-Server die individuellen Einstellungen der jeweiligen Umgebung eingelesen.
Die svwsconfig.json muss im Hauptverezichnis des SVWS-Servers liegen (z.B. /opt/app/svws/svwsconfig.json).
Es kann aber auch, wie im Linux-Installer ein symbolischer Link erstellt werden.

Ein Beispiel-Template der svwsconfig.json liegt unter: ./svws/conf/svwsconfig-template-nodb.json.
Der SVWS-Server startet auch ohne einen Eintrag unter Schemakonfiguration und bietet dann beim Start keine Auswahl für eine Datenbank an.
Unter https://meinserver/admin steht dann ein Admin-Client zur Verfügung, mit dem man erste Datenbanken migrieren oder Backups erstellen kann.

### Beschreibung der Variablen

| Variable |Default |Erläuterung|
|-------------|---------------|---------------|
|EnableClientProtection| null| Gibt an, ob die Dateien des Web-Clients auch über eine Authentifizierung an der Datenbank geschützt sind. |
| DisableDBRootAccess | false | Sperrt die Root-Enpunkte in der API |
| DisableAutoUpdates | false | Schaltet die Automatische Ausführung von Datenbankupdates bei Start des Servers aus. |
| DisableTLS | null | Schaltet das TLS aus. |
| PortHTTP | null | Port für HTTP bei NULL=80 |
| UseHTTPDefaultv11 | false | Nutze HTTP V1.1 als Default |
| PortHTTPS | null | Port für Https bei NULL=443 | 
| PortHTTPPrivilegedAccess | null | Port für die ROOT-API und den Admin-Client. Default 443. |
| UseCORSHeader | true | Nutze CORSHeader. |
| TempPath |  "./tmp" | Pfad für das temporäre Verzeichnis. |
| TLSKeyAlias | null | Alias für den TLSKey. |
| TLSKeystorePath | "." | Pfad für den Keystore mit genau dem Dateinamen "keystore". |
| TLSKeystorePassword | "svwskeystore" | Passwort für den Keystore |
| ClientPath | ".../opt/app/svws/client" | Pfad zum SVWS-Web-Client in der Installation. |
| AdminClientPath | "../opt/app/svws/adminclient" | Pfad zum Admin-Client in der Installation. |
| LoggingEnabled | true | Einschalten des Loggings. |
| LoggingPath | "./logs" | Pfad zu den Logdateien. |
| ServerMode | null | Servermode NULL=dev. dev=Developermode alpha=Alphamode, beta=Betamode, stable=Stablemode |
| DBKonfiguration | | Beginn der Datenbankkonfigurationen der verschiedenen Schemata. |
| dbms | "MARIA_DB" | Momentan einziges unterstütztes DBMS MariaDB mindesten 10.6.x. |
| location | "localhost" | Adresse des Datenbankservers (Hostename:Port) |
| defaultschema | null | Name des Defaultschema, das beim Start im Client als erstes angeboten wird. (Optional.) |
| SchemaKonfiguration | | Beginn der einzelnen Schemakonfigurationen. |
| name |  "svwsdb" | Name des Datenbankschemas. |
| svwslogin | false | Gibt an, ob der SVWS-Anmeldename und das zugehörige Kennwort auch für die Datenbankverbindung genutzt wird oder nicht. | 
| username | "svwsuser" | Datenbankuser für das Schema im DBMS. |
| password | "userpassword"| Passwort für den Datenbankuser. |
| connectionRetries | 0 | Gibt an, wieviele wiederholte Verbindungsversuche zur Datenbank stattfinden sollen. |
| retryTimeout | 0 | Gibt an, wie hoch die Zeit zwischen zwei Verbindungsversuchen in Millisekunden sein soll. |

### Servermode

Der Servermode bestimmt, welche Komponenten im Web-Client gezeigt werden:

- dev: Absoluter Developermode es werden alle Komponenten gezeigt, auch die die noch in Entwicklung sind.
- alpha: Es werden die Komponenten gezeigt, die für Alpha-Tester benötigt werden.
- beta: Es werden die Komponenten gezeigt, die für Beta-Tester benötigt werden.
- stable: Es werden nur Komponenten gezeigt, die für das Release freigegegeben wurden.

## Admin-Client Web-Applikation zur Verwaltung von Datenbank-Schemata

Der Admin-Client bietet eine Web-Applikation, die die Verwaltung von Datenbank-Schemata innerhalb eines grafischen Frontends ermöglicht.

Folgende Prozesse werden vom Admin-Client unterstützt:
- Anlegen von neuen (leeren) Schemata
- Löschen von Schemata
- Migration einer Schild-NRW2-Datenbank in ein neues oder bestehendes Schema
- Erstellen eines Backups aus einem bestehenden Schekata (SQLite-Format)
- Einspielen eine Backups in ein bestehendes oder ein eues Schema

Die Anmeldung am Admin-Client erfolg mit Benutzername und Passwort eine MaraDB-Users.
Dabei muss nicht zwingend der Root-Benutzer genommen werden. Der Benutzer sieht die Datenbank-Schemata, auf die er entsprechende Rechte hat.

