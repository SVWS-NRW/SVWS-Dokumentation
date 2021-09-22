# macOS
Für die Entwicklung auf macOS ist der Einsatz von homebrew und Docker vorteilhaft. Dies gilt sowohl für Rechner mit Intel CPU als auch mit M1.

Homebrew (brew.sh) wird genutzt, um benötigte Software vom Terminal aus zu installieren, Docker ist für den Einsatz der MariaDB zu empfehlen.

Das Script nutzt noch die GitHub-Token. Wenn es jemand auf diesem Weg ausprobiert, bitte die Doku an den entsprechenden Stellen anpassen.

```
# Installiere Homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nun die benötigten Programme:
brew install node git openjdk@11

# Java für den Server einrichten
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# den Docker Desktop:
brew install --cask docker

# wer mag, den VS Code
brew install visual-studio-code

# Erstelle zwei Umgebungsvariablen für Zugriff auf die privaten Repos
export GITHUB_ACTOR="Dein_GH_User"
export GITHUB_TOKEN="Dein_GH_Token"
# Diese können auch in der .zshrc abgelegt werden

# UI-Framework einrichten:
git clone git@github.com:SVWS-NRW/SVWS-UI-Framework.git
cd SVWS-UI-Framework
git checkout dev
npm install
npm build
npm link
cd ..

git clone git@github.com:FPfotenhauer/SVWS-Server.git
cd SVWS-Server
git checkout dev
./gradlew assemble

# Bitte den Pfad unten anpassen:
tee svws-server-app/svwsconfig.json <<EOF
{
  "EnableClientProtection" : null,
  "DisableDBRootAccess" : false,
  "DisableAutoUpdates" : null,
  "UseHTTPDefaultv11" : false,
  "PortHTTPS" : 443,
  "UseCORSHeader" : true,
  "TempPath" : "tmp",
  "TLSKeyAlias" : null,
  "TLSKeystorePath" : ".",
  "TLSKeystorePassword" : "svwskeystore",
  "ClientPath" : "PFAD_ZUM_/SVWS-Client/build/output",
  "LoggingEnabled" : true,
  "LoggingPath" : "logs",
  "DBKonfiguration" : {
    "dbms" : "MARIA_DB",
    "location" : "127.0.0.1",
    "defaultschema" : null,
    "SchemaKonfiguration" : [ {
      "name" : "svwsschema",
      "svwslogin" : false,
      "username" : "svwsadmin",
      "password" : "svwsadmin"
    } ]
  }
}
EOF

cd ..

# und nun der Client:
git clone git@github.com:FPfotenhauer/SVWS-Client.git
cd SVWS-Client
git checkout integration
npm install
npm link @svws-nrw/svws-ui @svws-nrw/svws-openapi-ts @svws-nrw/svws-core-ts

# alle Komponenten sind nun vorbereitet und können gestartet werden
# Dazu den Server starten, am besten in einem eigenen Terminal, z.B. dem von code:
cd SVWS-Server/svws-server-app
./run_server.sh

# nun läuft der Server. Entweder direkt mit dem Client über https://localhost verbinden
# oder den dev-Server starten des Clients:

cd SVWS-Client
npm run dev

# nun läuft auf http://localhost:3000 der dev-Server
```