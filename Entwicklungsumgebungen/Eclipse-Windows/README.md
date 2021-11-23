# Installation unter Windows 10 64bit

Die gesammte Entwicklungsumgebung belegt in etwa 3 GB. Die Installation auf einem Netzlauferk sollte vermieden werden. Gemappte Laufwerke unter Windows, wie es zum Beipiel im MSB -User Homeverzeichnis der Fall ist, sorgen im Kompiliervorgang zu Abbrüchen beim gralde build. Daher am Besten alles lokal installieren und möglichst noch Puffer einplanen. 

Idee: Alles in ein (nicht gemapptes) Verzeichnis installieren.

Z.B.: D:\svws_Entwicklungsumgebung\ und dort in Unterverzeichnissen ... jdk-17/ .../workspace/ arbeiten.

## Maria db installieren

download : 

im MSB: am besten unter D:// weil man sonst nur mit admin rechten an den Ordner kommt


## JDK 17 installieren

+ Download des jdk-17 -> https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.zip
+ Entpacken in z.B. D:\svws_Entwicklungsumgebung\jdk-17\
+ Path setzen: 
    + Über das Windowssymbol den Editor für die Umgebungsvariablen öffnen 
    + die Variable Path bearbeiten und einen weiteren Eintrag zum Java Verzeichnis einfügen

![Umgebungsvariablen setzen](Entwicklungsumgebungen/Eclipse-Windows/graphics/Umgebungsvariablen_setzen_1.png)

![Umgebungsvariablen setzen](Entwicklungsumgebungen/Eclipse-Windows/graphics/Umgebungsvariablen_setzen_2.png)

optional:

    + Es bietet sich hier auch an, das Schild 2 Passwort zu setzen wird aber nur im Inlstallen benötigt
    + (nur) zum build der Windows Installationsdateien ist der Eintrag der Variablen SVWS-CERTIFICATE_PASSWORD, SVWS-CERTIFICATE_PATh und SVWS_SIGNTOLL_PATH nötig. 

## NodeJS installieren 

+ Install node.js 16er Version -> https://nodejs.org/dist/v16.13.0/node-v16.13.0-x64.msi

## Eclipse installieren und konfigurieren

+ Installieren eclipse-inst-win64.zip (2021-09) (Eclipse IDE for Java Developers)-> https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2021-09/R/eclipse-jee-2021-09-R-win32-x86_64.zip&mirror_id=17
+ Einmaliger Start Eclipse - festlegen der Worspace-Pfade
+ Bei Bedarf den Speicher hochsetzen: in der eclipse.ini entsprechen z.B. aus der 512 eine 2048 machen
+ Eclipse > Window > Preferences > Java > installed JREs -> Add - 17 er Verzeichnis eintragen
+ Eclipse > Help > Marcet Place -> Java 17 suchen und "Eclipse Java Development Tools Latest Release" installieren
+ Exlipse > Window > Preferences > Java > Compiler -> 17 eintragen
+ Eclipse > Window > Preferences > General > Editors > Text Editors > Spelling > UTF-8
+ Eclipse > Window > Preferences > General > Workspace > Text file encodig > Other UTF-8

![Eclipse-UTF8_Settings](Entwicklungsumgebungen/Eclipse-Windows/graphics/Eclipse-UTF8-Setting.jpg)

### Git Repositories in Eclipse einrichten 

+ Eclpise > Windows > Shows Perspektive > GIT

#### Quellen einragen:

+ Repositories in Eclipse clonen: Git > Clone a Git repository

#### Alternative Quellen in GitHub.com
Hier benötigt man als "Passwort" in Eclipse den persönlichen Github Token 
+ https://github.com/FPfotenhauer/SVWS-Server (Mono-Repository mit Core, DB und Apps)
+ https://github.com/FPfotenhauer/SVWS-Client
+ https://github.com/SVWS-NRW/SVWS-UI-Framework
+ https://github.com/FPfotenhauer/jbcrypt

### Arbeiten in Eclipse

Wechseln in SVWS-Server den dev-Branch (wenn dev-Branch aktiv)
Check out as new Local Branch
Wechseln in Java-Perspective
Eclipse > File > Import > Import existing Gradle-Project
Import der vier Repositories als Gradle-Projekt
U.U. Neustart von Eclipse erforderlich
View > Gradle Tasks > SVWS-Server > Run Build


## svwsconfig.jason anpassen
git

## market Place
java 17 plugin
jason plugin

## window preferences 

neue Java Version
gradle Homeverzeichnis
compiler auf 17 

##
svws-server -> svws server app- /src/main/java/ -> de.nwr ... -> mian.jve
Runbconfiguration editieren für den Import der MDB
migration svsw-db utils-> src/main/java/ -> app -> migrate.java


## optionale Software 

### VSCodeUserSetup
+ Install VSCodeUserSetup-x64-latest.exe (optional)

### git per terminal auf Windows 

+ Ohne Administrationsrechte installierbar
+ hier die Anleitung auf heise.de -> https://www.heise.de/tipps-tricks/Git-auf-Windows-installieren-und-einrichten-5046134.html
+ download:  https://git-scm.com/download/win
+ Im MSB noch den Proxy eintragen: git config --global http.proxy http://10.64.128.22:3128

