# SVWS-Datenbankstrukturen

## Übersicht Datenbankfunktionen

![Übersicht-REST-Server-06](./graphics/Uebersicht-REST-Server-06.png)

## Das Projekt SVWS-DB
In diesem Projekt werden in der Übergangsphase von SchILD-NRW 3.0 die Datenbank-Skripte erzeugt. 
Das bedeutet, dass sämtliche Tabellenstrukturen über die CSV-Dateien festgehalten werden.
Zusätzlich werden hier alle Default-Daten in den Tabellen gepflegt. 
Dazu gehören die Statkue-, Schildintern, Schulver- und ImpExp-Tabellen. Die Default-Daten werden teilweise von IT.NRW 
bereit gestellt, so dass diese eingepflegt werden müssen.
Die momentan in der Entwicklung befindlichen Skripte können hier heruntergeladen werden:

https://github.com/SVWS-NRW/SVWS-DB-Scripte

Die Verwendung für SchILD-NRW 2.0 Datenbanken ist nicht zu empfehlen, auch wenn das über die Abschaltung von Case-Sensitiven-Tabellennamen möglich wäre.
Mit diesen Skripten kann über ein SQL-Tool eine leere SchILD-NRW 3.0 Datenbankstruktur erzeugt werden. 
Das Migrationstool von SchILD-NRW 2.0 erlaubt die Migration der Datenbank von SchILD-NRW 2.0 in diese erzeugte Datenbankstruktur, so dass ein Übergang zu SchILD-NRW 3.0 einfach möglich ist.
Diese Arbeiten werden aber zukünftig vom SVWS-Server erledigt!

Ziel ist es, dass SchILD-NRW nur noch in einer Übergangsphase auf die Datenbank direkt zugreifen kann. 
Perspektivisch wird der SVWS-Server alle Zugriffe übernehmen, so dass die Daten nur noch über die OpenAPI verändert werden können. 
Dafür werden entsprechende Services geschrieben, die dann feststehende und dokumentierte Endpunkte schaffen.

Eine Verschlüsselung ist auf Datenbankebene zunächst nicht vorgesehen, so dass die Sicherheitsrichtlinien des Betriebssystem den Schutz der Daten gewährleisten müssen. 
Bei höheren Sicherheitsanspüchen kann der SVWS-Server später in Rechenzentren auch in verschlüsselten Containern ausgeführt werden. 
Dies sollte das Ziel für größere kommunale Umgebungen sein.

## Einbindung der Statistikdaten von IT.NRW
Für das SVWS-Server-Projekt ist es wichtig, dass alle Daten direkt statistikkonform gespeichert werden oder auf die Tabellen von IT.NRW gemapped werden können.
Dazu wurde die Entscheidung getroffen, alle verwendeten Tabellen der Schulver.mdb, Stakue.mdb und dann direkt auch der Schildintern.mdb und der ImpExp.mdb 
in das Datenbankschema aufzunehmen.
Dadurch löst sich das Projekt von der Verwendung von Access-Datenbanken, schafft eine höhere Performance und bündelt die zu erledigenden Aktualisierungen 
im Repository, so dass Änderungen auch über DIFFs zurückverfolgt werden können.

Ein MDB-Genarator wird in der Übergangsphase die Keytabs MDBs für SchILD-NRW 2.0 erzeugen. So müssen die Defaultdaten von IT.NRW nicht doppelt gepflegt werden. Die vom Projekt erzeugten MDBs sind seit der Version 2.0.24.2 von SchILD-NRW in Verwendung!

## Modernisierung der Tabellenstrukturen
Ein Ziel des Datenbankprojekts ist es, dass alle Tabellen in der dritten Normalform vorliegen.
Dazu wurde zunächst die bestehende Datenbankstruktur übernommen und dann schrittweise angepasst. Die Diskussion über diese Vorgehensweise zeigt, dass dieser Weg kompliziert und fehleranfällig ist, da für SchILD-NRW 3.0 unter Umständen alte Strukturen (ggf. über Views) noch benötigt werden.
Fest steht jedenfalls, dass redundante Daten, nicht mehr verwendete Felder und Verletzungen der dritten Normalform sukzessive abgestellt werden müssen.


## Rechtesystem und Benutzerführung in der Datenbanksoftware
Als Default-DBMS wird MariaDB empfohlen. Für die SchILD*zentral*-Nachfolge wird aber weiterhin MS-SQL-Server unterstützt.

Zur Administration können die Standardbenutzer root (MariaDB) und sa (MS-SQL) verwendet werden. Diese Zugänge sollten ausschließlich dem DBMS-Administrator zur Verfügung stehen. Wahlweise können hier auch Zugänge mit Schema-übergreifenden Rechten für Administratoren angelegt werden.

Bei Installationen für einzelne Schulen dient dieser Zugang ausschließlich der Schama-Verwaltung, falls es gewünscht ist, zwei oder mehr Schemata zu Testzwecken oder bei Schulverbünden zu nutzen. Für den Zugriff auf die Daten im wird im Client trotzdem ein Datenbankuser angelegt, der nur Berechtigungen auf das Schema hat!

In größeren Systemen, in denen mehrere Schulen auf einem Datenbankserver betrieben werden, wird für jede Schule ein eigener Datenbankuser angelegt, dessen Rechte auf den Zugriff der schuleigenen Schemata beschränkt sind, so dass schon auf DBMS-Ebene ein Zugriff auf die Daten einer anderen Schule ausgeschlossen wird.


