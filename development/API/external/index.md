# Externe API

## Endpunkte für externe Anbieter und Werkzeuge

Ein Großteil der vorhandenen API-Endpunkte ist speziell auf den SVWS-Webclient ausgerichtet. Da sich diese Endpunkte im Rahmen der Weiterentwicklung ändern können, sind sie nur eingeschränkt für eine langfristige Nutzung durch externe Anwendungen geeignet.

Aus diesem Grund werden separate API-Endpunkte für externe Prozesse und Drittanbieter bereitgestellt. Diese APIs sollen stabil, versioniert und umfassend dokumentiert sein, sodass sie auch über längere Zeiträume zuverlässig genutzt werden können.

## Konzeption

Bei der Umsetzung der externen APIs wurden folgende Ziele verfolgt:

### 1. Versionierung der API

Die API wird sowohl in der URL als auch in den Antworten versioniert. Dadurch können Änderungen an einer neuen Version eingeführt werden, ohne bestehende Integrationen unmittelbar zu beeinträchtigen.

Drittanbieter erhalten dadurch ausreichend Zeit, ihre Anwendungen auf eine neue API-Version umzustellen, während die bisherige Version für einen Übergangszeitraum weiterhin unterstützt wird.

### 2. Einheitliche APIs für mehrere Anwendungsfälle

Um den Wartungsaufwand gering zu halten, sollen die Endpunkte nicht für einzelne Anwendungen entwickelt werden. Stattdessen werden ähnliche Anwendungsfälle in gemeinsamen APIs zusammengefasst. Dadurch können mehrere Anwendungen dieselben Endpunkte nutzen.

### 3. Vollständige Dokumentation

Alle externen APIs werden vollständig dokumentiert. Die Dokumentation beschreibt die verfügbaren Endpunkte, die benötigten Parameter, die Rückgabewerte sowie mögliche Fehlerfälle, sodass Drittanbieter die Schnittstellen ohne Kenntnis der internen Implementierung verwenden können.

## Verfügbare externe APIs

Derzeit stehen folgende externe APIs zur Verfügung:

+ [API Lernplattformen](./lernplattformen.md)
+ [API Externe Notenmanager](./notenmanager.md)
