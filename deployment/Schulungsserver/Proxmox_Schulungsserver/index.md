# Schulungsserver mit Proxmox

## SVWS Schulungsumgebung

Zu einer Schulung ohne SchILD sind die grundlegenden Anforderungen niedrig: Sie benötigen einen Rechner mit Browser und eine Anzahl von SVWS-Servern, die auch online bereit gestellt werden können. 

Eine Schulung mit SchILD-NRW 2.0, SchILD-NRW 3.0 oder ASDPC32 kann online nur mit höherem Aufwand erfolgen: Sie benötigen entweder einen Windowsrechner oder eine Windows KVM im Schulungsnetz, die per VPN oder Guacamole erreichbar ist.


## Aufsetzen des Proxmox-Servers

Hier gibt es zwei grundlegende Ansätze: per ISO oder über eine Erweiterung einer Debian 12 Installation um die Proxmox Funktionalität. Insbesondere bei physikalischem Zugang zum Server ist der einfachste Weg per ISO und Bootstick. Bei einem gemieteten online Server ist die Einrichtung über eine vorhandene Debian Installation der einfachere Weg. Dies ist jedoch nicht bei jeden Anbieter möglich ggf. kann dann auch per ISO installiert werden. 

### Installation Vorort per ISO auf einem Bootstick

Download der aktuellsten Proxmox VE z.B. unter https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso

Setzen Sie einen Ventoy Bootstick auf und legen Sie die .iso in das Hauptverzeichnis des Bootsticks.

Alternativ kann auch https://etcher.balena.io/ als bootstick verwendet werden. 

Booten Sie von dem Stick und folgen sie dem Installationsdialog.

### Installation auf der privaten Cloud

#### per ISO

Die oben beschrieben ISO kann über die Konfigurationsoberfläche beim Dienstleister i.d.R. eingelesen werden, 
so dass der nächste Bootvorgang über diese ISO erfolgt. 
Der Installationsdialog des Prommox-Servers kann dann via VNC gesteuert werden. 

#### auf einem Debian Grundsystem

Das installierte Debian 12 mit root-rechten updaten: 

``` bash
apt update && apt upgrade -y
```

+ Apt Sources einbinden 
+ updaten
+ Installationsanleitung folgen  

### Einstellungen im Installationsdialog  

Ggf. müssen hostnamen  in ```/etc/hosts``` und ```/etc/hostname``` anpassen
in diesem Beispiel: proxmox.meine.domain
und in der /etc/hosts die locale adresse als fixe IP ersetzen:
zum Beispiel mit dem Editor nano:

``` bash
nano /etc/hosts
```
Diese sollte so aussehen für beispielsweise die ServerIP 192.168.178.16 und die Domain proxmox.meine.domain

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
### Hilfreiche Einstellungen

Hilfreiche Tools und ggf die Localse auf die Deutsche Umlaute anpassen: 
``` bash
apt install -y net-tools dnsutils nmap curl zip wget 
dpkg-reconfigure locales
```

Wenn kein Enterprise Support bei Proxmox abgeschlossen ist, kann kostenfrei die Community Version genutzt werden. Hierzu müssen in den Apt-Sources die Quellen für PVE und Ceph in der Enterprise version nur auskommentiert werden. Eine Anleitung hierzu befindet sich auf der (Proxmox Webseite)[https://pve.proxmox.com/wiki/Package_Repositories].


## Präsensschulung

Bei der Präsentsschulung befinde sich alle Schulungsteilnehmer vorort und damit hinter der Firewall in einem Bereich, wo in der Regel auch ein DHCP Server das interne Netz managed. 

Für den Einsatz des Proxmox innerhalb eines Schulungsraumes benötigt man daher keine weitere Firwall oder Portweiterleitung. Hier reicht es eine internes virtuelle Bridge einzurichten, so dass die virtuellen Maschinen oder Container sich wie normals PCs im Schulungsnetz verhalten. Hier sind ggf Abstimmungen mit dem Netzwerkadministrator nötig, falls ein Macfilter o.Ä. die Vergabe der IPs im Internen Netz verhindert. Ggf müssen auch Anpassungen an der Firewall abgestimmt werden. 

Es können nun mehrere SVWS-Server als LX Container innerhalb des Schulungsnetzes eingerichtet werden. Siehe dazu Einrichtung des [
    Schulungsclient](../SchulungsClient/)

Falls Schulungen mit Schild 2.0, Schild 3.0 oder ASDPC durchgeführt werden sollen, können weiterhin die bestehenden Windows Rechner im Schulungsnetzwerdngenutzt werden. 

Die Einrichtung von Schild3 bei einem bestehenden SVWS-Server kann unter Installationsmethoden (Schild3)[../deployment/Schild-NRW3] nachgelesen werden. 

## Onlineschulung

### Netzwerkeinrichtung

Zunächst muss bei einem angemieteten Server mit nur einer IP ein internes Netzwerk eingerichtet werden. Die einfachste methode ist hierbei per SDN


### Übersicht über die Server 

Bei der Onlineschulung werden im folgenden Server benötigt: 

+ Firewall und ReverseProxy
+ Guacalome Videobridge für Schild3
+ Win 11 Client mit Schild3 für die Anzahl der Teilnehmer
+ SVWS-Server im LX oder Docker Container
+ Webserver für die Schulungsunterlagen


### Bereitstellung eines LXC-Container per Skript

Als Grundlage für die SVWS-Server Installation wird hier ein Debian Linux 13 verwendet. Dies kann zum Beispiel über einen Proxmox-Sever als LX-Container bereitgestellt werden. 

Hier ein Skript zum erstellen dieses Template Containers mit 4 Gb Ram, 2 CPU und 8GB Storage. Das Skript muss auf dem Terminal des Proxmoxservers ausgefürt werden.

link to pve_create_lxc.sh



