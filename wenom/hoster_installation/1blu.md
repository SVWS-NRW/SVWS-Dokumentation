# Webspace 1blu

## Voraussetzungen

+ Sie haben einen Webspace bei 1blu.
+ Sie haben einen FTP-Zugang zum Dateisystem des Webhostings.
+ Sie können eine Subdomain anlegen.
+ Sie können ein Zertifikat für die Subdomain erstellen.

## FTP Verbindung aufbauen und Dateien hochladen

Verbinden Sie sich mit Ihrem FTP-Benutzer und erstellen Sie im Verzeichnis "www" ein Unterverzeichnis, z. B. "wenom", in das die WeNoM-Dateien abgelegt werdenb sollen. Laden Sie die Dateien aus der ZIP-Datei in das neu erstellte Verzeichnis Verzeichnis hoch.

![FTP Upload](./graphics/hosteurope01.png "Dateien per FTP übertragen.")

Sie haben nun folgende Verzeichnisse:
- www
  -- wenom
     --- app
     --- db
     --- public
Setzen Sie für die Verzeichnisse "app" und "public" die Rechte auf 755. Beziehen Sie dabei alle Unterverzeichnisse  und Dateien mit ein:

![Bereich Domain](./graphics/hosteurope02.png "Einrichtung Subdomain.")

Setzen Sie für das Verzeichnisse "db" die Rechte auf 770. Beziehen Sie dabei alle Unterverzeichnisse  und Dateien mit ein:

![Bereich Domain](./graphics/hosteurope03.png "Einrichtung Subdomain.")

## Subdomain anlegen und Zertifikat zuweisen

Loggen Sie sich in den Kundenbereich von 1blu ein.
Legen Sie zu Ihrem Produkt unter "Domain" eine Subdomain an.

![Bereich Domain](./graphics/Hosert-Installation_1blu_Subdomain01.png "Einrichtung Subdomain.")

![Bereich Domain](./graphics/Hosert-Installation_1blu_Subdomain02.png "Einrichtung Subdomain.")

Aktivieren Sie für diese Subdomain ein SSL-Zertifikat für die sichere Verbindung.

![Bereich SSL Verwaltung](./graphics/Hosert-Installation_1blu_Zertifikat.png "Verknüpfung SSL Zertifikat.")

## Einrichtung

Weiter geht es mit der [Ersteinrichtung](../installation/ersteinrichtung.md) des WebNotenManagers.
