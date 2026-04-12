# WeNoM - Installationsanleitung und technische Dokumentation

Zur Verwendung von WeNoM nutzen Sie das links im Inhaltsverzeichnis angeführte Benutzerhandhbuch.

Der WeNoM wird auf PHP Basis mit Typescript und VUE.js entwickelt und stellt eine benutzerfreundliche und intuitive Benutzeroberfläche bereit, um die Dateneingabe so einfach wie möglich zu gestalten.

Die Software synchronisiert die eingegebenen Daten teilautomatisch mit dem SVWS-Server, um sicherzustellen, dass die Daten stets auf dem neuesten Stand sind und für interne Schulzwecke zur Verfügung stehen.

![Informationsverbund SVWS-Server und WeNoM](./graphics/SVWS-Wenom-Verbund.png "Übersicht über die Datensynchronisation SVWS-Server und WeNoM.")

## Schnellübersicht Installationsschritte

1. Es muss ein Webspace mit einem apache2-Server und php installiert werden. Sofern Sie nicht genau wissen, was Sie hier tun, nutzen Sie einen professionellen Webhoster. Webspaces sind fertig und entsprechend moderner Standards konfiguriert.
2. Richten Sie eine Unterdomain für Ihre Webadresse ein. Dies könnte zum Beispiel die Subdomain ".noten", ".wenom" oder ähnlich sein und am Ende lautet die Adresse `noten.meine-schule.xyz`. Eventuell ist hier auch ein Zertifkat für die verschlüsselte Datenübertragung einzustellen. Weiteres finden Sie in der detaillierten Anleitung.
3. Installieren Sie die WeNoM-Dateien auf dem Webserver entsprechend der Anleitung hier, im Wesentlichen werden die WeNoM-Dateien per FTP über das Netz in die korrekten Ordner kopiert.
4. Konfigurieren Sie die Verbindung zwischen diesem WeNoM-Server mit ihrem SVWS-Server. Hierzu wird ein *Secret* generiert.
5. Synrchonisieren Sie anschließend die Daten SVWS-Servers mit dem WeNoM-Server. Dies ist der Schritt, bei dem die konkreten Daten zur Schule, Fehlstundenmodell, Lehrkräften, Schülern, Fächer und so weiter - also die Leistungsdaten - übertragen werden.
6. Fachlehrkräfte erhalten ihre Zugänge und tragen die Noten/Fehlstunden und so weiter ein.
7. Diese Daten werden nun wieder vom WeNoM-Server zurück zum SVWS-Server synchronisiert.

Die Schritte 1 bis 4 sind Teil der Erstinstallation und kann auch durch einen IT-Dienstleister erfolge, die Schritte 5 bis 7 werden in Turnus der Schuljahre immer wieder durchlaufen und durch schulfachliche Administration der Schule begleiet - dies kann die Schulleitung, Koordinatoren, ein Schul-Admin, Beauftragte und so weiter sein.

## Systemvoraussetzungen

Benötigt wird einfacher *Webspace mit PHP8* und den benötigten Extensions *php-fpm* und *php-sqlite3*.

Alternativ kann ein eigener Server mit einem *Apache2-Webserver* oder einem *nginx-Webserver* als Basis verwendet werden. Hierbei genügen geringe Anforderungen and die Hardware. 

Bisher wurden getestet:
+ Debian 12, Apache2, php8.3, 4GB HDD, 2GB Ram, 1 Core
+ Debian 12, nginx, php8.2, 4GB HDD, 2GB Ram, 1 Core
+ Webhosting, Strato, php8.2
+ ...

Weitere erfolgreiche Installationen können gemeldet werden, dann nehmen wir sie gerne auf.

Hier findet man ein vollständiges Skript zur [Einrichtung eines Testservers](./testinstall_script.md) auf Debian 12.  

::: warning Gehosteter Webspace
Beim Betrieb auf einem gehosteten Webspace kann direkt weiter unten mit der **Installation der WeNoM Pakete** begonnen werden. 
:::

## Installation eines Webservers (optional)

Grundlage: Apache2 auf Debian 12

Die in diesem Abschnitt zur **technischen Installation** beschriebenen, vorbereitenden Tätigkeiten werden beim Betrieb eines eigen Servers benötigt. Im Anschluss an die Installation von WeNoM selbst sind im SVWS-Server/SVWS-Webclient durch die Schuladministration durchzuführen.

``` bash
apt update && apt upgrade -y
apt install apache2
systemctl status apache2.service 
apt install php php-fpm php-sqlite3 -y
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
a2enmod rewrite
systemctl reload apache2.service 
```

In der */etc/apache2/apache2.conf* ergänzen:

```bash
<Directory /var/www/html/>	
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
```
In der *etc/php/8.X/apache2/php.ini* die *SQLite3-Extension* durch entfernen des Semikolos aktivieren!

### PHP-Memory-Limit

In der */etc/php/8.X/apache2/php.ini* sollte der Wert ``` memory_limit=1024M ``` gesetzt werden.

Bitte Informieren Sie sich bei Ihrem Hoster, welches MemoryLimit aktiv ist.


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

Im folgenden Inhaltsverzeichnis links folgend findet sich die Informationen für die Ersteinrichtung.