# Administration

Der SVWS-Server kann sehr flexibel konfiguriert werden. Dies soll dazu führen, dass der Server sich an die vielen verschiedenen Systemumgebungen anpassen und je nach Bedarf Skaliert werden kann.

## Administration in der eigenen Schule

Der SVWS-Server kann auch weiterhin an der eigenen Schule auf einem Windows- oder Linux-Server betrieben werden.

Weitere Hinweise zur Installation befinden sich im Bereich *Administration/Entwicklung* ➜ **SVWS-Installation**.  

Es können auch verschiedene Datenbanken für eine Schule eingerichtet werden, zum Beispiel für den Produktivbetrieb, einen Testbetrieb und Schulungsbetrieb.

Um die Verwaltung der verschiedenen Systeme zu unterstützen, liefert der SVWS-Server einen Admin-Client aus.

## Administration an zentraler Stelle

Der SVWS-Server kann auch an zentraler Stelle betrieben werden und mehrere Schulen auf einem MariaDB-Server zur Verfügung stellen.

Dazu bekommt jede Schule ein eigenes Schema, das auch einen eigenen Schema-Datenbankbenutzer bekommt. Dadurch wird schon auf der Ebene der Schemata, der "Datenbanken" ausgeschlossen, dass Schulen auf Daten fremder Schulen zugreifen können.

Die Verwaltung der verschiedenen Schemata kann auch mit dem Admin-Client geschehen. Ebenso stehen den Schulträgern hierzu auch API-Endpunkte zur Verfügung, die die Schema-Verwaltung über eine priviligierte API ermöglichen.

Hierzu findet sich mehr unter https://doku.svws-nrw.de/deployment/, konkret wird dies https://doku.svws-nrw.de/deployment/IT-Umgebungen/ ausgeführt.
