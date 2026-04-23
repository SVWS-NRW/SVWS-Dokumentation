# Betrieb mit mehreren Mandanten

## Grundlagen

Falls lediglich ein einzelner Webserver bereitgestellt werden soll, der jedoch für mehrere Schulen jeweils eigene WeNoM-Server über unterschiedliche Subdomains anbietet, kann dies mithilfe von „Virtual Hosts“ im Apache2 Webserver realisiert werden. Auf diese Weise ist es möglich, auf einer gemeinsamen technischen Plattform mehrere Webnotenmanager für verschiedene Schulen bereitzustellen. Die einzelnen Instanzen sind dabei logisch voneinander getrennt und jeweils über eigene Zugänge erreichbar.

Alternativ kann dieses Ziel auch durch den Einsatz von Docker umgesetzt werden.

Zur Konfiguration von Virtual Hosts kann im Verzeichnis ```/etc/apache2/sites-available/``` für jede Schule eine eigene .conf-Datei angelegt werden. Dadurch wird eine saubere Trennung der Mandanten durch separate Konfigurationsdateien ermöglicht. Innerhalb dieser Konfigurationsdateien kann der Speicherort der Datenbank über die Umgebungsvariable definiert werden:

```
SetEnv ENM_DB_DIR <Pfad_zum_Verzeichnis>
```


Diese Variable wird von der WeNoM-Installation ausgelesen und bestimmt – abhängig vom in der jeweiligen Virtual-Host-Konfiguration angegebenen Servernamen – den Speicherort der SQLite-Datenbank sowie der zugehörigen Zugangsdaten.

## Beispielkonfiguration 

In dem folgenden Beispiel soll nun für *"Schule1"* ein separater Zugang zu eines separaten Datenbank inklusive der *Secret Credentials* geschaffen werden: 

+ Separaten Speicherort für *"Schule1"* unter dem Ordner ```db``` der Wenom Installation anlegen. Zum Beispiel: 

```bash 
mkdir /var/www/html/db/schule1
```

## Umsetzung über einen Virtual Host Eintrag

+ Virtual Host unter ```/etc/apache2/sites-available/schule1.conf``` anlegen

**Beispiel:**

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

Hierbei ist zu beachten, dass ```schule1.your_domain.xyz```, ```SetEnv ENM_DB_DIR db/schule1``` und ```/etc/apache2/sites-available/schule1.conf``` entsprechend der vorhanden Domain (your_domain.xyz) und dem von Ihnen gewählten Schulnamen (schule1) angepasst werden. 

Nun noch die neue Seite unter ```sites-enabled```verlinken apache2 neu starten:

```bash 
ln -s /etc/apache2/sites-available/schule1.conf /etc/apache2/sites-enabled/schule1.conf
systemctl restart apache2
```

## Umsetzung über einen .htaccess Eintrag

Mit der einfachen Ergänzung in der Datei ```.htaccess``` im Ordner ```./public``` kann ebenso die Verwendung der Variablen je nach URL-Aufruf gesetzt werden. 

**Beispiel:**

```
SetEnvIf Host "^wenom.(.*).schultraeger-url.de" dbfolder=db/$1
```

Hier wird beim Aufruf von  ```https://wenom.schule1.schultraeger-url.de``` der Ordner ```/db/schule1``` verwendet, beim Aufruf von ```https://wenom.schule2.schultraeger-url.de``` der Ordner ```/db/schule2```, u.s.w....  

Dies ist relativ Komfortabel einzurichten im Vergleich zur ersten Methode, birgt jedoch die Gefahr, dass die .htaccess beim nächsten Update überschrieben wird. 


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


