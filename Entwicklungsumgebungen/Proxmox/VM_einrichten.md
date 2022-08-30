# neue VM im Proxmox aufsetzen

## LXC Container

In der Regel sollte man aus Performancegründen eher einen LXContainer als eine KVM aufsetzen. 
Solange nichts anderes angegeben wird kann und soll man die default Einstellungen lassen. 

+ Create CT - Button oben rechts 

+ CT-ID nach internen Absprache auswählen: CT-ID soll die IP wiederspiegeln  
Bsp: 10.1.5.1 -> CT_ID 151  
Bei "Wegwerfmaschinen" einfach CT-IT> 200 nehmen. 

+ Template wählen  
Bsp.: Debian 11

+ Speicher, CPU und Memory angeben

+ Wichtig: Bridge: vmbr2 und bei IPv4 DHCP aktivieren

## Dokumentation

links den neuen Container auswählen und unter Summary auf der rechten Seite kann man die Notes bearbeiten. 
Hier kann man temporär das Passwort hinterlegen
ebenso den dhcp Eintrag (s.u.) 


## DHCP anpassen (optional)

Falls man immer wieder die gleiche IP vom DHCP bekommen möchte sollte man dies so einrichten. Dies ist bei "Wegwerfmaschinen" o.Ä. 
in der UFW einloggen (auf UFW klicken und auf Console oben rechts klicken) und dort mit 

		nano  /etc/dnsmasq.conf

bei den festen IP Zuweisungen, etwas weiter hinten im Text, einen neuen Eintrag machen. Zum Beispiel: 

		dhcp-host=06:77:42:18:90:4F,wenom.svws-nrw.de,10.1.4.4

syntax: dhcp-host=MAC-Adresse,FQDN,IP

reboot des dnsmasq dienstes: 

		 systemctl restart dnsmasq
		
In der eigentlichen maschine muss das Netzwerkdevice auch einmal neu gestartet werden. zum Beispiel mit einem reboot oder: 

		/etc/init.d/networking restart

Nun bekommt die VM immer die gleiche IP-Adresse. Wird keine IP festgelegt, bekommt die VM eine IP in der Range 10.1.2.20 - 10.1.2.200.


## DNS Eintrag (optional) 

Wenn die VM eine immer gleiche IP bzw. eine im internen DNS auffindbare FQDN hat, dann kann man dies im ReverseProxy eingetragen werden. 
So erreicht man eine Weiterleitung von einer auf Port 443 oder Port 80 aufgerufenen Anfrage an die Webservice an eine interne URL. 
Anfragen auf Port 80 werden dabei grundsätzlich auf Port 443 umgeleitet und mit einem in der UFW hinterlegten Zertifikat versehen. 
Aktuell sind bei 1 blue die folgenden subdomains aufgeführt:

+ git.svws-nrw.de
+ gitlab.svws-nrw.de
+ mattermost.svws-nrw.de
+ svws-nrw.de

Alle anderen aufgerufenen subdomain werden weitergegeben an den Server bei Hetzner und damit an den ReverseProxy. 
Hier sind im config file diverse Eintragungen von subdomains schon gemacht und können wie folgt ergänzt werden:

		
## Eintragung im ReverseProxy (optional) 

		nano /etc/nginx/sites-available/reverse-proxy.conf

Hier im Bereich hinter "default_server" die subdomain ergänzen. Die aktuelle Liste:

		server_name vpn.svws-nrw.de wiki.svws-nrw.de artifactory.svws-nrw.de  server.svws-nrw.de nightly.svws-nrw.de wenom.svws-nrw.de runner01.svws-nrw.de runner02.svws-nrw.de  graphana.svws-nrw.de  mirror.svws-nrw.de

Testen, ob die Config in Ordnung ist und laden: 

		nginx -t 
		nginx -s reload


## Zertifikat einrichten 

Man hat mehrere Möglichkeiten ein Zertifikat und damit ssl und https zu benutzen 

+ ein eigenes Zetifikat erstellen
+ ein eigenes Zetifikat erstellen und bei let's encrypt zu signieren 
+ das per nfs freigegebenes Zertifikat zu benutzen ohne Eintragung bei let´s entcrypt
+ das per nfs freigegebene Zertifikat zu benutzen mit Eintrag bei Let´s encrypt

Die beste Methode ist es ein eigenes Zertifikat jeder einzelnen subomain per certbot zu erstellen und anschließens bei bedarf noch die ssl Einstellungen in der Komunikation nachzuschärfen. 
Die Erstellung erfolgt comfortabel über certbot: 
		certbot --nginx
Bei dem Auswahldialog die entsprechende subdomain auswählen und das Zertifikat wird unter /etv/letsencrypt/live/sub.domain.name gespeichert. 

Bei der Komunikation nach außen wird dann dieses Zertifikat verwendet. 

# strong ssl

möchte man nun das die Komunikationsmöglichkeiten noch sicherer gestalten, dann kann man die folgenden Einträge unter dem 'listen 443 ssl' bei der entsprechenden Domain nachtragen: 