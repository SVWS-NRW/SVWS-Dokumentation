# Eclipse fuer die SVWS-Entwicklung

Diese Anleitung beschreibt nur die Einrichtung von Eclipse fuer die Arbeit am SVWS-Projekt. Betriebssystemspezifische Installationsschritte sind bewusst ausgelassen.

## Voraussetzungen

- Ein installiertes JDK 21
- Git-Zugriff auf das Repository
- Eine lokal erreichbare MariaDB-Instanz fuer Serverstarts und Tests

## Eclipse installieren

- Eine aktuelle Version von Eclipse IDE for Java Developers oder Eclipse IDE for Enterprise Java and Web Developers installieren
- Beim ersten Start einen lokalen Workspace festlegen
- Bei Bedarf die Speicherwerte in der `eclipse.ini` erhoehen

Beispiel:

```text
-Xms2048m
-Xmx32768m
```

## Eclipse konfigurieren

### UTF-8 aktivieren

- `Window -> Preferences -> General -> Workspace -> Text file encoding -> UTF-8`
- `Window -> Preferences -> General -> Editors -> Text Editors -> Spelling -> UTF-8`

### Java 21 hinterlegen

- Unter `Window -> Preferences -> Java -> Installed JREs` das JDK 21 eintragen
- Sicherstellen, dass das importierte Projekt ebenfalls mit Java 21 arbeitet

### Optionale Plugins

- JSON Editor Plugin fuer die Bearbeitung der `svwsconfig.json`
- Checkstyle Plugin, wenn die Checkstyle-Ansicht in Eclipse genutzt werden soll

## Repository einbinden

Das Repository kann direkt in Eclipse in der Git-Perspektive oder im Terminal geklont werden.

Repository:

- `https://github.com/SVWS-NRW/SVWS-Server`

Anschliessend in Eclipse:

- `Window -> Perspective -> Open Perspective -> Other -> Git`
- `Clone a Git Repository`

## Gradle-Projekt importieren

- In die Java-Perspektive wechseln
- `Import -> Gradle -> Existing Gradle Project`
- Das lokale Repository-Verzeichnis auswaehlen

## SVWS-Konfiguration anlegen

Die Beispiel-Konfiguration in das Zielverzeichnis kopieren und als `svwsconfig.json` ablegen.

```bash
cp ~/git/SVWS-Server/svws-server-app/src/main/resources/svwsconfig.json.example \
  ~/git/SVWS-Server/svws-server-app/svwsconfig.json
```

Fuer die lokale Entwicklung sollte `PortHTTPS` auf einen Wert groesser oder gleich `1024` gesetzt werden, zum Beispiel `3000`. So laesst sich der Server ohne erhoehte Rechte aus Eclipse starten.

Wichtige Pfade in der `svwsconfig.json`:

- `ClientPath` auf das Webclient-Build-Verzeichnis setzen
- `AdminClientPath` auf das Adminclient-Build-Verzeichnis setzen
- Datenbankzugang fuer die lokale MariaDB hinterlegen

Beispiel:

```json
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : false,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 3000,
  "UseCORSHeader" : true,
  "TempPath" : "tmp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : ".",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "/home/YOUR_USERNAME/git/SVWS-Server/svws-webclient/client/build/output/",
  "AdminClientPath" : "/home/YOUR_USERNAME/git/SVWS-Server/svws-webclient/admin/build/output/",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "localhost",
    "defaultschema" : "svwsdb",
    "SchemaKonfiguration" : []
  }
}
```

## Bauen und aktualisieren

### In Eclipse

- Gradle-Tasks fuer die benoetigten Teilprojekte ausfuehren, zum Beispiel `clean` und `build`
- Nach Aenderungen an Gradle-Konfigurationen ein Project Reload ausfuehren

### Im Terminal

```bash
cd ~/git/SVWS-Server
./gradlew clean
./gradlew build
```

## Code Styles

Die Code Styles werden bei einem Gradle Project Reload oder Build automatisch in den Workspace geladen. Eigene lokale Abweichungen sind nicht vorgesehen.

Weitere Informationen stehen in der Anleitung [Code Styles](../Code-Styles/index.md).

## Checkstyle

Wenn das Checkstyle-Plugin installiert ist, kann es direkt auf dem Projekt aktiviert werden:

- Rechtsklick auf das Projekt `SVWS-Server`
- `Checkstyle -> Activate Checkstyle`
- Optional die Ansicht `Checkstyle Problems` einblenden