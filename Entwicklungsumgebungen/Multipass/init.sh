# Erstelle zwei Umgebungsvariablen für Zugriff auf die privaten Repos
export GITHUB_ACTOR="Dein_GH_User"
export GITHUB_TOKEN="Dein_GH_Token"

# Füge das Node-Repository hinzu
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# installiere die folgenden Pakete
sudo apt install openjdk-11-jdk-headless nodejs mariadb-server -y

# Stelle npm so ein, dass Module auf Benutzerebene installiert werden
echo "prefix=~/.npm" > ~/.npmrc

# Klone und baue das UI-Framework
git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com//SVWS-NRW/SVWS-UI-Framework.git
cd SVWS-UI-Framework
git checkout dev
npm i
npm run build

# lokalen Link erstellen
npm link
cd

# Klone und baue den Server
git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/FPfotenhauer/SVWS-Server.git
cd SVWS-Server
git checkout dev
./gradlew assemble
# will irgendiwe nicht beim ersten Mal...
./gradlew svws-core-ts:assemble

# erstelle eine svwsconfig.json für den HTTP-Server mit Standardeinstellungen
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
  "ClientPath" : "/home/ubuntu/SVWS-Client/build/output",
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

cd

# Klone und baue den Client
git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/FPfotenhauer/SVWS-Client.git
cd SVWS-Client
git checkout dev
./gradlew build
cd

# richte die MariaDB ein und setze das root-Passwort
tee mysql_secure_installation.sql << EOF
UPDATE mysql.user SET plugin = 'mysql_native_password', authentication_string = PASSWORD('svwsadmin'), Password=PASSWORD('svwsadmin') WHERE user = 'root';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

sudo mysql < mysql_secure_installation.sql

# starte den SVWS-Server
cd SVWS-Server/svws-server-app
sudo ./run_server.sh &

# warte einen Moment, bis er läuft
sleep 20
cd

# importiere die Testdatenbank und setze Benutzernamen dafür
curl -X 'POST' \
  --anyauth \
  -u root:svwsadmin \
  -k \
  'https://localhost/api/schema/root/migrate/mdb/svwsschema' \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -F 'database=@GymAbi.mdb' \
  -F 'databasePassword=kakadu' \
  -F 'schemaUsername=Admin' \
  -F 'schemaUserPassword='