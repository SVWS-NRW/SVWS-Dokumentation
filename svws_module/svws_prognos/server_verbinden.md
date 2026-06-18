Verbindung zum SVWS-Server
← Übersicht

Beim ersten Start öffnet sich automatisch der Verbindungsdialog. Dieser fragt vier Angaben ab, die Sie von Ihrer Schulverwaltung oder Ihrem IT-Betreuer erhalten:

Verbindungsformular
Server-URL
Die vollständige Adresse Ihres SVWS-Servers, inklusive Protokoll und ggf. Port.

Beispiele:

https://svws.meine-schule.de
https://10.0.0.5:8443
Die URL beginnt immer mit https://. Eine unverschlüsselte Verbindung (http://) wird nicht unterstützt.

Schema
Das Schema entspricht dem Datenbank-Mandanten Ihrer Schule auf dem SVWS-Server. Jede Schule hat ein eigenes Schema. Der Name wird in der SVWS-Administration festgelegt.

Beispiel: gesamtschule_musterstadt

Wenden Sie sich bei Unklarheiten an Ihren SVWS-Administrator.

Benutzername und Passwort
Geben Sie Ihre persönlichen SVWS-Zugangsdaten ein. Es werden dieselben Daten verwendet, die Sie auch für den SVWS-WebClient nutzen.

Sicherheitshinweis: SVWS-Prognos speichert Ihr Passwort ausschließlich im Arbeitsspeicher — niemals auf der Festplatte oder in einer Datei. Nach dem Beenden der App sind alle Zugangsdaten gelöscht.

Verbindung herstellen
Klicken Sie nach dem Ausfüllen auf „Verbinden”. Die App:

Prüft die Erreichbarkeit des SVWS-Servers
Authentifiziert Ihren Benutzer
Lädt die verfügbaren Schuljahresabschnitte
Leitet Sie auf das Dashboard weiter
Verbindung beenden
Über den Button „Abmelden” auf dem Dashboard können Sie die Verbindung jederzeit trennen. Sie werden zum Verbindungsformular zurückgeleitet. Alle Daten im Speicher werden gelöscht.

Fehlermeldungen beim Verbinden
Meldung	Mögliche Ursache	Lösung
„Verbindung fehlgeschlagen”	Server nicht erreichbar, falsche URL	URL prüfen, Netzwerkverbindung prüfen
„Verbindung fehlgeschlagen”	Falsches Schema	Schema-Namen beim Administrator erfragen
„Verbindung fehlgeschlagen”	Falsches Passwort / gesperrter Account	Zugangsdaten prüfen
Seite lädt nicht	Firewall oder Proxy blockiert	IT-Abteilung kontaktieren
SSL-Zertifikatsfehler	Selbstsigniertes Zertifikat auf dem Server	Siehe Hilfe
Weitere Hinweise zur Fehlerdiagnose finden Sie auf der Seite Hilfe & Problemlösung.

Nächste Schritte
Nach erfolgreicher Verbindung gelangen Sie automatisch zum Dashboard:

→ Das Dashboard kennenlernen

