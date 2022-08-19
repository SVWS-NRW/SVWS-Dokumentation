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


## DHCP anpassen

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


## DNS Eintrag

Wenn die VM eine immer gleiche IP bzw. eine im internen DNS auffindbare FQDN hat, dann kann man dies im ReverseProxy eingetragen werden. 
So erreicht man eine Weiterleitung von einer auf Port 443 oder Port 80 aufgerufenen Anfrage an die Webservice an eine interne URL. 
Anfragen auf Port 80 werden dabei grundsätzlich auf Port 443 umgeleitet und mit einem in der UFW hinterlegten Zertifikat versehen. 
Aktuell sind bei 1 blue die folgenden subdomains aufgeführt:

+ git.svws-nrw.de
+ gitlab.svws-nrw.de
+ mattermost.svws-nrw.de
+ svws-nrw.de

Alle anderen aufgerufenen subdomain werden weitergegeben an den Server bei Hetzner und damit an den ReverseProxy. 