# Server-Installationen

In diesem Bereich sollen die verschiedenen Installtionsvarianten beschrieben werden.
Außerdem werden Anleitungen und Hinweise gegeben zu empfohlenen Technologien die zur Erhöhung der IT-Sicherheit verwendet werden sollten.

## Deployment 
Hier werden verschiedene Varianten beschrieben, wie der SVWS-Server in Schulen betrieben werden kann.

-> [Deployment](001_Deployment.md)

## Installation des SVWS-Servers

Hier ist dokumentiert, wie ein SVWS-Server, unter Anderem zu Testzwecken,  auf einem frisch installierten Debian 11 installiert wird:

-> [Installation des SVWS-Servers](002_Installation_SVWS-Server.md)

## Update des SVWS-Servers. 

Um den SVWS-Server im realistischen Umfeld zu testen, haben wir bei einem bekannten deutschen Hoster einen Server angemietet und betreiben hier eine Serverinstanz. 
Hier sind die notwendigen Schritte beschrieben, wie unser Testserver aktualisiert wird.

-> [Updateschritte für unseren Testserver](003_Update_SVWS-Server.md)

Die Daten der Schulen wurden mit Schutzbedarf hoch eingestuft.
Die verwendete Soft- und Hardware-Architektur muss dem festgestellten Schutzbedarf entsprechen.

# Die weitere IT Umgebung:

## ReverseProxy-Server

Diese Anleitung beschreibt die Einrichtung von Nginx unter Debian.

-> [Einrichtung eines NGinx als ReverseProxy-Server](004_Installation_ReverseProxy-Server.md)

## VPN-Server

Hier finden Sie eine Anleitung zur Einrichtuing eines VPN-Servers am Beispiel von Wireguard. 

-> [Einrichtung eines Wireguard-VPN-Servers](005_Installation_VPN-Server.md)


