# macOS
Für die Entwicklung auf macOS ist der Einsatz von homebrew und Docker/Podman vorteilhaft. Dies gilt sowohl für Rechner mit Intel CPU als auch mit Mx.

Homebrew (brew.sh) wird genutzt, um benötigte Software vom Terminal aus zu installieren, Docker/Podman ist für den Einsatz der MariaDB zu empfehlen.

Das Script nutzt noch die GitHub-Token. Wenn es jemand auf diesem Weg ausprobiert, bitte die Doku an den entsprechenden Stellen anpassen.

```bash
# Installiere Homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nun die benötigten Programme:
brew install node git openjdk@17

# Java für den Server einrichten
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# den Docker Desktop:
brew install --cask podman

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

# Bitte den Pfad unten anpassen:
tee svws-server-app/svwsconfig.json <<EOF
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : null,
  "DisableTLS" : null,
  "PortHTTP" : null,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 443,
  "UseCORSHeader" : true,
  "TempPath" : "tmp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : "./svws-server-app",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "/Users/DEIN_USER/SVWS-Server/svws-webclient/build/output",
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

cd ..


# alle Komponenten sind nun vorbereitet und können gestartet werden

# Nun den Keystore noch nach svws-server-app/keystore kopieren:
cp cp svws-server-app/src/main/resources/keystore.example svws-server-app/keystore

# Dazu den Server starten, am besten in einem eigenen Terminal, z.B. dem von code:
cd SVWS-Server
svws-server-app/start_server.sh

# nun läuft der Server. Entweder direkt mit dem Client über https://localhost verbinden
# oder den dev-Server starten des Clients:

cd svws-webclient/src/client/ts
npm run dev

# nun läuft auf http://localhost:3000 der dev-Server

```

Anschließend muss noch eine Datenbank initialisiert werden, dazu sollte vorerst die Debug-Schnittstelle genutzt werden: https://localhost/debug
