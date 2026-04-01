# Strato-Server (Linux, virtuell)

## Voraussetzung

+ Sie haben einen virtuellen Linux-Server bei Strato

+ Sie haben einen FTP-Zugang zum Dateisystem des Webhostings

+ Sie benötigen eine Subdomain

+ Sie benötigen ein Zertifikat

## Subdomain anlegen

Loggen Sie sich in den Kundenbrereich - Server-Login bei Strato ein.
Legen Sie unter "Domains" eine Subdomain an.

![Bereich Domain](./graphics/strato_VS_01.png "Einrichtung Subdomain.")

![Bereich SSL Verwaltung](./graphics/strato_VS_02.png "Verknüpfung SSL Zertifikat.")

Wechseln Sie in das Dashbord Plesk von Strato zur Adminstrierung des virtuellen Servers.

![Bereich Plesk](./graphics/strato_VS_03.png "Verknüpfung DNS-Hostung.")

Verknüpfen Sie diese Subdomain mit einem SSL-Zertifikat für die sichere Verbindung.  

Setzen Sie das Zielverzeichnis.  

![Bereich Plesk-SSL-ZielVZ](./graphics/strato_VS_04.png "Verknüpfung Ziel-SSL.")


## FTP Verbindung aufbauen, Dateien hochladen und entpacken

Verbinden Sie sich mit Ihrem FTP-User und laden Sie die ZIP-Datei in das Verzeichnis, das mit der gewünschten Subdomain verknüpft wurde. Entpacken Sie die ZIP-Datei

>Bemerkung: Diese Prozesse können auch mit Anwenungen wie z.B. **FileZilla** erledigt werden.

![FTP Upload](./graphics/strato-VS_05.png "Dateien per FTP übertragen und entpacken.")  



## Berchtigungen von Ordnern ändern
Setzen Sie die Rechte (auf alle Unterordner und Dateien) auf die Ordner Public und App:

![Bereich Domain](./graphics/strato-VS_06.png "Berechtigungen setzen.")


