# Ersteinrichtung

::: tip Voraussetzung für diesen Artikel
Bevor der WebNotenManager durch die Schule konfiguriert werden kann, muss die **Installation sowohl des Webservers als auch des schulischen Teils des WeNoM-Setups** abgeschlossen sein.
:::

Damit sich eine Lehrkraft anmelden kann, muss zuerst eine Synchronisation mit dem SVWS-Server eingerichtet werden. Erst dann werden die WeNoM-Daten, wie beispielsweise die persönlichen Lehrkraftzugänge, die Möglichkeit, E-Mails zu senden, oder die Klassen- und Kurslisten für die Notenerfassung, befüllt.

Für die Einrichtung der Synchronisation wird ein sogenanntes *Secret* benötigt, das bei der Ersteinrichtung im Zuge der technischen Installation erzeugt wird. Dies ist Aufgabe der für die Schule zuständigen technischen Administration/IT-Abteilung.

## Einrichtung der Synchronisation mit dem SVWS-Server

Die Einrichtung der Synchronisation mit dem SVWS-Server obliegt der für die Schule zuständigen **schulfachlichen Administration**, gegebenfalls also der Schulleitung, Stellvertretung oder Beauftragte/technische Koordinatoren/Schuladmins. Es werden somit höhere Rechte beim Benutzer des SVWS-Servers benötigt. Das oben genannte *Secret* und die URL des WeNoM liegen dem schulfachlichen Administrator vor.

Die Konfigurationsoberfläche für den WebNotenmanager befindet sich im Webclient des SVWS-Servers in der App **Noten ➜ Serververbindungen ➜ Verbindung**. 

 Hier werden das der schulfachlichen Administration vorliegende Secret und die URL eingetragen. Bitte hierbei auf die Schreibweise achten. Beispiel:
 
    https://wenom.ihre-domain.de

![WenomEinrichtung.png](graphics/WenomEinrichtung.png)

Nachdem die Verbindungsdaten erfolgreich eingegeben wurden, wird ein automatischer Verbindungstest durchgeführt. 


## Fehler bei der Einrichtung 

### Abweichungen des internen Names

Möglicherweise ist die URL vom SVWS-Server aus nicht auffindbar. Dies könnte an den Einstellungen eines Proxyservers liegen.

Hier könnte eine direkte Angabe der IP-Adresse statt des DNS-Namens erfolgen oder es könnte die Eingabe von `http://` statt `https://` ausprobiert werden. 

### Benutzung eines internen Zertifikats

In manchen seltenen netzinternen Umgebungen kann die Frage auftreten, ob dem eigenen Zertifikat vertraut werden soll. Dies kann in Absprache mit dem technischen Admin durch Setzen des Hakens bestätigt werden. 

### Verbindung prüfen 

Sind die Zugangsdaten eingerichtet, kann die Verbindung jederzeit unter „Verbindungsdaten einrichten” geprüft werden. 

![WenomEinrichtung2.png](graphics/WenomEinrichtung2.png)

Fahren Sie nun mit der **Synchronisation** fort, die im Benutzerhandbuch für die [schulfachliche Administration](../benutzerhandbuch/synchronisation_administration.md) beschrieben ist.
