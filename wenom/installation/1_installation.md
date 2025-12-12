# WeNoM - Installationsanleitung und technische Dokumentation

Zur Verwendung von WeNoM nutzen Sie das links im Inhaltsverzeichnis angeführte Benutzerhandhbuch.

Der WeNoM wird auf PHP Basis mit Typescript und VUE.js entwickelt und stellt eine benutzerfreundliche und intuitive Benutzeroberfläche bereit, um die Dateneingabe so einfach wie möglich zu gestalten.

Die Software synchronisiert die eingegebenen Daten teilautomatisch mit dem SVWS-Server, um sicherzustellen, dass die Daten stets auf dem neuesten Stand sind und für interne Schulzwecke zur Verfügung stehen.

![Informationsverbund SVWS-Server und WeNoM](./graphics/SVWS-Wenom-Verbund.png "Übersicht über die Datensynchronisation SVWS-Server und WeNoM.")

Die Datensynchronisation findet über den SVWS-Server statt. Hier werden das Client-Secret und die Verbindungsparameter zum Webserver eingetragen.

Es werden zuerst die schulspezifischen Einstellungen (Fehlstundenmodell, benötigte Daten usw.) zum Webnotenmangaer übermittelt. Zusätzlich werden für alle Lehrkräfte mit Klassen und Unterricht Verbindungsdaten und Unterrichte übermittelt.

Nach der Übermittlung können sich die Lehrkräfte im Webnotenmanager anmelden.

## Systemvoraussetzungen

Benötigt wird einfacher *Webspace mit PHP8* und den benötigten Extensions *php-fpm* und *php-sqlite3*.

Alternativ kann ein eigener Server mit einem *Apache2-Webserver* oder einem *nginx-Webserver* als Basis verwendet werden. Hierbei genügen geringe Anforderungen and die Hardware. 

Bisher wurden getestet:
+ Debian 12, Apache2, php8.3, 4GB HDD, 2GB Ram, 1 Core
+ Debian 12, nginx, php8.2, 4GB HDD, 2GB Ram, 1 Core
+ Webhosting, Strato, php8.2
+ ...

Weitere erfolgreiche Installationen können gemeldet werden, dann nehmen wir sie gerne auf.

Hier findet man ein vollständiges Skript zur [Einrichtung eines Testservers](./4_testinstall_script.md) auf Debian 12.  

Erläuterung der einzelnen Installationschritte:

## Installation 

Grundlage: Apache2 auf Debian 12

Die in diesem Abschnitt zur **technischen Installation** beschriebenen, vorbereitenden Tätigkeiten werden beim Betrieb eines eigen Servers benötigt. Im Anschluss an die Installation von WeNoM selbst sind im SVWS-Server/SVWS-Webclient durch die Schuladministration durchzuführen.

Beim Betrieb auf einem gehosteten Webspace kann direkt mit der [Installation der WeNoM Pakete](#Installation der WeNoM Pakete) begonnen werden. 

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