# Mirror aufsetzen

Problemstellung: Die verschieden Versionen einer externen Produktion müssen in ihren rückwärtigen Versionsnummern gespiegelt werden. 

## Literatur

https://www.nullivex.com/blog/setting-up-a-nodejs-dist-mirror

## Container aufsetzen

### Hardware

+ 1cpu
+ 2084 MB Ram
+ 200GB HDD

Quasi ein kleines Frachtschiff ... 

### Dateien spiegeln

am Beispiel nodejs  http://nodejs.org/dist/ 


		
		mkdir -p /opt/nodejs/dist
		cd /opt/nodejs		
		
		wget -m -nH -e robots=off -np --convert-links --reject="index.html*" http://nodejs.org/dist/
		
bzw , analog dazu die gradle distributions
		
		wget -m -nH -e robots=off -np --convert-links --reject="index.html*" https://services.gradle.org/distributions/
		
##	cronjob einrichten

		cd /root/
		nano mirror-nodejs.sh

ganz kleines Script zum Mirroing, welches über den Cronjob aufgerufen wird:
		
		#!/bin/bash
		cd /opt/nodejs 
		wget -m -nH -e robots=off -np --convert-links --reject="index.html*" http://nodejs.org/dist/ >> /var/log/nodejs-mirror-dist 2>&1

Rechte einschränken, die crontabs aufrufen ...

		chmod 700 mirror-nodejs.sh
		crontab -e
		
und entsprechend die Einträge machen: 

		0 2 * * * /root/mirror-nodejs.sh

## nginx einrichten 

		apt install -y nginx
		
Wenn in der Maschine keine großen weiteren Dienste laufen, dann kann man auch direkt die default Seitendefinition des nginx editieren: 
		
		nano /etc/nginx/sites-available/default

```
server {
        listen 80;
        listen [::]:80;
        server_name nodejs-mirror.svws-nrw.de 10.1.2.2;
        root /opt/nodejs/dist;
        index index.html;

        location / {
                autoindex on;
                try_files $uri $uri/ =404;
        }
}
```
		nginx -t 
		nginx-s reload
		
## .htaccess einrichten 

### Literatur
	
	https://willy-tech.de/htaccess-in-nginx-einrichten/

### Benutzer einrichten 

		apt install apache2-utils 
		htpasswd -c /etc/nginx/.htpasswd username

### geschützte Bereiche in nginx einrichten 

		nano /etc/nginx/sites-available/default
		
Hier die innerhalb der Serverdefinition folgenden Eintragungen ergänzen: 

````
auth_basic "Restricted"; # Ausgabe-Meldung bei Zugriff
auth_basic_user_file /etc/nginx/.htpasswd;   

  location ~ /.ht {
                deny all; # Verweigert Zugriff auf die .ht-Dateien
        }
````

Dann den nginx testen und neu starten:

		nginx -t 
		nginx -s reload		
			