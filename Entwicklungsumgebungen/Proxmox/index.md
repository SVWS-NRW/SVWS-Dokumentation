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

		apt install -y sshfs cifs-utils 

# Hilfreiche Tools

		apt install -y net-tools dnsutils nmap curl zip


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
		
```
		mount.cifs -o user=uXXXXXX-sub1,pass=abcdefghi //uxxxxxx-sub1.your-storagebox.de/uxxxxxx-sub1 /backup
```

4) dauerhaftes Mounten: 

in /etc/fstab die folgenden eintrgäge machen: 

```
//uxxxxxx-sub1.your-storagebox.de/uxxxxxx-sub1 /backup cifs iocharset=utf8,rw,credentials=/etc/backup-credentials.txt,file_mode=0660,dir_mode=0770 0 0

		nano /etc/backup-credentials.txt

user=uxxxxxx-sub1
pass=abcdefg
```

Anschießend sollte das mounten funktionieren

```sh
mount -a 
```

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

```sh
		#apt install ufw -y
		#ufw allow SSH
		#ufw allow 8006/tcp
		#ufw enable
```

## Nat per Iptables: 

### Literatur

https://www.pcwelt.de/ratgeber/Ratgeber-Firewall-Linux-Firewall-fuer-Profis-mit-iptables-472858.html
https://schroederdennis.de/allgemein/proxmox-auf-rootserver-mit-nur-1-public-ip-addresse-pfsense-nat/
### Einrichtung IPtables
Die beiden Iptable-Befehle organisieren die Weiterleitung allen anfragen auf das Netzwerkdevice enp7s0, so dass diese außer port 8006 und 22 
weitergeleitet werden auf die 10.0.0.2

```
		post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up   echo 1 > /proc/sys/net/ipv6/ip_forward
		iptables -t nat -A PREROUTING -i enp7s0 -p udp -j DNAT --to 10.0.0.2
		iptables -t nat -A PREROUTING -i enp7s0 -p tcp -m multiport ! --dport 22,8006 -j DNAT --to 10.0.0.2
```
		
Die Befehle können in der nano /etc/network/interfaces direkt an dem device eingebunden werden. 

### Alternativer Einrichtung
Alternativ kann man diese Befehle auch direkt ausführen 

```sh
iptables -L -v -n
iptables-save 
iptables -S
```

Um die Funktionalität zu prüfen, können die folgenden Befehle verwendet werden: 
  
```sh
iptables -L INPUT
iptables -L PREROUTING
```
		
###	Masquerading

Dem internen Networkdevice muss man ein Masquerading einrichten, so dass die Pakete auch auf ihrem Rückweg richtig zugeordnet werden. 

```sh
post-up   iptables -t nat -A POSTROUTING -s '10.0.0.0/30' -o enp7s0 -j MASQUERADE
post-down iptables -t nat -D POSTROUTING -s '10.0.0.0/30' -o enp7s0 -j MASQUERADE
```
	
	

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

```sh
		adduser username
```

login testet und dann den user login von root per ssh verbieten:

```sh
		nano /etc/ssh/sshd_config
```
		
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


	
  
# Proxmox Certifikate generieren

[Todo]
		
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

[UFW_ReverseProxy_co](./UFW_ReverseProxy_co.md)

[virtuelle Maschine einrichten](./VM_einrichten.md)

[Gitlab-Runner einrichten](./runner.md)

[Nexus-Artifactury einrichten](./artifactory.md)

[Docker auf LXH-Container einrichten](./docker.md)

[Mirror-Server einrichten](./mirror.md)

