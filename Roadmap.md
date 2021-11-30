# Roadmap

## Mai 2020 

+ Erstellung einer Schild-NRW-3.0-Version, die stabil mit den neuen DB-Scripten arbeitet
+ Fehlerbeseitigung
+ Ergänzung der letzten Änderungen aus Schild-NRW-2.0
+ Reporting Update und Tests
+ Programmierung eines REST-Clients in der Delphi-Umgebung, damit der Server angesprochen werden kann.

## Juni 2020
+ Erstellung eines Installers
	+ Artefakte werden in ein Reporsitory hochgeladen
	+ Artefakte sind versioniert
	+ Erstellung von Installer-Scripten (Gradle?)
+ Auswahl der Installer-Pakete
	+ DBMS-Installation mit Migration
	+ Einzelplatz-Installation
	+ Server-Installation
+ Einbettung des REST-Servers als Dienst
+ Nutzung des Migration-Tools durch den Delphi-REST-Client
+ Nutzung der Update-Funktionalität durch den Delphi-REST-Client

## August 2020
+ Bereitstellung der BETA-Version
+ Fertigstellung der Datenbankdokumantation

## November 2020
+ Einbindung erster Fachberater in den ALPHA-Test
+ Erstellung eine Konzeptes für die Reporting aus dem SVWS-Client

## Dezember 2020
+ Aufbau eine eigenen UI-Frameworks für SVWS mit VUE.js und Tailwind
+ Erstellung eine Usablity-Konzept
+ Vorgabe eines Styleguides
+ Gestaltung des SVWS-Client als Demo-APP
+ Beginn der Arbeiten an den Lupo-Legacy-Dateien (Import/Export in die SVWS-DB)

##Januar 2021
+ Entwicklung weiterer Anforderungen für das UI-Framework.
+ Erarbeitung der weiteren benötigten Services für die Webanwendungen.
+ Erarbeitung der Projektanforderung zur Beauftragung von WebENM.
+ Klärung aller Lizenfragen. Freischaltung der OpenSource-Repositories.

## Februar 2021
+ Erstellung eines Konzepts zur Funktion des Filter I
+ wie werden Filterdefinitionen an den SVWS-Server durchgereicht?
+ kann das mit bestehender Technik umgesetzt werden?
+ Vereinbarung der Rückgabewerte

## März 2021
+ Umstellung von Lupo auf Json-basierte Dateien.
+ Fertigstellung der Json-basierenden Schnittstelle für die ENM-Module.
+ Erweiterung der Demo-Webapplikation. (Fertigstellung der Lehrer und Schülerkarteireiter)
+ Implementierung des OpenSource-Blockungsalgorithmus in den SVWS-Server (Umschreiben von Lazarus nach Java).

## Mai 2021
+ Entwicklung einer Maske für einen Admin-Client, der die Schema-Services zu rVerfügung stellt.
+ Maske "Schule Einrichten" in der Webapplikation realisieren.
+ Beginn der Entwicklung von WebLupo oder dem WebNotenmodul.

## August 2021
+ Erweiterung der Arbeitsgruppe 
+ Umstellung auf Gitlab

## Zukunft
+ Entwicklung einer Schnittstelle SVWS-NRW
+ Schnittestelle auf Json-Basis für automatisierte Prozesse
+ Umwandlung JsonToCSV für manuelle Importe/Export
+ Auswahl einer PDF-Bibliothek die für Standardreports geeignet ist:
	+ https://carbone.io/
	+ https://tdf.github.io/odftoolkit/docs/odfdom/index.html
+ Erstellung einer REST-Reporting mit dem RBuilder