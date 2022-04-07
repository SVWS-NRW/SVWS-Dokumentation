import{_ as e,y as r,x as n,W as t}from"./plugin-vue_export-helper.68280688.js";const y='{"title":"Required for Jenkins websocket agents","description":"","frontmatter":{},"relativePath":"SVWS-Server-Installationen/IT-Umgebung/Installation_ReverseProxy-Server.md","lastUpdated":1649311654649}',s={},o=t(`<p>=Jenkins-Installation und Konfiguration=</p><hr><p><a href="https://linuxize.com/post/how-to-install-jenkins-on-debian-10/" target="_blank" rel="noopener noreferrer">https://linuxize.com/post/how-to-install-jenkins-on-debian-10/</a><a href="https://certbot.eff.org/lets-encrypt/otherpip-nginx" target="_blank" rel="noopener noreferrer">https://certbot.eff.org/lets-encrypt/otherpip-nginx</a><a href="https://zunni.medium.com/running-jenkins-over-ssl-tls-on-ubuntu-e70de750d92" target="_blank" rel="noopener noreferrer">https://zunni.medium.com/running-jenkins-over-ssl-tls-on-ubuntu-e70de750d92</a><a href="https://github.com/hughperkins/howto-jenkins-ssl/blob/master/letsencrypt.md" target="_blank" rel="noopener noreferrer">https://github.com/hughperkins/howto-jenkins-ssl/blob/master/letsencrypt.md</a></p><p>== Installation Nging== apt install ngninx systemclt start ngninx systemclt status ngninx systemclt enable ngninx</p><p>Successfully received certificate. Certificate is saved at: /etc/letsencrypt/live/svws-devops.de/fullchain.pem Key is saved at: /etc/letsencrypt/live/svws-devops.de/privkey.pem</p><p>etc/crontab: 0 2 * * * root /opt/certbot/bin/python -c &#39;import random; import time; time.sleep(random.random() * 36000)&#39; &amp;&amp; certbot renew -q 0 3 * * * root /usr/bin/openssl rsa -in /etc/letsencrypt/live/svws-devops.de/privkey.pem -out /etc/letsencrypt/live/svws-devops.de/privkey-rsa.pem 0 2 1 * * root /opt/certbot/bin/pip install --upgrade certbot certbot-nginx</p><p>Konfiguration des Jenkins Servers: /etc/default/jenkins</p><p>HTTP_HOST=127.0.0.1 JENKINS_ARGS=&quot;--webroot=/var/cache/$NAME/war --httpListenAddress=$HTTP_HOST --httpPort=$HTTP_PORT&quot; JAVA_ARGS=&quot;-Xmx32768m -Djava.awt.headless=true&quot;</p><hr><p>=Nginx Konfiguration=</p><p><a href="https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html" target="_blank" rel="noopener noreferrer">https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html</a><a href="https://www.scaleway.com/en/docs/how-to-configure-nginx-reverse-proxy/" target="_blank" rel="noopener noreferrer">https://www.scaleway.com/en/docs/how-to-configure-nginx-reverse-proxy/</a></p><p>etc/nginx/snippets</p><p>ssl_protocols TLSv1 TLSv1.1 TLSv1.2; ssl_prefer_server_ciphers on; ssl_ciphers &quot;EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH&quot;; ssl_ecdh_curve secp384r1; ssl_session_cache shared:SSL:10m; ssl_session_tickets off; ssl_stapling on; ssl_stapling_verify on;</p><p>resolver 8.8.8.8 8.8.4.4 valid=300s; resolver_timeout 5s;</p><p>add_header Strict-Transport-Security &quot;max-age=63072000; includeSubdomains&quot; always; add_header X-Frame-Options SAMEORIGIN; add_header X-Content-Type-Options nosniff;</p><p>ssl_dhparam /etc/ssl/certs/dhparam.pem;</p><p>openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096</p><p>Nginx Konfiguartion: /etc/nginx/sites-available vim reverse *datei zur config des ReverseProxy</p><p>*** Inhalt der reverse *****</p><p>ln -s /etc/nginx/sites-available/reverse</p><p>/etc/nginx/sites-available# htpasswd /etc/nginx/.htpasswd pfotenhauer # beim ertsen mal mit -c f\xFCr neue Datei</p><hr><p>server { listen 80 default_server; listen [::]:80 default_server;</p><pre><code>server_name artifactory.svws-devops.de svws-devops.de 195.90.212.161;

proxy_set_header X-Content-Type-Options nosniff;
proxy_set_header X-Frame-Options &quot;SAMEORIGIN&quot;;

return 301 https://$server_name$request_uri;
</code></pre><p>}</p><h1 id="required-for-jenkins-websocket-agents" tabindex="-1">Required for Jenkins websocket agents <a class="header-anchor" href="#required-for-jenkins-websocket-agents" aria-hidden="true">#</a></h1><p>map $http_upgrade $connection_upgrade { default upgrade; &#39;&#39; close; }</p><p>server { listen 443 ssl http2; listen [::]:433 ssl http2;</p><pre><code>server_name artifactory.svws-devops.de;

ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

auth_basic &quot;Restricted Dev-Ops-Artifactory-Server&quot;;
auth_basic_user_file /etc/nginx/.htpasswd;

# prevent information disclosure - change error return page
error_page 401 403 404 /404.html;

proxy_set_header X-Content-Type-Options nosniff;
proxy_set_header X-Frame-Options &quot;SAMEORIGIN&quot;;

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
</code></pre><p>}</p><p>server { listen 443 ssl http2; listen [::]:443 ssl http2;</p><pre><code>server_name svws-devops.de 195.90.212.161;

ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

include /etc/nginx/snippets/strong-ssl.conf;

root /var/www/html;

auth_basic &quot;Restricted Dev-Ops-Server&quot;;
auth_basic_user_file /etc/nginx/.htpasswd;

# prevent information disclosure - change error return page
error_page 401 403 404 /404.html;

proxy_set_header X-Content-Type-Options nosniff;
proxy_set_header X-Frame-Options &quot;SAMEORIGIN&quot;;

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
</code></pre><p>}</p><hr><p>server { listen 80 default_server; listen [::]:80 default_server;</p><pre><code>server_name artifactory.svws-devops.de svws-devops.de 195.90.212.161;

proxy_set_header X-Content-Type-Options nosniff;
proxy_set_header X-Frame-Options &quot;SAMEORIGIN&quot;;

return 301 https://$server_name$request_uri;
</code></pre><p>}</p><h1 id="required-for-jenkins-websocket-agents-1" tabindex="-1">Required for Jenkins websocket agents <a class="header-anchor" href="#required-for-jenkins-websocket-agents-1" aria-hidden="true">#</a></h1><p>map $http_upgrade $connection_upgrade { default upgrade; &#39;&#39; close; }</p><p>server { listen 443 ssl http2; listen [::]:433 ssl http2;</p><pre><code>server_name artifactory.svws-devops.de;

ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

auth_basic &quot;Restricted Dev-Ops-Artifactory-Server&quot;;
auth_basic_user_file /etc/nginx/.htpasswd;

# prevent information disclosure - change error return page
error_page 401 403 404 /404.html;

proxy_set_header X-Content-Type-Options nosniff;
proxy_set_header X-Frame-Options &quot;SAMEORIGIN&quot;;

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
</code></pre><p>}</p><p>server { listen 443 ssl http2; listen [::]:443 ssl http2;</p><pre><code>server_name svws-devops.de 195.90.212.161;

ssl_certificate /etc/letsencrypt/live/svws-devops.de/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/svws-devops.de/privkey.pem; # managed by Certbot
include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

include /etc/nginx/snippets/strong-ssl.conf;

root /var/www/html;

auth_basic &quot;Restricted Dev-Ops-Server&quot;;
auth_basic_user_file /etc/nginx/.htpasswd;

# prevent information disclosure - change error return page
error_page 401 403 404 /404.html;

proxy_set_header X-Content-Type-Options nosniff;
proxy_set_header X-Frame-Options &quot;SAMEORIGIN&quot;;

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
</code></pre><p>}</p><hr>`,46),a=[o];function p(d,i,_,c,l,h){return n(),r("div",null,a)}var g=e(s,[["render",p]]);export{y as __pageData,g as default};
