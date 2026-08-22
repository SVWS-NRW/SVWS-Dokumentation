# Schulungsserver

## Technische Rahmenbedingungen

Grundsätzlich ist zwischen Präsenz- und Onlineschulungen zu unterscheiden. Der wesentliche Unterschied besteht darin, dass sich die Schulungsteilnehmenden entweder innerhalb eines geschützten Netzwerks befinden oder von außerhalb über das Internet zugreifen.

Dies entspricht dem Zugriff auf den SVWS-Server aus dem Verwaltungsnetz einer Schule beziehungsweise von außerhalb. Für Onlineschulungen muss daher ein sicherer Zugang bereitgestellt werden.

Der WebClient des SVWS-Servers ist über HTTPS (Port 443) ausreichend abgesichert. Für Schulungen mit SchILD-NRW 3 werden zusätzlich eine direkte Verbindung zur MariaDB-Datenbank (Port 3306) sowie eine Windows-Installation oder ein Remotedesktop-Zugang benötigt. Dadurch ergeben sich höhere Anforderungen an die Sicherheits- und Netzarchitektur.

## Schulungsserver - Beispiele

Beispiele zur Umsetzung eines Schulungsservers hierzu finden Sie auf den Github Seiten ["SVWS-Schulungsunterlagen"](https://svws-nrw.github.io/Schulungsunterlagen/) der Beziksregierungen

Hier finden Sie die folgenden Beispiele:

+ Virualbox Schulungsclient - Ein schneller Weg zu einem einzelnen Schulungsrechner
+ Proxmox Schulungsserver - Online-Schulungen oder Präsenzschulungen
+ Docker Schulungsserver - Ressourcenschonende, cloudfähige Lösung
