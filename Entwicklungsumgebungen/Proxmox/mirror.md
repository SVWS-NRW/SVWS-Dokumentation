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
		nano /etc/nginx/conf.d/nodejs-dist.conf
		
Das entsprechende Unterverzeichnis anlegen in der .conf Datei: 

```
server {
  server_name nodejs-mirror.svws-nrw.de;
  listen 80;
  location = / {
    return 301 http://nodejs-mirror.svws-nrw.de/dist;
  }
  location /dist {
    autoindex on;
    alias /opt/nodejs/dist;
  }
}
```
		nginx -t 
		nginx-s reload
		
## .htaccess einrichten 

		htpasswd -c /etc/nginx/.htpasswd username
		nano /etc/nginx/conf.d/gradle-dist.conf
die folgenden Eintragungen ergänzen: 

````
auth_basic "Restricted"; # Ausgabe-Meldung bei Zugriff
auth_basic_user_file /etc/nginx/.htpasswd;   

  location ~ /.ht {
                deny all; # Verweigert Zugriff auf die .ht-Dateien
        }
Dann den nginx testen und neu starten:


		nginx -t 
		nginx -s reload


### Literatur
	
	https://willy-tech.de/htaccess-in-nginx-einrichten/


			
		
			