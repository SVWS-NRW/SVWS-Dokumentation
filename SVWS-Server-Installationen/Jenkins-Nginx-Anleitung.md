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



