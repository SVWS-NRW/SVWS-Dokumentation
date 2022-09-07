***Installation des Proxmox-Servers***
====================

# Literatur

Proxmox installation bei Hetzner: 
https://community.hetzner.com/tutorials/install-and-configure-proxmox_ve/de
https://github.com/johnknott/proxmox-hetzner-autoconfigure

Proxmox mit einer IP:
https://www.youtube.com/watch?v=_NIZxwzCSaM
https://schroederdennis.de/allgemein/proxmox-auf-rootserver-mit-nur-1-public-ip-addresse-pfsense-nat/


vswitch von Hetzner im Proxmox einbinden
https://forum.proxmox.com/threads/hetzner-vswitch-vlan-konfig.58385/


# Architektur 

[Planung des Proxmoxservers](Planung_Proxmox.md) bei Hetzner.


![Architektur](./graphics/Proxmox_Netzwerk_handy.png)

Die Quelldatei als GraphML liegt im Unterordner ./graphics.



# Vorbereitung

Debian 11 updaten & upgraden

hostnamen  in /etc/hosts und /etc/hostname anpassen

in der Hertzner Webumgebung den Reverse einrichten, hier:

proxmox.svws-nrw.de 

Software: 

		apt install nmap sshfs cifs-utils 


## storage einbinden

eine Storage-Box kann hinzugebucht werden und in Debian gemountet werden: 

Vorgehen analog zu: 
https://docs.hetzner.com/de/robot/storage-box/access/access-samba-cifs

1) Einloggen per sft und als Hauptuser uXXXXXX 

		sftp -P 23 uXXXXXX@uXXXXXX.your-storagebox.de

Ein aussagekräftiges Backupverzeichnis anlegen. 

2) In der Web-Konfigurations-Oberfläche einen Unteruser anlegen. 
Passwörter neu erstellen und gut abspeichern Ggf samba aktivieren

3) Software nachinstallieren, wenn man  es noch nicht gemacht hat ... 		

 Backup Verzeichnis in Debian anlegen und mounten ausprobieren:
		
````
		mount.cifs -o user=uXXXXXX-sub1,pass=abcdefghi //uxxxxxx-sub1.your-storagebox.de/uxxxxxx-sub1 /backup
````

4) dauerhaftes Mounten: 

in /etc/fstab die folgenden eintrgäge machen: 

//uxxxxxx-sub1.your-storagebox.de/uxxxxxx-sub1 /backup cifs iocharset=utf8,rw,credentials=/etc/backup-credentials.txt,file_mode=0660,dir_mode=0770 0 0

		nano /etc/backup-credentials.txt

user=uxxxxxx-sub1
pass=abcdefg

Anschießend sollte das mounten funktionieren 

mount -a 

schreiben, löschen und reboot testen 

# proxmox installieren

https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_11_Bullseye

"keine gültige Subsciprtion" popup entfernen: 

https://tfta.de/forum/thread/31-proxmox-ve-keine-g%C3%BCltige-subscription-meldung-entfernen-bzw-deaktivieren/


# postfix konfigurieren

https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-18-04-de

mit leichten Anpassungen an der Firewall und certbot (s.u.) 

# Firewall bei Hetzner schärfen: 


[TODO]

# Firewall auf dem Proxmox 

Ziel ist es jede Anfrage außer Port 8006 und Port 22 auf die dahinterliegende Firewall zu lenken. 
Der erste Versuch mit UFW wurde verworfen und statt dessen direkt in die IPtabels geschrieben. 


## UFW [disabeld]

Die UFW lässt sich schön komfortabel einrichten, zur Portweiterleitung mit definierten außnahmen eignet sich dann eher direkt IPtabels.

		#apt install ufw -y
		#ufw allow SSH
		#ufw allow 8006/tcp
		#ufw enable

## Nat per Iptables: 

### Literatur

https://www.pcwelt.de/ratgeber/Ratgeber-Firewall-Linux-Firewall-fuer-Profis-mit-iptables-472858.html
https://schroederdennis.de/allgemein/proxmox-auf-rootserver-mit-nur-1-public-ip-addresse-pfsense-nat/
### Einrichtung IPtables
Die beiden Iptable-Befehle organisieren die Weiterleitung allen anfragen auf das Netzwerkdevice enp7s0, so dass diese außer port 8006 und 22 
weitergeleitet werden auf die 10.0.0.2

		post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up   echo 1 > /proc/sys/net/ipv6/ip_forward
		iptables -t nat -A PREROUTING -i enp7s0 -p udp -j DNAT --to 10.0.0.2
		iptables -t nat -A PREROUTING -i enp7s0 -p tcp -m multiport ! --dport 22,8006 -j DNAT --to 10.0.0.2
		
		
Die Befehle können in der nano /etc/network/interfaces direkt an dem device eingebunden werden. 

### Alternativer Einrichtung
Alternativ kann man diese Befehle auch direkt ausführen 

		iptables -L -v -n
		iptables-save 
		iptables -S

Um die Funktionalität zu prüfen, können die folgenden Befehle verwendet werden: 
  
		iptables -L INPUT
		iptables -L PREROUTING
		
###	Masquerading

Dem internen Networkdevice muss man ein Masquerading einrichten, so dass die Pakete auch auf ihrem Rückweg richtig zugeordnet werden. 

		post-up   iptables -t nat -A POSTROUTING -s '10.0.0.0/30' -o enp7s0 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '10.0.0.0/30' -o enp7s0 -j MASQUERADE


	
		
  
# encrypt

// wird nicht benutzt, sondern das auf der ProxmoxOberfläche generierte Certifikat

		#ufw disable 
		#apt install certbot -y
		#certbot certonly --standalone --rsa-key-size 4096 --agree-tos --preferred-challenges http -d proxmox.svws-nrw.de
		#ufw enable

		#systemctl enable certbot.timer
		#systemctl start certbot.timer

bei letsencrypt hat man zusätzlich das Problem, dass proxmox an einer anderen Stelle seine Zertifikate speichert. 
Daher besser direkt auf der Proxmoxoberfläche das Cert-generieren anstoßen.

# Proxmox Certifikate generieren



# Proxmox Backup einrichten

[ToDo]

# Benutzerverwaltung

Permissions: direkt unter Datacenter -> "permissions" (hier ... nicht in einem weiteren Unterverzeichnis) können group oder auch diskrete Userrechte zugefügt werden

User hinzufügen: unter "users" natürlich das Hinzufügen einzelner User, sinnvoll ist hier die Benutzung des PVE-Realms

Zweifaktor für den Realm aktivieren: unter "realms" -> PVE anschalten & oath auswählen

Für jeden user zum Beispiel mit Hilfe der Google Authentificator app einen TFA verknüpfen: 
	
## 	Zweifaktor Authentisierung einrichten: 
	-> two Factor 
	-> add -> totp 
	-> user auswählen 
	-> in Description MUSS irgendwas stehen 
	-> Issuer Name kann gerne angepasst werden (für den user lesbarer)
	-> Qr Code scannen 
	-> verify code 
	
und fertig ... 

# root login abschalten

Achtung: erst andere user anlegen!

		adduser username
		
login testet und dann den user login von root per ssh verbieten:

		nano /etc/ssh/sshd_config
		
Eintrag abändern auf: 
-> PermitRootLogin no

root login unter der Proxmoxoberfläche abschalten: 

 -> Datacenter
 -> permissions
 -> users
 -> root
 bei enabeled den Haken rausnehmen



# fail to ban

https://www.thomas-krenn.com/de/wiki/SSH_Login_unter_Debian_mit_fail2ban_absichern


# opensense (verworfen)

Beim Handling der OpenSense gab es Probleme mit der Durchreichung / Erreichbarkeit des DNS Dienstes und der Zertifikate zum Updaten der Opensense, 
so dass wir uns entschieden haben die Funktionalitäten des reverse Proxy und der Firewall auf einem Debian 11 zu installieren. (siehe nächstes Kapitel)
Dafür spricht, dass wir die personellen Ressourcen (im Gegensatz zur OpenSense) dazu haben.

pfSense oder OpenSense? -> OpenSense!

https://www.youtube.com/watch?v=79yuldjWccQ

https://www.youtube.com/watch?v=-mFEib0zQWg

https://www.youtube.com/watch?v=4p1lw4FEfok

# Hilfreiche Tools

apt install -y net-tools dnsutils nmap curl zip



# UFW, Gateway und Nginx als ReverseProxy

## Literatur: 

https://goneuland.de/debian-11-bullseye-ufw-uncomplicated-firewall-einrichten/

https://unknownworkspace.de/2022/05/10/reverse-proxy-unter-debian-11-installieren/

https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.


https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-debian-10/

https://askubuntu.com/questions/1151289/ufw-rules-with-nat-masquerading

https://en.wikipedia.org/wiki/Dnsmasq

# UFW einrichten

apt install ufw nmap net-tools dnsutils

ufw allow ssh 
ufw allow http
ufw allow https

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


		apt-get install -y nginx nginx-extras
		unlink /etc/nginx/sites-enabled/default


		cd /etc/nginx/sites-available
		nano reverse-proxy.conf
		
Für eine Einfach Umlenkung von Port 80 auf eine bestimmte IP im dahinterliegenden Netz folgendes Eintragen: 

		server {
			server_name wiki.svws-nrw.de;
			location / {
                proxy_pass      http://10.1.1.20;
        }
}

		ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

		nginx -t
		
		nginx -s reload

## Certifikate einrichten

		apt-get install -y certbot python3-certbot-nginx
		
Eine Emailadresse wird benötigt, um diese bei der Vergabe der Zertifikate zu hinterlegen. Hier werden Renewal-Erinnerungen hingeschickt.

VOR ausführen des python skripts "certbot --nginx" kann man schon eine einfache ReverseProxy.config anlegen mit den Domainnamen. Das Skript aktualisiert diese automatisch um die nötigen ssl Eintragungen: 

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


		certbot --nginx
		certbot renew --dry-run
		
Prüfen, ob die regelmäßge Aktivierung angeschaltet ist:
 
		systemctl list-timers
		
Prüfen, welche Domains und subdomains im certifikat aufgelistet werden: 

		certbot certificates

eine subdomain hinzufügen: 

neuen eintrag  in den servernames: 

nano /etc/nginx/sites-available/reverse-proxy.conf

Hier im Bereich hinter "default_server" die subdomain ergänzen. Die aktuelle Liste:

		server_name vpn.svws-nrw.de wiki.svws-nrw.de artifactory.svws-nrw.de  server.svws-nrw.de nightly.svws-nrw.de wenom.svws-nrw.de runner01.svws-nrw.de runner02.svws-nrw.de  graphana.svws-nrw.de  mirror.svws-nrw.de

Testen, ob die Config in Ordnung ist und laden: 

		nginx -t 
		nginx -s reload

		certbot --nginx
		
und dann die richtige nummer auswählen -> man erhält ein neues einzelzertifikat 
		
		
		
		
#### Literatur: 

https://www.debacher.de/ublog/2016/06/letsencrypt/

https://www.teslina.com/tutorials/sicherheit/ssl/lets-encrypt-ssl-zertifikate-mit-certbot-erstellen/

[ToDo]

## http auf https umlenken

[ToDo]

# nfs freigabe

## Literatur 

https://www.howtoforge.de/anleitung/wie-man-nfs-server-unter-debian-11-installiert-und-konfiguriert/

https://www.thegeekdiary.com/dependency-failed-for-nfs-server-and-services/

## installation

		apt install nfs-kernel-server rpcbind
		
		mkdir /var/nfs/
		
Inhalte in share einfügen zb. echo "test" >> /share/test.txt 
ggf. noch rechte anpassen 

		nano /etc/exports
		
Freigabe per IP eintragen: 
		/var/nfs/ 10.1.0.1/16 (ro)
		


		systemctl is-enabled nfs-server
		systemctl status nfs-server

ufw anpassen:  
		ufw allow from 10.1.0.1/16 to any port nfs
		
		
Problem: es läuft hier in einem LXC container. 
		
# ACME Chalange aus DNS umbiegen


Port 80 wird daurhaft auf die UFW geleitet, 
damit hier die Firewall und der ReverseProxy ihre Umleitungen übernehmen können. 
Das Muttersystem des Proxmox hat jedoch unter Proxmox->Certificates nur den typ http als delfault eingerichtet.  

## Literatur

https://forum.proxmox.com/threads/acme-dns-challenge-plugin-with-hetzner-ns.87589/



## neue DNS Zone anlegen und umziehen
Unter der Hetznerkonsole einen neue DNS Zone anlegen. -> DNS -> add new zone
Namen angeben & autoscanning
Übernehmen und die drei(?) Hetzner DNS-Server bei 1 blue als eigenen DNS eintragen. 

Die Zuständigkeiten im Antworten auf die IP adressen sind nun neu geregelt, 
es sollte aber keinem auffallen, weil die Antwort ja gleich geblieben ist. 

## DNS-Methode als Plugin

### Plugin installieren

Achtung: es gibt einen Unterschied zwischen dem Klassischem root login und einem user aus der admingruppe. 

Nur als root kann man unter Datacenter -> ACME sehen. Hier unter Challange Plugins -> Add 

Namengeben, DNS-API hetzner auswählen und als Api Data:  HETZNER_Token="xy..z" wählen. 

### Token anlegen

Unter DNS im Hetzner webfrontend findet man die neue Zone und rechts daneben "Api token" 
-> neuen Token erstellen und diesen in der oben beschriebenen Form im Proxmox eintragen. 

### Verfahren umstellen

unter Proxmox -> Certificates -> AMCE -> Domaineintrag wählen -> Edit: Chalangetyp DNS und das installierte Plugin wählen. 








# virtuelle Maschinen einrichten

[virtuelle Maschine einrichten](./vm_einrichten.md)

[Gitlab-Runner einrichten](./runner.md)

[Nexus-Artifactury einrichten](./artifactury.md)

[Docker auf LXH-Container einrichten](./docker.md)

[Mirror-Server einrichten](./mirror.md)

