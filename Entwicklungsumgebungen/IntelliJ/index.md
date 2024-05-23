# Installation IntelliJ für Windows

## Voraussetzungen

+ **Java 21.03** muss in IntelliJ verfügbar sein
+ **Docker** muss auf dem System installiert sein
+ **DBeaver** sollte ebenfalls vorhanden sein

## IntelliJ installieren und konfigurieren

1. Installieren Sie die gewünschte IntelliJ-Edition (>=2024) (es gibt eine kostenlose Community Edition) -> https://www.jetbrains.com/de-de/idea/
2. Gehe zu **File -> New -> Project from Version Control**.
    + Wähle **Git** im Dropdown-Menü aus
    + Füge den **Repository HTTPS Checkout Link** ein
    + Lege den Pfad für den lokalen Arbeitsbereich fest und klicke auf "Clone"
    + GitLab erfordert **Username und Personal Token (an Stelle von Passwort)**.
      + Das Token muss vorher erstellt werden. Dazu auf GitLab gehen unter Edit profile > Access Tokens ein neues Token anlegen

## Checkout und Konfiguration in IntelliJ IDEA

1. **Neues leeres Fenster** in IntelliJ öffnen
2. Gehe zu **File -> New -> Project from Version Control**.
    + Wähle **Git** im Dropdown-Menü aus
    + Füge den **Repository HTTPS Checkout Link** ein
    + Lege den Pfad für den lokalen Arbeitsbereich fest und klicke auf "Clone"
    + GitLab erfordert **Username und Personal Token**. Das Token muss vorher erstellt werden.
3. IntelliJ fordert möglicherweise **weitere Einstellungen** an. Akzeptiere diese ggf. (z. B. Sprachpaket Deutsch).
4. Unter **Project Settings**:
    - Gehe zu **Build, Execution, Deployment -> Gradle** und verwende folgende Einstellungen:
        - **Build and run using**: Gradle (Default)
        - **Run Tests using**: Gradle (Default)
        - **Gradle Distribution**: Wrapper
        - **Gradle JVM**: temurin-21 (21.0.3)
5. Gehe zu **File -> Projekt Structure -> Project**
        - **SDK** auf temurin-21 setzen

## Datenbank starten
+ Navgieren zu FILE DOCKER COMPOSE?! TODO: this
+ Führe `docker compose up` aus, um die Datenbank zu starten.
+ Mit DBeaver testen ob DB läuft

## Konfiguration der Dateien

1. **keystore.example** in  **keystore** umbenennen und in das Projekt Root Verzeichnis `./SVWS-Server` kopieren TODO: hier folt noch irgendwas weil wir derzeit unsafe SSL erhalten
2. Die Datei **svwsconfig.json.example** in **svwsconfig.json** umbenennen (in den selben Pfad kopieren) und entsprechend konfigurieren:
    + Passe die Pfade für `clientPath` und `adminPath` an (Absolute Pfade zum Workspace erforderlich).
    + Unten in der Datei findest du die **DBKonfiguration**. Verwende die Einstellungen aus der Docker Compose-Datei. TODO: Dateiname ergänzen

## Weite Konfigurationen
+ Gehe zu **Settings -> Editor -> File encoding**
  + Global Encoding auf "UTF-8" stellen
  + Project Encoding auf "UTF-8" stellen

## Style checker Konfigueren
TODO: Derzeit sind die Stilvorlagen nicht entgültig geklärt, die Idee ist dass man in IntelliJ die Vorgaben einstellt und durch eine XML exportieren und importen kann


## Build und Ausführung

1. Führe `gradle assemble` aus.
2. Run **main()** in '''SVWS-Server\svws-server-app\src\main\java\de\svws_nrw\server\jetty'''

## Erste Schritte

1. Gehe auf https://localhost/admin und melde dich mit den Anmeldedaten aus der Docker Compose File an
2. Erstelle ein neues Schema über die GUI. (kleine Plus Symbol)
3. Fülle das neue Schema mit **Testdaten** aus diesem Repository über die Funktion "Schild2-Schema migrieren"
4. Wähle das neue Schema auf https://localhost aus und melde dich ohne Passwort an
