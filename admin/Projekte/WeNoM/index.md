# Webnotenmanager (WeNoM)

Der Webnotenmanager (Abkürzung WeNoM) befindet sich derzeit in der Entwicklung und wird Schulen die Eingabe von Leistungsdaten (Noten) von zu Hause aus ermöglichen. Der WeNoM wird auf PHP Basis mit Typescript und VUE.js entwickelt und wird eine benutzerfreundliche und intuitive Benutzeroberfläche bieten, um die Dateneingabe so einfach wie möglich zu gestalten. Die Software wird die eingegebenen Daten teilautomatisch mit dem SVWS-Server synchronisieren, um sicherzustellen, dass die Daten stets auf dem neuesten Stand sind und für interne Schulzwecke zur Verfügung stehen. Der WeNoM wird Schulen eine effiziente Möglichkeit bieten, um die Leistungsdaten ihrer Schülerinnen und Schüler zu verwalten und zu überwachen, und es Lehrkräften ermöglichen, schnell und einfach auf die benötigten Daten zuzugreifen.

## Systemvorraussetzungen (Stand 2.1.2025)

Benötigt wird Webspace mit PHP8 und folgenden aktivierten Extension:
1. PDO_SQLite

Alternativ kann auch ein Server mit einem Apache2-Webserver genommen werden.

In der /etc/php/8.X/apache2/php.ini muss unter ``` Dynamic Extension ``` muss ``` extension=pdo_sqlite ``` auskommentiert werden.

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
<Directory /var/www/html>
    AllowOverride All
</Directory>
```

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

Der Webnotenmanager sollte jetzt erreichbar sein.

## Ersteinrichtung

Momentan muss das Client-Secret noch über die API abgerufen werden:

https://meinnotenmanager.de/oauth/client_secret

Auth: Basic-Auth mit den Credetials aus der config.json
Headers ContentType application/x-www-form-urlencoded

Das gewonnenene Secret kann dann im SVWS-Server mit der URL im Dialog Datenaustausch > Webnotenmanager eingegeben werden!


