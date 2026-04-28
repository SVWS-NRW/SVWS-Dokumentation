# Schulungsserver mit Proxmox

## SVWS Schulungsumgebung

Zu einer Schulung ohne SchILD-NRW 3 sind die grundlegenden Anforderungen niedrig: Sie benötigen einen Rechner mit Browser und eine Anzahl von SVWS-Servern, die auch online bereit gestellt werden können.

Eine Schulung mit SchILD-NRW 2, SchILD-NRW 3 oder ASDPC32 kann online nur mit höherem Aufwand erfolgen: Sie benötigen entweder einen Windowsrechner oder eine Windows KVM im Schulungsnetz, die per VPN oder Guacamole erreichbar ist.


## Aufsetzen des Proxmox-Servers

Hier gibt es zwei grundlegende Ansätze: per ISO oder über eine Erweiterung einer Debian 13 Installation um die Proxmox Funktionalität. Insbesondere bei physikalischem Zugang zum Server eignet sich der Weg per ISO und Bootstick. Bei einem gemieteten online-Server ist die Einrichtung über eine vorhandene Debian Installation der empfohlene Weg. Dies ist jedoch nicht bei jeden Anbieter möglich, ggf. kann dann auch per ISO installiert werden.

### Installation Vor Ort per ISO auf einem Bootstick

Download der aktuellen Proxmox VE z.B. unter https://www.proxmox.com/de/downloads/proxmox-virtual-environment/iso

Setzen Sie einen Ventoy Bootstick auf und legen Sie die `.iso` in das Hauptverzeichnis des Bootsticks.

Alternativ kann auch https://etcher.balena.io/ als Bootstick verwendet werden.

Booten Sie von dem Stick und folgen sie dem Installationsdialog.

### Installation auf der privaten Cloud

#### Per ISO

Die oben beschriebene ISO kann über die Konfigurationsoberfläche beim Dienstleister i.d.R. eingelesen werden, so dass der nächste Bootvorgang über diese ISO erfolgt.

Der Installationsdialog des Prommox-Servers kann dann via VNC gesteuert werden.

#### Auf einem Debian Grundsystem

Das installierte Debian 13 mit root-Rechten updaten:

``` bash
apt update && apt upgrade -y
```

+ Apt Sources einbinden
+ updaten
+ Installationsanleitung folgen

### Einstellungen im Installationsdialog

Ggf. müssen Hostnamen  in `/etc/hosts` und `/etc/hostname` angepasst werden.

In diesem Beispiel: `proxmox.meine.domain`

Und in der `/etc/hosts` die lolale Adresse als fixe IP ersetzen, zum Beispiel mit dem Editor nano:

```bash
nano /etc/hosts
```

Diese sollte so aussehen für beispielsweise die Server-IP `19.168.178.16` und die Domain `proxmox.meine.domain`:

```bash
127.0.0.1       localhost
192.168.178.16  proxmox.meine.domain proxmox
```

Dies sollte auch die Netzwerkadresse in der `/etc/network/interfaces` sein, hier zum Beispiel für eine klassische FritzBox installation:

```bash
auto eth0
iface eth0 inet static
address 192.168.178.16/24
gateway 192.168.178.1
```

### Hilfreiche Einstellungen

Hilfreiche Tools und ggf. die Spracheinstellungen anpassen:

``` bash
apt install -y net-tools dnsutils nmap curl zip wget
dpkg-reconfigure locales
```

Wenn kein Enterprise Support bei Proxmox abgeschlossen ist, kann kostenfrei die Community Version genutzt werden. Hierzu müssen in den Apt-Sources die Quellen für PVE und Ceph in der Enterprise-Version nur auskommentiert werden. Eine Anleitung hierzu befindet sich auf der (Proxmox Webseite)[https://pve.proxmox.com/wiki/Package_Repositories].

## Präsenzschulung

Bei der Präsenzschulung befinden sich alle Schulungsteilnehmer vor Ort und damit hinter der Firewall in einem Bereich, wo in der Regel auch ein DHCP Server das interne Netz organisiert.

Für den Einsatz des Proxmox innerhalb eines Schulungsraumes benötigt man daher keine weitere Firwall oder Portweiterleitung. Hier reicht es, eine interne virtuelle Bridge einzurichten, so dass die virtuellen Maschinen oder Container sich wie normals PCs im Schulungsnetz verhalten. Hier sind ggf Abstimmungen mit dem Netzwerkadministrator nötig, falls ein MAC-filter o.Ä. die Vergabe der IPs im internen Netz verhindert. Ggf müssen auch Anpassungen an der Firewall abgestimmt werden.

Es können nun mehrere SVWS-Server als LX-Container innerhalb des Schulungsnetzes eingerichtet werden. Siehe dazu Einrichtung des [Schulungsclient](../SchulungsClient/).

Falls Schulungen mit SchILD-NRW 2, SchILD-NRW 3 oder ASDPC durchgeführt werden sollen, können weiterhin die bestehenden Windows-Rechner im Schulungsnetzwerk genutzt werden.

Die Einrichtung von SchILD-NRW 3 bei einem bestehenden SVWS-Server kann unter Installationsmethoden (SchILD-NRW 3)[../deployment/Schild-NRW3] nachgelesen werden.

## Onlineschulung

### Netzwerkeinrichtung

Zunächst muss bei einem angemieteten Server mit nur einer IP ein internes Netzwerk eingerichtet werden. Hier wird häufig SDN verwendet.

### Übersicht über die Server

Bei der Onlineschulung werden die folgenden Server benötigt:

+ Firewall und Reverse-Proxy
+ Guacalome Videobridge für SchILD-NRW 3
+ Windows 11 Client mit SchILD-NRW 3 für die Anzahl der Teilnehmer
+ SVWS-Server im LX- oder Docker-Container
+ Webserver für die Schulungsunterlagen


### Bereitstellung eines LXC-Container per Skript

Als Grundlage für die SVWS-Server Installation wird hier ein Debian Linux 13 verwendet. Dies kann zum Beispiel über einen Proxmox-Sever als LX-Container bereitgestellt werden.

Hier ein Skript zum erstellen dieses Template-Containers mit 4 GB Ram, 2 CPU und 8GB Storage. Das Skript muss auf dem Terminal des Proxmoxservers ausgefürt werden:

[pve_create_lxc.sh](https://github.com/SVWS-NRW/SVWS-Dokumentation/blob/main/deployment/Schulungsserver/Proxmox_Schulungsserver/pve_create_lxc.sh)

Die nötigen, serverspezifischen Variablen können in eine `.env`-Datei ausgelagert werden:

Hier ein Beispiel:

```bash
# Proxmox Infrastruktur

LXC_TEMPLATE="local:vztmpl/debian-13-standard_13.1-1_amd64.tar.zst"
GATEWAY="10.0.0.10"
VSWITCH="Intranet"
STORAGE="local-lvm"

# Einstellungen für den neuen LXC

# ROOTPW= # (optional)
```
