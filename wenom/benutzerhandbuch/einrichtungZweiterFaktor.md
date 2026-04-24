# Einrichtung der Zwei-Faktor-Authentifizierung 

Damit der Umgang mit sensiblen Daten über das Internet zusätzlich gesichert wird, ist es möglich, eine Zwei-Faktor-Authentifizierung für jeden Benutzer einzurichten.

Ist diese weitere Sicherheitsebene durch die schulfachliche Administration eingeschaltet worden, erhält ein Benutzer beim nächsten Login die Aufforderung den *Zweiten Faktor* einzurichten.

## Zwei-Faktor App installieren

Sie benötigen eine Authenticator-App als diesen zweiten Faktor. Eine solche App kann in Varianten auf lokalen Desktopsystemen, Tablets oder auch Handys verwendet werden.

Hier ein Beispiel einer Handy-App:

+ Richten Sie eine neue Verbindung ein (oft ein Plus-Zeichen).
+ Scannen Sie den QRCode

![Zwei Faktor Handy](./graphics/2fa_handy.png "Scannen Sie den QR-Code.")

+ Übertragen Sie den 6-stelligen Code, der auf dem Endgerät angezeigt wird, in die Eingabe unter TOTP Token, im Screenshot wird dieser durch den roten Kasten hervorgehoben. Bei diesen Verfahren werden *zeitbasierte Einmalkennworte* verwendet, die vom Nutzer in der Auth-App abzulesen und händisch bei einer Anmeldung bei einem Dienst einzugeben sind.

![Zwei Faktor Usereinrichtung](./graphics/2fa_user.png "Tragen Sie den in der App angezeigten Code in zur Anmeldung ein.")

Damit ist die Authentifizierung über einen zweiten Faktor eingerichtet und kann beim nächsten Login verwendet werden.
