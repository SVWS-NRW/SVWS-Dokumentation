# Installation IntelliJ für Windows

## Voraussetzungen

+ **Java 21.03** muss in IntelliJ verfügbar sein
+ **Docker** muss auf dem System installiert sein
+ **DBeaver** sollte ebenfalls vorhanden sein

## IntelliJ installieren und konfigurieren

1. Installieren Sie die gewünschte IntelliJ-Edition (>=2024) (es gibt eine kostenlose Community Edition) -> https://www.jetbrains.com/de-de/idea/
2. Gehe zu **File -> New -> Project from Version Control**
    + Wähle **Git** im Dropdown-Menü aus
    + Füge den **Repository HTTPS Checkout Link** ein
    + Lege den Pfad für den lokalen Arbeitsbereich fest und klicke auf "Clone"
    + GitLab bzw. GitHub erfordern **Username und einen Access Token**
      + Das Token muss vorher erstellt werden. Dazu auf GitLab/GitHub im Browser anmelden
          + GitLab: **Edit profile > Access Tokens** ein neues Token anlegen
          + GitHub: **Profil > Settings > Developer Settings > Personal Access Tokens** ein neues Token anlegen
3. IntelliJ fordert möglicherweise **weitere Einstellungen** an. Akzeptiere diese ggf. (z.B. Sprachpaket Deutsch)
4. Unter **Project Settings**:
    - Gehe zu **Build, Execution, Deployment > Gradle** und verwende folgende Einstellungen:
        - **Build and run using**: Gradle (Default)
        - **Run Tests using**: Gradle (Default)
        - **Gradle Distribution**: Wrapper
        - **Gradle JVM**: temurin-21 (21.0.3)
5. Gehe zu **File > Projekt Structure > Project**
    + **SDK** auf Java 21 setzen

## Datenbank starten
+ Navigiere zu deployment/docker/example/local/docker-compose.yml
+ Führe `docker compose up` aus, um die Datenbank zu starten
+ Mit DBeaver testen ob die DB läuft

## Konfiguration der Dateien

1. **keystore.example** in  **keystore** umbenennen und in das Projekt Root Verzeichnis `./SVWS-Server` kopieren TODO: Pfad überprüfen und ggf. anpassen
2. Die Datei **svwsconfig.json.example** in **svwsconfig.json** umbenennen (in den selben Pfad kopieren) und entsprechend konfigurieren:
    + Passe die Pfade für `clientPath` und `adminPath` an (Absolute Pfade zum Workspace erforderlich)
    + Unten in der Datei findest du die **DBKonfiguration**. Verwende die Einstellungen aus der docker-compose.yml. TODO: Dateipfad ergänzen

## Weite Konfigurationen
+ Gehe zu **Settings -> Editor -> File encoding**
  + Global Encoding auf "UTF-8" stellen
  + Project Encoding auf "UTF-8" stellen

## Style checker Konfigueren
TODO: Derzeit sind die Stilvorlagen nicht entgültig geklärt. Die Idee ist, die Vorgaben in IntelliJ einzustellen und dann exportieren/importieren zu können


## Build und Ausführung

1. Führe `gradle assemble` aus.
2. Run **main()** in '''SVWS-Server\svws-server-app\src\main\java\de\svws_nrw\server\jetty'''

## Erste Schritte

1. Gehe auf https://localhost/admin und melde dich mit den Anmeldedaten aus der docker-compose.yml an
2. Erstelle ein neues Schema über die GUI (über das Plus-Symbol)
3. Fülle das neue Schema mit **Testdaten** aus diesem Repository über die Funktion "Schild2-Schema migrieren"
4. Wähle das neue Schema auf https://localhost aus und melde dich ohne Passwort an
