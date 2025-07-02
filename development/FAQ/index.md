# Häufig gestellte Fragen

## Fragen zum Projekt

Das Projekt SVWS-Server wurde erstmals im November 2019 im Ministerium für Schule und Bildung NRW (MSB) vorgestellt.

Ein erster Web-Client auf Basis von NodeJS und Angular mit einem Jetty-Rest-Server wurde dort vorgestellt.

Alle Beteiligten waren sich einig, dass es sinnvoll ist, diesen Weg weiter zu verfolgen.

Das Ziel, einen plattformunabhängigen Web-Client zu schaffen, der nach und nach SchILD-NRW ablösen soll, wurde dann formuliert.

Die Auswahl der Programmiersprachen wurde hauptsächlich aus der Motivation getroffen, dass das Projekt als Open-Source später allen Schulen zur Verfügung stehen soll. Damit war die Entscheidung, dass ausschließlich plattformübergreifende Lösungen in Frage kommen, getroffen. Das Core-Projekt wird in Java programmiert und soll so einen skalierbaren Serverbetrieb ermöglichen, der unabhängig vom genutzten Betriebssystem zur Verfügung gestellt werden kann.

Die Auswahl von HTML, CSS, TypeScript mit VUE.JS wurde sehr stark von der Frage der Flexibilität geprägt. Außerdem hat das Projekt bisher wenig Altlasten bezüglich des Codes, der die Geschäftsprozesse der Schulverwaltung angeht. Bestehende Algorithmen und Abläufe bleiben in SchILD-NRW 2.0 und SchILD-NRW 3.0 erhalten. Es war allen beteiligten Entwicklern klar, dass neue Abschlussberechnungen und Gruppenprozesse usw. sowieso als Dienste völlig neu programmiert werden müssen. Außerdem kam eine Portierung aus dem Delphi-Code so gesehen auch nicht in Frage.

Im Jahr 2020 wurde dann die Entscheidung getroffen zu VUE.js zu wechseln, da zu diesem Zeitpunkt noch nicht viele UI-Elemente umgesetzt waren und die Entwicklung mit VUE.js durch den noch viel stärker von der Open-Source-Community getriebenen Charakter viel besser zu der Philosophie des Projekts SVWS-Server passt.

Außerdem wurde sehr viel Wert darauf gelegt, dass die Statistiktabellen von IT.NRW in transpilierbarer Form im SVWS-Server zur Verfügung stehen, damit diese auch im Web-Client genutzt werden können.

Im Juni 2021 wurde dann im MSB im Referat 133 (jetzt 135) eine Stelle geschaffen, die mit der Neuprogrammierung der Schulverwaltungssoftware betraut wurde. Seit dem werden auch externe Programmierer eingesetzt. Wobei an der grundsätzlichen Entscheidung festgehalten werden soll, dass hier auch aus schulfachlicher Sicht immer auch Lehrerinnen und Lehrer bei der Entwicklung einbezogen werden sollen, damit die Software den Bezug zu den alltäglichen Verwaltungsvorgängen in Schule behält.
Das ist auch der Grund, warum die Projektsprache weiterhin Deutsch ist, damit Kolleginnen und Kollegen sich leichter einlesen können.


## Mitarbeit am Projekt

Hier können interessierte Entwickler und Programmierer weitere Informationen zur [Mitarbeit](../../teamarbeit/) erhalten.

## Wo finde ich die nötigen Quellen?

Das Repository steht auf GitHub.com zur Verfügung.

https://github.com/SVWS-NRW/SVWS-Server

Die empfohlene Entwicklungsumgebung ist Eclipse. Hierzu gibt es auch eine Anleitung:

https://doku.svws-nrw.de/Entwicklungsumgebungen/

Die einzelnen Packages stehen auch auf Maven Central zur Verfügung:

https://central.sonatype.com/search?smo=true&q=svws

Die npm-Packages stehen auf npmjs.org zur Verfügung:

https://www.npmjs.com/search?q=svws

Ein Docker-Container des SVWS-Servers kann hier heruntergeladen werden:

https://hub.docker.com/r/svwsnrw/svws-server


## Datenbanken und Migration

Um den SVWS-Server zu betreiben, muss eine SchILD-NRW-Datenbank in die MariaDB migriert werden.

Hierzu stehen Dummy-Datenbanken zur Verfügung:

https://github.com/SVWS-NRW/SVWS-TestMDBs



## Selbst signierte Zertifikate akzeptieren
Solange die Schulverwaltungssoftware auf eigenen Servern oder Desktop-Rechnern in den Schulen betrieben werden muss, wird es in kleineren Systemen wichtg sein, dass die Https-Aufrufe über ein selbst signiertes Zertifikat laufen können.

Unschön wird es sein, wenn der User im Browser zunächst eine Fehlermeldung über eine unsichere Verbindung bekommt und dann den Browser über erweiterte Einstellungen dazu bringen muss, das Zertifikat zu akzeptieren.

In größeren Umgebungen, wo Schuldatenbanken von Rechenzentren gehostet werden, sollte der Betreiber ein Zertifikat besitzen und in den Keystore des SVWS-Server importieren.

Um das Problem auf Windows-Clients zu umgehen, sollte mit dem Installer das SVWS-Server-Zertifikat im Windows Zertifikatsmanager importiert werden. 

```shell
ausführen > cmd 

	certmgr.msc
```

Unter Firefox kann eingestellt werden, dass auch auf diese Zertifikate zugegriffen werden soll. Dazu muss in diesem Ordner: `C:\Program Files\Mozilla Firefox\defaults\pref` (Bei Standard-Installation)

eine Datei mit dem Namen 'trustcert.js' mit folgendem Inhalt angelegt werden:

```js
		/* Allows Firefox reading Windows certificates */ pref("security.enterprise_roots.enabled", true);
```

Für Chrome und Edge scheint das nicht notwendig zu sein.

## Diagnostik

Der SVWS-Server startet nicht ...

### Diagnosetools
Informationen zum Zustand des Servers erhält man z.B. mit den folgenden Befehlen, die ein Administrator auf dem Linux-Terminal absetzen kann: 

```bash 
systemctl status svws
```
bzw. 
```bash 
journalct -u svws -f
```

### Fehler: Cannot invoke "de.svws_nrw.db.DBConfig.getDBDriver()"

Hier stimmt irgendwas nicht mit der Definition oder dem Zugriff auf die MariaDB. Bitte die svwsconfig.json ansehen!

Workaround:

Man kann nun nach einer Sicherung der aktuellen ```svwsconfig.json``` ggf. die SchemaKonfiguration entfernen, so dass die Eintragung an dieser Stelle entsprechend: 
```bash 
...
"DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "127.0.0.1",
    "defaultschema" : "GymAbi",
    "SchemaKonfiguration" : [ ]
  }
 ... 
 ```
 
abgeändert wird. Nun den SVWS-Server neu starten mit: 

```bash 
systemctl restart svws
```

Anschließend kann man z.B. über die Swagger ein neues Datenbankschema anlegen. Hierzu bitte die folgende URL aufrufen ("mein_SVWS-Server" sinnvoll ersetzen):   
https://mein_SVWS-Server/debug/ 