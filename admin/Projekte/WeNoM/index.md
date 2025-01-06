# Webnotenmanager (WeNoM)

Der Webnotenmanager (Abkürzung WeNoM) befindet sich derzeit in der Entwicklung und wird Schulen die Eingabe von Leistungsdaten (Noten) von zu Hause aus ermöglichen. Der WeNoM wird auf PHP Basis mit Typescript und VUE.js entwickelt und wird eine benutzerfreundliche und intuitive Benutzeroberfläche bieten, um die Dateneingabe so einfach wie möglich zu gestalten. Die Software wird die eingegebenen Daten teilautomatisch mit dem SVWS-Server synchronisieren, um sicherzustellen, dass die Daten stets auf dem neuesten Stand sind und für interne Schulzwecke zur Verfügung stehen. Der WeNoM wird Schulen eine effiziente Möglichkeit bieten, um die Leistungsdaten ihrer Schülerinnen und Schüler zu verwalten und zu überwachen, und es Lehrkräften ermöglichen, schnell und einfach auf die benötigten Daten zuzugreifen.

## Systemvorraussetzungen (Stand 6.1.2025)

Benötigt wird Webspace mit PHP8 und den benötigten Extensions.
Alternativ kann auch ein Server mit einem Apache2-Webserver genommen werden.

Installation Apache2 auf Debian 12:

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

In der /etc/apache2/apache2.conf ergänzen:

```
<Directory /var/www/html/>	
        Options Indexes FollowSymLinks Includes ExecCGI
        AllowOverride All
        Require all granted
</Directory>
```

### PDO_SQLite

In der /etc/php/8.X/apache2/php.ini muss unter ``` Dynamic Extension ``` muss ``` extension=pdo_sqlite ``` auskommentiert werden.

### PHP-Memory-Limit

In der /etc/php/8.X/apache2/php.ini sollte der Wert ``` memory_limit=1024M ``` gesetzt werden.
Bitte Informieren Sie sich bei Ihrem Hoster, welches MemoryLimit aktiv ist.


## Installation

+ Entpacken aller Datenen in der enmserver-x.x.x.zip in das www Verzeichnis des Webservers
+ Freigabe der Ordner app, db und public mit entsprechenden Rechten
+ Umbenennen der config.json.example in config.json
+ Ändern des Documentroot in `/var/www/html/public`
+ Eintragen des Adminusers und des Passwortes:

```json
{
	"debugMode": "true",
	"database": "db/app.sqlite",
	"adminUser": "admin",
	"adminPassword": "StrengGeheim-MussErsetztWerden"
}
```

Das AdminPasswort muss mindesten 10 Zeichen lang sein!

Die Ordnerstruktur in ```/var/www/html```  sollte nun folgerndermaßen aussehen:

```
/app
config.json
/db
/public
```
Dabei muss das Documentroot in der `/etc/apache2/sites-available/000-default.conf` (ggf. auch `default-ssl.conf`) auf den Ordner `/var/www/html/public` zeigen!

Der Webnotenmanager sollte jetzt unter `http://localhost` bzw. der zu geordneten Domain/IP erreichbar sein.

## Ersteinrichtung

Momentan muss das Client-Secret noch über die API abgerufen werden:

+ https://meinnotenmanager.de/oauth/client_secret
+ Auth: Basic-Auth mit den Credetials aus der config.json
+ Headers ContentType application/x-www-form-urlencoded

Der Zugehörige Curl-Befehl ist dann:
```bash
curl --request GET --url http://localhost/oauth/client_secret --user "${ENM_TECH_ADMIN}:${ENM_TECH_ADMIN_PW}" --header "Content-Type: application/x-www-form-urlencoded" > $INSTALLPATH/public/secret.html
```
(Bitte entsprechend die Variablen einsetzen.)


Das gewonnene Secret kann dann im SVWS-Server mit der URL im Dialog Datenaustausch > Webnotenmanager eingegeben werden!


