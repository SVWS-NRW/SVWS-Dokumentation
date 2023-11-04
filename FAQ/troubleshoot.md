# FTroubleshooting

Sie haben Fragen zum Thema ... 


## Installation

siehe: https://doku.svws-nrw.de/Deployment/ 

## Bug tracking 

Sie haben einen Bug gefunden und möchten dies melden? Dann können Sie sich 
* an Ihre Fachberatung wenden   
(siehe https://www.svws.nrw.de/service/fachberatersuche)   
oder 
* in Gthub ein Issue dazu erstellen  
(siehe https://github.com/SVWS-NRW/SVWS-Server/issues)  

## Diagnostik

Der SVWS-Server startet nicht ...

### Diagnosetools
Informationen zum Zustand des Servers erhält man z.B. mit den folgenden Befehlen, die ein Administrator auf dem Linux-Terminal absetzen kann: 

```bash 
systemctl status svws
```
bzw. 
```bash 
journalct -u svws -f
```

### Fehler: Cannot invoke "de.svws_nrw.db.DBConfig.getDBDriver()"

Hier stimmt irgendwas nicht mit der Definition oder dem Zugriff auf die MariaDB. Bitte die svwsconfig.json ansehen!

Workaround:

Man kann nun nach einer Sicherung der aktuellen ```svwsconfig.json``` ggf. die SchemaKonfiguration entfernen, so dass die Eintragung an dieser Stelle entsprechend: 
```bash 
...
"DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "127.0.0.1",
    "defaultschema" : "GymAbi",
    "SchemaKonfiguration" : [ ]
  }
 ... 
 ```
 
abgeändert wird. Nun den SVWS-Server neu starten mit: 

```bash 
systemctl restart svws
```

Anschließend kann man z.B. über die Swagger ein neues Datenbankschema anlegen. Hierzu bitte die folgende URL aufrufen ("mein_SVWS-Server" sinnvoll ersetzen):   
https://mein_SVWS-Server/debug/ 