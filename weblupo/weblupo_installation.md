# WebLuPO

**Installationsanleitung und technische Dokumentation**

WebLuPo ist ein webbasiertes Laufbahnberatungs- und Planungstool für die gymnasiale Oberstufe in NRW.

Die Beschreibung und Benutzung des Tools für Anwender ist unter den Benutzerhandbüchern [WebLuPO Handbuch](weblupo_handbuch.md) zu finden.

## Technischer Hintergrund

Die Nutzer erhalten von der Schule `.lp`-Dateien, die über einen Link zum WebLuPO-Client geöffnet werden können. Dieser Client wird ausschließlich im Browser ausgeführt und versendet keine Daten.

Das bedeutet konkret, dass die Daten der Nutzer immer lokal auf ihrem PC, Tablet oder Handy bleiben und nicht auf einen Server übertragen werden. Außer beim erstmaligen Laden entsteht anschließend keine Last auf dem Server, sodass ein Server auch von mehreren Schulen genutzt werden kann.

Die Schülerinnen und Schüler können damit am Webbrowser individuell ihre Laufbahnplanung durchführen. Nachdem die Planung abgeschlossen ist, kann die Datei lokal gespeichert werden.

Dazu klicken Sie auf die Schaltfläche `Exportieren` und die Datei wird normalerweise im Download-Ordner des verwendeten Endgeräts gespeichert.

## Systemvoraussetzungen

Für die Bereitstellung des Clients ist ein einfacher Webspace ausreichend, ohne Datenbankanbindung oder PHP. Das Tool wurde unter Debian 12 mit einem nginx oder Apache2 Webserver getestet.

## Installation per zip download

Die aktuelle SVWS-Laufbahnplanung-x.y.z.zip kann vom [Github repository](https://github.com/SVWS-NRW/SVWS-Server/releases) heruntergeladen werden.

Entpacken Sie diese Datei im Webverzeichnis Ihres Hosters.

Hier ist ein Beispiel für ein Debian 12 mit Apache2 als Webserver:

```bash
cd /var/www/html/
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.8.8/SVWS-Laufbahnplanung-0.8.8.zip
unzip SVWS-Laufbahnplanung-0.8.8.zip
```

## Aktualisieren per zip-download

Die Dateien müssen lediglich ersetzt werden. Um sicher zu gehen, empfiehlt es  sich, zuvor die alten Dateien zu entfernen.

Hier ist ein Beispiel für ein Debian 12 mit Apache2 als Webserver:

```bash
rm -rf /var/www/html/*
cd /var/www/html/
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.8.8/SVWS-Laufbahnplanung-0.8.8.zip
unzip SVWS-Laufbahnplanung-0.8.8.zip
```
