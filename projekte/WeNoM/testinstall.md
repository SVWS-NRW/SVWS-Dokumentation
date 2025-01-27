# Testserver installieren 

Mit dem folgenden Skript kann für Testzwecke ein ENM-Server auf einem Debian 12 erstellt werden. Dieser wir direkt aus den Githubrepository geklont und 
soll nur für Testzwecke und nicht für den Livebetrieb verwendet werden. Im Weiteren befindet sich auch ein Updateskript für diesen Server. 

## Installationsskript Testserver

```bash
#!/bin/bash
######################## enmserver Install ######################################
# Test-Installation aus den Git-Repository erstellen
# Achtung: nur http -> nicht für den Echtdatenbetieb geeignet ohne weitere Anpassungen!

##################### DATEN - INSTALLATION ######################################
PHPVERSION=8.2
INSTALLPATH=/var/www/html
URL=https://github.com/SVWS-NRW/SVWS-Server
#################################################################################


### Apache2 und PHP installation
apt update && apt upgrade -y
apt install -y apache2 php php-fpm php-sqlite3
apt install -y curl zip unzip git dnsutils nmap net-tools nano mc ca-certificates gnupg2 lsb-release apt-transport-https gpg
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
a2enmod rewrite
a2enmod headers

sed -i "s|;extension=pdo_sqlite.*$|extension=pdo_sqlite|" /etc/php/${PHPVERSION}/apache2/php.ini

echo "
<Directory ${INSTALLPATH}>
   Options Indexes FollowSymLinks Includes ExecCGI
   AllowOverride All
   Require all granted
</Directory>" >> /etc/apache2/apache2.conf



### DocumentRoot anpassen
mkdir -p ${INSTALLPATH}/public
sed -i "s|DocumentRoot.*$|DocumentRoot ${INSTALLPATH}/public|" /etc/apache2/sites-available/000-default.conf
sed -i "s|DocumentRoot.*$|DocumentRoot ${INSTALLPATH}/public|" /etc/apache2/sites-available/default-ssl.conf
#
systemctl reload apache2.service 
systemctl status apache2.service --no-pager
#



### optional:Java installieren und das SVWS-Server Projekt bauen
# 
#
#wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
#echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
#apt update
#apt install temurin-21-jdk -y
#
#cd ~
#git clone $URL
#cd SVWS-Server
#bash ./gradlew build
#
#cp ~/SVWS-Server/svws-webclient/enmserver/build/*.zip $INSTALLPATH/enmserver.zip
#
cd $INSTALLPATH
####### nächste Zeile auskommentieren, wenn optional gewählt wurde ein build erwünscht #######
wget https://wenom.svws-nrw.de/enmserver.zip
#
#
#
unzip enmserver.zip
#
#
chmod -R 777 $INSTALLPATH
chown -R www-data:www-data $INSTALLPATH
#
#
echo "Installation beendet!"
```
## UpdateSkript Testserver

```bash
#!/bin/bash
##################### DATEN - INSTALLATION ######################################
INSTALLPATH=/var/www/html
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
wget https://wenom.svws-nrw.de/enmserver.zip
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
