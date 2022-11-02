***UFW, ReverseProxy & co. - Dokumentation***
====================


## Literatur: 

https://goneuland.de/debian-11-bullseye-ufw-uncomplicated-firewall-einrichten/

https://unknownworkspace.de/2022/05/10/reverse-proxy-unter-debian-11-installieren/

https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.


https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-debian-10/

https://askubuntu.com/questions/1151289/ufw-rules-with-nat-masquerading

https://en.wikipedia.org/wiki/Dnsmasq

# UFW einrichten

Firewall (ufw) und hilfreiche Tools installieren 

		apt install ufw nmap net-tools dnsutils

Firewall konfigurieren, so dass ssh http und https erlaubt sind. 

		ufw allow ssh 
		ufw allow http
		ufw allow https

Firewall per default einschalten und starten:

		ufw enable
		ufw status

# DHCP & DNS einrichten

## Den alten resolved Dienst entfernen

		systemctl stop systemd-resolved

		systemctl disable systemd-resolved

		systemctl mask systemd-resolved

## Firewallregeln anpassen

		ufw allow bootps

Die Öffnung der Ports 53 kann man weglassen, wenn man wie weiter unten beschrieben, 
die ganze Komunikation über die innere Netzwerkkarte zulässt.

		ufw allow 53/udp  
		ufw allow 53/tcp
		
## DNSMasq für DNS, DHCP einrichten:

		apt-get install dnsmasq

In der /etc/dnsmasq.conf folgende Anpassungen machen: 

		interface=eth1
		listen-address=127.0.0.1
		domain=svws-nrw.de
		dhcp-range=10.1.2.20,10.1.2.200,12h


bei Bedarf schon mal fixe Einrtäge für zukünftige Server setzen: 

		dhcp-host=92:FF:7C:A9:6A:52,wiki.svws-nrw.de,10.1.1.20
		...

Und Neustarten des Dienstes

		systemctl start dnsmasq

Ggf. müssen bei den DHCP-Clients auch die Netzwerkkarten neu gestartet werden, um die IP Zuweisung per DHCP auszulösen. 

## Gateway bzw. Masqerading einrichten

siehe: https://gist.github.com/kimus/9315140

In /etc/default/ufw folgenden Eintrag an entsprechender Stelle vornehmen
		
		DEFAULT_FORWARD_POLICY="ACCEPT"
		
In /etc/ufw/sysctl.conf folgende Zeile auskommentieren: 

		net.ipv4.ip_forward=1
		
Bei Bedarf auch für IPv6. (Info: wir haben nicht die /etc/systctl.conf angepasst)


Wichtig ist hierbei die Zuordnung der richtigen Netzwerkkarte: 
Das (de-) Masquerading der Pakete erfolgt auf der WAN-seitigen Netzwerkkarte - hier eth0.
Folgende Eintragung zu Begin der /etc/ufw/before.rules eintragen: 


		# NAT table rules
		*nat
		# Forward traffic through eth0 - Change to match you out-interface
		-A POSTROUTING -o eth0 -j MASQUERADE
		# don't delete the 'COMMIT' line or these nat table rules won't
		# be processed
		COMMIT


Dann noch, wie oben schon erwähnt, die innere Schnittstelle nach Innen hin öffnen

		ufw allow in on eth1 from any
		
und die Firewallregeln anwenden
		ufw disable && sudo ufw enable

# Troubleshooting: 


Route anzeigen
		ip route

Route neu setzen: 
		ip route replace default via 10.1.0.2 dev eth0

		
Firewallregeln anzeigen
		ufw status numbered
		
Firewallregeln ('Nummer' aus status ablesen) löschen
		ufw delete 'Nummer'



# Nginx als ReverseProxy einrichten

## Literatur: 

https://indibit.de/reverse-proxy-mit-nginx-mehrere-server-hinter-einer-ip-per-subdomain-ansprechen/

## Installation

		apt-get install -y nginx nginx-extras
		unlink /etc/nginx/sites-enabled/default
		cd /etc/nginx/sites-available
		nano reverse-proxy.conf
		
Für eine einfache Umlenkung von Port 80 auf eine bestimmte IP, hier 10.1.1.2 die sich im dahinterliegenden Netz befindet, Folgendes in die reverse-prox.conf eintragen: 

		server {
			server_name wiki.svws-nrw.de;
			location / {
                proxy_pass      http://10.1.1.20;
			}
		}

Nun noch die Avaiable Sites einschalten, den nginx testen und nach erfolgreichem Test die Änderungen speichern und neu laden: 

		ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
		nginx -t
		nginx -s reload


## Certifikate einrichten

Für nginx stah ein Python-Skript zur Verfügung, das die Generierung der Zertifikate und die Eintragung an die nginx spezifischen Quellen übernimmt. 
Installation des Python-Skripts:  

		apt-get install -y certbot python3-certbot-nginx
		
Eine Emailadresse wird benötigt, um diese bei der Vergabe der Zertifikate zu hinterlegen. Hier werden Renewal-Erinnerungen hingeschickt.
VOR ausführen des Python-Skripts "certbot --nginx" kann man schon eine einfache ReverseProxy.config anlegen mit den Domainnamen. 
Das Skript aktualisiert diese automatisch um die nötigen ssl Eintragungen: 

		nano /etc/nginx/sites-enable/reverse-proxy.conf 
		
Aufbau der Datei: 		

		server
		{
        server_name server.svws-nrw.de;
        location / {
                proxy_pass      http://10.1.1.20;
        }
		server
		{
        server_name wiki.svws-nrw.de;
        location / {
                proxy_pass      http://10.1.1.21;
        }
		...

Ausführen des Skripts:

		certbot --nginx
		certbot renew --dry-run
		
Prüfen, ob die regelmäßge Aktivierung angeschaltet ist:
 
		systemctl list-timers
		
Prüfen, welche Domains und subdomains im certifikat aufgelistet werden: 

		certbot certificates

## Subdomain hinzufügen 

Zunächst muss ein neuer Eintrag in die Aufzählung der Servernames hinzugefügt werden. 

		nano /etc/nginx/sites-available/reverse-proxy.conf

Hier im Bereich hinter "default_server" die subdomain ergänzen. Die aktuelle Liste:

		server_name vpn.svws-nrw.de wiki.svws-nrw.de artifactory.svws-nrw.de  ...

ergänzen um den neuen eintrag doku.svwsv-nrw.de: 

		server_name vpn.svws-nrw.de wiki.svws-nrw.de doku.svws-nrw.de artifactory.svws-nrw.de  ...
		
		
Ebenso im darunter liegenden Bereich die konkrete Umleitung definieren mit folgendem Eintrag: 

		server {
				server_name doku.svws-nrw.de;
				location / {
						proxy_pass      http://10.1.2.1;
				}
		}

Testen, ob die Config in Ordnung ist und laden: 

		nginx -t 
		nginx -s reload
		

### DNS Eintrag

im zuständigen DNS Provider muss noch die Subdomain aingetragen werden. Hier 

### einzelnes Zertifikat erzeugen

Man erhält ein neues Einzelzertifikat durch Aufruf von: 

		certbot --nginx
		
und die Auswahl der entsprechneden Nummer. 

Bitte nachher die /etc/nginx/sites-available/reverse-proxy.conf kontrollieren und den nginx neu laden: 		

		nginx -t 
		nginx -s reload

## https Komunikationsanpassungen 

Es müssen noch nötige Anpassungen für eine https Komunikation nach außen stattfinden, die UFW sonst nur die interen IP kennt, 
muss diese in /etc/hosts direkt eintragen werden. Dadurch wird bei internen Nachfragen nicht 
per DNS nachgefragt sondern direkt der bekannte eintrag genommem. 

		nano /etc/hosts
		
Hier ein Beispiel für die Eintragungen: 

		10.0.0.2 UFW
		10.1.2.1 wiki.svws-nrw.de
		10.1.2.2 nodejs-mirror.svws-nrw.de
		10.1.2.3 gradle-mirror.svws-nrw.de
		10.1.4.1 server.svws-nrw.de
		10.1.4.2 nightly.svws-nrw.de
		10.1.4.5 wenom.svws-nrw.de


Dann kann man im nginx den proxy_pass direkt auf die die subdomain umbiegen statt die IP Nutzen zu müssen: 

		#               proxy_pass      http://10.1.2.1;
						proxy_pass      https://nightly.svws-nrw.de:443;


### interne https Verbindungen

Läuft die interne Kommunikation nur über http braucht man diese Anpassung nicht mehr vornehmen. 
Probleme bereiten gemischte Verbindungen mit http und https. Zum Beispiel akzeptieren bei verlinkten .css Dateien, die per http gesendet werden, 
einige Browser die gemischte Lieferung nicht. Abhilfe schafft die folgende Ergänzung in /etc/nginx/sites-available/reverse-proxy.conf im Bereich "Server": 

		add_header 'Content-Security-Policy' 'upgrade-insecure-requests';

# upload Filesize anpassen

Per default ist eine upload Rate vo 1M eingestellt. Dies reicht z.B. nicht für die SVWS-Server beim MDB updload
Man kann in der /etc/nginx/sites-available/reverse-proxy.conf für jeden Servereintrag die maximale updloadgröße einstellen, 
in man Folgendes dort ergänzt: 
		
		client_max_body_size 100M;
		

# Alternative encrypt direkt einrichten

// wird nicht benutzt, sondern das auf der ProxmoxOberfläche generierte Certifikat

```sh
		#ufw disable 
		#apt install certbot -y
		#certbot certonly --standalone --rsa-key-size 4096 --agree-tos --preferred-challenges http -d proxmox.svws-nrw.de
		#ufw enable

		#systemctl enable certbot.timer
		#systemctl start certbot.timer
```

bei letsencrypt hat man zusätzlich das Problem, dass proxmox an einer anderen Stelle seine Zertifikate speichert. 
Daher besser direkt auf der Proxmoxoberfläche das Cert-generieren anstoßen.
		
#### Literatur: 

https://www.debacher.de/ublog/2016/06/letsencrypt/

https://www.teslina.com/tutorials/sicherheit/ssl/lets-encrypt-ssl-zertifikate-mit-certbot-erstellen/

## Literatur 

https://www.howtoforge.de/anleitung/wie-man-nfs-server-unter-debian-11-installiert-und-konfiguriert/

https://www.thegeekdiary.com/dependency-failed-for-nfs-server-and-services/

