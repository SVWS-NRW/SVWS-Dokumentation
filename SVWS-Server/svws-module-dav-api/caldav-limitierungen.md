# CalDav Limitierungen

**Fehlende Generierte Kalender**

Für generierte Kalender ist eine Implementierung angedacht, diese ist derzeit nicht umgesetzt. Eine Klasse für generierte Kalender `GenerierteKalenderRepository` gibt derzeit nur leere Listen zurück. Weiterhin müssen den generierten Kalendern IDs gegeben werden, die nicht mit den vorhandenen IDs auf DavRessourcen kollidieren, bspw. `Stundenplan` oder `Prüfungstermine`.

**Fehlendes UI für Kalendererstellung und ACL**

Obgleich das DavRepository die Methoden für das Anlegen von Kalendern sowie das zufügen von ACL-Einträgen am Kalender bereitstellt, fehlt der durchstich zur OpenAPI und ein entsprechendes Protokoll. Soweit bekannt unterstützen die Clients das Anlegen von Remote-Kalendern und das Rechtemanagement nicht. Unser derzeitiger Lösungsweg sieht vor, dass Admins neue Kalender und die Berechtigungen an den Kalendern in der Datenbank selbst pflegen muss - dies sollte keine Dauerlösung sein. Eine kurzfristige Lösung ohne notwendiges UI kann über die Konfiguration des Servers erreicht werden, indem Standardkalender und Lese- und Schreibberechtigte Nutzer(gruppen) dort vordefiniert werden können.

**Zusammenführen von CardDav- und CalDav-API**

Für die CardDav-Api wurde bisher nur der Weg der generierten Adressbücher eingeschlagen, für die CalDav-Api gespiegelt dazu nur der der Weg für beschreibbare und geteilte Kalender. Dadurch entstand einge Codeduplizierung im Rahmen der Dispatcher, welche für beide Implementierungen außerordentlich ähnlich sind (durch die gemeinsame Grundlage des webdav-Protokolls). Für die Implementierung der beschreibbaren Adressbücher und für Wartbarkeit des Codes (Stichwort Code Duplication) wäre eine Zusammenführung der beiden APIs sinnvoll, Grundlagen hierfür sind bei den URI-Parametern und einem Teil der Dispatcher bereits erfolgt, auch der Zugriff auf schreibbare DavRessourcen( und -sammlungen) sowie ACL sind im `DavRepository` bereits so allgemein gehalten, dass sie wiederverwendet werden können. In diesem Rahmen treten auch noch Sonarlint-Meldungen auf.

**Fehlende Konfiguration für Standardwerte**

Es gibt eine Reihe von Standardwerten, die in der SWVS-Konfiguration hinterlegt werden sollten. Dies ist bisher nicht umgesetzt, auch die Clients fragen diese Werte nicht an. 

## Tests

**Tests von Zeitzonen**

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
