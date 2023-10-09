# Schulungsserver mit Proxmox

## SVWS Schulung online

Zu einer Schulung ohne SchILD sind die grundlegenden Anforderungen niedrig: Sie benötigen einen Rechner mit Browser und eine Anzahl von SVWS-Servern, die auch online bereit gestellt werden können. 

Eine Schulung mit SchILD-NRW 2.0, SchILD-NRW 3.0 oder ASDPC32 kann online nur mit höherem Aufwand erfolgen: Sie benötigen entweder einen Windowsrechner oder eine Windows KVM im Schulungsnetz, die per VPN erreichbar ist.


## Aufsetzen des Proxmox-Servers

Download der aktuellsten Proxmox VE z.B. unter https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso

Setzen Sie einen Ventoy Bootstick auf und legen Sie die .iso in das Hauptverzeichnis des Bootsticks 
siehe auch https://doku.svws-nrw.de/Schulungsumgebungen/Virtualbox_Schulungsserver/

Alternativ kann auch https://etcher.balena.io/ als bootstick verwendet werden. 

Booten Sie von dem Stick und folgen sie dem Installationsdialog.

## Datenspeicher einrichten

Auf dem Datenspeicher muss noch ein .... 

## Netzwerk einrichten 

Für den Einsatz des Proxmox innerhalb eines Schulungsraumes benötigt man keine weitere Firwall oder Portweiterleitung.

vmbr0 einrichten: statische IPv4 und Subnetz und das Gateway ein. z.B. 
192.168.178.60/24 und Gateway: 192.168.178.1 bei einer klassischen Fritzbox

## Templates runterladen

 

## SVWS-Server im LCX Container

In der Regel sollte man aus Performancegründen eher einen LXContainer als eine KVM aufsetzen. Solange nichts anderes angegeben wird kann und soll man die default Einstellungen verwenden.

Create CT - Button oben rechts


    + Template wählen    
	Bsp.: Debian 12
    + Speicher, CPU und Memory angeben
	Bsp: 4GB, 2 Cores, 2048MB
    + Netzwerkeinstellungen Bridge:  
	i.d.R vmbr0, ggf eine fixe IP einrichten, falls kein DHCP vorhanden ist.

### Hilfreiche Tools installieren

apt install -y net-tools dnsutils nmap curl zip

### SVWS-Server installieren

Den Linux-Installer des SVWS-Server herunterladen und ausführen. 
siehe: https://doku.svws-nrw.de/Deployment/Linux-Installer/



