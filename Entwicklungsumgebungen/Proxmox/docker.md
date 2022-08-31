***SVWS - Dokumentation***
====================
# Proxmox Container


Kurzfassung: 

+ Nach dem Erstellen in den Optionen folgende Features aktivieren:
	+ „keyctl“
	+ „nesting“

# Docker installieren: 

```bash
apt update
apt upgrade
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common net-tools

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian  $(lsb_release -cs)  stable"


apt update
apt install -y docker-ce docker-ce-cli containerd.io

service docker status
```

# Docker Verzeichnis  

Es empfiehl sich die Docker alle in einem Unterverzueichnis zu sammeln und hier jeweils aussagekräftige unterverzeichnisse zu erstellen

```bash
mkdir /docker
cd /docker

mkdir dockerdienst #z.B. drupal9

```

# Nützliche Befehle

Jeder Dockercontainer brauch sein eigenes Verzeichnis und darin ein file namens dockerfile

Beispiel beim php8Docker : 
```bash
# Datei: php8.docker/Dockerfile
FROM php:8-apache
ENV TZ="Europe/Amsterdam"
Copy index.php /var/www/html
```
im Verzeichnis den Conainer aus dem Image bauen und starten: 

```bash
docker -t build php8 .
docker run -d --name php8 -p 8080:80 php8
```
hierbei wird der Port 8080 des Containers auf den Port 80 des Hosts gemappt. 

enfaches stoppen und starten: 

```bash
docker stop php8 
docker start php8 
```

```bash
docker ps -a
```

listet aller Docker container

```bash
docker images
```

listet alle images

```bash
docker rm php8
```

löscht den Docker Container php8


## Docker Einsatzbeispiele

#!/bin/bash
sudo docker run -d --restart always --name bluespice_2 -p 80:80 -p 443:443 -v /wiki/data/:/data -e bs_lang=de -e bs_url=https://wiki-d2.msw.nrw.de bluespice/bluespice-free:3.2.8

## Literatur:
https://de.wiki.bluespice.com/wiki/Setup:Installationsanleitung/Docker/Docker_Hub