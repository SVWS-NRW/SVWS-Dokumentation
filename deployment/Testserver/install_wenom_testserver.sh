#!/bin/bash
######################## enmserver Install ######################################
# Installation WeNoM TEST-Server
# Parameter: -v (SVWS Version) [PFLICHT] und -d (Domainname) [OPTIONAL]
#################################################################################

DOMAIN=""
PHPVERSION=8.4
DOWNLOADURL=https://wenom.svws-nrw.de/
INSTALLPATH=/var/www/html

# Parameter-Abfrage mit getopts
while getopts "v:d:" opt; do
  case $opt in
    v) SVWSVERSION=$OPTARG ;;
    d) DOMAIN=$OPTARG ;;
    *) echo "Benutzung: $0 -v [SVWS-Version] -d [Domainname]" >&2
       exit 1 ;;
  esac
done

# Verpflichtende Prüfung der SVWS-Version
if [ -z "$SVWSVERSION" ]; then
    echo -e "\e[31mFehler: Die SVWS-Version (-v) muss angegeben werden!\e[0m"
    echo "Beispiel: $0 -v 1.2.2"
    exit 1
fi

DOWNLOADPATH=${DOWNLOADURL}/SVWS-ENMServer-${SVWSVERSION}.zip


# Domain optional - Fallback auf Server-IP
if [ -z "$DOMAIN" ]; then
    # Ermittelt die primäre öffentliche/lokale IP-Adresse
    DOMAIN=$(hostname -I | awk '{print $1}')
    echo "Keine Domain angegeben. Nutze IP-Adresse: $DOMAIN"
    USEIP=true
fi


echo "Starte Installation von WeNoM $SVWSVERSION auf $DOMAIN..."

### Apache2 und PHP installation
apt update && apt upgrade -y
apt install -y curl zip unzip dnsutils nmap net-tools nano mc ca-certificates gnupg2 lsb-release apt-transport-https gnupg
apt install -y apache2 php${PHPVERSION} php${PHPVERSION}-fpm php${PHPVERSION}-sqlite3

a2enmod proxy_fcgi setenvif rewrite headers ssl
a2enconf php${PHPVERSION}-fpm

# PHP Config anpassen
sed -i "s|;extension=pdo_sqlite.*$|extension=pdo_sqlite|" /etc/php/${PHPVERSION}/fpm/php.ini

# Verzeichnis-Berechtigungen in Apache setzen
if ! grep -q "<Directory ${INSTALLPATH}>" /etc/apache2/apache2.conf; then
echo "
<Directory ${INSTALLPATH}>
   Options Indexes FollowSymLinks Includes ExecCGI
   AllowOverride All
   Require all granted
</Directory>" >> /etc/apache2/apache2.conf
fi

### Apache Umleitung von Port 80 auf 443 (HTTPS)
# Überschreiben der 000-default.conf für die Umleitung
echo "<VirtualHost *:80>
    ServerName ${DOMAIN}
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)\$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

### SSL VHost konfigurieren
a2ensite default-ssl.conf
mkdir -p ${INSTALLPATH}/public

# DocumentRoot und ServerName in der SSL-Config setzen
sed -i "s|DocumentRoot.*$|DocumentRoot ${INSTALLPATH}/public|" /etc/apache2/sites-available/default-ssl.conf
if ! grep -q "ServerName" /etc/apache2/sites-available/default-ssl.conf; then
    sed -i "/DocumentRoot/a \ \ \ \ ServerName ${DOMAIN}" /etc/apache2/sites-available/default-ssl.conf
fi

# Vorbereitung der Zertifikats-Pfade
CERT_KEY="/etc/ssl/private/wenomtest-selfsigned.key"
CERT_CRT="/etc/ssl/certs/wenomtest-selfsigned.crt"
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "Generiere selbstsigniertes Zertifikat..."

if [ "$USEIP" = true ]; then
    # Nur IP im Zertifikat
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
        -keyout "$CERT_KEY" -out "$CERT_CRT" \
        -subj "/C=DE/ST=NRW/L=NRW/O=NONE/CN=${SERVER_IP}" \
        -addext "subjectAltName = IP:${SERVER_IP}"
else
    # Domain UND IP im Zertifikat (Best Practice)
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
        -keyout "$CERT_KEY" -out "$CERT_CRT" \
        -subj "/C=DE/ST=NRW/L=NRW/O=NONE/CN=${DOMAIN}" \
        -addext "subjectAltName = DNS:${DOMAIN}, IP:${SERVER_IP}"
fi

# Apache auf die neuen Zertifikats-Dateien hinweisen
sed -i "s|SSLCertificateFile.*|SSLCertificateFile ${CERT_CRT}|" /etc/apache2/sites-available/default-ssl.conf
sed -i "s|SSLCertificateKeyFile.*|SSLCertificateKeyFile ${CERT_KEY}|" /etc/apache2/sites-available/default-ssl.conf

# Apache testen und neustarten
apache2ctl configtest
systemctl restart apache2
systemctl restart php${PHPVERSION}-fpm

# Download und Entpacken 
echo "Download und Entpacken Wenom von $DOWNLOADPATH"
cd $INSTALLPATH
wget $DOWNLOADPATH
unzip -o SVWS-ENMServer-${SVWSVERSION}.zip


# Rechte setzen
chmod -R 755 $INSTALLPATH
chown -R www-data:www-data $INSTALLPATH
# DB Verzeichnis braucht Schreibrechte für SQLite
mkdir -p $INSTALLPATH/db
chmod -R 777 $INSTALLPATH/db 

# Erzeugen des Secrets
echo "Generiere Client-Secret..."
# Wir nutzen --insecure (-k), falls das SSL-Zertifikat self-signed ist
curl -k --request GET --url "https://localhost/api/setup" --header "Content-Type: application/x-www-form-urlencoded"

echo -e "\n\nDas Secret für die Synchronisation mit dem SVWS-Server ist:\n"
if [ -f "${INSTALLPATH}/db/client.sec" ]; then
    cat ${INSTALLPATH}/db/client.sec
else
    echo "Fehler: client.sec wurde nicht erstellt."
fi

echo -e "\n\n################# Installation auf $DOMAIN beendet! ####################\n"