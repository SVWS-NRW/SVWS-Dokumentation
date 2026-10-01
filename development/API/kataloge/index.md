# Kataloge API

Über den Aufruf von `https://MEINSERVER:PORT/types/allinone.json` wird eine Ausgabe im json-Format erzeugt, die alle Katalogdaten enthält.

Sie erhalten unter anderem alle IDs, Kürzel und so weiter. Die Ausgabe erfolgt über alle Schemata, die auf dem Server angelegt sind.

Beispielausgabe, die hier mit dem Abschlüssen beginnt:

````
{"SchulabschlussAllgemeinbildend":{"version":3,"daten":[{"bezeichner":"OA","idStatistik":"1","historie":[{"id":0,"schluessel":"A","kuerzel":"OA","text":"Ohne Abschluss","gueltigVon":null,"gueltigBis":null,"auslaufdauer":0}]},{"bezeichner":"HA9A","idStatistik":"2","historie":[{"id":1000,"kuerzel":"HA9A","text":"Hauptschulabschluss nach Klasse 9 (ohne Berechtigung zum Besuch der Klasse 10 Typ B)","schluessel":"B","gueltigVon":null,"gueltigBis":2021,"auslaufdauer":0},{"id":1001,"schluessel":"B","kuerzel":"ESAA","text":"Erster Schulabschluss (ohne Berechtigung zum Besuch der Klasse 10 Typ B)","gueltigVon":2022,"gueltigBis":null,"auslaufdauer":0}]},{"bezeichner":"HA9","idStatistik":"3","historie":[{"id":2000,"schluessel":"C","kuerzel":"HA9","text":"Hauptschulabschluss nach Klasse 9 (mit Berechtigung zum Besuch der Klasse 10 Typ B)","gueltigVon":null,"gueltigBis":2021,"auslaufdauer":0},{"id":2001, [...]
````

Es folgen alle weiteren Katalogdaten.