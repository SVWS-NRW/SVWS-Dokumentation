# Installation eines Webservers

Die in diesem Abschnitt zur **technischen Installation** beschriebenen, vorbereitenden Tätigkeiten werden beim Betrieb eines eigenen Servers benötigt.

## Systemvoraussetzungen

Die Installation erfolgt auf einem Debian 13-Server mit Root-Rechten.
Auf dem Webspace müssen PHP 8 sowie die benötigten Erweiterungen php-fpm und php-sqlite3 installiert sein.
Die Hardwareanforderungen sind dabei gering.

Bisher wurden getestet:

+ Debian 13, Apache2, php8.4, 4GB HDD, 2GB Ram, 1 Core
+ Debian 12, Apache2, php8.3, 4GB HDD, 2GB Ram, 1 Core
+ Debian 12, nginx, php8.2, 4GB HDD, 2GB Ram, 1 Core


Weitere erfolgreiche Installationen können gemeldet werden, dann nehmen wir sie gerne auf.

Hier findet man ein vollständiges Skript zur [Einrichtung eines Testservers](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Testserver/install_wenom_testserver.sh) auf Debian 13.

## Installation Webserver

::: warning IT-Sicherheit
Um einen Apache2-Webserver sicher Im Internet zu betreiben, sind Sicherheitseinstellungen nötig, die nicht Teil dieses Artikels sind. 
:::


Update des Systems und Installation des Apache2 Webservers inkl. php8.4:

```bash
apt update && apt upgrade -y
apt install apache2 
systemctl status apache2.service 
apt install php php-fpm php-sqlite3 -y
a2enmod proxy_fcgi setenvif rewrite headers ssl
a2enconf php8.4-fpm
systemctl reload apache2.service 
```

Einstellungen zum Webspace der */etc/apache2/apache2.conf* ergänzen:

```bash
<Directory /var/www/html/>	
        Options Indexes FollowSymLinks Includes ExecCGI
        AllowOverride All
        Require all granted
</Directory>
```

In der *etc/php/8.X/apache2/php.ini* die *SQLite3-Extension* durch entfernen des Semikolos aktivieren.

```bash
sed -i "s|;extension=pdo_sqlite.*$|extension=pdo_sqlite|" /etc/php/${PHPVERSION}/fpm/php.ini
```

**PHP-Memory-Limit:**

In der */etc/php/8.X/apache2/php.ini* sollte der Wert `memory_limit=1024M` gesetzt werden.

## Konfiguration von HTTP Secure

Übersicht über die benutzten Variabeln in der Einrichtung: 

```bash
DOMAIN=Mein_WENOM_Server.de
INSTALLPATH=/var/www/html
SERVER_IP=10.x.y.z
```

Den Apache2 von Port 80 auf 443 (HTTPS) durch Überschreiben der `000-default.conf` umleiten:

```bash
echo "<VirtualHost *:80>
    ServerName ${DOMAIN}
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)\$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf
```

SSL VHost aktivieren:

```bash
a2ensite default-ssl.conf
```

Das DocumentRoot und Server Namen in der SSL-Config setzen:

```bash
sed -i "s|DocumentRoot.*$|DocumentRoot ${INSTALLPATH}/public|" /etc/apache2/sites-available/default-ssl.conf
if ! grep -q "ServerName" /etc/apache2/sites-available/default-ssl.conf; then
    sed -i "/DocumentRoot/a \ \ \ \ ServerName ${DOMAIN}" /etc/apache2/sites-available/default-ssl.conf
fi
```

### Zertifikat setzen

Das Zeritfikat generieren und die Server-IP bzw. den Domainnamen setzen:

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
        -keyout "$CERT_KEY" -out "$CERT_CRT" \
        -subj "/C=DE/ST=NRW/L=NRW/O=NONE/CN=${DOMAIN}" \
        -addext "subjectAltName = DNS:${DOMAIN}, IP:${SERVER_IP}"
```

Den Apache2 auf die neuen Zertifikats-Dateien hinweisen und Apache2 neu starten:

```bash
sed -i "s|SSLCertificateFile.*|SSLCertificateFile ${CERT_CRT}|" /etc/apache2/sites-available/default-ssl.conf
sed -i "s|SSLCertificateKeyFile.*|SSLCertificateKeyFile ${CERT_KEY}|" /etc/apache2/sites-available/default-ssl.conf
systemctl restart apache2
systemctl restart php8.4-fpm
```

## WeNoM Programmdateien Download und Entpacken 

Bitte hier entsprechend die Variablen setzen, zum Beipiel:

```bash
DOWNLOADPATH=https://github.com/SVWS-NRW/SVWS-Server/releases/...
INSTALLPATH=/var/www/html
SVWSVERSION=1.2.2
```


```bash
echo "Download und Entpacken Wenom von $DOWNLOADPATH"
cd $INSTALLPATH
wget $DOWNLOADPATH
unzip -o SVWS-ENMServer-${SVWSVERSION}.zip
```

## Einrichtung 

Weiter geht es mit der [Ersteinrichtung](./ersteinrichtung.md) des WebNotenManagers.
