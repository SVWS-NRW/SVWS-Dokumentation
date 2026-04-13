# Installation eines Webservers (optional)

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