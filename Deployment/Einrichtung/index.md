# Einrichtung eines SVWS-Servers

## Konfigurationsdatei svwsconfig.json


| Variable |Default |Erläuterung|
|-------------|---------------|---------------|
|EnableClientProtection| null| ??? |
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
| defaultschema | null | Name des Defaultschema das beim Start im Client als erstes angeboten wird. (Optional.) |
| SchemaKonfiguration | | Beginn der einzelnen Schemakonfigurationen. |
| name |  "svwsdb" | Name des Datenbankschemas. |
| svwslogin | false | Gibt an, ob der SVWS-Anmeldename und das zugehörige Kennwort auch für die Datenbankverbindung genutzt wird oder nicht. | 
| username | "svwsuser" | Datenbankuser für das Schema im DBMS. |
| password | "userpassword"| Passwort für den Datenbankuser. |
| connectionRetries | 0 | Gibt an, wieviele wiederholte Verbindungsversuche zur Datenbank stattfinden sollen. |
| retryTimeout | 0 | Gibt an, wie hoch die Zeit zwischen zwei Verbindungsversuchen in Millisekunden sein soll. |


## Admin-Client Web-Applikation zur Verwaltung von Datenbank-Schemata

