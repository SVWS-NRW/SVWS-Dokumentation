# Proxmox als Schulungsserver

## SVWS Schulung online

Zu einer Schulung ohne Schild sind die grundlegenden Anforderungen niedrig: Sie benötigen einen Rechner mit Browser und eine Anzahl von SVWS-Servern, die auch online berteit gestellt werden können. 

Eine Schulung mit SchiLD2, SchiLD3 oder ASD-PC kann online nur mit höherem Aufwandt erfolgen: Sie benötigen entweder einen Windowsrechner oder eine Windows KVM im Schulungsnetz, die per VPN erreichbar ist.


## Aufsetzen des Proxmoxserver

Download der aktuellsten Proxmox VE z.B. unter https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso

Setzen Sie einen Ventoy Bootstick auf und legen Sie die .iso in das Hauptverzeichnis des Bootsticks 
siehe auch https://doku.svws-nrw.de/Schulungsumgebungen/Virtualbox_Schulungsserver/

Alternativ kann auch https://etcher.balena.io/ als bootstick verwendet werden. 

Booten Sie von dem Stick und folgen sie dem Installationsdialog.

## Datenspeicher einrichten

Auf dem Datenspeicher muss noch ein .... 

## Netzwerk einrichten 

Wenn der Proxmox innerhalb eines Schulungaraumes einsetzen möchte, dann benötigt man keine weitere Firwall oder Portweiterleitung 

vmbr0 einrichten: statische IPv4 und Subnetz und das Gateway ein. z.B. 
192.168.178.60/24 und Gateway: 192.168.178.1 bei einer klassischen Fritzbox

## Templates runterladen

 

## SVWS-Server im LCX Container

In der Regel sollte man aus Performancegründen eher einen LXContainer als eine KVM aufsetzen. Solange nichts anderes angegeben wird kann und soll man die default Einstellungen lassen.

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

Den linuxinstaller SVWS-Server herunterladen und installieren. 
siehe: https://doku.svws-nrw.de/Deployment/Linux-Installer/



