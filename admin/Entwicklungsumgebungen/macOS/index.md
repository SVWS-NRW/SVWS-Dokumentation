# Installation auf macOS
Für die Entwicklung auf macOS ist der Einsatz von homebrew und Docker/Podman vorteilhaft. Dies gilt sowohl für Rechner mit Intel CPU als auch mit Silicon CPU.

Homebrew (brew.sh) wird genutzt, um benötigte Software vom Terminal aus zu installieren, Docker/Podman ist für den Einsatz der MariaDB zu empfehlen.

```zsh
# Installiere Homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nun die benötigten Programme:
brew install node git openjdk@21

# Java für den Server einrichten
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk

# den Docker Desktop:
brew install podman

podman machine init
podman machine start

# nun mariadb als container starten, hier auf Port 3307
podman run -p 127.0.0.1:3307:3306 --name mariadb -e MARIADB_ROOT_PASSWORD=svwsadmin -d mariadb

# wer mag, den VS Code
brew install visual-studio-code

git clone https://github.com/SVWS-NRW/SVWS-Server.git
cd SVWS-Server
git checkout dev
./gradlew assemble

# Bitte den Pfad der Clients unten anpassen:
tee svwsconfig.json <<EOF
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : null,
  "DisableTLS" : null,
  "PortHTTP" : null,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 443,
  "PortHTTPPrivilegedAccess" : null,
  "UseCORSHeader" : true,
  "TempPath" : "tmp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : "./svws-server-app",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "/Users/DEIN_USER/SVWS-Server/svws-webclient/build/output",
  "AdminClientPath" : "/Users/DEIN_USER/SVWS-Server/svws-webclient/admin/build/output",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "ServerMode" : "dev",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "127.0.0.1:3307",
    "defaultschema" : "GymAbi",
    "SchemaKonfiguration" : [ {
      "name" : "GymAbi",
      "svwslogin" : false,
      "username" : "svwsadmin",
      "password" : "svwsadmin"
    } ],
    "connectionRetries" : 0,
    "retryTimeout" : 0
  }
}
EOF

# alle Komponenten sind nun vorbereitet und können gestartet werden

# Nun den Keystore noch nach svws-server-app/keystore kopieren:
cp cp svws-server-app/src/main/resources/keystore.example svws-server-app/keystore

# Dazu den Server starten, am besten in einem eigenen Terminal, z.B. dem von code:
svws-server-app/start_server.sh

# nun läuft der Server. Entweder direkt mit dem Client über https://localhost verbinden
# oder den dev-Server starten des Clients:

cd svws-webclient/client
npm run dev

# nun läuft auf http://localhost:3000 der dev-Server

```

Anschließend muss noch eine Datenbank initialisiert werden. Dazu kann der Admin-client verwendet werden:

```bash
cd svws-webclient/admin
npm run dev
```

Der Admin-Client sollte auf einem lokalen Port verfügbar sein, vite wird beim Start die genaue Adresse ausgeben.

## Einrichtung der PHP-Umgebung für den ENM-Server
Um den ENM-Server lokal nutzen zu können, muss PHP installiert sein. Ist dies bereits der Fall, reicht:

```bash
cd svws-webclient/enmserver
php -S 127.0.0.1:1443 router.php
```

Aber da eine PHP-Installation meist recht invasiv ist und podman sowieso schon vorhanden ist, kann auch ein Container
verwendet werden.

Dazu wird im `enmserver`-Verzeichnis ein Docker-Container gebaut und anschließend verwendet:

```bash
# in das Verzeichnis wechseln
cd svws-webclient/enmserver
# mit Podman ein neues Image bauen (siehe Dockerfile)
podman build -t enmserver:latest .
# den Container auf Port 1443 starten
podman run -p 1443:443 -v ./src/php:/var/www --rm --name php enmserver
```

Das gebaute Image verwendet die vorgegebenen Pfade des ENM-Servers und erstellt ein neues Zertifikat. Dies muss nun
geladen und als `localhost.pem` abgelegt werden:

```bash
openssl s_client -showcerts -connect localhost:1443 </dev/null 2>/dev/null|openssl x509 -outform PEM >localhost.pem
```

:::warning Achtung
Im folgenden wird davon ausgegangen, dass zur Installation von Java `homebrew` verwendet wurde. Für andere Installationsarten gelten andere Verzeichnisse.
:::

Nun wird das Zertifikat in den Java-Keystore importiert:

```bash
keytool -import -trustcacerts -alias enmserver -file localhost.pem -keystore /opt/homebrew/Cellar/openjdk@21/21.0.5/libexec/openjdk.jdk/Contents/Home/lib/security/cacerts
```

Hier ist zu beachten, dass sich der Pfad mit jeder Java-Version ändern wird. Bitte entsprechend anpassen.

Jedes Mal, wenn das Zertifikat auf diesem Weg neu impoertiert werden soll oder das alte aus anderen Gründen gelöscht werden soll, ist folgender Befehl zu nutzen:

```bash
keytool -delete -keystore /opt/homebrew/Cellar/openjdk@21/21.0.5/libexec/openjdk.jdk/Contents/Home/lib/security/cacerts
```

`keytool` fragt nun nach dem Alias, man antwortet mit `enmserver`, dies ist der frei vergebene Alias, der beim Import angegeben wurde.

Um sich das aktuelle Zertifikat anzeigen zu lassen, wird dieser Befehl verwendet:

```bash
keytool -list -alias enmserver -keystore /opt/homebrew/Cellar/openjdk@21/21.0.5/libexec/openjdk.jdk/Contents/Home/lib/security/cacerts
```

Nun kann der SVWS-Server mit dem ENM-Server kommunizieren.