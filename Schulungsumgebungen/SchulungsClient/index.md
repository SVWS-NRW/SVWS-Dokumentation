# SchulungsClient

Unter SchulungsClients sollen hier (virtuelle) Maschinen verstanden werden, die für einen Teilnehmenden bzw. einen Schulungsplatzinstanz zur Verfügung stehen.

## Anforderungen

+ der SchulungsClient sollte eine virtuelle Maschine sein, so dass unabhängig von der zur Verfügung stehenden Hardware geabreitet werden kann
+ wenn möglich sollen keine Lizensen an den Client gebunden sein, so dass dieser bedenkenlos weitergegeben werden kann.
+ der Client sollte updatefähig sein
+ über den Client sollten Schulungsmedien bereitgestellt werden können, die individuell bearbeitbar sind 
+ der Client soll verschiedene Schulungsdatenbanken einbinden können
+ die Fortbilder sollen den Client auf Ihre Berüfnisse anpassen können
+ der Client sollte auf verschiedenen Plattformen (Proxmox, VMWare, ... ) betrieben werden können
+ der Client sollte remote steuerbar sein (rdp,vnc, x2go, ...)
+ der Client sollte ressourcenschonend betrieben werden können

## Installation des Grundsystems

## Installation des SVWS-Servers

## Bereitstellung der Schulungsmedien

## Installation Schild3

## Zurücksetzen und Einspielen neuer Datenbanken

Löschen der vorhanden Datenbanken auf der Konsole des SVWS-Servers per curl Aufruf:

```bash
#!/bin/bash
############################### update-svwsdbs.sh #########################################
#
##
# [Einstellungen]
##
SERVERNAME=Bitte_Domainnamen_angeben
PORT=8443   #i.d.R ist das so korrekt 
MYSQLROOTPW=Bitte_PW_angeben
MDB_PW=Bitte_PW_angeben
#
# SQLITE Datenbanken, die angelegt werden sollen:
DB_1_NAME=TestDB_G # falls gesetzt, sonst leere Datenbank
DB_1_USER=svwsadmin
DB_1_MYSQL_PW=svwsadmin
DB_1_PATH=/SVWS-TestMDBs/DB1.sqlite
#
#
##
# [Beispiel: Datenbanken download]
##
# wget https://github.com/SVWS-NRW/Schulungsunterlagen/blob/master/LeistungsdatenSekII/DB/1_Gym_Jg10_ohneWahlen.sqlite
# mkdir /SVWS-TestMDBs                
# mv 1_Gym_Jg10_ohneWahlen.sqlite /SVWS-TestMDBs/DB1.sqlite
#
## 
# [Löschen der DB1]
## 
echo "DB1 wird gelöscht"
curl --user "root:${MYSQLROOTPW}" \
	-k -X "POST" "https://${SERVERNAME}:${PORT}/api/schema/root/destroy/${DB_1_NAME}" \
	-H "accept: application/json"
#
##
# [Neu Anlegen einer DB1 aus SQLITE-File]
#
curl --user "root:${MYSQLROOTPW}" \
  -X "POST" "https://${SERVERNAME}:${PORT}/api/schema/root/import/sqlite/${DB_1_NAME}" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "database=@${DB_1_PATH}" \
  -F "schemaUsername=${DB_1_USER}" \
  -F "schemaUserPassword=${DB_1_MYSQL_PW}" 

#
##
# [Beispiel: MDB Datenbanken migrieren]
##
# DB_2_NAME=TestDB_G # falls gesetzt, sonst leere Datenbank
# DB_2_USER=svwsadmin
# DB_2_MYSQL_PW=svwsadmin
# DB_2_PATH=/SVWS-TestMDBs/DB2.mdb
#
# Beispiel: Neu Anlegen der DB2 als Migration aus MDB
# echo "DB1 wird angelegt"
# curl --user "root:${MYSQLROOTPW}" \
#	-k -X "POST" "https://${SERVERNAME}:${PORT}/api/schema/root/migrate/mdb/${DB_2_NAME}" \
#	-H "accept: application/json" \
#	-H "Content-Type: multipart/form-data" \
#	-F "databasePassword=${MDB_PW}" \
#	-F "schemaUsername=${DB_2_USER}" \
#	-F "schemaUserPassword=${DB_2_MYSQL_PW}" \ 
#	-F "database=@${DB_2_PATH}"
#

``` 
Im Skript auskommentiert ist hier die Möglichkeit auch vorhandene Datenbanken zu migrieren. Die Methode ein SQLite Backup einzuspielen ist jedoch wesentlich performanter als die Mirgation einer Access Datenbank und sollte hier primär verwendet werden. 



