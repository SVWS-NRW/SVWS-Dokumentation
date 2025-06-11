# Datensicherung 

## manuelle Sicherung im SQLite Format 

Über die grafische Oberfläche des Adminclients kann sehr komfortabel eine Datensicherung im SQLite Format angelegt werden. 
Der Admin-Client kann i.d.R. unter `https://URLdesSVWS-Servers/admin` aufgerufen werden. 
Weitere Informationen dazu befinden sich im [Handbuch des Adminclients](../../adminclient/).

## automatisierte SQLite Backups

Automatisierte SQLite Backups können z.B. crontab gescriptet aufgerufen werden. 

````bash 

curl --user "rootUsername:MYSQLROOTPW" -k -X "GET"  "https://SERVERNAME:PORT/db/SCHEMA/export/sqlite" -H "accept: application/json"

````

Hier bitte die Variablen rootUsername, MYSQLROOTPW, SERVERNAME, PORT und SCHEMA ersetzen bzw. vorher im Skript oder Terminal definieren. 

## Backup mit Mariabackup

Das Tool mariabackup kann auch auf Windows per MSI-Paket installiert werden. Die [Anleitung von MariaDB.com] (https://mariadb.com/kb/en/full-backup-and-restore-with-mariabackup/) beschreibt, 
wie man mit kurzen Befehlen Backups anlegt und zurückspielt. Dies kann über einen Cronjob oder die Windows Aufgabenplanung regelmäßig ausgeführt werden.


## automatisiertes Backup per mysqldump

### mysqldump per cronjob

````bash 
mysqldump --user=USERNAME --password=PASSWORD DATABASENAME /path/to/mysql_dump.sql
````
Sichert die Datenbank einmalig unter dem angegebenen path. Dies kann mit Crontab sinnvoll automatisiert werden.

### automysqlbackup

Das Linux Tool `automysqlbackup` ist für regelmäßige Sicherungen sehr komfortabler und einfach. 
Es richtet unter `/var/lib/automysqlbackup` in entsprechenden Ordnern daily, weekly und monthly `.sql` Sicherungen ein. 

````bash 
apt install automysqlbackup
````
In der config `/etc/default/automysqlbackup` kann ggf. das Backupverzeichnisse definiert oder die Zeiten bzw. Exklusionen editiert werden. 

Regelmäßige Backups müssen dann per cronjob eingerichtet werden. z.B:

````bash 
0  1 * * * /usr/sbin/automysqlbackup
````

Aktuell muss unter Debian 12 in `/etc/mysql/debian.cnf` das rootpasswort für den Datenbankzugang eingetragen werden. Dazu bitte die beiden Variablen in dieser Datei ergänzen: 
````bash 
USERNAME=root
PASSWORD="the root password"
````
Dann in der Datei `/etc/mysql/debian.cnf` die folgenden Zeilen aktivieren:

````bash 
...
USERNAME=`grep user /etc/mysql/debian.cnf ...
...
PASSWORD=`grep password /etc/mysql/debian.cnf 
````bash 
