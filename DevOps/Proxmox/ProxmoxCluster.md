## Literatur

https://docs.hetzner.com/robot/dedicated-server/network/vswitch/#how-do-i-setup-a-vswitch

https://docs.hetzner.com/de/cloud/networks/connect-dedi-vswitch/

https://docs.hetzner.com/de/robot/dedicated-server/network/vswitch/

## Vorbereitung Hetzner Konsole

Einloggen auf der Hettner Konsole und unter Robots server > vswitch hinzufügen 

Anschließend unter dem  vswitch alle in Frage kommenden Server hinzufügen. 

## Netzwerkarte VLAN implementieren

Die Netzwerke auf den entsprechend teilnehmende Servern setzen: 

Achtung IP darf sich nicht wieder holen (192.168.100.1, 192.168.100.2, ...) und die Netzwerkkarte hat einen indifiduellen namen unter debian. 
Hier ein Beispiel für die Karte enp0s:


´´´´bash
# /etc/network/interfaces
auto enp0s.4000
iface enp0s.4000 inet static
  address 192.168.100.1
  netmask 255.255.255.0
  vlan-raw-device enp0s
  mtu 1400
´´´´
Anschließend noch gegenseitig per ping testen, ob auch die Erreichbarkeit gewährleistet ist. 

# Cluster aufbauen

## Literatur

https://www.thomas-krenn.com/de/wiki/Proxmox_HA_Cluster_erstellen

https://www.youtube.com/watch?v=WloayeIWYcg

## Vorbereitung

Unter /etc/hosts in jedem Node entsprechend die locale IP und den Nodenamen eintragen, 
damit ein Weiterarbeiten des Clusters auch nach Ausfall des DNS möglich ist.


## Cluster erstellen
Aus dem primären Node unter Datacenter -> Cluster -> Cluster erstellen anklicken. 

Einfach einen freiwälhbaren Namen hier eintragen und unter link am Besten die interne Netzwerkkarten verbinden, 
die nur zur Synchronisation per VLAN vorgesehen sind. Als Fallback kann noch die externe IP eingetragen werden. 
Prinzipiell kann der Trafic auch direkt über die externe IP laufen, dies könnte aber mit zunehmender Netzwerkgröße 
bremsend wirken. Problematisch können dann auch separat anfallende Kosten werden. 

Unter Datacenter -> Cluster kann man die Join Informationen für die noch hinzuzufügenden Nodes kopieren. 

## Cluster hinzufügen

Achtung: der Node verliert die selbt verwalteten Informationen, wie userlogins und zugeordneten VMs an den Cluster. 
Also immer nur einen blanken Node hinzufügen. 

auf dem Node unter Datacenter -> Cluster die vorher kopierte Join Information bei Join Cluster eintragen und die entsprechenden localen Netzwerkkarten als Gegenlink angeben. 

Bei Join werden alle verbindungen gekappt und man muss sich anschließend neu einloggen. 