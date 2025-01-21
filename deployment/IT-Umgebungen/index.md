# IT-Umgebungen


## Szenarien

Der SVWS-Server ist so ausgelegt, dass er in allen schulischen Umfeldern eingesetzt werden kann. Wichtige Grundlage ist dabei weiterhin der dezentrale Ansatz, der im Land NRW vertreten wird:   

Kleine Grundschulen haben die Schulverwaltungssoftware gegebenfalls auf einem Rechner installiert, größere Schulen besitzen unter Umständen einen oder mehrere Server. Andere Schulen haben IT-Dienstleister, die sie mit Serverinstallationen unterstützen. Am oberen Ende findest sich der zentrale Einsatz in Rechenzentren. 

## Einzelplatz-Rechner

Mit Hilfe des Windows-Installers können der SVWS-Server und SchILD-NRW 3 auf einem einzelnen PC mit MS Windows 10 oder Windows 11 Betriebssystem (64 bit) installiert werden. 

Der SVWS-Server öffnet dabei den Port 443, so dass der SVWS-Client auch von anderen Computern im Netzwerk erreicht werden kann.

Ein echter Server-Betrieb ist dadurch allerdings nicht gewährleistet, da der Einzelplatzrechner beim Ende der Nutzer-Arbeitszeit in der Regel heruntergefahren wird.

Diese Installationsvariante ist für sehr kleine Schulen ohne weitere IT-Umgebung beziehungsweise IT-Unterstützung denkbar.

![Einzelplatzinstallation_einfach.png](./graphics/Einzelplatzinstallation_einfach.png "SVWS-Server und SchILD-NRW 3 laufen auf einem lokalen Rechner.")

## Server im Schulverwaltungsnetz

Die Variante einen Server in der Schule zu betreiben, der im Verwaltungsnetzwerk abgekoppelt vom pädagogischen Netzwerk betrieben wird, ist die häufigste Installations-Art.

Auch hier wird der Port 443 intern geöffnet, so dass der SVWS-Web-Client mit einem Web-Browser im Verwaltungsnetz aufgerufen werden kann. 

Der SVWS-Server kann hierbei sowohl auf einem windows- als auch auf einem linuxbasierten Rechner betrieben werden.

Die Installation auf Linuxbasis ermöglicht den Schulen beziehungsweise den Schulrägern eine komplett lizenzkostenfreie Installation des SVWS-Servers basierend auf Open Source Software. 

Das bei der Installation erstellte Zertifikat sollte an die Clients per Gruppenrichtlinie oder manuell verteilt werden, damit der Browser die Verbindung auch als *sicher* einstuft und keine Warnung beim Aufrufen ausgibt.

Alternativ kann der Server per Certbot gegebenfalls über einen dazwischengeschalteten ReverseProxy zertifiziert werden. 

Über eine Dateifreigabe im lokalen Netz oder eine Gruppenrichtlinie kann SchILD-NRW 3 auf den Windows-Clients verteilt werden. Vorerst muss SchILD-NRW 3 eine Verbindung zum SVWS-Server und auch direkt zur MariaDB des SVWS-Servers einrichten und aufbauen.

Perspektivisch wird der Zugriff auf die MariaDB durch Nutzung entsprechender Web-Services des SVWS-Servers ersetzt werden, so dass nur noch eine Verbindung zum SVWS-Server benötigt wird.

![Serverinstallation_Schule_ohne_VPN_einfach.png](./graphics/Serverinstallation_Schule_ohne_VPN_einfach.png "SVWS-Server und SchILD 3 liegen auf einem Server, auf den Rechner im Verwaltungsnetz zugreifen.")

## Kommunaler Server im Rechenzentrum

In größeren Umgebungen sind verschiedene Varianten der Installation denkbar. So können mehrere SVWS-Server auch die Funktionalität von SchILD*zentral* übernehmen. 

Die Trennung der Schemata ist hier eine wichtige Datenschutzmaßnahme. Dies kann innerhalb eines großen MariaDB-Servers oder auch mit mehreren kleinen MariaDB Instanzen erfolgen. 

In Rechenzentren macht es aus lizenzgründen Sinn auf Linux-Systeme zu setzen, so dass hier mit Docker-Containern oder auch LX-Containern gearbeitet werden kann.Des Weiteren können auch einzelne virtuelle Maschinen (KVM) in Virtualisierungssystemen wie zum Beispiel Proxmox, VMWare, HyperV, etc. erstellt und den jeweiligen Schulen zugeordnet werden. Es ist auch möglich, jedoch eher für Schulsysteme oder Dependancen sinnvoll, mehrere Schul-Schemata über einem SVWS-Server bereitzustellen. 

Welche Kombination der Installationsmöglichkeiten die Beste ist, sollte  anhand der lokalen Gegebenheiten und den hier zugänglichen Ressourcen entschieden werden. 

![Serverinstallation_Schule_ohne_VPN_einfach.png](./graphics/Serverinstallation_Rechenzentrum_einfach.png "Ein komplexerer Aufbau in einem Rechenzentrum.")
