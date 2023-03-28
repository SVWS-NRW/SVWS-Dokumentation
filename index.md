# SVWS - Server

Das Projekt zur Schaffung einer Schulverwaltungssoftware mit Open:API-Schnittstelle für die dezentrale Schulverwaltung NRW.

![Übersicht-REST](./graphics/700px-Uebersicht-REST-Server-01.png)

In der Übersicht soll einen erster Eindruck vom Aufbau des SVWS-Servers vermitteln.
Im Vordergrund steht die Kapselung von Datenbank, Core-API und GUI.


## Übersicht

Die Schulverwaltungssoftware des Landes NRW wurde im Jahr 2000 erstmalig in Auftrag gegeben.
Mittlerweile ist die Software 20 Jahre alt und es besteht dringender Bedarf an Modernisierung.
Unter den bisherigen Entwicklern besteht der Konsens, dass es extrem schwierig sein wird, eine neue Software 
mit den bestehenden Ressourcen zu entwicklen, die den gleichen Funktionsumfang bietet, wie das jetzige Schild-NRW.

Aus diesem Grund die Idee: Entwicklung eines REST-Servers, der eine offene API-Schnittstelle zur Verfügung stellt.
Schild-NRW 3.0 kann dann weiterhin in einer Übergangsphase auf die Datenbank zugreifen.
Sobald alle Services der REST-Schnittstelle zur Verfügung stehen, wird Schild-NRW 3.X auf diese Webservices umgesetellt 
und vom direkten Datenbankzugriff abgekoppelt. Ebenso können weitere GUIs auf die API des SVWS-Servers zugreifen. 

## Github Quellen

[Github Repository](https://github.com/SVWS-NRW/SVWS-Server)

Unser Projekt ist Open Source!

## weitere Informationen 

### [Hilfe und Handbuch] (https://help.svws-nrw.de/)

### [Projektanforderungen](Projektanforderungen.md)

### [FAQ](FAQ.md)


----
