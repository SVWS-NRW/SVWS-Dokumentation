# Installation des SVWS-GradeHub

Laden Sie den **SVWS Externen Notenmanager für Lehrkräfte GradeHub** auf der [Seite des MSB für Schulverwaltungssoftware](https://www.svws.nrw.de/) im Bereich für [Tools und Module](https://www.svws.nrw.de/svws-server-schild-nrw-3/svws-server-tools-module) herunter.

* Als .zip, (auch) geeignet für Webserver (-> Impressum!)
* Als MS-Windows-exe
* als Linux-executable appimage.

3. Anwendung starten
Option A: Offline im Browser
Entpacken Sie gradehub-*-offline.zip.
Öffnen Sie index.html im Browser.
Die Anwendung läuft vollständig lokal — keine Serververbindung nötig.
Im file://-Modus ist die Verschlüsselung aus technischen Gründen (kein Secure Context) eingeschränkt. Die App weist darauf hin.

Option B: Statischer Webserver (z. B. Jetty)
Entpacken Sie gradehub-*-webserver.zip in das Webroot-Verzeichnis des Servers.
Rufen Sie die URL im Browser auf (z. B. https://svws-server.schule.de/gradehub/).
Bei https:// steht die vollständige Verschlüsselung zur Verfügung.
Option C: Node.js-Server (mit E-Mail-Funktion)
Entpacken Sie gradehub-*-node-server.zip auf einem Server mit Node.js.
Installieren Sie die Abhängigkeiten:
npm install --omit=dev
Starten Sie den Server:
node server.js               # Port 3000 (Standard)
PORT=8080 node server.js     # oder ein anderer Port
Rufen Sie die URL im Browser auf (z. B. http://server:3000).
Für den Dauerbetrieb empfiehlt sich ein Prozessmanager:

npm install -g pm2
pm2 start server.js --name gradehub
pm2 save
Option D: Electron-Desktop-App
Linux: SVWS-GradeHub-*.AppImage ausführbar machen und starten.
Windows: SVWS-GradeHub-Setup-*.exe installieren und starten.
Die Desktop-App enthält den Node.js-Server bereits eingebettet — E-Mail-Versand ist ohne separate Serverinstallation verfügbar.

4. Optionale Mail-Funktion neben Jetty
Wenn GradeHub über einen statischen Webserver (z. B. den SVWS-Jetty-Server) ausgeliefert wird und der E-Mail-Versand trotzdem genutzt werden soll, kann server.js parallel auf einem anderen Port betrieben werden.

Voraussetzung
Node.js ist auf dem Server verfügbar und gradehub-*-node-server.zip wurde entpackt und gestartet (z. B. auf Port 3001, s. Option C).

Konfiguration
Öffnen Sie die Datei config.js im Webroot-Verzeichnis der statischen Auslieferung und tragen Sie die URL des Node.js-Servers ein:

window.GRADEHUB_CONFIG = {
  mailServerUrl: 'https://svws-server.schule.de:3001',
}
Speichern Sie die Datei — kein Neustart und kein Neubau nötig. Beim nächsten Seitenaufruf erkennt GradeHub den Mail-Server automatisch, und der Button Dateien versenden erscheint im Adminbereich.

Hinweis: Port 3001 muss in der Firewall des Servers nach außen freigegeben sein.

5. Laufzeit-Konfiguration (config.js)
Die Datei config.js im Webroot kann nach dem Build jederzeit angepasst werden, ohne die Anwendung neu zu bauen:

Option	Werte	Beschreibung
admintoolVisible	true / false	Adminbereich ein- oder ausblenden
mailServerUrl	URL-String oder leer	URL des Node.js-Mail-Servers (nur bei separatem Betrieb nötig)
Beispiel für eine vollständige Konfiguration:

window.GRADEHUB_CONFIG = {
  admintoolVisible: true,
  mailServerUrl: 'https://svws-server.schule.de:3001',
}
Ist mailServerUrl nicht gesetzt, verwendet die App relative Pfade — das ist der Standardfall, wenn server.js die App selbst ausliefert.

