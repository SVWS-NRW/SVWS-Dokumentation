# IT-Umgebungen


## Szenarien

Der SVWS-Server ist so ausgelegt, dass er in allen schulischen Umfeldern eingesetzt werden kann. 
Wichtige Grundlage ist dabei weiterhin der dezentrale Ansatz, der im Land NRW vertreten wird:   
Kleine Grundschulen haben die Schulverwaltungssoftware ggf. auf einem Rechner installiert, größere Schulen besitzen unter Umständen einen oder mehrere Server. 
Andere Schulen haben IT-Dienstleister, die sie mit Serverinstallationen unterstützen. Denkbar ist ebenso der zentrale Einsatz in Rechenzentren. 

## Einzelplatz-Rechner
Mit Hilfe des Windows Installers kann der SVWS-Server und SchILD-NRW 3.0 auf einem einfachen PC mit Windows 10(64bit) oder Windows 11 Betriebssystem installiert werden. 
Der SVWS-Server öffnet dabei den Port 443, so dass der SVWS-Client auch von anderen Computern im Netzwerk erreicht werden kann.
Ein echter Server-Betrieb ist dadurch allerdings nicht gewährleistet, da der Einzelplatzrechner i.d.R. heruntergefahren wird.
Diese Installationsvariante ist für sehr kleine Schulen ohne weitere IT-Umgebung bzw. IT-Unterstützung denkbar.

![Einzelplatzinstallation_einfach.png](./graphics/Einzelplatzinstallation_einfach.png)

## Eigener Server im Schulverwaltungsnetz

Die Variante einen eigenen Server in der Schule zu betreiben, der im Verwaltungsnetzwerk abgekoppelt vom pädagogischen Netzwerk betrieben wird, 
ist die häufigste Installations-Art. Auch hier wird der Port 443 intern geöffnet, so dass der SVWS-Web-Client mit einem Web-Browser aufgerufen werden kann. 
Der SVWS-Server kann hierbei sowohl auf einerm windows- als auch auf einem linuxbasierten Rechner betrieben werden. 
Die Installation auf Linuxbasis ermöglicht den Schulen bzw. den Schulrägern eine komplett lizenzkostenfreie Installation des SVWS-Servers basierend auf Open Source Software. 

Das Zertifikat, welches bei der Installation erstellt wird, sollte dann an die Clients per Gruppenrichtlinie oder manuell verteilt 
werden, damit der Browser die Verbindung auch als sicher einstuft. 
Alternativ kann der Server per Certbot ggf. über einen dazwischengeschalteten ReverseProxy zertifiziert werden. 

Über eine Dateifreigabe im lokalen Netz oder eine Gruppenrichtlinie kann SchILD-NRW 3.0 auf den Windows-Clients verteilt werden. Vorerst muss SchILD-NRW 3.0 eine Verbindung zum SVWS-Server und auch direkt zur MariaDB des SVWS-Servers einrichten und aufbauen. Perspektivisch wird der Zugriff auf die MariaDB durch Nutzung entsprechender Web-Services des SVWS-Servers ersetzt werden, so dass nur noch eine Verbindung zum SVWS-Server benötigt wird.

![Serverinstallation_Schule_ohne_VPN_einfach.png](./graphics/Serverinstallation_Schule_ohne_VPN_einfach.png)

## Kommunaler Server im Rechenzentrum

In größeren Umgebungen sind verschiedene Varianten der Installation denkbar. So können mehrere SVWS-Server auch die Funktionalität von SchILD*zentral* übernehmen. 
Die Trennung der Schemata ist hier eine wichtige Datenschutzmaßnahme. Dies kann innerhalb eines großen MariaDB-Servers oder auch mit mehreren kleinen MariaDB Instanzen erfolgen. 
In Rechenzentren macht es aus lizenzgründen Sinn auf Linux-Systeme zu setzen, so dass hier mit Docker-Containern oder auch LX-Containern gearbeitet werden kann. Des Weiteren können auch einzelne virtuelle Maschinen (KVM) in Virtualisierungssystemen wie zum Beispiel Proxmox, VMWare, HyperV, etc. erstellt und den jeweiligen Schulen zugeordnet werden. Es ist auch möglich, jedoch eher für Schulsysteme oder Dependancen sinnvoll, mehrere Schul-Schemata über einem SVWS-Server bereitzustellen. 

Welche Kombination der Installationsmöglichkeiten die Beste ist, 
sollte sicherlich anhand der lokalen Gegebenheiten und den hier zugänglichen Ressourcen entschieden werden. 

![Serverinstallation_Schule_ohne_VPN_einfach.png](./graphics/Serverinstallation_Rechenzentrum_einfach.png)


## FAQ

### Was bedeuten die Begriffe SVWS-Server und SchILD-NRW 3.0

Der SVWS-Server ist ein in Java geschriebener Web-Server, der eine API und einen Web-Client zur Verfügung stellt.
Der Web-Client wird in der Version 1.0.0 zunächst die Funktionalitäten von Kurs42 und Lupo übernehmen, da diese Programme die
neue Datenbankstruktur nicht mehr unterstützen.
Dieser muss also nur von Schulformen mit gymnasialer Oberstufe genutzt werden, wenn Blockung und Klausurterminplanung gewünscht sind.

SchILD-NRW 3.0 ist weiterhin ein in Delphi geschriebenes Programm, welches auf Windows-Systemen betrieben werden muss.
Das Programm benötigt in einer Übergangsphase weiterhin Zugriff auf die Datenbank. Hier wird aber sukzessive auf die API umgestellt.
SchILD-NRW 3.0 wird in den kommenden Jahren noch genutzt werden müssen. Die Installation dieses Programm ist der Installation von SchILD-NRW 2.0 sehr ähnlich.

### Welche Browser werden vom SVWS-Web-Client unterstützt?

Der Web-Client wird mit Firefox, Chrome, Edge und Safari getestet.

### Warum wird ein selbstsigniertes Zertifikat genutzt und kann man das ändern?

Bei der Installation wird ein selbstsigniertes Zertifikat erstellt, welches in einem internen Netzwerk genutzt werden kann.
Eigene Zertifikate können in den Keystore des SVWS-Server geladen werden. Eine Anleitung dazu wird zur Verfügung gestellt.

### Wird pro Schule ein eigener virtueller Server benötigt?

Nein. Ein Server kann so konfiguriert werden, dass er von mehreren Schulen datenschutzsicher genutzt werden kann.
Abhängig von den lokalen Gegebenheiten, kann das sinnvoll sein.

### Liegt die Datenbank auf einem seperaten Server?

Das kann individuell konfiguriert werden. Beide Varianten sind möglich.

### Welche Systemvorraussetzungen müssen erfüllt werden?

Dies muss noch umfassender getestet werden. In einer virtuellen Umgebung wird der SVWS-Server hier mit 2 Cores und 8 GB RAM betrieben.

### Wer benötigt Zugriff auf den SVWS-Server?

Alle Personen, die auch jetzt schon mit SchILD-NRW arbeiten.

### Benötigt der SVWS-Server eine Internetverbindung?

Momentan eigentlich nicht. Jedoch werden in Zukunft viele Prozesse dazu kommen, die ein Internetverbindung benötigen.
(Web-Notenmanager, SchülerOnline, digitales Zeugnis usw.)


---
