# Einrichtung eines SVWS-Servers

## Konfigurationsdatei svwsconfig.json

Aus der `svwsconfig.json` werden beim Start des SVWS-Server die individuellen Einstellungen der jeweiligen Umgebung eingelesen.
Die `svwsconfig.json` muss im Hauptverezichnis des SVWS-Servers liegen (z.B. ``opt/app/svws/svwsconfig.json`).
Es kann aber auch, wie im Linux-Installer, ein symbolischer Link erstellt werden.

Ein Beispiel-Template der `svwsconfig.json` liegt unter: `./svws/conf/svwsconfig-template-nodb.json`.
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

### Beispieldatei für eine svwsconfig.json (mit einem Schema)

``` json
{
  "EnableClientProtection" : false,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : null,
  "DisableTLS" : null,
  "PortHTTP" : null,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : null,
  "PortHTTPPrivilegedAccess" : null,
  "UseCORSHeader" : true,
  "TempPath" : "./Temp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : ".",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "./SVWS-Server/svws-webclient/client/build/output",
  "AdminClientPath" : "./SVWS-Server/svws-webclient/admin/build/output",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "ServerMode" : "stable",
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
      "password" : "svwspassword"
    } ]
  }
}

```

### Servermode

Der Servermode bestimmt, welche Komponenten im Web-Client gezeigt werden:

- dev: Es werden alle Komponenten gezeigt, auch die, die noch in Entwicklung sind.
- alpha: Es werden die Komponenten gezeigt, die für Alpha-Tester benötigt werden.
- beta: Es werden die Komponenten gezeigt, die für Beta-Tester benötigt werden.
- stable: Es werden nur Komponenten gezeigt, die für das Release freigegegeben wurden.

## Admin-Client Web-Applikation zur Verwaltung von Datenbank-Schemata

Der Admin-Client bietet eine Web-Applikation, die die Verwaltung von Datenbank-Schemata innerhalb eines grafischen Frontends ermöglicht.

Folgende Prozesse werden vom Admin-Client unterstützt:
- Anlegen von neuen (leeren) Schemata
- Löschen von Schemata
- Migration einer Schild-NRW2-Datenbank in ein neues oder bestehendes Schema
- Erstellen eines Backups aus einem bestehenden Schema (SQLite-Format)
- Einspielen eine Backups in ein bestehendes oder ein eues Schema
- Setzen eines Schemas in die `svwsconfig.json`

Die Anmeldung am Admin-Client erfolgt mit Benutzername und Passwort eines MariaDB-Users.
Dabei muss nicht zwingend der Root-Benutzer genommen werden. Der Benutzer sieht die Datenbank-Schemata, auf die er entsprechende Rechte hat.

### Symbole unter der Schemaliste (nur für root)

Entsprechend der Beschreibung, die als Tooltip erscheinen, können Schemata wie o.a. erstellt, verändert oder entfernt werden.
Für diese Aktionen, die unter der Schemataliste dargestellt werden, werden grundsätzlich root-Rechte benötigt. Die Symbole werden auch nur dem root-Benutzer angezeigt.

#### Migration in ein neues Schema

Hier wird automatisch ein neues Schema angelegt und mit den erforderlichen Tabellen befüllt.
Es öffnet sich ein Dialog, in dem die erforderlichen Angaben zur Migration abgefragt werden.

Es kann aus folgenden Datanbankformaten importiert werden:
- Access
- MySQL
- MariaDB
- SQL-Server (MSSQL)

***1. Access:***

***Quelldatenbank:*** 

Wählen Sie hier eine Schild-NRW-2 Access Datenbank (Endung .mdb) aus. Es gibt vereinzelt noch Datenbanken im Access98-Format. Diese können nicht migriert werden. Kontaktieren Sie Ihren Fachberater!

***Zieldatenbank***

***Schema***

Name des neuen Schemas im SVWS-Server.

***Name des Datenbanknutzers***

Datenbankbenutzer in der MariaDB des SVWS-Servers. Dieser kann für jedes Schema anders gewählt werden. Somit kann man schon auf Datenbankebene verhindern, dass Schulen auf die Daten von anderen Schulen zugreifen können. Wenn man einen bestehenden Datenbankbenutzer noch einmal verwenden möchte, so muss natürlich das korrekte Passwort verwendet werden.
Wenn der Datenbankbenutzer noch nicht existiert, so wird er vor der Migration angelegt.

***Passwort des Datenbankbenutzers***

Das Passwort des Datenbankbenutzers.

***2. Alle anderen DBMS:***

***Angabe einer Schulnummer***

Diese Funktion ist für die Migration aus Schild-Zentral geschaffen worden.
Durch die Angabe der Schulnummer werden nur die Daten dieser Schule in das neue Schema migriert. Der SVWS-Server unterstützt die Haltung von mehreren Schulen in einem Schema aus Datenschutzgründen nicht mehr.

***Quelldatenbank:***

***Datenbankhost***

Name oder IP-Adresse unter der der Datenbankserver erreichbar ist. (hostname:port oder IP:port)
Bei SQL-Server (MSSQL) muus das TCP-Protokoll aktiviert und freigegeben sein.

***Datenbank-Schema***

Name des Quellschemas auf dem Datenbankserver, der als Quelle dient.

***Name des Datenbankbenutzers***

Name des Users auf dem Datenbankserver, der als Quelle dient.

***Passwort des Datenbankbenutzers***

Passwort des Users auf dem Datenbankserver, der als Quelle dient.

***Zieldatenbank***

***Schema***

Name des neuen Schemas im SVWS-Server. Dieses Schema wird automatisch erstellt.

***Name des Datenbanknutzers***

Datenbankbenutzer in der MariaDB des SVWS-Servers. Dieser kann für jedes Schema anders gewählt werden. Somit kann man schon auf Datenbankebene verhindern, dass Schulen auf die Daten von anderen Schulen zugreifen können. Wenn man einen bestehenden Datenbankbenutzer noch einmal verwenden möchte, so muss natürlich das korrekte Passwort verwendet werden.
Wenn der Datenbankbenutzer noch nicht existiert, so wird er vor der Migration angelegt.

***Passwort des Datenbankbenutzers***

Das Passwort des Datenbankbenutzers.

#### SQ-Lite Schema importieren

Ein aus einer anderen Datenbank erzeugtes SQLite-Backup kann hier in ein neu angelegtes Schema importiert werden.

#### Schema duplizieren

Erzeugt eine Kopie eines Schemas in einem neuen Schema. Diese Funktion soll es erleichtern, eine Testdatenbank zu erstellen, wenn z.B. komplexere Arbeiten im Vorfeld getestet werden sollen.

#### Anlegen eines neuen SVWS-Schema

Unter der Liste der Schemata kann mit dem Plussymbol ein neues SVWS-Schema angelegt werden.
Das Schema wird dabei automatisch mit den erforderlichen Tabellen gefüllt und in der `svwsconfig.json` registriert.

Man erhält somit eine leere Datenbank, die man mit einer Schulnummer initialisieren kann.


## Menüpunkte im rechten Fensterbereich

Diese Menüpunkte haben die gleichen Funktionen, wie die Menüpunkte unter der Schemaliste.
Nur werden diese Funktionen immer auf das ausgewählte und bestehende Schema ausgeführt und können somit auch von anderen Benutzern außer root verwendet werden. Diese Menüpunkte sind immer verfügbar.

***In Config setzen***

Diese Funktion setzt ein bestehendes Schema in die `svwsconfig.json`, so dass dieses Schema beim nächsten Start des SVWS-Servers mit in die Auswahlliste aufgenommen wird. Achtung! Dieses Schema muss initialisiert werden, also die Datenbankstruktur des SVWS-Servers haben!

Sollte ein Datenbankadministrator keine Rechte besitzen, Schemata anzulegen oder zu löschen, so kann dieser dann aber so angelegte, leere Schemata verwalten.
