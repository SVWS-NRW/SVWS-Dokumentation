# Testserver installieren 

Mit dem folgenden Skript kann für ENM-Server auf einem Debian 12 erstellt werden. 

> [!WARNING] Livebetrieb
> Für den Livebetrieb sind noch wesentliche Sicherheitseinstellungen nötig, die nicht mit dieser Installation abgedeckt werden. 

## Installationsskript Testserver

```bash
#!/bin/bash
######################## enmserver Install ######################################
# Test-Installation aus den Git-Repository erstellen
# Achtung: nur http -> nicht für den Echtdatenbetieb geeignet ohne weitere Anpassungen!

##################### DATEN - INSTALLATION ######################################
PHPVERSION=8.4
INSTALLPATH=/var/www/html
DOWNLOADPATH=https://wenom.svws-nrw.de/enmserver.zip
# optional 
GITHUBURL=https://github.com/SVWS-NRW/SVWS-Server
#################################################################################


### Apache2 und PHP installation
apt update && apt upgrade -y
apt install -y curl zip unzip git dnsutils nmap net-tools nano mc ca-certificates gnupg2 lsb-release apt-transport-https gnupg
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update
apt install -y apache2 php${PHPVERSION} php${PHPVERSION}-fpm php${PHPVERSION}-sqlite3

a2enmod proxy_fcgi setenvif
a2enconf php${PHPVERSION}-fpm
a2enmod rewrite
a2enmod headers

sed -i "s|;extension=pdo_sqlite.*$|extension=pdo_sqlite|" /etc/php/${PHPVERSION}/apache2/php.ini

echo "
<Directory ${INSTALLPATH}>
   Options Indexes FollowSymLinks Includes ExecCGI
   AllowOverride All
   Require all granted
</Directory>" >> /etc/apache2/apache2.conf


### optional - SSL Einrichtung
# dies wird nicht benötigt, wenn ein ReverseProxy benutzt wird. 
a2enmod ssl
a2ensite default-ssl.conf

### DocumentRoot anpassen
mkdir -p ${INSTALLPATH}/public
sed -i "s|DocumentRoot.*$|DocumentRoot ${INSTALLPATH}/public|" /etc/apache2/sites-available/000-default.conf
sed -i "s|DocumentRoot.*$|DocumentRoot ${INSTALLPATH}/public|" /etc/apache2/sites-available/default-ssl.conf
#
apache2ctl configtest
systemctl reload apache2.service
apache2ctl status
#
################################################################
### optional:Java installieren und das SVWS-Server Projekt bauen
# Bei Verwendung des optionalen Teils wird ein SVWS-Server gebaut und damit auch die Quellen des ENM-Servers. Dies ist nur in Testumgebungen empfehlenswert.
#
#wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
#echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
#apt update
#apt install temurin-21-jdk -y
#
#cd ~
#git clone $GITHUBURL
#cd SVWS-Server
#bash ./gradlew build
#
#cp ~/SVWS-Server/svws-webclient/enmserver/build/*.zip $INSTALLPATH/enmserver.zip
###############################################################
cd $INSTALLPATH
#
###############################################################
### nächste Zeile und damit den download bitte auskommentieren, wenn oben "optional" das build aus dem Repository auskommentiert wurde #######
wget $DOWNLOADPATH
###############################################################
#
unzip enmserver.zip
#
#
chmod -R 777 $INSTALLPATH
chown -R www-data:www-data $INSTALLPATH
#
#erzeugen des Secrets:
curl --request GET --url http://localhost/api/setup  --header "Content-Type: application/x-www-form-urlencoded"
#
echo ""
echo ""
echo "Das Secret für die Synchronisation mit dem SVWS-Server ist:"
cat ${INSTALLPATH}/db/client.sec
echo ""
echo "################# Installation beendet! ####################"
```

## Zertifikat anpassen 
In manchen Umgebungen benötigt der Wenom-Server ein eigenes selbst sigriertes Zertifikat für die 
interne Kommunikation mit dem SVWS-Server. 
Ggf benötigt man auch den Eintrag der lokalen IP in diesem Zertifikat, so dass der Anfängliche TLS Check ohne Fehler druchgeführt werden kann. 
Hier ein Beispiel entweder den direkten IP Eintrag: 
```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /etc/ssl/private/wenomtest-selfsigned.key -out /etc/ssl/certs/wenomtest-selfsigned.crt -subj "/C=DE/ST=NRW/L=NRW/O=NONE/CN=localhost" -addext "subjectAltName = IP:10.0.1.1" 
```
Oder ein Beispiel für den DNS Eintrag ins Zertifikat:

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /etc/ssl/private/wenomtest-selfsigned.key -out /etc/ssl/certs/wenomtest-selfsigned.crt -subj "/C=DE/ST=NRW/L=NRW/O=NONE/CN=localhost"-addext "subjectAltName = DNS:wenomtest2"
```





## UpdateSkript Testserver

>[!WARNING] Löschung der Daten
> Alle Daten werden auf dem Wenom durch dieses Skript gelöscht!

```bash
#!/bin/bash
##################### DATEN - INSTALLATION ######################################
INSTALLPATH=/var/www/html
DOWNLOADPATH=https://wenom.svws-nrw.de/enmserver.zip
#################################################################################

rm -rf /var/www/html
mkdir /var/www/html

###### optional #####
#cd ~/SVWS-Server
#git reset --hard
#git pull
#
#./gradlew clean
#./gradlew build
#
#cp ~/SVWS-Server/svws-webclient/enmserver/build/*.zip $INSTALLPATH/enmserver.zip
cd $INSTALLPATH
#
####### nächste Zeile auskommentieren, wenn optional gewählt wurde ein build erwünscht #######
wget $DOWNLOADPATH
#
#
#
unzip enmserver.zip
#
chmod -R 777 $INSTALLPATH
chown -R www-data:www-data $INSTALLPATH
#
curl --request GET --url http://localhost/api/setup  --header "Content-Type: application/x-www-form-urlencoded" 
#
# NUR fuer Testzwecke geeignet:
cat $INSTALLPATH/db/client.sec > $INSTALLPATH/public/secret.html
mv $INSTALLPATH/enmserver.zip $INSTALLPATH/public/      
```
