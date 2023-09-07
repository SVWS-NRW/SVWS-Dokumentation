# svws-openapi

Die Klasse "OpenAPIApplication" ist eine Java-Klasse, die als Grundlage für einen OpenAPI-Server dient und die Initialisierung der OpenAPI-Schnittstelle auf Basis der zugeordneten OpenAPI-Klassen übernimmt. 
Die Klasse erbt von der abstrakten Klasse "Application" aus dem "jakarta.ws.rs"-Paket und verwendet die Annotation "@ApplicationPath" zur Definition des Wurzelpfads der Anwendung ("/").

Die Klasse definiert eine private Instanzvariable "classes", die eine Menge von Klassen enthält, die für die OpenAPI-Schnittstelle eingebunden werden sollen. 
Die Klasse definiert auch eine statische Methode "getBasicOpenAPI", die eine OpenAPI-Spezifikation ohne die Definition der Schnittstellen-Klassen erstellt und zurückgibt.

Die Methode "getBasicOpenAPI" initialisiert eine OpenAPI-Spezifikation mit Informationen wie Titel, Version, Beschreibung, Kontaktinformationen und Lizenz. 
Die Methode fügt auch Sicherheitsschemas und -anforderungen hinzu und definiert Server-URLs für die OpenAPI-Spezifikation.
