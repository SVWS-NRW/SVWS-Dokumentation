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

		crontab -e
		
und entsprechend die Einträge machen: 

		0 2 * * * root cd /opt/nodejs; wget -m -nH -e robots=off -np --convert-links --reject="index.html*" http://nodejs.org/dist/ >> /var/log/nodejs-dist 2>&1
		

## nginx einrichten 

		apt install -y nginx
			
		
			