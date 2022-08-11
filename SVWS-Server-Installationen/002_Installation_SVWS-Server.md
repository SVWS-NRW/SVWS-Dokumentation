***Installation des SVWS-Servers***
====================

# Installation per Script

Dieses Installations-Script ist wurde entwickelt für die vollständige Installation des SVWS-Servers auf Debian 11. 
Es wurde getestet in einem [Proxmox-Container](./IT-Umgebung/Einrichtung_Proxmox-Container.md). Es beinhaltet quasi alle Schritte,
die unter dem nachfolgenden Kapitel *Installation from Scratch*  aufgeführt sind, vereint in einem Script. 
Aktuell werden noch Token-Zugänge zum Github SVWS-Server und SVWS-Client Repository benötigt und im Script abgefragt. 
Dieser Schritt* entfällt bei Veröffnetlichung der SVWS-Servers auf Git Hub unter OpenSource-Lizens

+ Show [install-svws-from-scratch.sh](./scripts/install-svws-from-scratch.md)
+ Download [install-svws-from-scratch.sh](./scripts/install-svws-from-scratch.sh)
+ ausführbar machen: `chmod +x install-svws-from-scratch.sh`
+ Script starten: `./install-svws-from-scratch`

<!-- ![download  & script starten](./graphics/screenshots/install_svws_1.jpg) -->

+ geben Sie Ihren Github-Usernamen und das Token an*
+ geben Sie das MBD Passwort für Schild an

Die Angabe des Schild Passwortes ist nur nötig, wenn auch eine Schild2-Datenbank importiert werden soll. 
Dies kann auch im Anschluss an die Installation noch erfolgen. 
Das Script läuft ohne Unterbrechung durch und legt eine nur für den Systemadmin lesbare Datei `SVWS-Zugangsdaten.txt` in das root-Hauptverzeichnis. 


<!-- ![script gestartet](./graphics/screenshots/install_svws_2.jpg) -->


Nach etwa 10-15 min ist der SVWS-Server inklusive aller benötigten Bestandteile aus dem Quellcode heraus compiliert und mit beendigung des Scripts gestartet. 
Der user svws wird eingerichtet und unter /app befinden sich nun die Dateien zum Betrieb des Servers. 
Er läuft als Service im Debian System, wird beim Start des Systems automatisch gestartet oder kann mit den folgenden Befehlen gestartet bzw. gestopt werden: 

```bash
			systemctl start svws
			systemctl restart svws
			
			systemctl stop svws
```
						
Der SVWS-Client für die Bedienung des SVWS-Servers kann unter https://*IP-oder-FQDN-des-Servers*/ aufgerufen werden:

<!-- ![SVWS-Server & Client startet](./graphics/screenshots/install_svws_3.jpg) -->





	
# Installation from Scratch 

Alle Schritte, die in dem vorangegangenem Kapitel in einem Script zusammengefasst ausgeführt werden, werden hier einzeln aufgeführt und beschrieben. 

## Vorbereitungen und erste Schritte

Der SVWS-Server benötigt [Debian 11](https://www.debian.org/CD/http-ftp/) als grundlegendes Betriebssystem. 
Je nach Hardware kann das typische [AMD64 Netzwerk Image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso)
von Debian benutzt werden. 

Nach Installation wird das Betriebssystem auf den neuesten Stand gebracht, also als root die folgenden Befehle ausführen:

```bash
		apt update -y
		apt dist-upgrade -y
```

Anschließend die nötige bzw. hilfreiche Software installieren:
```bash
		apt install ssh nmap curl git zip net-tools dnsutils software-properties-common dirmngr -y
```

Dann den user anlegen, z. B. `svws`, unter dem der Dienst betrieben wird: 

```bash
		useradd	-m -G users -s /bin/bash svws
```
		
## MariaDB installieren und einrichten

Es wird MariaDB mindestens 10.6 benötigt. Unter debain 11 bisher nur über die ofiziellen Sources von mariadb.org installierbar:

```bash
		wget https://mariadb.org/mariadb_release_signing_key.asc
		chmod -c 644 mariadb_release_signing_key.asc
		mv -vi mariadb_release_signing_key.asc /etc/apt/trusted.gpg.d/
		echo "deb [arch=amd64,arm64,ppc64el] https://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.6/debian bullseye main" | tee /etc/apt/sources.list.d/mariadb.list

		apt update
		apt install mariadb-server -y 
```

Die Datei `mysql_secure_installation.sql` anlegen, um das MariaDB-Passwort zu setzen und weitere sicherheitsrelevante Einstellung zu tätigen:

```bash
		echo "
		ALTER USER 'root'@'localhost' IDENTIFIED BY '!geben_Sie_hier_Ihre_Daten_an!';
		DELETE FROM mysql.user WHERE User='';
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		FLUSH PRIVILEGES;
		" > mysql_secure_installation.sql
```

Den o.g. mysql Befehl ausführen: 

```bash
		mysql < mysql_secure_installation.sql
```

## Java installieren

Java mind. 17 unter debain 11 installieren:

```bash
		apt install openjdk-17-jdk-headless -y
````

Den Pfad setzen, aktualisieren und dauehaft verfügbar machen, unter dem Java zu finden ist:

```bash
		PATH=/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH
		export PATH
		echo "JAVA_HOME:/usr/lib/jvm/java-17-openjdk-amd64" >> /etc/environment
```
## NodeJs installieren

node.js mind. Version 16 herunterladen und installieren: 

```bash
		curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
		apt install nodejs -y
		echo "prefix=~/.npm" > ~/.npmrc
````

## SVWS-Server Sources herunterladen und bauen 

Das Verzeichnis erstellen, unter der die Software zu finden ist: 

```bash
		mkdir /app
		cd /app
```

Git Quellen einrichten und Repositories clonen: 

```bash
		export GITHUB_ACTOR=Geben_Sie_hier_ihre_Daten_an 
		export GITHUB_TOKEN=Geben_Sie_hier_ihre_Daten_an 
		export SCHILD_PW=Geben_Sie_hier_ihre_Daten_an 
		git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/FPfotenhauer/SVWS-Server.git
```

Für die weitere Installation wird noch ein gradle.properties File angelegt

```bash
		mkdir ~/.gradle
		echo github_actor=$GITHUB_ACTOR >> ~/.gradle/gradle.properties 
		echo github_token=$GITHUB_TOKEN >> ~/.gradle/gradle.properties 
		echo schild2_access_password=$SCHILD_PW >> ~/.gradle/gradle.properties 
```

Um den Developer branch zu wählen muss jeweils noch `git checkout dev` vor dem Build Prozess erfolgen. Hier kann natürlich auch (bald) ausprobiert werden und ein anderer Branch gewählt werden.
Nun wird nacheinander das UI-Framework, der Server und der Client gebaut. Bitte diese Reihenfolge einhalten: 

```bash
		cd /app/SVWS-Server
		git checkout dev
		./gradlew build
```

## Starten des SVWS-Servers

Es muss vor dem Starten des SVWS-Servers nun die Konfiguration des SVWS-Servers in der Datei `svwsconfig.json` gespeichert werden: 

```bash
		echo '
		{
		"EnableClientProtection" : null,
		"DisableDBRootAccess" : false,
		"DisableAutoUpdates" : null,
		"UseHTTPDefaultv11" : false,
		"PortHTTPS" : 443,
		"UseCORSHeader" : true,
		"TempPath" : "tmp",
		"TLSKeyAlias" : null,
		"TLSKeystorePath" : "svws-server-app",
		"TLSKeystorePassword" : "svwskeystore",
		"ClientPath" : "../SVWS-Server/svws-webclient/build/output",
		"LoggingEnabled" : true,
		"LoggingPath" : "logs",
		"DBKonfiguration" : {
			"dbms" : "MARIA_DB",
			"location" : "127.0.0.1",
			"defaultschema" : null,nmap
			"SchemaKonfiguration" : []
			}
		}
		' > /app/SVWS-Server/svwsconfig.json 


```

Es müssen weiterhin die richtigen Rechte gesetzt werden, um den SVWS-Server nicht mit root-Rechten starten zu wollen: 

```bash
		chown -R svws:svws /app/
```

manueller Start des SVWS-Server:

```bash
		cd /app/SVWS-Server/
		./start_server.sh &
```


## Einrichten des Servers als Dienst

Erstelle eine Datei zur Beschreibung und Bedienung des Dienstes per systemd:

```bash
		echo "
		[Unit]
		Description=SVWS Server
		
		[Service]
		# User=svws 
		# im Develop unter root getest
		Type=simple
		WorkingDirectory = /app/SVWS-Server
		ExecStart=/bin/bash /app/SVWS-Server/start_server.sh
		# Restart=on-failure 	# optional-auskommentieren, wenn gewünscht
		# RestartSec=5s 		# optional-auskommentieren, wenn gewünscht
		StandardOutput=journal 
		
		[Install]
		WantedBy=multi-user.target
		
		" > /etc/systemd/system/svws.service
```

Den Dienst nun noch fest einbinden, so dass er beim Neustart gestartet wird: 
```bash
		systemctl enable svws
```

Nun noch den Server folgenden Befehlen starten:
```bash
		systemctl start svws
```

## Fehlersuche und Fehleranalyse

### Neustart der Dienste
 
Zum Neustart des Servers braucht man üblicherweise unter Linux nicht das gesammte System neu starten sondern kann einfach nur den Dienst neustarten oder auch ggf. stoppen: 

```bash
		systemctl restart svws

		systemctl stop svws
```

Ebenso kann man natürlich auch den mysql Dienst starten, neustarten und beenden.

### Fehlersuche per Journal 

Vermutet man Abstürze des Servers, so lohnt sich ein Blick in die Log files:

```bash
		journalctl  -f -u svws
```

Zusätzlich kann man, um einen regelmäßigen Restart zu ermöglichen, den 5 sekündigen Neustart wie oben beschrieben erzwingen. 
So erhält man ggf. auch regelmäßige Einträge bzw. direkt Einträge nach Absturz des Servers. 
