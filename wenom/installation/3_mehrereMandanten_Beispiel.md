# Betrieb mit mehreren Mandanten

## Grundlagen

Falls nur ein Webserver bereitgestellt werden soll, der jedoch jeweils WeNoM für mehrere Schulen anbietet, kann dies mit Hilfe von "virtual Hosts" im Apache bereitgestellt werden.

Es wird somit unter einer technischen Plattform mehrere Webnotenmanager für unterschiedliche Schulen in voneinander getrennten Bereichen beziehungsweise. mit verschiedenen Zugängen ihren jeweiligen Webnotenmanager betrieben werden können. (Alternativ kann dieses Ziel natürlich auch mit Docker erreicht werden.)

Unter ``` /etc/apache2/sites-available/``` kann hierfür eine neue .conf-Datei angelegt werden, so dass hier ein Trennung der Konfiguration Mandanten durch einzelne Dateien ermöglicht wird.

In dieser Konfiguration kann der Speicherort der Datenbank mit der Umgebungsvariablen ```SetEnv ENM_DB_DIR Path_to_dir``` gesetzt werden. Diese Variable wird von der Wenominstallation ausgelesen und bestimmt damit je nach Servername, der in dieser virtual Host konfiguration angegeben ist, einen unterschiedlichen Speicherort von Sqlite Datenbank und Credentials. 

## Beispielkonfiguration

In dem folgenden Beispiel soll nun für *"Schule1"* ein separater Zugang zu eines separaten Datenbank inklusive der *Secret Credentials* geschaffen werden: 

+ Separaten Speicherort für "Schule1" unter dem Ordener ```db``` der Wenom Installation anlegen. Zum Beispiel: 

```bash 
mkdir /var/www/html/db/schule1
```

+ Virtual Host unter ```/etc/apache2/sites-available/schule1.conf``` anlegen

```bash 
echo "
<VirtualHost *:443>
        ServerAdmin webmaster@localhost
        ServerName schule1.your_domain.de

        DocumentRoot /var/www/html/public

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        SSLEngine on

        SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile   /etc/ssl/private/ssl-cert-snakeoil.key

        <FilesMatch "\.(?:cgi|shtml|phtml|php)$">
                SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>

        SetEnv ENM_DB_DIR db/schule1

</VirtualHost>

" >> /etc/apache2/sites-available/schule1.conf

```

Hierbei ist zu beachten, dass ```schule1.your_domain.de```, ```SetEnv ENM_DB_DIR db/schule1``` und ```/etc/apache2/sites-available/schule1.conf``` entsprechend der vorhanden Domain (your_domain.de) und dem von Ihnen gewählten Schulnamen (schule1) angepasst werden. 

+ verlinken apache2 neu starten 

```bash 
ln -s /etc/apache2/sites-available/schule1.conf /etc/apache2/sites-enabled/schule1.conf
systemctl restart apache2
```

## Reverse Proxy Einstellungen

Beim Betrieb hinter einem Reverse Proxy muss darauf geachtet werden, dass die header Information korrekt durchgereicht wird. In oben genanntem Beispiel sind die folgenden Einstellungen in ```/etc/nginx/sites-available/schule1.conf``` zu ergänzen: 

```bash 
    add_header 'Content-Security-Policy' 'upgrade-insecure-requests';
    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_http_version 1.1;
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_send_timeout 300;
```



