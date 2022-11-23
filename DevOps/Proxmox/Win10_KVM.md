# Windows 10 Client 

als KVM im Proxmox aufsetzen 

## Literatur

https://pve.proxmox.com/wiki/Windows_10_guest_best_practices

http://www.linux-kvm.org/page/Virtio

https://forum.proxmox.com/threads/virtio-treiber-problem-windows-10-server2019-unter-pve-7-0-x.92850/

## Isos

+ download aktuelle .iso Win10 bei Microsoft
+ download VirtIO-Treiber-iso: https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers
+ upload isos in der WebGiu der Proxmox in den entsprechenden Storage. 

Alternativer Weg:   
Bei Speicherplatzproblemen oder Trafikproblemen kann man in der root-Konsole des Proxmox auch per `wget URL_to_iso` 
die isos direkt in das Verzeichnis /var/lib/vz/templates/iso/ downloaden. 

## KVM konfigurieren

+ create KVM
+ iso image Win10 zuordnen 
+ Type windows 10 und Version angeben 
+ SCISI Controller: VirtIO SCSI auswählen
+ Quemu Agent: checked
+ BIOS: Default (SeaBIOS)
+ Cache: write Back auswählen
+ Netzwerkkarte: VirtIO (paravirtualized) 
+ noch nicht starten 

## Workaround

Bei der aktuellen Proxmox 7 und Windows 10 in Deutsch. Nach Erstellen der KVM unter Hardware noch die zweite ISO mit den VirtIO Treibern einbinden. 
Workaround bei NetzwerkkartenProblemen: Machine: q35 auswählen Version 6.0 !!!! (ggf auch nachträglich ändern), dann sollte der Treiber geladen werden.
Achtung: Mit q35 muss man die Laufwerke noch auf SATA umstellen, mit zwei IDEs gibt es Probleme. 

Es emfiehlt sich für die Erstinstallation von Windows die Netzwerkkarte zu deaktivieren, um die verknüpgung mit den Microsoft-Cloud-Diensten (einfach) zu umgehen. 


## Windows installation

-> starten der KVM
-> dem Windows Installationsdialog folgen 
-> beim Harddisk-Dialog der Installationsroutine den Treieber von der eingebundenen Iso nachladen
-> weiter dem Installtionsdialog folgend und Cloud Dienste ablehnen
-> Windows nach der Installation herunterfahren 
-> Netzwerkkarte aktivieren
-> Treiber von der eingebundenen Iso installieren: virtio-win-gt-x64
-> Tools von der eingebundenen Iso installieren: virtio-win-guest-tools

 



