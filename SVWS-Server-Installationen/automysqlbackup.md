
# automatisiertes Mysql Backup

## automysqlbackup einrichten

apt install automysqlbackup

ein mal am Tag wird dann in /var/lib/automysqlbackup ein backup hinterlegt

per hand kann man auch ein Backup mit dem Befehl automysqlbackup anlegen. 

config Datei: 
nano /etc/default/automysqlbackup

Hier kann man die Backupüverzeichnisse definieren oder die Zeiten bzw. Exklusionen. 

## regelmäßige backups per cronjob einrichten 

dreckiger Hack: 

in /etc/mysql/debian.cnf das rootpasswort für mysql eintragen


0  1 * * * /usr/sbin/automysqlbackup
