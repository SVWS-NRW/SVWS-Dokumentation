# SVWS - Server Dokumentation


(Platzhalter Logo) 

Projekt zur Erstellung einer Schulverwaltungssoftware mit Open:API-Schnittstelle für die dezentrale Schulverwaltung in NRW.  

## Übersicht

In dieser Dokumentation können Sie sich über den technischen Aufbau des SVWS-Servers,
die Einrichtung einer Entwicklungsumgebung und den verschiedenen Deplomentszenarien informieren.

In der folgenden Übersicht soll ein erster Eindruck vom Aufbau des SVWS-Servers vermittelt werden.
Im Vordergrund steht die Kapselung von Datenbank und Core-API.

![Übersicht-REST](./graphics/Uebersicht_SVWS-Server.png)

Externe Services können über die REST-Schnittstelle nach erfolgreicher Anmeldung Daten vom SVWS-Server erhalten. 
Ebenso greift die GUI auf die Daten zu und präsentiert diese dem jeweiligen Benutzer. 
Dieser Webclient wird mit dem SVWS-Server zusammen ausgeliefert und steht mit Installation des Servers zur Verfügung. 

## Übergang von Schild 2.0 zum SVWS-Server

Die Schulverwaltungssoftware SchiLD-NRW des Landes NRW wurde im Jahr 2000 erstmalig in Auftrag gegeben.
Mittlerweile ist die Software 20 Jahre alt und es besteht dringender Bedarf an Modernisierung.
Unter den bisherigen Entwicklern besteht der Konsens, dass es extrem schwierig sein wird, eine neue Software 
mit den bestehenden Ressourcen zu entwicklen, die den gleichen Funktionsumfang bietet, wie das jetzige Schild-NRW.

Aus diesem Grund entschied man sich zur Entwicklung eines REST-Servers, der eine offene API-Schnittstelle zur Verfügung stellt.
Schild-NRW 3.0 kann dann weiterhin in einer Übergangsphase auf die Datenbank zugreifen.
Sobald alle Services der REST-Schnittstelle zur Verfügung stehen, wird Schild-NRW 3.X auf diese Webservices umgesetellt 
und vom direkten Datenbankzugriff abgekoppelt. Ebenso können weitere GUIs auf die API des SVWS-Servers zugreifen. 
Mit dem update zu Schild 3.0 wird im technischen Backend die Grundlage für diese Modernisierung geschaffen. 

## Hilfe und Handbuch 

Hier finden Sie eine Übersicht über die Funktionen des SVWS-Servers und Hilfen für den Anwender: [help.swvs-nrw.de](https://help.svws-nrw.de/)

## Github Quellen

Unser Projekt ist Open Source!  

Hier finden Sie unser Software Repository: [Github Repository](https://github.com/SVWS-NRW/SVWS-Server)

Sie können unseren Quellcode und Testdatenbanken unter dem o.g. Repository bzw. unter [Github - Schulverwaltung NRW](https://github.com/SVWS-NRW) finden.

Wenn Sie an einer Mitarbeit am Projekt interessiert sind, so finden Sie in dieser Dokumentation unter Entwicklungsumgebungen weitere Informationen zu den benötigten Voraussetzungen.

Per Github kann die Kontaktaufnahme zu unserem Entwicklerteam erfolgen. Ebenso sollen hier perspektivisch Issues aus der Open Source Gemeinschaft gesammelt werden. 


## [Projektanforderungen](Projektanforderungen.md)

## [FAQ](FAQ/index.md)

## [Impressum](https://www.schulministerium.nrw/impressum-haftungsausschluss-datenschutzbestimmungen)
