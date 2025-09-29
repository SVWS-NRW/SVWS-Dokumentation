# Roadmap

Letzte Aktualisierung: 2025-09-10

## 2024 - Start Betaphase

Start in die öffentliche Betaphase für SchILD-NRW-3 und den SVWS-Server.
Am 13. Oktober 2024 werden die Installationspakete auf GitHub zur Verfügung gestellt.

Dabei soll SchILD-NRW-3 den Funktionsumfang von SchILD-NRW-2 ablösen und in Zusammenspiel mit dem SVWS-Web-Client die Möglichkeit bieten die gymnasiale Oberstufe an Gymnasien und Gesamtschulen in NRW ermöglichen.

Der **Web-Client** dient zu dieser Zeit ausschließlich als Ersatz für die Programme *Kurs42* und *LuPO*!

An der Integration weiterer Funktionalitäten im Web-Client wird gearbeitet.

## 2025 März - Aufbau von Teststellungen

Der Aufbau von Teststellungen kann flächendeckend beginnen. Schulen und deren IT-Dienstleister können SchILD-NRW-3 mit dem SVWS-Server installieren und erproben.

Eine doppelte Pflege der Daten sollte aber unter allen Umständen vermieden werden.

Zum Zeitpunkt der Umstellung auf den Produktivbetrieb kann die SchILD-NRW-2 Datenbank nochmals neu migriert werden und der Betrieb von SchILD-NRW-3 kann beginnen.

## 2025 August - Erstellen eines ausreichenden Stable-Mode

Der SVWS-Client soll alle benötigten Tabs und Kataloge im Stable-Mode erhalten, sodass erste produktive Arbeiten auch außerhalb der gymnasialen Oberstufe stattfinden können.

Dabei ist es wichtig, dass die schulformspezifischen Bedingungen eingearbeitet werden und die eingeblendeten Kataloge in das Testkonzept einbezogen sind.

## 2025 Oktober - SVWS-Server und SchILD-NRW 3 - Start in den Produktivbetrieb

Ende der öffentlichen Betaphase und Start in den produktiven Betrieb.
Alle Schulen, deren Tests erfolgreich waren, haben nun die Möglichkeit, SchILD-NRW-3 produktiv zu nutzen.

Dabei ist ein Umstieg nach Abgabe der Statistik 2025/26 ratsam.
Ein Umstieg zu diesem Zeitpunkt ist nicht verpflichtend. Die Planung hierzu kann individuell erfolgen.

Externe Module (Notenmodul WeNoM, Prognos und Konferenzmodul) werden zeitnah auch für SchILD-NRW-3 zur Verfügung stehen.

## 2025 November - Erstellung der Architekturdokumenation für den SVWS-Server

Die Architekturdokumenation für den Betrieb des SVWS-Servers soll auf Basis des Arch42-Standards erfolgen.

Hier soll eine mitwachsende Dokumentation entstehen, die es den Betreibern und Entwicklern erleichtern soll, Systementscheidungen zu treffen.

## 2025 Dezember - Start Beta-Phase WebNotenManager (WeNoM)

Der externe WebNotenManager zur Einholung der Noten über ein webbasiertes System wird als Beta-Version allen Schulen zur Verfügung gestellt.
Dabei wird der WebNotenmanager den Schulen über das Open-Source Repository zur Verfügung gestellt.

Die Software kann auf einem Webspace bei einem Dienstleister mit entsprechendem AVV oder auch bei der jeweiligen Schulträger-IT betrieben werden.

## 2025 Dezember - Durchführung eines Security-Audit für SVWS-Server und WebNotenManager

Durchführung einer intensiven Sicherheitsüberprüfung für das Zusammenspiel von SVWS-Server und WebNotenManager.

Insbesondere die Passwortverwaltung, die Synchronisationsprozesse und die Datenschutzanalyse sollen hier geprüft werden.

## 2026 Februar - Erster Feldtest Schulbewerbungen

Es soll ein erster abgegrenzter Feldtest mit ausgesuchten Schulen stattfinden, die den digitalen Schülerwechsel mit dem SVWS-Server und schulbewerbung.de durchführen.

## 2026  - Ausbau des Web-Clients für Grundschulen

Ausbau des Web-Clients für weitere Schulformen. Zunächst sollen Grundschulen alle Funktionalitäten bekommen, die einen Betrieb des Web-Clients im Alltag ermöglichen.

Hier wird es notwendig sein, dass Gruppenprozesse und Filterfunktionen wie gewohnt im SVWS-Client zur Verfügung stehen.

## 2026 - Implementierung der Abschlussberechnungen

Die Abschlussberechnungen aller Schulformen inkl. Berufskolleg sollen vorangetrieben werden.

Diese Abschlussberechnungen sollen dann auch für SchILD-NRW 3 über die API zur Verfügung stehen.

## 2026 Schrittweise Umstellung auf API

SchILD-NRW 3 soll schrittweise auf die API des SVWS-Servers umgestellt werden, so dass direkte Datenbankzugriffe nicht mehr oder nur noch lesend notwendig sind.

## 2027 - Ablösung ASDPC32

Geplante Ablösung des Programms ASDPC32 als Statistikprogramm durch den SVWS-Web-Client.

## 2028 - Digitale Zeugnisausfertigung

Die Arbeiten zur digitalen Zeugnisausfertigung sollen im SVWS-Server umgesetzt werden.