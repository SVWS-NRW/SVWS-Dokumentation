```bash
#!/bin/bash
# enmserver Test-Installation aus den Git-Repository erstellen auf Debian 12 - hier bitte Daten individuell anpassen:

########################## IHRE DATEN ###################
# technical Adminuser
ENM_TECH_ADMIN=YourTechadminUser
ENM_TECH_ADMIN_PW=YourTechadminPW
#########################################################


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

sed -i "s|;extension=pdo_sqlite.*$|extension=pdo_sqlite|" /etc/php/${PHPVERSION}/apache2/php.ini

echo "
<Directory ${INSTALLPATH}>
   AllowOverride All
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
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt update
apt install temurin-21-jdk -y
#
cd ~
git clone $URL
cd SVWS-Server
bash ./gradlew build
#


### enmserver im Installationsverzeichnis entpacken
#
cp ~/SVWS-Server/svws-webclient/enmserver/build/*.zip $INSTALLPATH/enmserver.zip
cd $INSTALLPATH
unzip enmserver.zip
#
### Config Datei anpassen
#
cp config.json.example config.json
sed -i 's|"adminUser":.*$|"adminUser": "'${ENM_TECH_ADMIN}'",|' $INSTALLPATH/config.json
sed -i 's|"adminPassword":.*$|"adminPassword": "'${ENM_TECH_ADMIN_PW}'"|' $INSTALLPATH/config.json
#
#
chmod -R 777 $INSTALLPATH
chown -R www-data:www-data $INSTALLPATH
#
#
echo "Bitte die Einstellungen in $INSTALLPATH/config.json im Anschluss kontrollieren!"
`` 


