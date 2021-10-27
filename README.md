![Open-api-logo-klein.png](uploads/Open-api-logo-klein.png)

Das Projekt zur Schaffung einer Open:API-Schnittstelle f�r die Schulverwaltung NRW.


# �bersicht

**Das Projekt:** 
Die Schulverwaltungssoftware des Landes NRW wurde im Jahr 2000 erstmalig in Auftrag gegeben.
Mittlerweile ist die Software 20 Jahre alt und es besteht dringender Bedarf an Modernisierung.
Unter den bisherigen Entwicklern besteht der Konsens, dass es extrem schwierig sein wird, eine neue Software mit den bestehenden Ressourcen zu entwicklen, die den gleichen Funktionsumfang bietet, wie das jetzige Schild-NRW.

Aus diesem Grund die Idee: Entwicklung eines REST-Servers, der eine offene API-Schnittstelle zur Verf�gung stellt.
Schild-NRW kann dann weiterhin in einer �bergangsphase auf die Datenbank zugreifen.
Sobald aber alle Services der REST-Schnittstelle zur Verf�gung stehen, kann Schild-NRW dann nach und nur noch als GUI dienen.



![700px-�bersicht-REST-Server-01.png](uploads/700px-�bersicht-REST-Server-01.png)



In der �bersicht soll einen erster Eindruck vom zuk�nftigen Aufbau vermitteln.
Im Vordergrund steht die Kapselung von Datenbank, Core-API und GUI.


[Projektanforderungen](/Projektanforderungen)


----
