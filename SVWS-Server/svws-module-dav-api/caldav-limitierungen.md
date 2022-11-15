# CalDav Limitierungen

** Fehlende Generierte Kalender **
Für generierte Kalender ist eine Implementierung angedacht, diese ist derzeit nicht umgesetzt. Eine Klasse für generierte Kalender `GenerierteKalenderRepository` gibt derzeit nur leere Listen zurück. Weiterhin müssen den generierten Kalendern IDs gegeben werden, die nicht mit den vorhandenen IDs auf DavRessourcen kollidieren, bspw. `Stundenplan` oder `Prüfungstermine`.

** Zusammenführen von CardDav- und CalDav-API **
Für die CardDav-Api wurde bisher nur der Weg der generierten Adressbücher eingeschlagen, für die CalDav-Api gespiegelt dazu nur der der Weg für beschreibbare und geteilte Kalender. Dadurch entstand einge Codeduplizierung im Rahmen der Dispatcher, welche für beide Implementierungen außerordentlich ähnlich sind (durch die gemeinsame Grundlage des webdav-Protokolls). Für die Implementierung der beschreibbaren Adressbücher und für Wartbarkeit des Codes (Stichwort Code Duplication) wäre eine Zusammenführung der beiden APIs sinnvoll, Grundlagen hierfür sind bei den URI-Parametern und einem Teil der Dispatcher bereits erfolgt, auch der Zugriff auf schreibbare DavRessourcen( und -sammlungen) sowie ACL sind im `DavRepository` bereits so allgemein gehalten, dass sie wiederverwendet werden können. In diesem Rahmen treten auch noch Sonarlint-Meldungen auf.

## Serialisierung

** Unvollständige Serialisierung von Kalenderdaten zum vCalendar-Format **
Für die vorhandenen Kalenderdaten genügt ein rudimentärer Parser des VCalendar-Formats, welcher das Minimale und Maximale Datum eines Eintrags für von Clients verwendete Zeitfilter aus den VCalendar-Rohdaten parst. Die Serialisierung ist in Ansätzen implementiert, sollte aber für die generierten Kalender noch vervollständigt werden.

** Fehlende Unterstützung für wiederkehrende Termine **
Wiederkehrende Termine (bspw. wöchentliche, monatliche Termine) werden im VCalendar-Format als Recurrence-Rules (RRULE) abgebildet. Für die derzeit vorhandenen beschreibbaren Kalender ist es kein direktes Hindernis, dass diese weder geparst, noch serialisiert werden können. Dies wird erst in Kombination mit (von Outlook verwendeten) Filtern hinderlich, wenn ein wiederkehrender Termin außerhalb des gefilterten Zeitfensters gestartet ist, aber durch die wiederkehr in das Zeitfenster fällt - diese Termine werden nicht für das Zeitfenster erfasst. Außerdem ist für generierte Kalender (mit Stundenplänen oder regelmäßigen Terminen allgemein) eine Modellierung und Serialisierung der RRULES außerordentlich sinnvoll.

## Tests

** Tests von Zeitzonen **
Mit manuellen Tests wurde bisher ausschließlich in der Standardzeitzone getestet, so dass Server und Client in Europe/Berlin waren. Dieser Happy-Path sollte auch der Regelfall für die Anwendung sein, von Abweichungen muss aber ausgegangen werden. Da an mehreren Stellen zwischen ISO, SQL und Java Zeitpunkten ineinander konvertiert werden muss und hier auch die Zeitzone eine Rolle spielt, möchte ich eine Fehleranfälligkeit ohne weitere Tests nicht ausschließen.

**Testautomatisierung: Automatische API-Tests in CI integrieren**

API-Tests wurden im Rahmen der Entwicklung als Insomnia-Collections
angelegt. So konnte schnell geprüft werden, welche Payloads und Header
in den unterschiedlichen Requests vom Server geliefert werden. Die
Requests sind also als wiederholbare Scripts angelegt. Eine weitere
Verbesserung wäre, diese Requests in die CI-Pipeline mit aufzunehmen.
Die Erfahrung hat gezeigt, dass geringfügige Änderungen am DAV-API je
nach DAV-Client schnell zu Inkompatibilitäten führen können (zB
bestimmter Header fehlt). Um das Fehlerrisiko zu mindern, wäre eine
kontinuierliche Prüfung des APIs mit automatisierten API-Tests sinnvoll.
Eine Alternative wäre diese Tests als Unit-Tests abzubilden, um zB
etwaige Abhängigkeiten zu Testdatenzu vermeiden.
