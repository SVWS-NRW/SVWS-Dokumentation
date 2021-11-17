# Update des Testserver auf die neueste Version des DEV-Branch

Einloggen auf dem Testserver
@root: sytemctl stop svws
@root: sytemctl status svws
@root: su svws

@svws: cd /app

@svws: cd SVWS-UI-Framework
@svws: git branch (Kontrololle auf dev)
@svws: git pull (kann mit dem User svws-gitlab und dessen Token gemacht werden)
@svws: ./gradlew clean build

@svws: cd /app

@svws: cd SVWS-Server
@svws: git branch (Kontrololle auf dev)
@svws: git pull (kann mit dem User svws-gitlab und dessen Token gemacht werden)
@svws: ./gradlew clean build

@svws: cd /app

@svws: cd SVWS-Client
@svws: git branch (Kontrololle auf dev)
@svws: git pull (kann mit dem User svws-gitlab und dessen Token gemacht werden)
@svws: ./gradlew clean build

Sollten Änderungen im Repo durch den Build-Prozess existieren:
@svws: git reset --hard

@svws: cd app/git/SVWS-Server/svws-server-app
@svws: vi svwsconfig.json > Schema svwsdb löschen

@svws: exit
@root: systemctl start svws
@root: sytemctl status svws

http://svws-nrw.de/debug
SchemaRoot > /api/schema/root/migrate/mdb/{schema}
GymAbi.mdb in svwsdb mit svwsadmin und Passwort migrieren.