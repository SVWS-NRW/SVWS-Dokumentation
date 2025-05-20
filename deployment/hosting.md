# Hosting - FAQ für Schulträger

## Mandantentrennung

Der SVWS-Server trennt die Daten der Schulen im Gegensatz zu Schild2-Zentral auf Datenbankebene.
Dies führt dazu, dass pro Schule ein Schema verwendet wird. Hier kann, anders als in Schild2-Zentral, über den Datenbank-Benutzer sichergestellt werden, dass die Daten einer Schule auch nur den Benutzern dieser Schule zur Verfügung stehen.

Durch diese Trennung kann auch das Einspielen von Backups wesentlich vereinfacht, wenn Daten von nur einer Schule wieder eingespielt werden müssen.

Durch das neue Datenbank-Schema-Management in Schild-NRW und auch in Schild-Zentral können diese Schemata verwaltet werden.
Manuelle Eingriffe in die einzelnen Datenbanken entfallen zukünftig, da die Aktualisierung von Statistikdaten und die Anhebung der Datenbankrevisionen automatisch vom SVWS-Server übernommen werden.

Umfangreiche Unterstützung bei der Migration der Schuldatenbanken wird durch den SVWS-Server gewährleistet.

Insgesamt sollte sich der Datenbank-Traffic mit dieser Art der Datentrennung sogar verringern lassen, da die Abfragen nicht mehr über die gesamte Anzahl der Mandanten gefiltert werden muss.

**Begründung für die Trennung in verschiedenen Datenbanken:**

Die Trennung der Mandantendaten auf Tabellenebene durch Mandanten-Schlüssel (z.B. ein „Mandant_ID“-Feld in jeder Zeile) bietet zwar eine logische Abgrenzung, stellt aber bei hohem Schutzbedarf kein ausreichendes Sicherheitsniveau dar. Dies liegt an mehreren Gründen:

1. **Risiko durch Software-Fehler und Fehlkonfigurationen:**
Bei einer Trennung nur über Mandanten-Schlüssel besteht die Gefahr, dass durch Programmierfehler, fehlerhafte Abfragen oder Fehlkonfigurationen versehentlich Daten mehrerer Mandanten zusammengeführt oder offengelegt werden. Ein simpler Fehler in einer SQL-Abfrage (z.B. fehlende WHERE-Klausel) kann dazu führen, dass ein Mandant Zugriff auf sämtliche Daten erhält.
2. **Erhöhte Angriffsfläche:**
Ein Angreifer, der sich Zugriff auf die zentrale Datenbank verschafft, hat potentiell Zugriff auf die Daten aller Mandanten. Die Trennung über verschiedene Datenbanken begrenzt im Falle eines Angriffs das Schadensausmaß auf die betroffene Datenbank und damit auf einen Mandanten.
3. **Berechtigungsmanagement:**
Die Vergabe und Kontrolle von Zugriffsrechten ist bei separaten Datenbanken wesentlich granularer und sicherer möglich. So können beispielsweise Datenbanknutzer, Backup-Jobs oder Administratoren auf Mandantenebene getrennt werden. Bei einer gemeinsamen Datenbank ist dies technisch oft nicht möglich.
4. **Einhaltung regulatorischer Vorgaben:**
Bei hohem Schutzbedarf – insbesondere bei sensiblen, personenbezogenen oder geheimhaltungsbedürftigen Daten – fordern viele gesetzliche und branchenspezifische Vorgaben (z.B. BSI IT-Grundschutz, ISO 27001, DSGVO) eine möglichst weitgehende technische Trennung, was in der Praxis meist durch separate Datenbanken umgesetzt wird.
5. **Vermeidung von Datenvermischung:**
Bei Migrationen, Backups oder Wiederherstellungen besteht bei einer gemeinsamen Datenbank die Gefahr, dass versehentlich Daten anderer Mandanten mit exportiert, importiert oder wiederhergestellt werden. Separate Datenbanken verhindern dies zuverlässig.

**Fazit:**
Die Trennung der Mandantendaten in unterschiedlichen Datenbanken bietet ein deutlich höheres Sicherheitsniveau als die reine Trennung per Mandanten-Schlüssel in den Tabellen. Sie reduziert die Angriffsfläche, minimiert das Risiko von Datenlecks durch menschliche oder technische Fehler und entspricht den Anforderungen bei hohem Schutzbedarf. Bei besonders sensiblen Daten ist diese Form der Trennung daher zwingend erforderlich.


## Datenbanksystem MariaDB

Der SVWS-Server unterstützt MariaDB als Open-Source-Datenbanklösung.
Hier kann auf die kostenfreie Community-Variante, aber auch auf die Enterprise-Lösung zurückgegriffen werden.

Im Bereich des Windows-Installers wird eine kompatible Version von MariaDB mitgeliefert.

Die Auswahl dieses Datenbanksystems ermöglicht einen modernen Zugriff auf die Daten der Schulen.
Die Nutzung von Funktionen, wie Autoincrementen, Triggern und Json-Tabellenfunktionen unterstützen langfristig einen Performance-Gewinn.

Die Pflege von fehleranfälligen Doppelungen in den Abfragen, um mehrere Datenbanksysteme zu unterstützen entfällt durch die Auswahl eine einzigen DBMS.
Alle Abfragen und Datenbankoperationen werden durch den SVWS-Server getestet und durch ein Release-Verfahren geprüft.

Hier werden Integrationstests mit Migrationen und Datenbankupdates automatisch ausgeführt und ausgewertet.

Durch diese Maßnahmen sollen die Rechenzentren bei dem Betrieb des Datenbanksystems MariaDB so unterstützt werden, dass der Aufwand verhältnismäßig bleibt.

## Skalierung der Systeme

Der SVWS-Server unterstützt die Mandantenfähigkeit, so dass möglichst viele Schulen auf einem Server betrieben werden können.
Die Anzahl der Schulen muss im Rahmen der Bedingungen vor Ort gewählt werden. Dies kann durch den Grad der Virtualisierung und der zugrunde liegenden Hardware sehr variieren.

## Verringerung des Aufwands

Durch den Wegfall der Produkte Kurs42 und Lupo können zu Beginn der Einführung von Schild-NRW3 schon einige Aufwände verringert werden.
Auch die Zentralisierung der System und die einheitlicheren Supportbedingungen können hier helfen Kosten zu reduzieren.

Perspektivisch wird dies noch durch die Ablösung anderer Module unterstützt werden. (Notenmodule, Konferenzmodule, Prognos, ASDPC32)

Die Unterstützung weiterer Online-Funktionen, wie z.B. Schulbewerbung.de und auch die einheitliche Erstellung von digitalen Zeugnissen, sollen hier die Schulträger entlasten.
Die Anzahl der individuellen Einzellösungen kann hier reduziert werden, auch durch die Bereitstellung von versionierten Standard-API-Endpunkte, wie z.B. die Schnittstelle zur Synchronisation von Lernplattformen, die hier eine deutliche Verringerung von Aufwänden durch Automatisierung hervorbringen kann.

## IT-Sicherheitsmaßnahmen

Der SVWS-Server wird täglich mit Trivy auf gemeldete Sicherheitslücken gescannt. CVE-Reports mit der Einstufung HIGH oder höher werden sofort behoben, wenn ein Lösung durch den Hersteller der betroffenen Komponente zur Verfügung steht.


