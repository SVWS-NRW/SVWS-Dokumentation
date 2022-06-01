# **SVWS-core**
Die untere Übersicht zeigt den Aufbau des Servers als Zwiebelmodell. Das Herzstück des Servers wird aus dem SVWS-core gebildet. Der SVWS-core besteht aus den implementierten Algorithmen, den core-types (Datentypen /Java-Klassenm, mit Hilfsmethoden), und aus den core-DTO's (data transferobject).
Der SVWS-core organisiert nicht nur serverseitig die Zugriffe und Verarbeitung von DTOs und copre-types und deren Speicherung, Update und Löschung in der Datenbank mit Hilfe der Packages svws-db und svws-db-utils, sondern er beantwortet auch die requests, die vom SVWS-Client kommen, über die Open-API-Schnittstelle.

 
- Jetzige Zustand
 	Der core besteht aus dem core-type (svws-base {logger, csv-Definitionen}) und dem data-Object. (data-object was ist das? woraus besteht das?)
	Der core generiert beim Build-Prozess Datenbanktabellen aus den csv-Dateien und erstellt einen Datenbankschema her (dies wird im wird in der SVWS-Datenbank geladen?)


- baldige Zustand
	Die csv-Definitionen werden nicht mehr im svws-base sein. Hierbei werden die Pa	kete SVWS-base und SVWS-db in einem SVWS-db-Paket vereint.
	(wenn keine csv-Dateien mehr benötigt werden, was wird konkret geändert?)

	
![Server-Client-Zwiebelmodel](../graphics/Zwiebelmodell_SVWS-Server_und_SVWS-Client.png)
