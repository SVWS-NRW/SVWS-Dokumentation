# Häufig gestellte Fragen

Inhaltsverzeichnis
  * [Fragen zum Projekt](#fragen-zum-projekt)
  * [Grundlegende Entscheidungen](#grundlegende-entscheidungen)
  * [Datenbankuser bei Migration](#datenbankuser-bei-migration)
  * [Verwendung eines CSS-Frameworks](#verwendung-eines-css-frameworks)
  * [JSweet zur Auslagerung der Algorithmik in den Browser](#jsweet-zur-auslagerung-der-algorithmik-in-den-browser)
  * [Selbst signierte Zertifikate akzeptieren](#selbst-signierte-zertifikate-akzeptieren)



## Fragen zum Projekt

An dieser Stelle werden Fragen bzw. Antworten gesammelt, die während der Entwicklung des Projektes entstehen.

Es handelt sich auch vielfach um Entscheidungen, die getroffen wurden oder noch getroffen werden müssen.

Entwickler, die zu einem späteren Zeitpunkt auf das Projekt stoßen, sollen hier auch Informationen bekommen, warum bestimmte Entscheidungen getroffen wurden. Oder es sollen Informationen gegeben werden, dass Features in Richtungen geplant sind, aber eben noch nicht umgesetzt.


## Grundlegende Entscheidungen
Die Auswahl der Programmiersprachen wurde hauptsächlich aus der Motivation getroffen, dass das Projekt als OpenSource später allen Schulen zur Verfügung stehen soll. Damit war die Entscheidung, dass ausschließlich plattformübergreifende Lösungen in Frage kommen getroffen. Das Core-Projekt wird in Java programmiert und soll so einen skalierbaren Serverbetrieb ermöglichen, der unabhängig vom genutzten Betriebssystem zur Verfügung gestellt werden kann.

Die Auswahl von HTML, CSS, TypeScript mit VUE.JS wurde sehr stark von der Frage der Flexibilität geprägt. Außerdem hat das Projekt bisher wenig Altlasten was den Code angeht, der die Geschäftsprozesse der Schulverwaltung angeht. Bestehende Algorithmen und Abläufe bleiben in Schild-NRW-2.0 und Schild-NRW-3.0 erhalten. Es war allen beteiligten Entwicklern klar, dass neue Abschlussberechnungen und Gruppenprozesse usw. sowieso als Dienste völlig neu programmiert werden müssen. Außerdem kam eine Portierung aus dem Delphi-Code so gesehen auch nicht in Frage.

Hier einige Links zu Artikeln, die im Nachhinein die Entscheidungen unterstützen.

+ [Heise Artikel zu Softwareentwicklungen](https://www.heise.de/news/Kommentar-So-kann-Microsoft-die-Abwanderung-von-NET-Entwicklern-nicht-stoppen-4725901.html)

+ [MediaWiki einigt sich auf VUE.js](https://www.heise.de/developer/meldung/Renovierungsplaene-fuer-Phabricator-mit-Vue-js-4687279.html)

+ [Die Stadt München will zwingend OpenSource entwickeln lassen](https://www.heise.de/news/Gruen-Rot-Stadt-Muenchen-soll-rasch-fuenf-Open-Source-Projekte-entwickeln-4937719.html)

+ [LUSD muss flexibler werden.....](https://www.egovernment-computing.de/leistungsfaehige-it-services-fuer-hessische-schulverwaltung-durch-innovation-und-team-arbeit-a-536808/)

+ [eGovernment zum Thema OpenSource und offenen Standards](https://www.egovernment-computing.de/zwischen-open-source-und-open-standards-a-959060/)

## Datenbankuser bei Migration
Der root-Benutzer sollte nicht in der Konfiguration eingetragen sein. Deswegen ist dies auch so gar nicht vorgesehen. Die API um eine Migration vorzunehmen kann allerdings mit einem root-Benutzer durchgeführt werden und ist insbesondere für den Installer vorgesehen.

Im CORE_Projekt muss aber noch dieses bereits geplante, aber noch nicht umgesetzte, Feature ergänzt werden, dass dieser Teil der Schnittstelle per Default abgestellt ist und nur gezielt über die svwsconfig-Datei aktiviert werden kann. In dieser Konfigurationsdatei ist übrigens, wie oben beschrieben, der schildadmin vorgesehen. Dieser hat erhöhte Rechte, um Tabellen, etc. anzulegen.

Das Anlegen eines weiteren Schemas ist nur für Multi-DB-Umgebungen vorgesehen, welche in Schulungsumgebungen vorkommen. Schulträger sollten für unterschiedliche Schulen aus meiner Sicht sowieso unterschiedliche DB-Installationen verwenden, wodurch diese Problematik dann erst gar nicht auftaucht.


## Verwendung eines CSS-Frameworks
Ein gutes reines CSS-Framework kann Arbeit ersparen. Interessant ist aber auch die Handhabung solcher Frameworks bei der Entwicklung. Eine Unterstützung unterschiedlicher Themes ist auch interessant. Wenn in dem Bereich der UI-Framworks Erfahrung vorliegt, dann sollte man das Einbinden des CSS-Frameworks in das bestehende Client-Projekt an einem Beispiel demonstrieren. Eine Verbesserung wäre auch hier wünschenswert...


## JSweet zur Auslagerung der Algorithmik in den Browser
Damit Teile des Codes im Browser auf dem Client ausgeführt werden können un dsomit nicht die Prozessorleitsung des Server genutzt werden muss, wenn rechenintensive Prozesse angestoßen werden, wird der Code mittels JSweet in Javascript oder Typyscript übersetzt.

http://www.jsweet.org/

Dieser Transpiler übersetzt Java direkt in Javascript. Dafür müssen bei der Gestaltung des Codes einige Dinge beachtet werden, so dürfen z.B. keine Lambda-Ausdrücke verwendet werden. Dies muss von den Entwikclern des Codes beachtet werden und sollte gut dokumentiert werden.

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