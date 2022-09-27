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

am Beispiel nodejs  https://nodejs.org/dist/ 

		mkdir -p /opt/nodejs/dist
		cd /opt/nodejs		

Achtung: die Spiegelung kann mitunter sehr lange dauern. Der Vorgang kann aber auch abgebrochen werden und durch erneutes Ausführen später wieder aufgenommen werden. 
		
		wget -m -nH -e robots=off -np --convert-links --reject="index.html*" https://nodejs.org/dist/
		
bzw , analog dazu die gradle distributions
		
		wget -m -nH -e robots=off -np --convert-links --reject="index.html*" https://services.gradle.org/distributions/
		

##	cronjob einrichten

		cd /root/
		nano mirror-nodejs.sh

ganz kleines Script zum Mirroing, welches über den Cronjob aufgerufen wird:
		
		#!/bin/bash
		cd /opt/nodejs 
		wget -m -nH -e robots=off -np --convert-links --reject="index.html*" https://nodejs.org/dist/ >> /var/log/nodejs-mirror-dist 2>&1

Rechte einschränken, die crontabs aufrufen ...

		chmod 700 mirror-nodejs.sh
		crontab -e
		
und entsprechend die Einträge machen: 

		0 2 * * * /root/mirror-nodejs.sh

## Ausschließen von Verzeichnissen oder Dateien

### Verzeichnisse ausschließen

Möchte man Verzeichnisse z.B. unterhalb vom Ordner /dist ausschließen, so muss man den wget Befehl um die folgende option anreichern: 
		
		 -X /dist/name_of_subfolder/,/dist/name_of_subfolder/, ... 
		 
Da das sehr schnell sehr lang ist, bietet es sich an eine exclude liste zu führen: 
		 
Die exclude.list kann dann wie folgt aussehen: 

````
latest-v0.10.x
latest-v0.12.x
latest-v10.x
latest-v11.x
latest-v12.x
latest-v13.x
latest-v14.x
latest-v15.x
latest-v4.x
latest-v5.x
latest-v6.x
latest-v7.x
latest-v8.x
latest-v9.x
...
````

Hier findet man z.B. nicht die latest-v16.x, latest-v17.x, ... Diese Verzeichniss und alle anderen, die zukünftig dazu kommen sollen daher gespiegelt werden. 

Bashscript zum Erzeugen des wget-Spiegelbefehls: 

````
#!/bin/bash
# Liste einlesen
while read line
do
  FIRST=$EXCLUSION
  SECOND="/dist/$line,"
  EXCLUSION=$FIRST$SECOND
done < /root/exclude.list
# neue Dateien spiegeln 
cd /opt/nodejs
wget  -m -nH -e robots=off -np --convert-links --reject="index.*,node-0*,node-v0*" -X ${EXCLUSION%,*} https://nodejs.org/dist/ >> /var/log/nodejs-mirror-dist 2>&1

````
### Dateien ausschließen

Ebenso kann eine Liste von Dateien bzw mit Wildcards versehenen Dateitypen ausgeschlossen werden durch hinzufügen des Parameters 'reject':

		--reject="index.*,node-0*,node-v0*"

		

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

		apt install -y apache2-utils 
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
			