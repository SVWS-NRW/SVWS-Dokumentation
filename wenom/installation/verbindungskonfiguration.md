# Technische Ersteinrichtung von WeNoM

## Generation des Secrets

??? Was ist ein Secret?

Das Secret kann durch die Eingabe der Verbindungsdaten im SVWS-Web-Client generiert werden.

Bei der erstmaligen Eingabe der Daten wird der /api/setup Befehl einmal gesendet.

### Generation des Secrets durch einen direkten API-Aufruf

Zur ersten Initialisierung folgende URL */api/setup* auf ihrer Domain aufrufen, ein Beispiel wäre etwa: 

    https://meinnotenmanager.de/api/setup

Über die Konsole des Browsers (F12) kann die Response überprüft werden.

Gültige Responsecodes sind:

    204 Setup erfolgreich
    409 Server ist schon initialisiert

Alternativ kann mit Tools wie Insomnia, Postman oder Bruno oder direkt curl gearbeitet werden.

+ Auth: keine Authentisierung
+ Headers ContentType application/x-www-form-urlencoded

Der zugehörige Curl-Befehl ist:

```bash
curl --request GET --url http://meinnotenmaganger/api/setup --header "Content-Type: application/x-www-form-urlencoded"
```

Der Aufruf des oben genannten api-Befehls erzeugt im Ordner */db* eine *app.sqlite*-Datenbank und eine Datei *client.sec*.

In dieser Datei steht das generierte *Secret*.

Dieses *Secret* kann im SVWS-Client in der **App Noten** unter **Serververbingungen** und dann bei der gewählten Verbindung zusammen mit der *URL* eingegeben werden und ermöglich so die Synchronisation mit dem SVWS-Server.

Soll WeNoM auf einem Webserver mehrere WeNoM für mehrere Mandanten anbieten, nehmen Sie folgend die entsprechenden Artikel zur Kenntnis.

Hiermit endet die **technische Installation** durch die IT. Damit WeNoM von der Schule verwendet werden kann, sind durch die Schul-Administratoren des SVWS-Servers/SVWS-Webclients Einstellungen vorzunehmen.
