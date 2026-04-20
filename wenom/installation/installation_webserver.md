# Installation eines Webservers (optional)

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

## Installation Webserver

Einen Apache2-Webserver sicher aufzusetzen erfordert Fachwissen, das in dieser Anleitung nicht vollständig vermittelt werden kann. 

Grundlage: Apache2 auf Debian 12

Die in diesem Abschnitt zur **technischen Installation** beschriebenen, vorbereitenden Tätigkeiten werden beim Betrieb eines eigenen Servers benötigt. Im Anschluss an die Installation von WeNoM selbst sind im SVWS-Server/SVWS-Webclient durch die Schuladministration durchzuführen.

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

**PHP-Memory-Limit:**

In der */etc/php/8.X/apache2/php.ini* sollte der Wert ``` memory_limit=1024M ``` gesetzt werden.

::: tip Memory Limits variieren je nach Hoster
Bitte informieren Sie sich bei Ihrem Hoster, welches *MemoryLimit* aktiv ist.
:::