# Webspace Hosteurope

## Voraussetzung

+ Sie haben einen Webspace bei Hosteurope
+ Sie haben einen FTP-Zugang zum Dateisystem des Webhostings
+ Sie benötigen eine Subdomain
+ Sie benötigen ein Zertifikat

## Subdomain anlegen

Loggen Sie sich in den Kundenbrereich (KIS) von Hosteurope ein.
Legen Sie unter "Domains" eine Subdomain an.

![Bereich Domain](./graphics/hosteurope04.png "Einrichtung Subdomain.")

Verknüpfen Sie diese Subdomain mit einem SSL-Zertifikat für die sichere Verbindung.

![Bereich SSL Verwaltung](./graphics/hosteurope05.png "Verknüpfung SSL Zertifikat.")

## FTP Verbindung aufbauen und Dateien hochladen

Verbinden Sie sich mit Ihrem FTP-User und laden Sie die Dateien aus dem ZIP in das Verzeichnis, das mit der gewünschten Subdomain verknüpft wurde.

![FTP Upload](./graphics/hosteurope01.png "Dateien per FTP übertragen.")

Setzen Sie die Rechte (auf alle Unterordner und Dateien) auf die Ordner Public und App:

![Bereich Domain](./graphics/hosteurope02.png "Einrichtung Subdomain.")

Setzen Sie die Rechte  (auf alle Unterordner und Dateien) auf den Ordner db:

![Bereich Domain](./graphics/hosteurope03.png "Einrichtung Subdomain.")
