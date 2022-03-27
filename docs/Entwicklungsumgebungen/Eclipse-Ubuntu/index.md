# Installation auf einem Ubuntu

## Systemvoraussetzungen 
Installation unter Ubuntu 20.04 oder Debian 10

## Software Installation
Java, Curl, git, NodeJS installieren

```bash
sudo apt update
sudo apt-get install openjdk-17-jre
sudo apt install curl git
cd ~
curl -sL https://deb.nodesource.com/setup_17.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
node -v 				#Kontrolle der Version
sudo apt install npm 			#Wird von nodejs installiert
echo "prefix=~/.npm" > ~/.npmrc 	#root-Rechte können somit vermieden werden
```

Eclipse, VisualStudioCode und DBeaver über den Software-Store installieren

```bash
sudo snap install eclipse --classic
sudo snap install code --classic
sudo snap install dbeaver-ce
sudo snap install dbeaver-ce
```
## Einrichtung 
In Eclipe eine GIT-Perspective öffnen und die Repositories in Eclipse oder im Terminal clonen.

### Git Repositories
SVWS-Server Repository clonen

```bash
git clone https://github.com/FPfotenhauer/SVWS-Server --branch dev #Mono-Repository mit Core, DB, Webclient, UI-Components und Apps

````

Für den aktuellen Entwicklungs branch in den dev-Branch wechseln, wenn dev-Branch aktiv ist.
Check out as new Local Branch.

### Eclipse
Beim Start von Eclipse zuerst einen neuen workspace anlegen.
#### Gradle einrichten
Für den Zugriff auf einige private Repositories müssen noch die Gradle-Properties gesetzt werden.

```bash
cd home/.gradle
vim gradle.properties
```
		
Die folgenden Variablen müssen gesetzt werden: 	
```bash
github_actor=hier_GitHub-Username_eintragen
github_token=hier_den_token_eintragen
schild2_access_password=hier_das_schild2_password_eintragen
```

#### SVWS Einstellungen

Die Beispiel-Config ins Zielverzeichnis kopieren und umbenennen.

```bash
cp src/main/resources/svwsconfig.json.example #Zielverzeichnis#/svwsconfig.json
```
		
In der 'svwsconfig.json' sollte der Port auf >=1024 (z.B. 3000) gesetzt werden. 
Eclipse benötigt beim Start des Servers auf Port 443 Root-Rechte. 
In der Entwicklungsumgebung kann das so vermieden werden. 

Beispiel einer svwsconfig.json, bitte die userdaten und Passwörter entspechend anpassen:
		
```json
{
"EnableClientProtection" : null,
"DisableDBRootAccess": false,
"DisableAutoUpdates" : false,
"UseHTTPDefaultv11": false,
"PortHTTPS": 443,
"UseCORSHeader": true,
"ClientPath": "/home/svwsdeveloper/git/SVWS-Server/svws-webclient/build/output",
"LoggingEnabled": true,
"LoggingPath": "logs",
"TempPath": "/home/svwsdeveloper/temp",
"TLSKeystorePath": ".",
"TLSKeystorePassword": "svwskeystore",
"DBKonfiguration": {
	"dbms": "MARIA_DB",
	"location": "localhost",
	"SchemaKonfiguration": [
		{
		"name": "schildtest",
		"svwslogin": false,
		"username": "svwsadmin",
		"password": "svwsadmin"
		}
		]
	}
}
```


## Bau des SVWS-Servers und Clients

### Arbeiten in Eclipse

+ Gradle-Task SVWS-Server > clean > build
+ Gradle-Task SVWS-Client > clean > build

### Alternativ im Terminal

```bash
./gradlew clean
./gradlew build
```
		
in den folgenden Unterverzeichnissen ausführen: 
+ ~/git/SVWS-Server 
+ ~/git/SVWS-Client 