# WeNoM - Installationsanleitung

## Schnellübersicht 

### [Technischer Teil](#technische-einrichtung)

1. Optional: Richten Sie eine Unterdomain für Ihre Webadresse ein. "noten.meineSchule.de" oder "wenom.meineSchule.de" sein.

2. Kopieren Sie die [WeNoM Programmdateien](#kopieren-der-wenom-pakete) auf das Verzeichnis des Webserver.

3. Geben Sie dem Webserver auf das Verzeichnis /db Schreibrechte und reduzieren Sie ggf. die Schreib- und Leserechte auf das nötigste.

### [Ersteinrichtung](./ersteinrichtung.md)

4. Konfigurieren Sie die Verbindung zwischen diesem WeNoM-Server mit ihrem SVWS-Server. Hierzu wird ein *Secret* generiert.

### [Schulfachlicher Teil](../benutzerhandbuch/schulische_administration.md)

5. Synrchonisieren Sie die Daten SVWS-Servers mit dem WeNoM-Server. Dies ist der Schritt, bei dem die konkreten Daten der Schule übertragen werden: 
Alle Benutzerlogins, Fehlstundeneinstellungen, Lerngruppen, Fächer, Leistungsdaten, etc.

6. Fachlehrkräfte erhalten ihre Zugänge und können ihre die Leistungsdaten, Fehlstunden, etc. eintragen. 


Die Schritte 1 bis 4 sind Teil der Erstinstallation und kann auch durch einen IT-Dienstleister erfolgen. Die Schritte 5 bis 6 werden in Turnus der Schuljahre immer wieder durchlaufen und durch schulfachliche Administration der Schule begleitet. Dies können die Schulleitung, Koordinatoren, eine Schulverwaltungskraft oder anderweitig von der Schulleitung Beauftragte sein.

## Technische Einrichtung

### Voraussetzungen

Es wir ein Webspace mit php8.2 oder höher und sqlite3 Modul benötigt und für den Webspace muss über ein Zertifikat eingerichtet sein. 
Dies alles liegt in der Regel bei den gängigen [Webhostern](../hoster_installation/index.md) fertig eingerichtet vor.

Alternativ können Sie die Einrichtung des Webservers unter der Artikel "[eigener  Webserver](./installation_webserver.md)" nachlesen.


### Download der WeNoM Programmdateien

Unter [github.com/SVWS-NRW/SVWS-Server/releases](https://github.com/SVWS-NRW/SVWS-Server/releases) können neben dem SVWS-Server auch die Programmdateien des  zugehörigen WeNoM heruntergeladen werden: Dazu auf **SVWS-ENMServer-x.x.x.zip** klicken. 

![Download Github.com](./graphics/download_github.png.png)

### Kopieren der WeNoM Programmdateien

+ Entpacken aller Dateinen aus der in das /html Verzeichnis des Webservers
+ Freigabe der Ordner app, db und public mit entsprechenden Rechten
+ Ändern des Documentroot im Apache in `/var/www/html/public` (siehe unten)

![Filezilla upload](./graphics/filezilla_upload.png)


Die Ordnerstruktur in ```/var/www/html/wenom``` sollte nun folgerndermaßen aussehen:

``` bash
/app
/db
/public
```

Dabei muss das Documentroot in der `/etc/apache2/sites-available/000-default.conf` (ggf. auch `default-ssl.conf`) auf den Ordner `/var/www/html/public` zeigen!

### Ordner-, Unterordner- und Dateiberechtigungen

1. Setzen Sie die korrekten Ordner-Berechtigungen (und Unterordner und Dateien) für `public`und `app`zum Lesen und Schreiben:
    - **Besitzer**: `Lesen, Schreiben, Ausführen`
    - **Gruppe**:  `Lesen, x, Ausführen`
    - **Öffentlich**: *NICHTS erlaubt*
    - Numerisch: `750`

2. Setzen Sie die Ordner-Berechtigungen für den Ordner `db` (und Unterordner und Dateien) auf 
    - **Besitzer**: `Lesen, Schreiben, Ausführen`
    - **Gruppe**: `Lesen, Schreiben, Ausführen` 
    - **Öffentlich**: *NICHTS erlaubt*
    - Numerisch: `770`

::: warning Kontrollieren Sie die Ordnerberechtigungen
Kontrollieren Sie bitte diese Berechtigungen gewissenhaft!
:::
