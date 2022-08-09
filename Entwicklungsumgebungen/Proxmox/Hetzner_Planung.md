# Devops Server bei Hetzner

Produkte: AX Line NVME + 2 TB SSD in Deutschland  69.02€/mntl.

Backup: 20%*69.02€ = 13,8€/mntl.

Stroage zum Backup: 5 TB -> 11,87€/mntl. 

Domain: 11,90€/a

Summe bisher: 95,68€/mntl

Rücksprache mit Bernd: Sind 6 Core, 12 Threads ausreichend ? 

# Abrechnung

- Monatlich 1/4 Jährlich und Jährlich 
- ebenso die passende Kündigungsfrist
- beim Dedivcated Server im Voraus zu bezahlen
- per Rechnung -> Überweisung auswählen

# Domain

svws-server.de

a) Umleiten oder <br> -> weitere Kosten
b) zu Hetzner übertragen -> (ggf. keine mail oder einen mailserver einrichten?) 

# mögliche Server

per Hetzner app eintichtbar: Gitlab, bbb & Nextcloud

Schätzung CPU / Ram / HD / Dienst.domainname.de

- / 5GB-10GB / 18GB+ gitlab.svws-server.de
- / 16GB / 2GB bbb.svws-server.de - geht auch weiter bei Bernd (?)
- / 5GB-10GB / 100GB artefactory.svws-server.de 
- mattermost.svws-server.de
- testserver.svws-server.de A
- 1 / 1GB svws-server.de -> blog oder wiki A
- 1 / 1GB / 8GB ldap.svws-server.de
- 2 / 2GB / 100Gb nextcloud.svws-server.de A ggf nicht notwendig
- wireguard.svws-server & reverseProxy
- mail.svws-server.de -> über Hetzner console!
- 1 / 1GB / 20GB Graphana.svws-server.de A über docker!

# Monitoring und Updates

ansible 

telegraph und Graphana



# Vlans

Sicherheit: Ein internes Vlan einrichten für die ssh Zugänge zu den Servern und zu der ProxmoxOberfläche
Zughang nur per Wirguard oder über Hetznerkonsole <- prüfen

# Backup 

direkte Snapshots auf 

über 5GB Volume - getrennte User einrichten und per mount einbinden
