# Webspace All-Inkl

## Voraussetzung

+ Sie haben einen Webspace bei All-Inkl
+ Sie haben einen FTP-Zugang zum Dateisystem des Webhostings
+ Sie benötigen eine freie Subdomain oder Domain
+ Sie benötigen ein Zertifikat

## Subdomain anlegen

Loggen Sie sich in den Kundenbereich - Technische Verwaltung (KAS) von All-Inkl ein.
Legen Sie unter "Domains" eine Subdomain an.

![Bereich Domain](./graphics/all-inkl01.png "Einrichtung Subdomain.")

Verknüpfen Sie diese Subdomain mit einem SSL-Zertifikat für die sichere Verbindung.

![Bereich SSL Verwaltung](./graphics/all-inkl02.png "Verknüpfung SSL Zertifikat.")

## FTP Verbindung aufbauen, Dateien hochladen und entpacken

Verbinden Sie sich mit Ihrem FTP-Benutzer und laden Sie die ZIP-Datei in das Verzeichnis, das mit der gewünschten Subdomain verknüpft wurde. Entpacken Sie die ZIP-Datei

![FTP Upload](./graphics/all-inkl03.png "Dateien per FTP übertragen und entpacken.")

## Berechtigungen von Ordnern ändern
Setzen Sie die Rechte (auf alle Unterordner und Dateien) auf die Ordner `Public` und `App`:

![Bereich Domain](./graphics/all-inkl04.png "Berechtigungen setzen.")

![Bereich Domain](./graphics/all-inkl09.png "Berechtigungen setzen.")

Setzen Sie die Rechte  (auf alle Unterordner und Dateien) auf den Ordner `db`:

![Bereich Domain](./graphics/all-inkl10.png "Berechtigungen setzen.")

Kontrollieren Sie, ob in den Subdomain-Einstellungen als Ziel der `/public` Ordner eingetragen ist.

![Bereich Domain](./graphics/all-inkl12.png "Subdomain Einstellung")

## Einrichtung

Weiter geht es mit der [Ersteinrichtung](../installation/ersteinrichtung.md) des WebNotenManagers.
