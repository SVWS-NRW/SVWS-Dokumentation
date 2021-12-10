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
