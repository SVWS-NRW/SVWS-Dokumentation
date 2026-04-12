# Datenschutz und Datensicherheit

Dieses Kapitel beschreibt die wichtigsten Datenschutz- und Sicherheitsaspekte der SVWS-Konferenzübersicht.

## Grundsatz: Alles bleibt im Browser

Die Anwendung ist so konzipiert, dass alle sensiblen Informationen ausschließlich lokal im Browser verarbeitet werden. Es werden keine Konferenzdaten, keine Schülerdaten und keine Noten an einen externen Server oder einen Drittanbieter gesendet.

- Bei einer Dateiauswahl (`enm.json.gz`) verbleiben die Daten in der Browsersitzung.
- Bei einem Online-Abruf vom SVWS-Server wird die Datei nur zum Browser übertragen und dort entschlüsselt, entpackt und dargestellt.
- Es existiert kein zentraler Server, der Daten speichert oder weiterleitet.

## Offline-Modus: Sichere Nutzung ohne Netzwerk

Der Offline-Modus ist ausdrücklich für sichere Situationen ohne Netzwerkverbindung vorgesehen. Sie laden die `enm.json.gz`-Datei aus einer vertrauenswürdigen Quelle und nutzen die App direkt im Browser.

- Es ist kein Netzwerkzugang erforderlich.
- Es findet kein Datenexfiltrieren oder Synchronisieren statt.
- Die Anwendung funktioniert auch dann, wenn das Gerät vollständig offline ist.

## Sicherheit der lokalen Verarbeitung

Die Daten werden nur im Arbeitsspeicher des Browsers gehalten. Wenn der Browser geschlossen oder die Seite neu geladen wird, endet die Bearbeitungssitzung und die geladenen Daten werden verworfen.

Empfehlungen:

- Schließen Sie die Seite, wenn die Konferenzarbeit beendet ist.
- Nutzen Sie einen vertrauenswürdigen Arbeitsplatzrechner, der nicht von unbefugten Personen verwendet wird.
- Speichern Sie eine lokal geladene `enm.json.gz`-Datei nur an einem sicheren Ort.

## Online-Abruf vom SVWS-Server

Wenn Sie die Anwendung mit Online-Abruf nutzen, gelten folgende Prinzipien:

- Die App fordert nur die Daten direkt vom SVWS-Server an.
- Die übertragenen Daten bleiben im Browser und werden nicht an einen dritten Server weitergereicht.
- Zugangsdaten werden nur für den Abruf benötigt und nicht dauerhaft außerhalb der Browser-Sitzung gespeichert.

Für den Online-Abruf sollten Sie prüfen, dass die Verbindung zum SVWS-Server im Schulnetz sicher ist und vertrauenswürdige Zertifikate verwendet werden.

## Organisatorische Hinweise

Auch wenn die Anwendung selbst keine Daten nach außen sendet, sollten organisatorische Maßnahmen getroffen werden:

- Beschränken Sie den Zugriff auf den Arbeitsplatzrechner auf berechtigte Personen.
- Vermeiden Sie das Speichern sensitiver Exportdateien auf unsicheren oder öffentlichen Laufwerken.
- Nutzen Sie nach Möglichkeit separate Arbeitsplätze für die Auswertung, die nicht frei zugänglich sind.

## Architekturentscheidung

Die Architekturentscheidung bestätigt diesen Ansatz: die Verarbeitung erfolgt vollständig clientseitig, ohne persistenten Datenspeicher und ohne Übertragung an Drittserver.
