# Administration

Der SVWS-Server kann sehr flexibel konfiguriert werden.
Dies soll dazu führen, dass der Server sich an die vielen verschiedenen Systemumgebungen anpassen und je nach Bedarf Skaliert werden kann.

## Administration in der eigenen Schule

Der SVWS-Server kann auch weiterhin an der eigenen Schule auf einem Windows- oder Linux-Server betrieben werden.

Weitere Hinweise zur Installation befinden sich hier: 
https://doku.svws-nrw.de/deployment/

Es können auch verschiedene Datenbanken für eine Schule eingerichtet werden, z.B. für den Produktivbetrieb, einen Testbetrieb und z.B. Schulungsbetrieb.

Um die Verwaltung der verschiedenen Systeme zu unterstützen, liefert der SVWS-Server einen Admin-Client aus.

## Administration an zentraler Stelle

Der SVWS-Server kann auch an zentraler Stelle betrieben werden und mehrere Schule auf einem Server zur Verfügung stellen. Dazu bekommt jede Schule ein eigenes Schema, das auch einen eigenen Datenbankbenutzer bekommt. Dadurch wird schon auf Datenbankebene ausgeschlossen, dass Schulen versehentlich auf fremde Daten zugreifen können.

Die Verwaltung der verschiednen Schemata kann auch hier mit dem Admin-Client geschehen.
Allerdings stehen den Schulträgern hier auch API-Endpunkte zur Verfügung, die die Schema-Veraltung über eine priviligierte API ermöglichen.

https://doku.svws-nrw.de/deployment/IT-Umgebungen/
