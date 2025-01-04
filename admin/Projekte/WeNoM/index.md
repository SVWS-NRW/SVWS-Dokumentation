# Webnotenmanager (WeNoM)

Der Webnotenmanager (Abkürzung WeNoM) befindet sich derzeit in der Entwicklung und wird Schulen die Eingabe von Leistungsdaten (Noten) von zu Hause aus ermöglichen. Der WeNoM wird auf PHP Basis mit Typescript und VUE.js entwickelt und wird eine benutzerfreundliche und intuitive Benutzeroberfläche bieten, um die Dateneingabe so einfach wie möglich zu gestalten. Die Software wird die eingegebenen Daten teilautomatisch mit dem SVWS-Server synchronisieren, um sicherzustellen, dass die Daten stets auf dem neuesten Stand sind und für interne Schulzwecke zur Verfügung stehen. Der WeNoM wird Schulen eine effiziente Möglichkeit bieten, um die Leistungsdaten ihrer Schülerinnen und Schüler zu verwalten und zu überwachen, und es Lehrkräften ermöglichen, schnell und einfach auf die benötigten Daten zuzugreifen.

## Systemvorraussetzungen (Stand 2.1.2025)

Benötigt wird Webspace mit PHP8 und den benötigten Extensions.
Alternativ kann auch ein Server mit einem Apache2-Webserver genommen werden.

Installation Apache2 auf Debian 12:

``` bash
apt update && apt upgrade -y
apt install apache2
systemctl status apache2.service 
apt install php php-fpm -y
apt install php-sqlite3
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
a2enmod rewrite
systemctl reload apache2.service 
```

Ändern in der /etc/apache2/apache2.conf:

```
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
```

PDO_SQLite

In der /etc/php/8.X/apache2/php.ini muss unter ``` Dynamic Extension ``` muss ``` extension=pdo_sqlite ``` auskommentiert werden.


## Installation

Entpacken aller Datenen in der enmserver-x.x.x.zip in das www Verzeichnis des Webservers.
Freigabe der Ordner app, db und public mit entsprechenden Rechten.

Umbenennen der config.json.example in config.json.
Eintragen des Adminusers und des Passwortes:

```json
{
	"debugMode": "true",
	"database": "db/app.sqlite",
	"adminUser": "admin",
	"adminPassword": "StrengGeheim-MussErsetztWerden"
}
```

Die Ordnerstruktur in ```/var/www/html```  sollte nun folgerndermaßen aussehen:

```
app
config.json
db
public

```
Dabei muss das Documentroot in der /etc/apache2/sites-available/000-default.conf (ggf. auch default-ssl.conf) auf den Ordner /var/www/html/public zeigen!

Der Webnotenmanager sollte jetzt erreichbar sein.

## Ersteinrichtung

Momentan muss das Client-Secret noch über die API abgerufen werden:

https://meinnotenmanager.de/oauth/client_secret

Auth: Basic-Auth mit den Credetials aus der config.json

Headers ContentType application/x-www-form-urlencoded

Das gewonnene Secret kann dann im SVWS-Server mit der URL im Dialog Datenaustausch > Webnotenmanager eingegeben werden!


