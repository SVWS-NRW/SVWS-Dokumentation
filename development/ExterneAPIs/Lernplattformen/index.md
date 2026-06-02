# API-Endpunkt für den Export zu Lernplattformen

Es wurden vier Endpunkte für Anbieter von externen Lernplattformen geschaffen.
Mit dieser API soll ein automatisierter Abgleich von Schüler- und Lehrkräftedaten ermöglicht werden.

Die Endpunkte können nur im internen Verwaltungsnetz aufgerufen werden und benötigen einen SVWS-User mit entsprechenden Rechten.

## Versionierung

Es wird über die URL eine Versionierung /v(x) geben.
Ältere Versionen werden dann bis zu 12 Monate weiter supportet, damit eine Umstellung auf neuere Versionen stattfinden kann.

## Endpunkte URLs

Zur Verfügung stehen vier Endpunkte.

Ein Datenexport unkomprimiert:
/api/external/{schema}/v1/lernplattformen/{idLernplattform}/{idSchuljahresabschnitt}

Ein Datenexport als gzip:
/api/external/{schema}/v1/lernplattformen/{idLernplattform}/{idSchuljahresabschnitt}/gzip

Eine Übersicht aller im Schema vorhandenen Lernplattformen mit ID:
/api/external/{schema}/v1/lernplattformen

Eine Übersicht aller verfügbaren Schuljahresabschnitte:
/api/external/{schema}/v1/schuljahresabschnitte

## Aufbau des Json

Der Aufbau des übergebenen Jsons kann hier entnommen werden:

https://nightly.svws-devops.de/debug/index.html?urls.primaryName=external

