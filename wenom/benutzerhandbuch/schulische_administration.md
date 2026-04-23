# Administrative Arbeit mit WeNoM

## Ersteinrichtung WeNoM

Damit WeNoM und der SVWS-Server miteinander kommunizieren bzw. synchronisieren können, muss ein erstmalig internes Passwort, ein sog. *Secret* eingerichtet werden. Eine Beschreibung der Einrichtung befindet sich unter [technische Ersteinrichtung](../installation/ersteinrichtung.md).

## Synchronisation

Nachdem die Installation und Ersteinrichtung und damit die erfolgreiche Verbindung zum WeNoM-Server im SVWS-Server eingerichtet wurde, kann die schulfachliche Administration auf der Konfigurationsoberfläche des SVWS-Servers die Synchronisation zwischen beiden Datenbeständen ausführen.

![WenomSVWS.png](graphics/WenomSVWS.png)

In besonderen Fällen kann nur hoch- beziehungsweise runtergeladen werden. In der Regel werden die Datenbestände jedoch direkt synchronisiert, was einem Hochladen mit anschließendem Herunterladen entspricht.

Dabei wird anhand eines *Zeitstempels* in beiden Datenbeständen entschieden, welcher Eintrag der neuere ist und dieser wird dann für den SVWS-Server übernommen.

## Zurücksetzen / Daten löschen

Über den Punkt **Zurücksetzen** bietet sich der schulfachlichen Administration die Möglichkeit,

+ Daten zurücksetzen
+ Daten und Benutzer zurücksetzen.

Im normalen halbjährlichen Schulabschnittswechsel können mit dem Punkt `Daten zurücksetzen` alte Zeugnisdaten zur Sicherheit noch einmal aus dem über das Internet erreichbaren System genommen werden, sodass das neue Halbjahr sauber begonnen werden kann.

Falls ein Webnotenmanager aufgegeben werden soll und der schulfachliche Administrator somit die Löschung aller Daten auf dem Wenom-Server durchführen muss, kann dies über `Daten und Benutzer zurücksetzen` erreicht werden.

### Verbindungsdaten löschen / erneuern

Wenn ein neues Secret benötigt wird oder ein Wenom-Server gelöscht werden soll, können die noch eingetragenen Zugangsdaten unter `Verbindungsdaten einrichten` gelöscht bzw. erneuert werden.

![WenomVerbindungLoeschen.png](graphics/WenomVerbindungLoeschen.png)

::: danger Achtung!
Die *Daten*, die sich auf dem WeNoM-Server befinden, werden dabei nicht gelöscht. Es wird nur die *Verbindungsmöglichkeit* gelöscht.

Diese kann gegebenfalls auch wiederhergestellt werden, falls das Secret des WeNoM-Servers noch gültig ist.
:::

## Zugänge der Lehrkräfte

Die Lehrkräfte erhalten von der schulfachlichen Administration ein *Initialpasswort*. In Kombination mit der *Dienstlichen Emailadresse* ist dieses Kenntwort der individuelle Zugang zum WebNotenManager.

![WenomInitialkennwort.png](graphics/WenomInitialkennwort.png)

Ungültige oder uneindeutige Email-Einträge in den Dienstmails werden als Fehler markiert und nicht zum WeNoM-Server übertragen. Ebenso werden nur die Dienstmailadressen und keine privaten E-Mail-Adressen des Lehrerdatensatzes als Zugangsdaten verwendet.

Falls unter **Mail** eine gültige Emailadresse zum Versenden von Nachrichten für den WeNoM-Server eingetragen ist, können sich die Lehrkräfte statt des Initialpassworts ein neues Initialpasswort zuschicken lassen.

![WenomMail.png](graphics/WenomMail.png)

(Diese Funktion ist in Version 1.0.12 noch nicht aktiviert.)

## Einrichten einer Zwei-Faktor-Authentifizierung

Sie können unter **Noten-> Administration -> Zugangsdaten** individuell oder auch gruppenweise die Zwei-Faktor-Authentisierung aktivieren. 

![Zwei Faktor Authentisierung](./graphics/2fa.png)

Bei der Mehrfachauswahl von Benutzern können beispielsweise durch drücken des Buttons TOTP alle Benutzer verpflichtet werden die Zweifaktorautorisierung beim ersten Login einzurichten. 

![Zwei Faktor Authentisierung Gruppenprozess](./graphics/2fa_GP.png)

An dieser Stelle können auch einzelne bzw. alle Zweifaktor Authorisierungen zurückgesetzt werden. Dies wäre bei Verlust oder Diebstahl eines Endgerätes eine möglichkeit die Datenintegrität zu wahren. 

Am grünen Haken unter 2FA erkennen man, dass die Zwei-Faktor-Authentisierung für diese Benutzer eingeschaltet ist 

::: warning Synchronisation
Die Einstellungen werden erst durch eine erneute Synchronisation auf dem WeNoM-Server übertragen 
:::

## Konfiguration

![Konfiguration Notenmodul](./graphics/konfigurationNotenmodul.png)


## Mail 