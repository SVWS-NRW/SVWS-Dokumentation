# Schulungsserver mit Proxmox

## SVWS Schulungsumgebung

Zu einer Schulung ohne SchILD sind die grundlegenden Anforderungen niedrig: Sie benötigen einen Rechner mit Browser und eine Anzahl von SVWS-Servern, die auch online bereit gestellt werden können. 

Eine Schulung mit SchILD-NRW 2.0, SchILD-NRW 3.0 oder ASDPC32 kann online nur mit höherem Aufwand erfolgen: Sie benötigen entweder einen Windowsrechner oder eine Windows KVM im Schulungsnetz, die per VPN erreichbar ist.


## Aufsetzen des Proxmox-Servers

Hier gibt es zwei grundlegende Ansätze: über einen Bootstick oder über eine Erweitereung einer Debian 12 Installation um die Proxmox Funktionalität. Insbesondere bei physikalischem Zugang zum Server ist der einfachste Weg der Bootstick. Bei einem gemieteten online Server ist die Einrichtung über eine vorhandene Debian Installation der bessere Weg. 

### Installation per Bootstick

Download der aktuellsten Proxmox VE z.B. unter https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso

Setzen Sie einen Ventoy Bootstick auf und legen Sie die .iso in das Hauptverzeichnis des Bootsticks 
siehe auch https://doku.svws-nrw.de/Schulungsumgebungen/Virtualbox_Schulungsserver/

Alternativ kann auch https://etcher.balena.io/ als bootstick verwendet werden. 

Booten Sie von dem Stick und folgen sie dem Installationsdialog.

### Installation auf Debian

Das installierte Debian 12 mit root-rechten updaten: 

``` bash
su -
updaten & upgraden
```

ggf. hostnamen  in ```/etc/hosts``` und ```/etc/hostname``` anpassen
in diesem Beispiel: proxmox.meine.domain
und in der /etc/hosts die locale adresse als fixe IP ersetzen:
zum Beispiel mit dem Editor nano:

``` bash
nano /etc/hosts
```
Diese sollte so aussehen für beispielsweise die ServerIP 192.168.178.16

``` bash
127.0.0.1       localhost
192.168.178.16  proxmox.meine.domain proxmox
``` 

Dies sollte auch die Netzwerkadresse in der /etc/network/interfaces sein, hier zum Beispiel für eine klassische Fritzbox installation: 
``` bash
auto eth0
iface eth0 inet static
address 192.168.178.16/24
gateway 192.168.178.1
```
### Hilfreiche Tools

``` bash
apt install -y net-tools dnsutils nmap curl zip wget
```
## Netzwerk einrichten

Auch hier gibt es zwei grundsätzliche Varianten: 

+ die Präsensschulung 
+ die Onlineschulung

Bei der Präsentsschulung befinde sich alle Schulungsteilnehmer vorort und damit hinter der Firewall in einem Bereich, wo in der Regel auch ein DHCP Server das interne Netz managed. 

Für den Einsatz des Proxmox innerhalb eines Schulungsraumes benötigt man daher keine weitere Firwall oder Portweiterleitung. Hier reicht es eine internes vit

vmbr0 einrichten: statische IPv4 und Subnetz und das Gateway ein. z.B. 
192.168.178.16/24 und Gateway: 192.168.178.1 bei einer klassischen Fritzbox





## SVWS-Server installieren

## SVWS-Server im LCX Container

In der Regel sollte man aus Performancegründen eher einen LXContainer als eine KVM aufsetzen. Solange nichts anderes angegeben wird kann und soll man die default Einstellungen verwenden.

Create CT - Button oben rechts


    + Template wählen    
	Bsp.: Debian 12
    + Speicher, CPU und Memory angeben
	Bsp: 4GB, 2 Cores, 2048MB
    + Netzwerkeinstellungen Bridge:  
	i.d.R vmbr0, ggf eine fixe IP einrichten, falls kein DHCP vorhanden ist.


### SVWS-Server installieren

Den Linux-Installer des SVWS-Server herunterladen und ausführen. 
siehe: https://doku.svws-nrw.de/Deployment/Linux-Installer/



