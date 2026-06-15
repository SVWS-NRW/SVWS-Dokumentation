# Installation des SVWS Prognosewerkzeugs

Installation
← Übersicht

SVWS-Prognos steht in drei Varianten bereit:

Variante	Betriebssystem	Datei
Desktop-App (Windows)	Windows 10 / 11	SVWS-Prognos-x.x.x.exe
Desktop-App (Linux)	Ubuntu, Fedora u. a.	SVWS-Prognos-x.x.x.AppImage
Web-Bundle	Beliebiger Browser	SVWS-Prognos-x.x.x-webserver.zip
Die aktuellen Downloads finden Sie auf der Release-Seite des Projekts.

Installation unter Windows
Voraussetzungen
Windows 10 (64-Bit) oder Windows 11
Keine weitere Software erforderlich (alle Abhängigkeiten sind enthalten)
Schritte
Laden Sie die Datei SVWS-Prognos-x.x.x.exe herunter.
Starten Sie die Installationsdatei mit einem Doppelklick.
Folgen Sie dem Installationsassistenten.
SVWS-Prognos wird im Startmenü eingetragen und kann direkt geöffnet werden.
Windows-Sicherheitswarnung: Da die Anwendung aktuell kein Code-Signing-Zertifikat besitzt, kann Windows beim ersten Start eine SmartScreen-Warnung anzeigen. Klicken Sie auf „Weitere Informationen” und anschließend auf „Trotzdem ausführen”.

Installation unter Linux
Voraussetzungen
64-Bit-Linux-Distribution (Ubuntu 20.04+, Fedora 38+, Debian 11+)
Ausführungsrecht auf die AppImage-Datei
Schritte
Laden Sie die Datei SVWS-Prognos-x.x.x.AppImage herunter.
Machen Sie die Datei ausführbar. Entweder über den Dateimanager (Rechtsklick → Eigenschaften → Ausführen erlauben) oder im Terminal:

chmod +x SVWS-Prognos-x.x.x.AppImage
Starten Sie die App per Doppelklick oder im Terminal:

./SVWS-Prognos-x.x.x.AppImage
Hinweis für Wayland-Nutzer: Sollte die App nicht starten, fügen Sie die Option --ozone-platform=x11 hinzu:

./SVWS-Prognos-x.x.x.AppImage --ozone-platform=x11
Betrieb als Web-App (Webserver)
Wenn Sie SVWS-Prognos auf einem Schulserver als Web-Anwendung bereitstellen möchten, nutzen Sie das Web-Bundle.

Voraussetzungen
Ein Webserver (z. B. nginx, Apache)
HTTPS-Zertifikat (empfohlen, da SVWS-Server meist HTTPS verwendet)
Schritte
Laden Sie SVWS-Prognos-x.x.x-webserver.zip herunter.
Entpacken Sie das Archiv in das Webverzeichnis Ihres Webservers, z. B.:

unzip SVWS-Prognos-x.x.x-webserver.zip -d /var/www/html/prognos/
Rufen Sie die App im Browser auf: https://ihr-schulserver.de/prognos/
CORS-Hinweis: Im Web-Browser-Betrieb muss der SVWS-Server CORS-Anfragen von Ihrer Domain erlauben. Wenden Sie sich dazu an Ihren SVWS-Administrator.

Systemanforderungen
Merkmal	Mindestanforderung
Prozessor	x86-64 (Intel/AMD 64-Bit)
Arbeitsspeicher	512 MB RAM
Bildschirmauflösung	1280 × 768 Pixel
Netzwerk	Verbindung zum SVWS-Server der Schule
Browser (Web-Variante)	Chrome 90+, Firefox 90+, Edge 90+, Safari 15+
Nächste Schritte
Nach der Installation verbinden Sie die App mit Ihrem SVWS-Server:

→ Verbindung zum SVWS-Server herstellen