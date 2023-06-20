# Häufig gestellte Fragen

Inhaltsverzeichnis
  * [Fragen zum Projekt](#fragen-zum-projekt)
  * [Mitarbeit am Projekt](#mitarbeit-am-projekt)
  * [Datenbankuser bei Migration](#datenbankuser-bei-migration)
  * [Selbst signierte Zertifikate akzeptieren](#selbst-signierte-zertifikate-akzeptieren)
  * [](#)


## Fragen zum Projekt

Das Projekt SVWS-Server wurde erstmals im November 2019 im Ministerium für Schule und Bildung NRW (MSB) vorgestellt.

Ein erster Web-Client auf Basis von NodeJS und Angular mit einem Jetty-Rest-Server wurde dort vorgestellt.

Alle Beteiligten waren sich einige, dass es sinnvoll ist , diesen Weg weiter zu verfolgen.

Das Ziel, eionen plattformunabhängigen Web-Client zu schafenn, der nach und nach Schild-NRW ablösen soll, wurde dann formuliert.

Die Auswahl der Programmiersprachen wurde hauptsächlich aus der Motivation getroffen, dass das Projekt als OpenSource später allen Schulen zur Verfügung stehen soll. Damit war die Entscheidung, dass ausschließlich plattformübergreifende Lösungen in Frage kommen getroffen. Das Core-Projekt wird in Java programmiert und soll so einen skalierbaren Serverbetrieb ermöglichen, der unabhängig vom genutzten Betriebssystem zur Verfügung gestellt werden kann.

Die Auswahl von HTML, CSS, TypeScript mit VUE.JS wurde sehr stark von der Frage der Flexibilität geprägt. Außerdem hat das Projekt bisher wenig Altlasten was den Code angeht, der die Geschäftsprozesse der Schulverwaltung angeht. Bestehende Algorithmen und Abläufe bleiben in Schild-NRW-2.0 und Schild-NRW-3.0 erhalten. Es war allen beteiligten Entwicklern klar, dass neue Abschlussberechnungen und Gruppenprozesse usw. sowieso als Dienste völlig neu programmiert werden müssen. Außerdem kam eine Portierung aus dem Delphi-Code so gesehen auch nicht in Frage.

Im Jahr 2020 wurde dann die Entscheidung getroffen zu VUE.js zu wechseln, da zu diesem Zeitpunkt noch nicht viele UI-Elemente umgesetzt waren und die Entwicklung mit VUE.js durch den noch viel stärker von der Open-Source-Community getriebenen Charakter viel besser zu der Philosophie des Projekts SVWS-Server passt.

Außerdem wurde sehr viel Wert darauf gelegt, dass die Statistiktabellen von IT.NRW in transpilierbarer Form im SVWS-Server zur Verfügung stehen, damit diese auch im Web-Client genutzt werden können.

Im Juni 2021 wurde dann im MSB im Referat 133 eine Stelle geschaffen, die mit der Neuprogrammierung der Schulverwaltungssoftware betraut wurde. Seit dem werden auch externe Programmierer eingesetzt. Wobei die grundsätzliche Entscheidung, dass hier auch aus schulfachlicher Sicht immer auch Lehrerinnen und Lehrer bei der Entwicklung einbezogen werden sollen, damit die Software den Bezug zu den alltäglichen Verwaltungsvorgängen in Schule behält.
Das ist auch der Grund, warum die Projektsprache weiterhin Deutsch ist, damit Kolleginnen und Kollegen sich leichter einlesen können.


## Mitarbeit am Projekt


## 


## Datenbankuser bei Migration
Der root-Benutzer sollte nicht in der Konfiguration eingetragen sein. Deswegen ist dies auch so gar nicht vorgesehen. Die API um eine Migration vorzunehmen kann allerdings mit einem root-Benutzer durchgeführt werden und ist insbesondere für den Installer vorgesehen.

Im CORE_Projekt muss aber noch dieses bereits geplante, aber noch nicht umgesetzte, Feature ergänzt werden, dass dieser Teil der Schnittstelle per Default abgestellt ist und nur gezielt über die svwsconfig-Datei aktiviert werden kann. In dieser Konfigurationsdatei ist übrigens, wie oben beschrieben, der schildadmin vorgesehen. Dieser hat erhöhte Rechte, um Tabellen, etc. anzulegen.

Das Anlegen eines weiteren Schemas ist nur für Multi-DB-Umgebungen vorgesehen, welche in Schulungsumgebungen vorkommen. Schulträger sollten für unterschiedliche Schulen aus meiner Sicht sowieso unterschiedliche DB-Installationen verwenden, wodurch diese Problematik dann erst gar nicht auftaucht.




## Selbst signierte Zertifikate akzeptieren
Solange die Schulverwaltungssoftware auf eigenen Servern oder Desktop-Rechnern in den Schulen betrieben werden muss, wird es in kleineren Systemen wichtg sein, dass die Https-Aufrufe über ein selbst signiertes Zertifikat laufen können.

Unschön wird es sein, wenn der User im Browser zunächst eine Fehlermeldung über eine unsichere Verbindung bekommt und dann den Browser über erweiterte Einstellungen dazu bringen muss das Zertifikat zu akzeptieren.

In größeren Umgebungen, wo Schuldatenbanken von Rechenzentren gehostet werden, sollte der Betreiber ein Zertifikat besitzen und in den Keystore des SVWS-Server importieren.

Um das Problem auf Windows-Clients zu umgehen sollte mit dem Installer das SVWS-Server-Zertifikat im Windows Zertifikatsmanager importiert werden. 

ausführen > cmd 

	certmgr.msc

Unter Firefox kann eingestellt werden, dass auch auf diese Zertifikate zugegriffen werden soll. Dazu muss in diesem Ordner: C:\Program Files\Mozilla Firefox\defaults\pref (Bei Standard-Installation)

Eine Datei mit dem Namen 'trustcert.js' mit folgfendem Inhalt angelegt werden:

		/* Allows Firefox reading Windows certificates */ pref("security.enterprise_roots.enabled", true);

Für Chrome und Edge scheint das nicht notwendig zu sein.