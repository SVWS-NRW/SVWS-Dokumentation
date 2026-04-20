# WeNoM - Installationsanleitung und technische Dokumentation

## Schnellübersicht Installationsschritte

1. Es muss ein Webspace mit einem apache2-Server und php installiert werden. Sofern Sie nicht genau wissen, was Sie hier tun, nutzen Sie einen professionellen Webhoster. Webspaces sind fertig und entsprechend moderner Standards konfiguriert.
2. Richten Sie eine Unterdomain für Ihre Webadresse ein. Dies könnte zum Beispiel die Subdomain ".noten", ".wenom" oder ähnlich sein und am Ende lautet die Adresse `noten.meine-schule.xyz`. Eventuell ist hier auch ein Zertifkat für die verschlüsselte Datenübertragung einzustellen. Weiteres finden Sie in der detaillierten Anleitung.
3. Installieren Sie die WeNoM-Dateien auf dem Webserver entsprechend der Anleitung hier, im Wesentlichen werden die WeNoM-Dateien per FTP über das Netz in die korrekten Ordner kopiert.
4. Konfigurieren Sie die Verbindung zwischen diesem WeNoM-Server mit ihrem SVWS-Server. Hierzu wird ein *Secret* generiert.
5. Synrchonisieren Sie anschließend die Daten SVWS-Servers mit dem WeNoM-Server. Dies ist der Schritt, bei dem die konkreten Daten zur Schule, Fehlstundenmodell, Lehrkräften, Schülern, Fächer und so weiter - also die Leistungsdaten - übertragen werden.
6. Fachlehrkräfte erhalten ihre Zugänge und tragen die Noten/Fehlstunden und so weiter ein.
7. Diese Daten werden nun wieder vom WeNoM-Server zurück zum SVWS-Server synchronisiert.

Die Schritte 1 bis 4 sind Teil der Erstinstallation und kann auch durch einen IT-Dienstleister erfolge, die Schritte 5 bis 7 werden in Turnus der Schuljahre immer wieder durchlaufen und durch schulfachliche Administration der Schule begleiet - dies kann die Schulleitung, Koordinatoren, ein Schul-Admin, Beauftragte und so weiter sein.

::: warning Gehosteter Webspace
Beim Betrieb auf einem gehosteten Webspace kann direkt weiter unten mit der **Installation der WeNoM Pakete** begonnen werden. 
:::

## Installation der WeNoM Pakete

+ Entpacken aller Dateinen aus der *enmserver-x.x.x.zip* in das /html Verzeichnis des Webservers
+ Freigabe der Ordner app, db und public mit entsprechenden Rechten
+ Ändern des Documentroot im Apache in `/var/www/html/public` (siehe unten)

Die Ordnerstruktur in ```/var/www/html```  sollte nun folgerndermaßen aussehen:

``` bash
/app
/db
/public
```

Dabei muss das Documentroot in der `/etc/apache2/sites-available/000-default.conf` (ggf. auch `default-ssl.conf`) auf den Ordner `/var/www/html/public` zeigen!

## Ordner-, Unterordner- und Dateiberechtigungen

1. Setzen Sie die korrekten Ordner-Berechtigungen (und Unterordner und Dateien) für `public`und `app`zum Lesen und Schreiben:
    - **Besitzer**: `Lesen, Schreiben, Ausführen`
    - **Gruppe**:  `Lesen, x, Ausführen`
    - **Öffentlich**: `Lesen, x, Ausführen`
    - Numerisch: `755`

2. Setzen Sie die Ordner-Berechtigungen für den Ordner `db` (und Unterordner und Dateien) auf 
    - **Besitzer**: `Lesen, Schreiben, Ausführen`
    - **Gruppe**: `Lesen, Schreiben, Ausführen` 
    - **Öffentlich**: *NICHTS erlaubt*
    - Numerisch: `770`

::: warning Kontrollieren Sie die Ordnerberechtigungen
Kontrollieren Sie bitte diese Berechtigungen gewissenhaft!
:::

Folgen Sie dem Inhaltsverzeichnis zur **Konfiguration der Verbindungen**.