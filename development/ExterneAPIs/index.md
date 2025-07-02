# API-Endpunkte für externe Anbieter und Tools

## Grundgedanke

Da viele der API-Endpunkte speziell auf den Web-Client zugeschnitten sind und auch während der Entwicklung einem starken Wandel unterzogen sind, kam der Gedanke auf, spezielle API-Endpunkte für externe Prozesse zu schaffen.

Diese sollen einen stabilen und dokumentierten Zustand haben und es Drittanbietern ermöglichen, die API langfristig zu nutzen.

## Umsetzung

Bei der Umsetzung der externen API-Endpunkte standen folgende Überlegungen im Vordergrund:

1. Versionierung der API

In der URL und auch in der Response soll eine Versionierung stattfinden. So können andere Anbieter bei Änderungen in einem zeitlichen Rahmen reagieren.
Solange kann die ätere Version weiterhin genutzt werden.

2. Ein Format für mehrere Anwendungen

Damit die Liste der Endpunkte den Aufwand der Wartung nicht übermäßig belastet, sollen möglichst Anwendungen mit ähnlichen Zielen gebündelt werden.

3. Dokumentation

Die Endpunkte sollen alle für Drittanbieter nachvollziehbar dokumentiert sein.

## Liste der externen APIs

1. [Lernplattformen](https://doku.svws-nrw.de/development/ExterneAPIs/Lernplattformen)
