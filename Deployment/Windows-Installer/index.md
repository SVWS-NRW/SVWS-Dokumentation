# Windows-Installer

## Download

https://storage.svws-nrw.de/windows_installer/

## Systemvoraussetzungen

+ Windows 10 64bit
+ 16 GB RAM
+ Auflösung min 1920x1080 fullHD
+ 300 MB freier Speicherplatz

## Installationshinweise

Der SVWS-Installer wird für Windows64bit mit InnoSetup erstellt. 
Er installiert die im Folgenden genannten Komponenten und startet alle Dienste. Eine Migration kann optional durchgeführt werden.

Der SVWS-Installer übernimmt die folgenden Aufgaben:

+ Installation einer MariaDB-Instanz, wenn nicht vorhanden
+ Update einer bestehenden MariaDB-Instanz
+ Installation der Java-Laufzeitumgebung, wenn nicht vorhanden
+ Update der Java-Umgebung
+ Installation des SVWS-Servers, wenn nicht vorhanden
+ Update des SVWS-Servers
+ Abfrage aller notwendigen Kennwörter für MariaDB und SVWS-Server
+ Abfrage aller benötigten Informationen für den Keystore und das SSL-Cert
+ Registrieren und Starten des MariaDB-Dienstes
+ Registrieren und Starten des SVWS-Server-Dienstes
+ Anlegen eines leeren Schemas in MariaDB
+ Anlegen eines selbstsignierten SSL-Zertifikats
+ Abspeichern des Zertifikats im Verzeichnis Dokumente des angemeldeten Benutzers
+ Anlegen der Freigaben für die Windows Firewall, damit der Server auch für andere Clients erreichbar ist.
+ Ggf. Migration aus einer bestehenden Datenbank in das neue Schema

## Installationseinstellungen wählen

Zu Beginn der Installation erscheinen nach der Annahme der Lizenzvereinbarungen folgende Optionen:


![](./graphics/Installer_Auswahl_Dialog.jpg)



***Achtung!***


*Es werden für MariaDB und den Datenbank-User Zufallskennwörter generiert!*

*Ändern Sie diese nach Ihren Wünschen, aber <b>dokumentieren Sie in jedem Fall Ihre Eingabe</b>.*	

*Ohne diese Kennwörter kann Ihnen später im Supportfall nicht geholfen werden!*

---

## Installation MariaDB

Der Installer erkennt anhand der Registry-Einträge, ob MariaDB bereits installiert ist und in welcher Version. 
Wenn ein eigener MariaDB-Server installiert wird, muss entweder ein anderer Port verwendet werden, oder es muss später eine Verbindung zum bestehenden Server hergestellt werden.
Ist die Option deaktiviert und es wird keine svwsconfig.json gefunden wird, dann erscheint eine Seite zur Angabe der Zugangsdaten zum bestehenden Server.
Ist die Installation aktiviert wird der MariaDB-Server in den Programm-Verzeichnissen installiert. Der Dienst wird als Windows-Service registriert und gestartet.
Mit dem Installer kann die MariaDB-Version zu zu späteren Zeitpunkten dann auch aktualisiert werden.

Programmverzeichnis MariaDB: 

`C:\Programme\SVWS-Server\db Datenverzeichnis MariaDB: C:\ProgramData\SVWSServer\data`

Die sort_buffer_size wird in der my.ini im data-Verzeichnis auf 16777216 gesetzt!

## Installation JDK
Mit dem Installer wird auch das verwendetet JDK ausgeliefert. 
Dieses ist an den SVWS-Server gekoppelt und kann in zukünftigen Versionen nur in Kombination mit dem eigentlichen Server installiert 
oder geupdated werden.

Zielverzeichnis JDK: `C:\Programme\SVWS-Server\java`

## Installation SVWS-Server
Die notwendigen Dateien des SVWS-Server werden standardmäßig unter 
`C:/Programme/SVWS-Server/svws-server`  installiert. 
Da diese mit der ausgeliferten OpenJDK-Version zusammen passen müssen, werden diese beiden Teile miteinander verbunden und können nicht separat installiert werden.

Die Aufrufe werden in Form von Batch-Dateien mit der Endung .cmd im Hauptverezichnis ausgeliefert.
Die Dienste MariaDB und SVWS-Server werden in der Computerverwaltung registriert und automatisch gestartet.

![](./graphics/SVWSDienste.jpg)

## Konfigurationsdatei editieren 

Man findet alle Einstellungsmöglichkeiten zum Betrieb des SVWS-Servers an zentraler Stelle in der Datei: 
`svwsconfig.json`
			
Unter Windows im Verzeichnis: 
`C:\ProgramData\SVWS-Server\res`

![](./graphics/Svwsconfig.json.jpg)

In dieser Datei wird die Serverkonfiguration gespeichert.

### Parameter Beschreibung

#### allgemeine Einstellungen
|Parameter 	|	Beschreibung |
|---|---|
| DisableDBRootAccess | Hier kann bei erhöhtem Sicherheitsbedarf der Root-Zugang zur Datenbank gesperrt werden. |  
| UseHTTPDefaultv11 | Hier kann auf HTTP/1.1 herunter geschaltet werden. | 
|PortHTTPS | Hier kann der Port von 443 auf einen anderen Port gesetzt werden, falls 443 schon belegt ist. |
|UseCORSHeader | Die Verwendung des CORSHeader kann deaktiviert werden.|
|TLSKeystorePath | Pfad zum Keystore für das Zertifikat|
|TLSKeystorePassword | Das Passwort für den Keystore. (Wird automatisch generiert.)
|ClientPath | Pfad zu den Dateien des SVWS-Cllient. (Web-Anwendung in Entwicklung)|
|LoggingEnabled | Schaltet das Logging ein.|
|LoggingPath | Pfad zu den LOG-Dateien.|

#### Datenbankserver Einstellungen
|DBKonfiguration||
|---|---|
|dbms| Datenbanksystem (MariaDB oder SQLite für Schulungsumgebungen)|
|location| ServerURL|
|defaultschema| Standart-Schema. Es können mehrere Schemata verwendet werden.|

#### Datenbankschemata Einstellungen
|SchemaKonfiguration||
|---|---|
|name| Name des Datenbankschemas|
| svwslogin| Login-Prozess auch über das DBMS möglich. (User muss dann im DBMS angelegt sein.) <br> Zur Zeit nicht unterstützt!|
| username | Datenbank-Username|
| password | Passwort des Datenbank-Users


## Registrierung der Dienste

![](./graphics/SVWSDienste.jpg)

Die beiden Server werden als Dienst registriert. Diese können in der Computerverwaltung überprüft werden.

## Erstellen des Keystore/Zertifikat
Im Keystore des SVWS-Server wird ein selbstsigniertes Zertifikat erstellt. 
Der öffentliche Teil wird im Ordner 

`C:\Users\{Username}\Dokumente` gespeichert. 

Dieses Zertifikat muss anschließend in den Zertifikatsspeicher von Windows übertragen werden.

![](./graphics/SVWSZertifikat.jpg)

**Ort:** Vertrauenwürdige Stammzertifikate

Bitte beachten Sie das nur Chrome und Edge automatisch diese Zertifikate nutzen. 

**Firefox** muss in der about:config die Einstellung security.enterprise_roots.enabled auf true gesetzt haben.

## Uninstaller
Im Programmverzeichnis des SVWS-Server befindet sich auch ein signierter Uninstaller mit dem alle Installationsdateien wieder entfernt werden können.

Bitte beachten Sie, dass Dateien, die nach der Installation hinzugefügt wurden nicht erfasst werden.

Außerdem sollte kontrolliert werden, ob auch alle Dienste entfernt wurden. Windows 10 gibt in einigen Fällen die Dienste nicht schnell genug frei, so dass die Löschung scheitert.

## Wichtige Pfade zu den Ordnern
Als Default-Verzeichnisse werden bei der Installation folgende Verzeichnisse vorgeschlagen:

| Pfad | Beschreibung |
|---|---|
|`C:\Program files\SVWS-Server`| Alle Programm-Dateien inklusive MariaDB und Java-Umgebung|
|`C:\ProgramData\SVWS-Server`| Alle Daten und Logs und Einstellungsdateien|
|`C:\Users\{Username}\AppData\Local\Temp`| Log-Files des Installers und Uninstallers|
|`C:\Users\{Username}\Dokumente`|Das Zertifikat für die Browser|

## Pakete im SVWS-Installer

Unter folgender URL können die benötigten Pakete und Versionen für den Bau des Installers heruntergeladen werden.

+ curl
	+ https://svws.nrw.de/uploads/media/svws-server-downloads/curl/7.72.0/curl-7.72.0-windows.zip
	+ Sourcen: https://svws.nrw.de/uploads/media/svws-server-downloads/curl/7.72.0/src-curl-7_72_0.zip
+ mariadb
	+ https://svws.nrw.de/uploads/media/svws-server-downloads/mariadb/10.5.7/mariadb-10.5.7-win.zip
+ Sourcen: https://svws.nrw.de/uploads/media/svws-server-downloads/mariadb/10.5.7/server-mariadb-10.5.7.zip
+ innoextract
	+ https://svws.nrw.de/uploads/media/svws-server-downloads/innoextract/1.9/innoextract-1.9-windows.zip
	+ Sourcen: https://svws.nrw.de/uploads/media/svws-server-downloads/innoextract/1.9/innoextract-1.9.tar.gz
+ innosetup
	+ https://svws.nrw.de/uploads/media/svws-server-downloads/innosetup/6.0.5/innosetup-6.0.5.exe
	+ https://github.com/jrsoftware/issrc
+ jdk
	+ https://svws.nrw.de/uploads/media/svws-server-downloads/jdk/12.0.2/jdk-12.0.2-win.zip
	+ Sourcen: https://svws.nrw.de/uploads/media/svws-server-downloads/jdk/12.0.2/src-jdk-12-2.zip
+ winsw
	+ https://svws.nrw.de/uploads/media/svws-server-downloads/winsw/2.10.3/
	+ Sourcen: https://svws.nrw.de/uploads/media/svws-server-downloads/winsw/2.10.3/

