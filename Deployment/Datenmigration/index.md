# Datenmigration

Neue Schemata oder vorhandene Schemata in der Datenbank des SVWS-Servers anlegen.

## Download von Testdaten

Für Testzwecke und Schulungen werden anonymisierte Datenbanken verschiedener Schulformen vorgehalten.
Zu bestimmten Datenbanken sind auch passende Lupo Dateien etc. vorhanden, um sich passende Testfälle anzusehen.  
**Die Daten sind vollständig anonymisiert!**


[https://github.com/SVWS-NRW/SVWS-TestMDBs](https://github.com/SVWS-NRW/SVWS-TestMDBs)

## Übersicht

Es gibt mehrer Möglichkeiten ein Schemata in der Datenbank anzulegen bzw. zu befüllen: 

+ per Admin-Webclient
+ per Swagger UI
+ per Curl Befehl
+ per Shell Skript
+ aus einer SQLite Datensicherung 
+ aus einem SQL-Dump

## Benutzung des Admin-Webclient

![adminclient.png](./graphics/adminclient.png)

Melden Sie sich mit root und dem Kennwort an der MariaDB an.
Sie können auch einen anderen Datenbankuser wählen, dieser sieht dann die vorhandenen Datenbanken entsprechnd seiner Rechte.

Im Adminclient können je nach Rechtevergabe des Datenbankusers folgende Arbeiten erledigt werden:

- Datenbankschema für SVWS anlegen und in die svwsconfig.json aufnehmen
- Datenbank mit Schulnummer initialisieren
- Schild-NRW2 Datenbank in Schema migrieren
- SQLite-Backup ausführen
- SQLite-Backup wieder einspielen
- Datenbankschema löschen

## Einfügen per SwaggerUI

Eine Übersicht über die Web-Services bietet die SwaggerUI. 
Hier kann man über *Try it Out* -- Buttons jeweils die Services ausprobieren bzw. benutzen.
Die Swagger UI aufrufen:

```bash
		https://<YourServerDomainName>/debug/
```

![SwaggerUI.png](./graphics/Swagger-01.png)


   
**Achtung:** Um auf der SwaggerUI diesen Service bzw. die mit "Root" gekennzeichneten Services nutzen zu können, muss man sich zuerst authentisieren, indem man auf ein rechts abgebildetes Schloss klickt. 


Hier nun den User `root` der MariaDB-Installation und das entsprechende Passwort angeben. 


**Hinweis** Möchte man andere "nicht root - Services" nutzen, so muss man sich mit dem SchILD-NRW 3.0-Benutzer bzw. SVSW-Benutzer anmelden.
 


Dann unter dem Abschnitt  
	-> "SchemaRoot /api/schema/root/migrate/mdb/{schema}"   
	-> *Try it Out*-Button  
drücken, so dass man diese Ansicht erhält:



![SwaggerUI.png](./graphics/Swagger-02.png)





Anschließend die folgenden Einträge unter der Maske ausfüllen:

+ **schema**: Hier steht der Name, der auch auf der Anmeldemaske dargestellt wird, z.B. Testschule. 
+ **Databasefile**: Hier können Sie z.B. eine SchILD-NRW 2.0-MDB-Datenbank aus der o.g. SVWS-TestMDBs einstellen.
+ **databasePassword**: Hier das SchILD-NRW 2.0 Access-Passwort angeben.
+ **SchemaUsername**: Einen beliebigen Usernamen angeben, z.B. svwsadmin, der bei der Einrichtung des Schemas auf der Datenbank für dieses Schema GRANT-Rechte erhält. 

Es kann auch ein schon existierender Benutzer genommen werden. 
Falls ein schon existierender Benutzer verwendet wird, muss das anschließend abgefragte Passwort natürlich passen.

++ **SchemaUserPasswort**: Passwort der o.g. (neu angelegte) MariaDB Users. 


# Schemata per Curl erstellen

```bash
 --user "%1:%2" -k -X POST "https://localhost/api/schema/root/migrate/mdb/%3" 
-H "accept: application/json" 
-H "Content-Type: multipart/form-data" 
-F "databasePassword=%4" 
-F "schemaUsername=%5" 
-F "schemaUserPassword=%6" 
-F "database=@%7"
```

+ %1: Benutzer der Datenbank mit GRAND-Rechten zum Anlegen neuer Datenbanken
+ %2: Passwort der o.g. Benutzers
+ %3: Name der neu anzulegenden Datenbank - Achtung: existierende Datenbanken werden überschrieben!
+ %4: Das allseits bekannte SchILD-NRW 2.0 - Passwort, um die MDB-Datenbank zu öffnen. 
+ %5: Der neue MariaDB User für die neue Datenbank (Schuldatenbankadmin im Backend)
+ %6: Passwort der o.g. Benutzers
+ %7: vollständiger Pfad zur MDB auf dem Server - MIT @ davor!


Beispiel: 
```bash
curl --user "root:mariabd_root_pw" -k -X "POST" "https://server.svws-nrw.de/api/schema/root/migrate/mdb/svwsdb" \
	-H "accept: application/json"  \
	-H "Content-Type: multipart/form-data" \
	-F "databasePassword=kannManWissen" \
	-F "schemaUsername=svwsuser" \
	-F "schemaUserPassword=svwsadmin_PW" \
	-F "database=@/root/SVWS-TestMDBs/GOST_Abitur/Abi-Test-Daten-01/GymAbi.mdb"
```



