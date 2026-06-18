# Strato-Server

## Voraussetzung

+ Sie haben einen virtuellen Linux-Server bei Strato
+ Sie haben einen FTP-Zugang zum Dateisystem des Webhostings
+ Sie benötigen eine Subdomain
+ Sie benötigen ein Zertifikat

## Subdomain anlegen (optional)

Falls Sie ihren Wenom Server unter einer Subdomain betreiben wollen, wie zum Beispiel wenom.IhreWebseite.de, muss diese noch angelegt weden. Loggen Sie sich dazu in den Kundenbereich - Server-Login bei Strato ein.
Legen Sie unter "Domains" eine Subdomain an.

![Bereich Domain](./graphics/strato_VS_01.png "Einrichtung Subdomain.")


Verknüpfen Sie diese Subdomain mit einem SSL-Zertifikat für die sichere Verbindung.  

![Bereich SSL Verwaltung](./graphics/strato-VS_02.png "Verknüpfung SSL Zertifikat.")


Setzen Sie das Zielverzeichnis.  

![Bereich Plesk-SSL-ZielVZ](./graphics/strato_VS_04.png "Verknüpfung Ziel-SSL.")


## FTP Verbindung aufbauen, Dateien hochladen und entpacken

Verbinden Sie sich mit Ihrem FTP-Benutzer und laden Sie die ZIP-Datei in das Verzeichnis, das mit der gewünschten Subdomain verknüpft wurde. Entpacken Sie die ZIP-Datei

>Bemerkung: Diese Prozesse können auch mit Anwendungen wie z.B. **FileZilla** erledigt werden.

![FTP Upload](./graphics/strato-VS_05.png "Dateien per FTP übertragen und entpacken.")  


## Berechtigungen von Ordnern ändern
Setzen Sie die Rechte (auf alle Unterordner und Dateien) auf die Ordner `Public` und `App`:

![Bereich Domain](./graphics/strato-VS_06.png "Berechtigungen setzen.")


## Einrichtung 

Weiter geht es mit der [Ersteinrichtung](../installation/ersteinrichtung.md) des WebNotenManagers.
