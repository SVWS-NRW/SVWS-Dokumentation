# svws-db-utils

Hier findet man Hilfsprogramme für externen Datenbankzugriffe. Diese können auch bei abgeschaltetem Server von Administratoren mit entsprechenden Rechten ausgeführt werden. Insbesondere bei Verarbeitung größerer Aufgabenstapel bietet es sich an per Skript diese Hilfprogramme einzubinden. 

## kurs42_import

 Mit ```kurs42_import.cmd``` bzw. ```kurs42_import.sh``` können Kursdateien, die im Kurs42 eigenen .blo Format vorliegen, eingelesen werden.
 
 Argument short | Argument long | Beschreibung 
 -------------- | ------------- | ------------
 -cp [PATH] | --configPath [PATH] | Gibt den Pfad zu der SVWS-Konfigurationsdatei an, wenn diese nicht an einem Standardort liegt
 -s [SCHEMA_NAME] | --schema [SCHEMA_NAME] | Der Schema-Name für die SVWS-DB (bei "MDB" und "SQLITE" nicht benötigt
 -d [DIR] | --directory [DIR] | Das Verzeichnis, in dem sich die Textdateien der Kurs-42-Blockung befinden

## lupo_import

Mit ```lupo_import.cmd``` bzw. ```lupo_import.sh``` können Lupodateien, die im LuPO eigenen .lpo Format vorliegen, eingelesen werden.


 Argument short | Argument long | Beschreibung 
 -------------- | ------------- | ------------
-j | --ja| Beantwortet alle Fragen beim Import automatisch mit "Ja"
-f [FILE] | --file [FILE]| Der vollständige Dateiname, wo die LuPO-Datei liegt
-cp [PATH] | --configPath [PATH]| Gibt den Pfad zu der SVWS-Konfigurationsdatei an, wenn diese nicht an einem Standardort liegt
-td [DRIVER] | --tgtDrv [DRIVER]| Der Treiber für die Ziel-DB ("MDB", "MSSQL", "MYSQL", "MARIA_DB" oder "SQLITE")
-tl [LOCATION] | --tgtLoc [LOCATION]| Der Ort, wo die Ziel-DB zu finden ist (Der Pfad einer Datei oder der Ort im Netzwerk, z.B. "localhost")
-ts [SCHEMA_NAME] | --tgtDB [SCHEMA_NAME]| Der Schema-Name für die Ziel-DB (bei "MDB" und "SQLITE" nicht benötigt)
-tu [USERNAME] | --tgtUser [USERNAME]| Der DB-Benutzer für die Ziel-DB
-tp [PASSWORD] | --tgtPwd [PASSWORD]| Das DB-Kennwort für die Ziel-DB

Beispiel:  

```bash
/PATH_TO/SVWS-Server/svws-db-utils/lupo_import.sh -j -cp "/PATH_TO/SVWS-Server/svws-server-app/"  -f "/PATH_TO/SVWS-TestMDBs/GOST_Abitur/Abi-Test-Daten-01/EF.lup" -td MARIA_DB -tl localhost -ts svws_db -tu svws_user -tp pw_svws_user
```
## create_db

Mit ```create_db.cmd``` bzw. ```create_db.sh``` kann eine leere Datenbank erschaffen bzw. vorbereitet werden, die per graphischen Frontend im WebClient befüllt werden kann. 

Argument short | Argument long | Beschreibung 
 -------------- | ------------- | ------------
-r [REVISION] | --revision [REVISION]| Gibt die maximale Revision an, bis zu der die migrierte DB maximal aktualisiert wird (Default| -1 für so weit wie möglich)
-j | --ja | Beantwortet den Hinweise auf das notwendige Löschen der Ziel-DB automatisch mit "Ja"
-d | --developerMode| Führt den Import im Developer-Mode durch. Dies bedeutet, dass die Datenbank nur für Testzwecke geeignet ist und entsprechend gekennzeichnet wird.
-cp [PATH] | --configPath [PATH]| Gibt den Pfad zu der SVWS-Konfigurationsdatei an, wenn diese nicht an einem Standardort liegt
-td [DRIVER] | --tgtDrv [DRIVER]| Der Treiber für die Ziel-DB ("MDB", "MSSQL", "MYSQL", "MARIA_DB" | "SQLITE"
-tl [LOCATION] | --tgtLoc [LOCATION]| Der Ort, wo die Ziel-DB zu finden ist (Der Pfad einer Datei | der Ort im Netzwerk, z.B. "localhost")
-ts [SCHEMA_NAME] | --tgtDB [SCHEMA_NAME]| Der Schema-Name für die Ziel-DB (bei "MDB" und "SQLITE" nicht benötigt)
-tu [USERNAME] | --tgtUser [USERNAME]| Der DB-Benutzer für die Ziel-DB
-tp [PASSWORD] | --tgtPwd [PASSWORD]| Das DB-Kennwort für die Ziel-DB
-tq [USERNAME] | --tgtRootUser [USERNAME]| Ein DB-Root-User für die Ziel-DB (nur bei "MSSQL", "MYSQL", "MARIA_DB")
-tr [PASSWORD] | --tgtRootPwd [PASSWORD]| Das DB-Root-Kennwort für die Ziel-DB (nur bei "MSSQL", "MYSQL", "MARIA_DB")

Beispiel:  
```bash
/PATH_TO/SVWS-Server/svws-db-utils/create_db.sh -j -r -1 -d -td "MARIA_DB" -tl "localhost" -ts "svws_db" -tu "user_neu" -tp "pw_user_neu" -tr "pw_root_user" -cp "/PATH_TO/SVWS-Server/svws-server-app"
```

 ##  migrate_db
 
 Mit ```migrate_db.cmd``` bzw. ```migrate_db.sh``` kann eine  vorliegende Datenbank in ein anderes Schema migriert werden. Grundlegender Prozess für die migration von SchILD2 auf SVWS-Server.


Argument short | Argument long | Beschreibung 
 -------------- | ------------- | ------------
-r [REVISION] | --revision [REVISION]| Gibt die maximale Revision an, bis zu der die migrierte DB maximal aktualisiert wird (Default oder -1 für so weit wie möglich)
-j | --ja| Beantwortet den Hinweise auf das notwendige Löschen der Ziel-DB automatisch mit "Ja"
-d | --developerMode| Führt den Import im Developer-Mode durch. Dies bedeutet, dass die Datenbank nur für Testzwecke geeignet ist und entsprechend gekennzeichnet wird
-n [SCHULNUMMER] | --schulNummer [SCHULNUMMER]| Für Schildzentral-Quell-DBs| Gibt die Schulnummer an, für welche Daten aus der Quelldatenbank migriert werden sollen
-cp [PATH] | --configPath [PATH]| Gibt den Pfad zu der SVWS-Konfigurationsdatei an, wenn diese nicht an einem Standardort liegt
-sd [DRIVER] | --srcDrv [DRIVER]| Der Treiber für die Quell-DB ("MDB", "MSSQL", "MYSQL", "MARIA_DB" oder "SQLITE")
-sl [LOCATION] | --srcLoc [LOCATION]| Der Ort, wo die Quell-DB zu finden ist (Der Pfad einer Datei oder der Ort im Netzwerk, z.B. "localhost"
-ss [SCHEMA_NAME] | --srcDB [SCHEMA_NAME]| Der Schema-Name für die Quell-DB (bei "MDB" und "SQLITE" nicht benötigt)
-su [USERNAME] | --srcUser [USERNAME]| Der DB-Benutzer für die Quell-DB
-sp [PASSWORD] | --srcPwd [PASSWORD]| Das DB-Kennwort für die Quell-DB"));
-td [DRIVER] | --tgtDrv [DRIVER]| Der Treiber für die Ziel-DB ("MDB", "MSSQL", "MYSQL", "MARIA_DB" oder "SQLITE"
-tl [LOCATION] | --tgtLoc [LOCATION]| Der Ort, wo die Ziel-DB zu finden ist (Der Pfad einer Datei oder der Ort im Netzwerk, z.B. "localhost")
-ts [SCHEMA_NAME] | --tgtDB [SCHEMA_NAME]| Der Schema-Name für die Ziel-DB (bei "MDB" und "SQLITE" nicht benötigt)
-tu [USERNAME] | --tgtUser [USERNAME]| Der DB-Benutzer für die Ziel-DB
-tp [PASSWORD] | --tgtPwd [PASSWORD]| Das DB-Kennwort für die Ziel-DB
-tq [USERNAME] | --tgtRootUser [USERNAME]| Ein DB-Root-User für die Ziel-DB (nur bei "MSSQL", "MYSQL", "MARIA_DB"
-tr [PASSWORD] | --tgtRootPwd [PASSWORD]| Das DB-Root-Kennwort für die Ziel-DB (nur bei "MSSQL", "MYSQL", "MARIA_DB")



Beispiel:  
```bash
/PATH_TO/SVWS-Server/svws-db-utils/migrate_db.sh -cp "/PATH_TO/SVWS-Server/svws-server-app/" -r "-1" -j -d -sd "MDB" -sl "/PATH_TO/SVWS-TestMDBs/ENM-Json/ENM-Testdaten-03/ENMJson.mdb" -sp "Schild2_MDB_PW" -td "MARIA_DB" -tl localhost -ts svws_db -tu user_neu -tp pw_user_neu -tr pw_root_user
```

## export & import 

Diese beiden Hilfprogramme eignen sich z.B. für ein automatisiertes Datenbank Backup welches schnell und einfach bei einem anderen SVWS-Server zurückgespielt werden kann. 

### export

Mit ```export.cmd``` bzw. ```export.cmd``` kann ein SQLITE Datenbank Abzug erstellt werden. 

Argument short | Argument long | Beschreibung 
 -------------- | ------------- | ------------
-j | --ja| Beantwortet den Hinweise auf das notwendige Löschen der Ziel-DB automatisch mit "Ja"
-cp [PATH] | --configPath [PATH]| Gibt den Pfad zu der SVWS-Konfigurationsdatei an, wenn diese nicht an einem Standardort liegt
-sd [DRIVER] | --srcDrv [DRIVER]| Der Treiber für die Quell-DB ("MDB", "MSSQL", "MYSQL", "MARIA_DB" oder "SQLITE"
-sl [LOCATION] | --srcLoc [LOCATION]| Der Ort, wo die Quell-DB zu finden ist (Der Pfad einer Datei oder der Ort im Netzwerk, z.B. "localhost"
-ss [SCHEMA_NAME] | --srcDB [SCHEMA_NAME]| Der Schema-Name für die Quell-DB (bei "MDB" und "SQLITE" nicht benötigt)
-su [USERNAME] | --srcUser [USERNAME]| Der DB-Benutzer für die Quell-DB
-sp [PASSWORD] | --srcPwd [PASSWORD]| Das DB-Kennwort für die Quell-DB
-f [FILENAME] | --file [FILENAME]| Der vollständige Dateiname, in welcher der SQLite-Export abgelegt wird


### import

Mit ```import.cmd``` bzw. ```import.sh``` kann eine SQLITE Datenbank importiert werden. 


Argument short | Argument long | Beschreibung 
 -------------- | ------------- | ------------
-r [REVISION] | --revision [REVISION]| Gibt die maximale Revision an, bis zu der die migrierte DB maximal aktualisiert wird (Default: -1 für so weit wie möglich)
-j | --ja | Beantwortet den Hinweise auf das notwendige Löschen der Ziel-DB automatisch mit "Ja"
-d | --developerMode| Führt den Import im Developer-Mode durch. Dies bedeutet, dass die Datenbank nur für Testzwecke geeignet ist und entsprechend gekennzeichnet                        
-cp [PATH] | --configPath [PATH]| Gibt den Pfad zu der SVWS-Konfigurationsdatei an, wenn diese nicht an einem Standardort liegt
-td [DRIVER] | --tgtDrv [DRIVER]| Der Treiber für die Ziel-DB ("MDB", "MSSQL", "MYSQL", "MARIA_DB" oder "SQLITE"
-tl [LOCATION] | --tgtLoc [LOCATION]| Der Ort, wo die Ziel-DB zu finden ist (Der Pfad einer Datei oder der Ort im Netzwerk, z.B. "localhost")
-ts [SCHEMA_NAME] | --tgtDB [SCHEMA_NAME]| Der Schema-Name für die Ziel-DB (bei "MDB" und "SQLITE" nicht benötigt)
-tu [USERNAME] | --tgtUser [USERNAME]| Der DB-Benutzer für die Ziel-DB
-tp [PASSWORD] | --tgtPwd [PASSWORD]| Das DB-Kennwort für die Ziel-DB
-tq [USERNAME] | --tgtRootUser [USERNAME]| Ein DB-Root-User für die Ziel-DB (nur bei "MSSQL", "MYSQL", "MARIA_DB")
-f [FILENAME} | --file [FILENAME]| Der vollständige Dateiname, in welcher der SQLite-Import liegt