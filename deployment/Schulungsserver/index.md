# Schulungsserver

## Übersicht über die technischen Rahmenbedingungen

In diesem Bereich werden mögliche Lösungen für Schulumgsumgebungen skizziert.

Grundsätzlich muss unterschieden werden zwischen Präsenzschulungen und Online-Schulungen. Der wesentliche Unterschied
besteht darin, dass sich die Schulungsteilnehmer innerhalb oder außerhalb eines gemeinsam mit dem SVWS-Server genutzen,
geschützten Netzes befinden.

Diese beiden Szenarien sind vergleichbar mit der Anforderung einerseits innerhalb des Verwaltungsnetzes einer Schule
oder andererseits außerhalb, über das Internet, am SVWS-Server arbeiten zu können. Für die Online-Schulungen muss also
ein sicherer Zugang gewähleistet werden.

Der WebClient des SVWS-Servers ist dabei über Port 443 mit dem HTTPS-Protokoll hinreichend abgesichert. Für eine
zusätzliche SchILD-NRW 3-Schulung wird jedoch noch eine direkte Verbindung zur MariaDB-Datenbank, in der Regel über Port
3306, und eine Windows-Installation bzw. ein Zugang per Remotedesktop-Verbindung zu einem Windows Schulungsrechner
benötigt. Dies stellt wesentlich höhere Anforderungen an die Sicherheit und Netzarchitektur.

+ [SchulungsClient](SchulungsClient/index.md) - Ein schneller Weg zu einem einzelnen Schulungsrechner
+ [Proxmox](Proxmox_Schulungsserver/index.md) - Online-Schulungen oder Präsenzschulungen
+ [Schulungsserver per Docker](Docker_Schulungsserver/index.md) - Ressourcenschonende, cloudfähige Lösung

