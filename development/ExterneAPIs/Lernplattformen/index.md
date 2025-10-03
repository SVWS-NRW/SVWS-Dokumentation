# API-Endpunkt für den Export zu Lernplattformen

Es wurden drei Endpunkte für Anbieter von externen Lernplattformen geschaffen.
Mit dieser API soll ein automatisierter abgleich von Schüler- und lehrkräftedaten ermöglicht werden.

Die Endpunkte können nur im internen Verwaltungsnetz aufgerufen werden und benötigen einen SVWS-User mit entsprechenden Rechten.

## Versionierung

Es wird über die URL eine Versionierung /v(x) geben.
Ältere Versionen werden dann bis zu 12 Monate weiter supportet, damit eine Umstellung auf neuere Versionen stattfinden kann.

## Endpunkte URLs

Zur Verfügung stehen zwei Endpunkte, die die Json-Datei übergeben.

Einmal unkomprimiert:
/api/external/{schema}/v1/lernplattformen/{idLernplattform}/{idSchuljahresabschnitt}

Einmal als gzip:
/api/external/{schema}/v1/lernplattformen/{idLernplattform}/{idSchuljahresabschnitt}/gzip

Ein dritte Enpunkt liefert die Liste alle in Schema vorhandenen Lernplattformen mit ID:
(wird noch nachgereicht 3.10.2025)

## Aufbau des Json

Der Aufbau des übergebenen Jsons kann hier entnommen werden:

https://nightly.svws-devops.de/debug/index.html?urls.primaryName=external

