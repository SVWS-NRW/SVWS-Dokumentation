# WebLuPO

Ein webbasiertes Laufbahnberatungs- und Planungstool für die gymnasiale Oberstufe in NRW. 

Beschreibung und Benutzung des Tools ist unter [doku.svws-nrw.de](https://doku.svws-nrw.de/laufbahnplanung/) beschrieben. 

# Technischer Hintergrund

Die Nutzer erhalten von der Schule .lp-Dateien, die über einen WebLuPO Server geöffnet werden. Auf diesem Server wird eine Webseite aufgerufen und damit ausführbarer Code heruntergeladen. Das bedeutet konkret, dass die Daten der Nutzer immer lokal auf ihrem PC, Tablet oder Handy bleiben und nicht auf den Server übertragen werden. Außer beim erstmaligen Laden entsteht anschließend keine Last auf dem Server, sodass ein Server auch von mehreren Schulen genutzt werden kann. Die Schülerinnen und Schüler können damit am Webbrowser individuell ihre Laufbahnplanung durchführen. Nachdem die Planung abgeschlossen ist, kann die Datei lokal gespeichert werden. Dazu klicken Sie auf die Schaltfläche 'Exportieren' und die Datei wird normalerweise im Download-Ordner des verwendeten Endgeräts gespeichert. 

# Systemvoraussetzungen

Für die Bereitstellung des Servers ist ein einfacher Webspace ausreichend, ohne Datenbankanbindung oder PHP. Das Tool wurde unter Debian 12 mit einem nginx oder Apache2 Webserver getestet. Zur neuen Erstellung der HTML-Seiten aus den Quellen werden git und npm benötigt, für den einfachen download nur wget bzw. zip. 

# Installation per zip download 

Die aktuelle SVWS-Laufbahnplanung-x.y.z.zip kann unter unserem  [Github repository](https://github.com/SVWS-NRW/SVWS-Server/releases) heruntergeladen werden. 
Entpacken Sie diese Datei im Webverzeichnis Ihres Hosters.  

Hier ist ein Beispiel für ein Debian 12 mit Apache2 als Webserver: 

```bash
cd /var/www/html/
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.8.8/SVWS-Laufbahnplanung-0.8.8.zip
unzip SVWS-Laufbahnplanung-0.8.8.zip
```

## Aktualisieren per zip download

Die Dateien müssen lediglich ersetzt werden. Es empfiehlt sich, vorher die alten Dateien zu entfernen, um sicherzugehen.  

Hier ist ein Beispiel für ein Debian 12 mit Apache2 als Webserver:

```bash
rm -rf /var/www/html/*
cd /var/www/html/
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.8.8/SVWS-Laufbahnplanung-0.8.8.zip
unzip SVWS-Laufbahnplanung-0.8.8.zip
```

# Installation aus den Github Quellen
[Todo: testen]
apache2, git und npm auf dem Server installieren.

```bash
apt update && apt upgrade -y
apt install -y git apache2 npm 
rm /var/www/html/index.html 
```
Quelldateien aus dem Gitrepository holen und im Anschluss die Serverseiten mit npm erstellen 

```bash
cd /var/www/
git clone https://github.com/SVWS-NRW/SVWS-Server
cd /var/www/SVWS-Server/
npm i 
cd /var/www/SVWS-Server/svws-webclient/laufbahnplanung/
npm run build
cp -r /var/www/SVWS-Server/svws-webclient/laufbahnplanung/build/output/* /var/www/html/
```

## Aktualisieren per Github 


```bash
cd /var/www/SVWS-Server/
git pull
cd /var/www/SVWS-Server/
npm i 
cd /var/www/SVWS-Server/svws-webclient/laufbahnplanung/
npm run build
cp -r /var/www/SVWS-Server/svws-webclient/laufbahnplanung/build/output/* /var/www/html/
```



 

