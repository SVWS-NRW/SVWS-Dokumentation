# Administrative Arbeit mit WeNoM

## Ersteinrichtung WeNoM

Damit WeNoM und der SVWS-Server miteinander kommunizieren bzw. synchronisieren können, muss ein erstmalig internes Passwort, ein sog. *Secret* eingerichtet werden. Eine Beschreibung der Einrichtung befindet sich unter [technische Ersteinrichtung](../installation/ersteinrichtung.md).

## Synchronisation

Nachdem die Installation und Ersteinrichtung und damit die erfolgreiche Verbindung zum WeNoM-Server im SVWS-Server eingerichtet wurde, kann die schulfachliche Administration auf der Konfigurationsoberfläche des SVWS-Servers die Synchronisation zwischen beiden Datenbeständen ausführen.

![Administration zum Hoch- Runterladen und Synchronisieren und Daten löschen ](graphics/WenomSVWS.png "Syncrhonisieren Sie die Daten wie gewünscht oder entfernen Sie Daten.")

 In der Regel werden die Datenbestände *synchronisiert*, was einem Hochladen mit anschließendem Herunterladen entspricht.

Dabei wird anhand eines *Zeitstempels* in beiden Datenbeständen entschieden, welcher Eintrag der Neuere ist und der Eintrag mit dem neuesten Datum wird für den SVWS-Server erhlaten beziehungseise von WeNoM übernommen.

Beim Synchronisieren werden ebenfalls die Benutzer abgeglichen, so dass es für WeNoM ausschließlich Benutzer gibt, die im SVWS-Server vorhanden sind.

In besonderen Fällen kann nur hoch- beziehungsweise runtergeladen werden, so dass kein beidseitiger Abgleich über die Datumsstempel stattfindet.

## Zurücksetzen / Daten löschen

Über den Punkt **Zurücksetzen** bietet sich der schulfachlichen Administration die Möglichkeit,

+ **Daten** zurücksetzen
+ **Daten und Benutzer** zurücksetzen.

Im normalen halbjährlichen Schulabschnittswechsel können mit dem Punkt `Daten zurücksetzen` alte Zeugnisdaten zur Sicherheit aus dem über das Internet erreichbaren System genommen werden. Zum einen sind diese Daten dann überhaupt nicht mehr in WeNoM abrufbar und zum anderen kann ein neuer Lernabschnitt auf WeNoM sauber begonnen werden.

Falls ein installierter Webnotenmanager vollständig aufgegeben oder vollständig neu initialisiert werden soll und der schulfachliche Administrator somit die Löschung aller Daten auf dem WeNoM-Server durchführen muss, kann dies über den Schalter `Daten und Benutzer zurücksetzen` erreicht werden.

### Verbindungsdaten löschen oder erneuern

Wenn ein neues Secret benötigt wird oder ein Wenom-Server gelöscht werden soll, können die noch eingetragenen Zugangsdaten unter `Verbindungsdaten einrichten` gelöscht beziehungsweise erneuert werden.

![WenomVerbindungLoeschen.png](graphics/WenomVerbindungLoeschen.png "Löschen Sie die Verbindungsdaten für einen WeNoM-Server.")

::: danger Achtung!
Die *Daten*, die sich auf dem WeNoM-Server befinden, werden dabei nicht gelöscht. Es wird lediglich nur die *Verbindungsmöglichkeit* entfernt.

Die Möglichkeit zur Verbindung kann gegebenfalls wiederhergestellt werden, falls das *Secret* des WeNoM-Servers noch gültig ist.
:::

## Zugänge der Lehrkräfte

Die Lehrkräfte erhalten von der schulfachlichen Administration ein *Initialpasswort*. In Kombination mit der *Dienstlichen Emailadresse* als Benutzername ist dieses Kennwort der individuelle Zugang zum WebNotenManager.

![WenomInitialkennworte/Emailadressen einsehen im SVWS-Webclient](graphics/WenomInitialkennwort.png "Im SVWS-Webclient sind die Initialkennworte hinterlegt.")

Ungültige oder uneindeutige Email-Einträge in den Dienstmails werden als Fehler markiert und nicht zum WeNoM-Server übertragen.

Ebenso werden ausschließlich Dienstmailadressen und keine privaten E,Email-Adressen des Lehrerdatensatzes als Zugangsdaten verwendet.

Falls unter **Mail** eine gültige Emailadresse zum Versenden von Nachrichten für den WeNoM-Server eingetragen ist, können sich die Lehrkräfte ein neues Initialpasswort zuschicken lassen.

![Wenom Email Konfiguration](graphics/WenomMail.png "Konfigurieren Sie Emaildaten, um automatisch Kennwörter versenden zu können.")

(Diese Funktion ist in Version 1.0.12 noch nicht aktiviert.)

## Einrichten einer Zwei-Faktor-Authentifizierung

Sie können unter **Noten-> Administration -> Zugangsdaten** individuell oder auch gruppenweise die Zwei-Faktor-Authentisierung aktivieren. 

![Zwei Faktor Authentisierung](./graphics/2fa.png "Stellen Sie bei ausgewählten oder allen Benutzern ein, dass zwei Faktoren zur Authentisierung verwendet werden.")

Bei der Mehrfachauswahl von Benutzern können über den `Schalter TOTP` alle Benutzer verpflichtet werden, die Zwei-Faktor-Autorisierung beim ersten Login einzurichten.

![Zwei Faktor Authentisierung Gruppenprozess](./graphics/2fa_GP.png "Setzen Sie alle oder ausgewählte Zwei-Faktor-Authentisierungen zurück.")

An dieser Stelle können auch die einzelner Benutzer beziehungsweise alle Zwei-Faktor-Autorisierungen zurückgesetzt werden.

Dies wäre bei Verlust oder Diebstahl eines Endgerätes eine Möglichkeit, die Sicherheit der Daten zu wahren und Fremdzugriffe auszuschließen. 

Am *grünen Haken* unter 2FA ist zu erkennen, dass die Zwei-Faktor-Authentisierung für diese Benutzer eingeschaltet ist.

::: warning Synchronisation
Die Einstellungen werden erst durch eine erneute Synchronisation auf dem WeNoM-Server übertragen!
:::

## Konfiguration

![Konfiguration Notenmodul](./graphics/konfigurationNotenmodul.png)


## Mail 