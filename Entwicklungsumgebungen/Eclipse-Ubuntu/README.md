# Installation auf einem Ubuntu


Dowload Eclipse Linux64bit entpacken in eigene Dateien.


//TODO




Befehl für die Verlinkung von Eclipse, so dass sich der SVWW-Server auch ohne Root-Rechte auf Port 443 starten kann:
```
/sbin/setcap 'cap_net_bind_service=ep' /usr/lib/jvm/java-17-openjdk-amd64/bin/java
```


Hier wird das JDK einfach für den net_bind freigegeben.
Muss bei Änderung des JDKs erneut ausgeführt werden.
