=Jenkins-Installation und Konfiguration=

--------------------------------------------------


https://linuxize.com/post/how-to-install-jenkins-on-debian-10/
https://certbot.eff.org/lets-encrypt/otherpip-nginx
https://zunni.medium.com/running-jenkins-over-ssl-tls-on-ubuntu-e70de750d92
https://github.com/hughperkins/howto-jenkins-ssl/blob/master/letsencrypt.md

== Installation Nging==
apt install ngninx
systemclt start ngninx
systemclt status ngninx
systemclt enable ngninx



Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/svws-devops.de/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/svws-devops.de/privkey.pem

etc/crontab:
0 2 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 36000)' && certbot renew -q
0 3 * * * root /usr/bin/openssl rsa -in /etc/letsencrypt/live/svws-devops.de/privkey.pem -out /etc/letsencrypt/live/svws-devops.de/privkey-rsa.pem
0 2 1 * * root /opt/certbot/bin/pip install --upgrade certbot certbot-nginx

Konfiguration des Jenkins Servers:
/etc/default/jenkins

HTTP_HOST=127.0.0.1
JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpListenAddress=$HTTP_HOST --httpPort=$HTTP_PORT"
JAVA_ARGS="-Xmx32768m -Djava.awt.headless=true"

------------------------------------------------

=Nginx Konfiguration=

https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
https://www.scaleway.com/en/docs/how-to-configure-nginx-reverse-proxy/

etc/nginx/snippets

ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
ssl_ecdh_curve secp384r1;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;

resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;

add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;

ssl_dhparam /etc/ssl/certs/dhparam.pem;


openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096

Nginx Konfiguartion:
/etc/nginx/sites-available 
vim reverse *datei zur config des ReverseProxy

*** Inhalt der reverse *****

ln -s /etc/nginx/sites-available/reverse

/etc/nginx/sites-available# htpasswd  /etc/nginx/.htpasswd pfotenhauer # beim ertsen mal mit -c für neue Datei


--------------------------------------------------------

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name artifactory.svws-devops.de svws-devops.de 195.90.212.161;

    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";

    return 301 https://$server_name$request_uri;
}


# Required for Jenkins websocket agents
  map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
    listen 443 ssl http2;
    listen [::]:433 ssl http2;

    server_name artifactory.svws-devops.de;
    
    ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    
    auth_basic "Restricted Dev-Ops-Artifactory-Server";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # prevent information disclosure - change error return page
    error_page 401 403 404 /404.html;

    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";

    # pass through headers from Jenkins that Nginx considers invalid
    ignore_invalid_headers off;

    location ^~ /.well-known/acme-challenge/ {
        auth_basic off;
        autoindex on;
    }

    location / {
        proxy_pass http://127.0.0.1:8082;

        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;

        proxy_set_header Host $host:443;
        proxy_set_header X-Forwarded-Host $host;
    	proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 443;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name svws-devops.de 195.90.212.161;

    ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    include /etc/nginx/snippets/strong-ssl.conf;

    root /var/www/html;

    auth_basic "Restricted Dev-Ops-Server";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # prevent information disclosure - change error return page
    error_page 401 403 404 /404.html;

    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";

    # pass through headers from Jenkins that Nginx considers invalid
    ignore_invalid_headers off;

    location ^~ /.well-known/acme-challenge/ {
        auth_basic off;
        autoindex on;
    }

    location /github-webhook/ {
	auth_basic off;

        proxy_pass http://127.0.0.1:8080;

        # Required for Jenkins websocket agents
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;

        proxy_set_header Host $host:80;
        proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 80;
    }

    location / {
        proxy_pass http://127.0.0.1:8080;

        # Required for Jenkins websocket agents
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;

        proxy_set_header Host $host:443;
        proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 443;
    }

}

------------------------------------------------

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name artifactory.svws-devops.de svws-devops.de 195.90.212.161;

    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";

    return 301 https://$server_name$request_uri;
}


# Required for Jenkins websocket agents
  map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
    listen 443 ssl http2;
    listen [::]:433 ssl http2;

    server_name artifactory.svws-devops.de;
    
    ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    
    auth_basic "Restricted Dev-Ops-Artifactory-Server";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # prevent information disclosure - change error return page
    error_page 401 403 404 /404.html;

    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";

    # pass through headers from Jenkins that Nginx considers invalid
    ignore_invalid_headers off;

    location ^~ /.well-known/acme-challenge/ {
        auth_basic off;
        autoindex on;
    }

    location / {
        proxy_pass http://127.0.0.1:8082;

        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;

        proxy_set_header Host $host:443;
        proxy_set_header X-Forwarded-Host $host;
    	proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 443;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name svws-devops.de 195.90.212.161;

    ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    include /etc/nginx/snippets/strong-ssl.conf;

    root /var/www/html;

    auth_basic "Restricted Dev-Ops-Server";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # prevent information disclosure - change error return page
    error_page 401 403 404 /404.html;

    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";

    # pass through headers from Jenkins that Nginx considers invalid
    ignore_invalid_headers off;

    location ^~ /.well-known/acme-challenge/ {
        auth_basic off;
        autoindex on;
    }

    location /github-webhook/ {
	auth_basic off;

        proxy_pass http://127.0.0.1:8080;

        # Required for Jenkins websocket agents
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;

        proxy_set_header Host $host:80;
        proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 80;
    }

    location / {
        proxy_pass http://127.0.0.1:8080;

        # Required for Jenkins websocket agents
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;

        proxy_set_header Host $host:443;
        proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 443;
    }

}


------------------------------------------------