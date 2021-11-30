# SVWS-Datenbankstrukturen

## Übersicht Datenbankfunktionen

![Übersicht-REST-Server-06](graphics/Übersicht-REST-Server-06.png)

## Das Projekt SVWS-DB
In diesem Projekt werden in der Übergangsphase von Schild-NRW-3.0 die Datenbank-Scripte erzeugt. Das bedeutet, dass sämtliche Tabellen-Strukturen über die CSV-Dateien festgehalten wird.
Zusätzlich werden hier alle Default-Daten in den Tabellen gepflegt. Dazu gehören die Statkue-, Schildintern, Schulver- und impexp-Tabellen. Die Defaultdaten werden teilweise von IT-NRW bereit gestellt, so dass diese eingepflegt werden müssen.
Die momentan in der Entwicklung befindlichen Scripte können hier heruntergeladen werden:

https://github.com/SVWS-NRW/SVWS-DB-Scripte

Die Verwendung für Schild-NRW-2.0-Datenbanken ist nicht zu empfehlen, auch, wenn das über die Abschaltung von Case-Sensitiven-Tabellennamen möglich ist.
Mit diesen Scripten kann über ein SQL-Tool eine Schild-NRW-3.0-Datenstruktur erzeut werden. Es kann sogar mit dem Migrationstool von Schild-NRW-2.0 in eine solche Datenbank migriert werden, so dass Schild-NRW-3.0 betrieben werden kann.
Diese Arbeiten werden aber zukünftig vom SVWS-Server erledigt!

Ziel ist es, dass Schild-NRW nur noch in einer Übergangsphase auf die Datenbank direkt zugreifen kann. Der SVWS-Server wird alle diese Zugriffe perspektivisch übernehmen, so dass die Daten nur noch über die OpenAPI verändert werden können. Dafür werden entsprechende Services geschrieben, die dann fest stehende und dokumentierte Endpunkte schaffen.

Eine Verschlüsselung ist auf Datenbankebene zunächst nicht vorgesehen, die Daten werden über die Sicherheitsrichtlinien des Betriebssystem geregelt. Bei höheren Sicherheitsanspüchen kann der SVWS-Server später in Rechenzentren auch in verschlüsselten Containern ausgeführt werden. Dies sollte das Ziel für größere Kommunale-Umgebungen sein.

## Einbindung der Statistikdaten von IT.NRW
Für das SVWS-Server-Projekt ist es wichtig, dass alle Daten direkt statistikkonform gespeichert werden oder auf die Tabellen von IT-NRW gemapped werden können.
Dazu wurde die Entscheidung getroffen, alle verwendeten Tabellen der Schulver.mdb, STakue.mdb und dann direkt auch der Schildintern.mdb und der ImpExp.mdb in das Datenbankschema einzubeinden.
Dadurch löst sich das Projekt von der Verwendung von Access-Datenbanken, schafft eine höhere Performance und bündelt die zu erledigenden Aktualisierungen im Repository, so dass Änderungen auch über DIFFs zurück verfolgt werden können.

Ein MDB-Genarator wird in der Übergangsphase die Keytabs MDBs für Schild2.0 erzeugen. So müssen die Defaultdaten von IT.nicht doppelt gepflegt werden müssen. Die vom Projekt erzeugten MDBs sind seit dem Update Schlild-NRW2.0.24.2 in Verwendung!
Eine Beschreibung, wie bestimmte Tabellen aktualisiert werden müssen gibt es an dieser Stelle, außerdem wird hier beschriben warum und wie von den Tabellen von IT.NRW abgewichen wurde und wie das gepflegt werden sollte:

+ Schulver.mdb einlesen
+ Datumswerte korrekt in CSV importieren
+ Statkue_Fachklasse einlesen
+ Statkue_ZulFaecher mit Mapping
+ Statkue_SVWS_ZulaessigeJahrgaenge
+ Statkue_ZulKuArt
+ Statkue_SVWS_Fachgruppen mit Schulformen
+ Statkue_SVWS_Fachgruppen mit Schulformen


# Modernisierung der Tabellenstrukturen
Ziel des Datenbankprojekts soll es sein, alle benötigten Informationen atomar und in normalisierter Form dargestellt werden.
Dazu werden zunächst die bestehenden Strukturen übernommen und dann schrittweise dem Ziel zugeführt. Die Diskussion über diese Vorgehensweise zeigt, dass dieser Weg kompliziert und Fehleranfällig ist, da für Schild-NRW3.0 unter Umständen die alten Strukture (ggf. über Views) noch benötigen wird.
Fest steht jedenfalls, dass redundate Stellen, nicht mehr verwendete Felder und Verletzungen der atomaren und normalisierten Speicherung sukzessiv abgestellt werden müssen.


# Rechtesystem und Benutzerführung in der Datenbanksoftware
Als Default-DBMS wird MariDB empfohlen. Für die Schild-Zentral-Nachfolge wird aber weiterhin MS-SQL-Server unterstützt.

In beiden System kann der root oder sa Zugang für administrative Zwecke verwendet werden. Diese Zugänge sollten ausschließlich dem DBMS-Administrator zur Verfügung stehen. Wahlweise können hier auch Zugänge mit Schema-übergreifenden Rechten für Administratoren angelegt werden.

Bei Installationen für einzelne Schulen dient dieser Zugang ausschließlich der Schama-Verwaltung, falls es gewünscht ist, zwei oder mehr Schemata zu Testzwecken oder bei Schulverbünden zu nutzen. Es wird für den Zugriff auf die Daten im Client trotzdem ein Datenbankuser angelegt, der nur Berechtigungen auf das Schema hat!

In größeren System, in denen mehrere Schulen auf einem Datenbankserver betrieben werdne, wird für jede Schule ein Datenbankuser nur mit Rechten auf die jeweiligen Schemata der einzelnen Schule angelegt! So dass schon allein auf DBMS-Ebene kein Zugriff von einer Schule auf eine andere erfolgen kann.


