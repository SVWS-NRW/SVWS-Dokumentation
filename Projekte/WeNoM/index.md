# WeNoM - der Web-Notenmanager

Der Web-Notenmanager ist eine Möglichkeit über den Austausch mit dem SVWS-Server 
die Noteneingabe dezentral zu gestalten. 
Das Bedienkonzept und Design ist hierbei identisch zu dem im SVWS-Client benutzen 
Baustein des [Notenmanagers](../../SVWS-Server/svws-webclient/Notenmanager.md).

Im Folgenden wird nur auf spezielle Abweichungen im Umgang zum normalen Notenmodul eingegangen.

Diese Abschnitte befindet sich in Entwicklung.

## Installation auf dem Webspace

Todo: 
	- upload der PHP Skripte
	- Einrichtung der Datenbank
	- Einrichtung der Verschlüsselung 

## Einrichtung der Verbindung im SVWS-Server bzw. in Schild_3.0

Todo: 
	- Datenbankeinträge erzeugen - nötige Daten für WeNoM ablegen 
	- Verschlüsselung zu WeNoM einrichten

## Sycncronisation der Daten

	
### Upload zu WeNoM

Todo: 
	- Funktionsweise des Webservice
		- Authorisierung
		- Beschreibung des Json-Objekts
	- upload der Daten per Webservice 	
	- Konflikt in der Datenstruktur 
		- Lehrerwechsel
		- Noten überschreiben
	- Fehlermanagement

### Download zum SVWS-Server
	
Todo: 
	- Funktionsweise des Webservice
		- Authorisierung
		- Beschreibung des Json-Objekts
	- download der Daten per Webservice 	
	- Konflikt in der Datenstruktur 
		- Lehrerwechsel
		- Noten überschreiben
		- Datensatz nicht mehr vorhanden
	- Fehlermanagemaent