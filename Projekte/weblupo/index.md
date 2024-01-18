# weblupo

Ein webbasiertes Laufbahnberatungs- und Planungstool für die gymnasiale Oberstufe in NRW. 

Beschreibung und Benutzung des Tools ist unter https://hilfe.svws-nrw.de/gost/weblupo/ beschrieben. 

# technischer Hintergrund
Die User rufen eine Webseite auf und laden damit den ausführbaren Code herunter. Die von der Schule an die User verteilten .lp Dateien sind verschlüsselt und können hier geöffnet werden. Das bedeutet konkret, dass die Daten der User immer lokal auf ihrem PC, Tablet oder Handy bleiben und nicht zu Server gelangen. Außer beim erstmaligen Laden entsteht anschließend keine Last auf dem Server, so dass ein Server auch mehreren Schulen zur Verfügung gestellt werden kann. Nach verrichteter Fachwahl kann die Datei wieder lokal gespeichert werden. Dazu drücken die User den "Exportieren" Button und die Datei wird i.d.R. in den Downloadordner auf den verwendeten Client-Endgerät gespeichert. 

# Systemvoraussetzungen
Zur Bereitstellung ist ein einfacher Webspace ohne Datenbankanbindung, PHP o.Ä. schon ausreichend, um den Server zur Nutzung bereit zu stellen. Getestet wurde das Tool unter Debian 12 mit einem nginx oder einem Apache2 Webserver. Zur Erstellung der html Seiten aus den Quellen wird git und npm benötig. 

# Installation per zip download 

Unter unserem [Github repository](https://github.com/SVWS-NRW/SVWS-Server/releases) kann die aktuelle SVWS-Laufbahnplanung-x.y.z.zip heruntergeladen werden. 
Diese Datei in dem Webverzeichnis eines Hosters entpacken. Das wäre schon alles. 

Hier ein Beispiel für ein Debian 12 mit Apache2 als Webserver: 

````bash
cd /var/www/html/
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.8.8/SVWS-Laufbahnplanung-0.8.8.zip
unzip SVWS-Laufbahnplanung-0.8.8.zip
```

## Aktualisieren per zip download

Im Grunde müssen die Dateien nur ersetzt werden. Um sicher zu gehen sollten vorher die alten Dateien entfernt werden. Das wäre schon alles. 

Hier ein Beispiel für ein Debian 12 mit Apache2 als Webserver:

````bash
rm -rf /var/www/html/*
cd /var/www/html/
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.8.8/SVWS-Laufbahnplanung-0.8.8.zip
unzip SVWS-Laufbahnplanung-0.8.8.zip
```

# Installation aus den Github Quellen
[Todo: testen]
apache2, git und npm auf dem Server installieren.

'''bash
apt update && apt upgrade -y
apt install -y git apache2 npm 
rm /var/www/html/index.html 
'''
Quelldateien aus dem Gitrepository holen und im Anschluss die Serverseiten mit npm erstellen 

'''bash
cd /var/www/
git clone https://github.com/SVWS-NRW/SVWS-Server
cd /var/www/SVWS-Server/
npm i 
cd /var/www/SVWS-Server/svws-webclient/laufbahnplanung/
npm run build
cp -r /var/www/SVWS-Server/svws-webclient/laufbahnplanung/build/output/* /var/www/html/
'''

## Aktualisieren per Github 

'''bash
cd /var/www/SVWS-Server/
git pull
cd /var/www/SVWS-Server/
npm i 
cd /var/www/SVWS-Server/svws-webclient/laufbahnplanung/
npm run build
cp -r /var/www/SVWS-Server/svws-webclient/laufbahnplanung/build/output/* /var/www/html/
'''



 

