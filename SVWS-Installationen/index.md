# Server-Installationen

In diesem Bereich sollen die verschiedenen Installtionsvarianten beschrieben werden.
Außerdem werden Anleitungen und Hinweise gegeben zu empfohlenen Technologien die zur Erhöhung der IT-Sicherheit verwendet werden sollten.

## Deployment 
Hier werden verschiedene Varianten beschrieben, wie der SVWS-Server in Schulen betrieben werden kann.

-> [Deployment](Deployment.md)

## Installation des SVWS-Servers

Hier ist dokumentiert, wie ein SVWS-Server, unter Anderem zu Testzwecken,  auf einem frisch installierten Debian 11 installiert wird:

-> [Installation des SVWS-Servers](Installation_SVWS-Server.md)

## Update des SVWS-Servers. 

Um den SVWS-Server im realistischen Umfeld zu testen, haben wir bei einem bekannten deutschen Hoster einen Server angemietet und betreiben hier eine Serverinstanz. 
Hier sind die notwendigen Schritte beschrieben, wie unser Testserver aktualisiert wird.

-> [Updateschritte für unseren Testserver](Update_SVWS-Server.md)

Die Daten der Schulen wurden mit Schutzbedarf hoch eingestuft.
Die verwendete Soft- und Hardware-Architektur muss dem festgestellten Schutzbedarf entsprechen.

# Die weitere IT Umgebung:

Der SVWS-Server ist in der Regel nicht der einzige PC bzw. Server in der Schulverwaltung und muss auch im Zusammenspiel mit gängige Einrichtungen im IT-Umfeld von 
Schulen harmonieren. Im Folgenden finden Sie nützliche Installationsanleitung, die in unserer SVWS-Umgebung getestet wurden. 
Es handelt sich dabei um gängige Einrichtungen in IT-Umfeld von Schulen und weitstgehend frei zugänglichen OpenSource Lösungen. 
Ob diese Beispiele so installiert werden entscheiden die auf kommunaler und schulischer Ebene Zuständigen. 
Dies ist keine zwingende Voraussetzung zum Betrieb des SVWS-Servers und kann daher als optionale Möglichkeit verstanden werden.  

## VPN-Server

Mit einem VPN-Server kann die Möglichkeit geschaffen werde über eine sicher Verbindung vom Homeoffice ins schulische Verwaltungsnetz einzuwählen. 
Hier finden Sie eine Anleitung zur Einrichtung eines VPN-Servers am Beispiel von Wireguard:

-> [Beispiel: Einrichtung eines Wireguard-VPN-Servers](IT-Umgebung/Installation_VPN-Server.md)

## ReverseProxy-Server


Diese Anleitung beschreibt die Einrichtung von Nginx unter Debian.

-> [Beispiel: Einrichtung eines NGinx als ReverseProxy-Server](IT-Umgebung/Installation_ReverseProxy-Server.md)


## Portfreigaben im Router

Je nach IT-Landschaft kann und muss eine Portfreigabe nur durch das zuständige Rechenzentrum oder die Zuständigen des kommunalen Trägers geschehen. 
Bei vielen Schulen gibt es jedoch einen eigenen Zugang, der oft mit einer FritzBox ausgestattet ist. 

-> [Beispiel: Einrichtung einer Portfreigabe in einer FritzBox](IT-Umgebung/Einrichtung_Portfreigabe.md).

## Proxmox-Container

Viele IT Dienstleister und Schulen benutzen Virtualisierungen zum Betrieb ihrer Server. 
Dies birgt sehr viele Vorteile, die hier nicht alle aufgelistet werden sollen. 
Hier finden Sie eine Anleitung zur Einrichtung eines LXH-Containers. 
In unseren Testumgebungen wurden in solchen Szenarien der SVWS-Server, Wireguard-VPN-Server sowie die der Reverse-Proxy-Server installiert. 

-> [Beispiel: Einrichtung eines LXH-Containers auf einem Proxmox-Server](IT-Umgebung/Einrichtung_Proxmox-Container.md)
