# **SVWS-core**
Die untere Übersicht zeigt den Aufbau des Servers aus Gradelsicht (Bauplan) her. Das Herz-stück des Server wird aus dem SVWS-core gebildet. Der SVWS-core besteht aus den im-plementierten Algorithmen, den core-types (generierten Datentypen /Java-Klassen), und aus den core-DTO (data transferobject) dies sind generierte java-Objekte, die vom core zur Ver-fügung gestellt, bzw. vom Server verarbeitet werden.
Der SVWS-core organisiert nicht nur serverseitig die Zugriffe und Verarbeitung von generier-ten Java-Objekte (DTOs) und deren Speicherung update und Löschung auf die Datenbank mit Hilfe der Packages svws-db und svws-db-utils sondern er beantwortet auch die request die vom SVWS-client kommen über die Open-API Schnittstelle.

 
- Jetzige Zustand
 	Der core besteht aus dem core-type (svws-base {logger, csv-Definitionen}) und dem data-Object. (data-object was ist das? woraus besteht das?)
	Der core generiert beim Build-Prozess Datenbanktabellen aus den csv-Dateien und erstellt einen Datenbankschema her (dies wird im wird in der SVWS-Datenbank geladen?)


- baldige Zustand
	Die csv-Definitionen werden nicht mehr im svws-base sein. Hierbei werden die Pa	kete SVWS-base und SVWS-db in einem SVWS-db-Paket vereint.
	(wenn keine csv-Dateien mehr benötigt werden, was wird konkret geändert?)

	

