***Update des SVWS-Servers***
=============================

# Update des Grundsystems

		apt update
		apt upgrade -y


# Update per Script

Mit Hilfe diese Scripts kann ein Update zum Beispiel auf die neueste Version des DEV-Branch des SVWS-Servers durchgeführt werden. 

Voraussetzung ist dabei die [Installation direkt aus den Git-Quellen](002_Installation_SVWS-Server.md). 
	
+ Show [update-svws-from-scratch.md](scripts/update-svws-from-scratch.md)

	
    ausführbar machen: chmod -x install-svws-from-scratch.sh
    Script starten: ./update-svws-from-scratch
	
Alle Rückmeldungen werden im logfile unter `~/svws-update.log` gesammelt.


# Update from Scratch

Alle Schritte, die in dem vorangegangenem Kapitel in einem Script zusammengefasst ausgeführt werden, werden hier einzeln aufgeführt und beschrieben.

Einloggen auf dem Testserver

		sytemctl stop svws
		sytemctl status svws

ggf. den svws-Benutzer wechseln: 

		su svws

## Aktualisieren des SVWS-Servers

Wechsel ins Installationsverzeichnis des SVWS-Servers:

		cd /app/SVWS-Server
		
		
### optional: Branch auswählen 

Kontolle, ob das richtige Branch eingestellt ist.
		
		git branch
		
Falls dies nicht schon bei der Installation geschehen ist, müsste hier ggf. noch den gewünschten Branch eingestellt werden.

		git checkout dev

### Quellcode abholen und das UI-Framework bauen:


		git pull 
		./gradlew clean build

## Aktualisieren des UI-Frameworks

Analog zum oben beschriebenen Update des SVWS-Servers kann das UI-Framework aktualisiert werden.

		cd /app/SVWS-UI-Framework
		git pull
		./gradlew clean build

## Aktualisierung des SVWS-Clients

Nachdem der SVWS-Server und das SVWS-UI-FRamework aktualisiert sind kann der SVWS-Client akualisiert werden. 

		/app/SVWS-Client
		git pull
		./gradlew clean build

## Fehlerbehebung 

Sollten Änderungen im Repo durch den Build-Prozess existieren:

		git reset --hard
		
		cd app/git/SVWS-Server/svws-server-app
		vi svwsconfig.json > Schema svwsdb löschen

## Start des SVWS-Server

ggf mit `exit` wieder zum user root wechseln und den Service starten

		systemctl start svws
		systemctl status svws

http://svws-nrw.de/debug

SchemaRoot > /api/schema/root/migrate/mdb/{schema}

GymAbi.mdb in svwsdb mit svwsadmin und Passwort migrieren.