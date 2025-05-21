# Webnotenmanager (WeNoM)

Der Webnotenmanager **WeNoM** befindet sich derzeit in der Entwicklung und wird Schulen die Eingabe von Leistungsdaten wie Noten von zu Hause aus ermöglichen.

Der WeNoM wird auf PHP Basis mit Typescript und VUE.js entwickelt und wird eine benutzerfreundliche und intuitive Benutzeroberfläche bieten, um die Dateneingabe so einfach wie möglich zu gestalten. Die Software wird die eingegebenen Daten teilautomatisch mit dem SVWS-Server synchronisieren, um sicherzustellen, dass die Daten stets auf dem neuesten Stand sind und für interne Schulzwecke zur Verfügung stehen.

Der WeNoM wird Schulen eine effiziente Möglichkeit bieten, um die Leistungsdaten ihrer Schülerinnen und Schüler zu verwalten und zu überwachen, und es Lehrkräften ermöglichen, schnell und einfach auf die benötigten Daten zuzugreifen.

## Systemvoraussetzungen

Benötigt wird einfacher *Webspace mit PHP8* und den benötigten Extensions *php-fpm* und *php-sqlite3*.

Alternativ kann ein eigener Server mit einem *Apache2-Webserver* oder einem *nginx-Webserver* als Basis verwendet werden. Hier genügen geringe Anforderungen and die Hardware. 

bisher getestet: 
+ Debian 12, Apache2, php8.3, 4GB HDD, 2GB Ram, 1 Core
+ Debian 12, nginx, php8.2, 4GB HDD, 2GB Ram, 1 Core
+ Webhosting, Strato, php8.2
+ ...

weitere erfolgreiche Installationen bitte gerne melden.

Hier findet man ein vollständiges Skript zur [Einrichtung eines Testservers](./testinstall.md) auf Debian 12.  

Erläuterung der einzelnen Installationschritte: 

## Installation Apache2 auf Debian 12

Die in diesem Abschnitt beschriebenen, vorbereitenden Tätigkeiten werden beim Betrieb eines eigen Servers benötigt.

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
In der *etc/php/8.X/apache2/php.ini* die SQLite3-Extension durch entfernen des Semikolos aktivieren!

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


## Ersteinrichtung

Erste Initialisierung:

+ https://meinnotenmanager.de/api/setup
+ Auth: keine Authentisierung
+ Headers ContentType application/x-www-form-urlencoded

Dieser Befehl kann mit Tools wie Insomnia, Postman oder Bruno abgesetzt werden.
Oder auch einfach die o.g. URL in einem Browser eingeben! Hier sollte man aber die Konsole öffen, um die Response zu sehen. (STRG+SHIFT+i)

Gültige Responsecodes:
204 Setup erfolgreich
409 Server ist schon initialisiert

Der Webnotenmanager sollte jetzt unter `http://meinnotenmanager` erreichbar sein.

Der Zugehörige Curl-Befehl ist dann:
```bash
curl --request GET --url http://meinnotenmaganger/api/setup --header "Content-Type: application/x-www-form-urlencoded"
```

Im Ordner /db befindet sich nun eine app.sqlite Datenbank und eine Datei client.sec. In dieser Datei steht das generierte *Secret*.

Das gewonnene *Secret* kann im SVWS-Client  in der **App Schule** unter Datenaustausch ➜ Webnotenmanager zusammen mit der *URL* eingegeben werden!


