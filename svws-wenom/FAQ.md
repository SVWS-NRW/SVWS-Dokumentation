# FAQ

Häufig gestellte Frage und Supportfälle werden hier gesammelt. 

## Abruch nach erster erfolgreicher Synchronisation

### Ausgangssituation

Der Upload und die Einrichtung der Serververbindung vom SVWS-Server zum VENUM-Server wurden erfolgreich durchgeführt. Die Dateien auf dem WeNoM-Server sind vollständig befüllt, sodass sich Benutzer anmelden und Noten eingeben können.

### Fehlerbild

Die Rückübertragung der im WeNoM erfassten Daten an den SVWS-Server ist jedoch nicht möglich. Auch die Backup-Synchronisation wird abgebrochen. Es funktioniert ausschließlich das Hochladen der Daten vom SVWS-Server zum WeNoM-Server.

Daraus ergeben sich folgende Probleme:

- Die im WeNoM erfassten Noten und weiteren Daten können nicht zum SVWS-Server zurückübertragen werden.
- Neu vergebene Passwörter beziehungsweise Passwortänderungen werden nicht ordnungsgemäß synchronisiert.
- Der aktuelle Passwortzustand kann nicht zuverlässig vom WeNoM-Server auf den SVWS-Server zurückgespielt werden.
- Die Backup-Synchronisation kann nicht erfolgreich abgeschlossen werden.

### Ursache

Als Ursache wurde häufig ein zu niedrig eingestelltes PHP-Memory-Limit auf dem WeNoM-Server vermutet bzw. ein zu scharf eingestellter Reverse Proxy.
Das verfügbare PHP-Speicherlimit / ReverseProxy Übertragungslimit auf den WeNoM-Server bei der Verarbeitung größerer Datenmengen wird überschritten. 

### Empfohlene Prüfung und Maßnahme

Es sollte geprüft werden, ob das PHP-Memory-Limit auf dem WeNoM-Server auf mindestens **512 MB** eingestellt ist.

Falls der Wert darunter liegt, sollte er entsprechend erhöht werden. Anschließend sollten die Rückübertragung der Daten sowie die Backup-Synchronisation erneut getestet werden.

Dabei ist zu überprüfen, ob die Noten- und sonstigen Nutzdaten sowie die Passwortänderungen anschließend in beide Richtungen korrekt synchronisiert werden.
