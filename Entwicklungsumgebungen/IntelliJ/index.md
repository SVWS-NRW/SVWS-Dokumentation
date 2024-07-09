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
+ Navigiere zu `deployment/docker/example/local/docker-compose.yml`
+ Führe `docker compose up` aus, um die Datenbank zu starten
+ Mit DBeaver testen ob die DB läuft

## Konfiguration der Dateien

1. **keystore.example** in  **keystore** umbenennen und in das Projekt Root Verzeichnis `./SVWS-Server` kopieren TODO: Pfad überprüfen und ggf. anpassen
2. Die Datei **svwsconfig.json.example** in **svwsconfig.json** umbenennen (in den selben Pfad kopieren) und entsprechend konfigurieren:
    + Passe die Pfade für `clientPath` und `adminPath` an (Absolute Pfade zum Workspace erforderlich)
    + Unten in der Datei findest du die **DBKonfiguration**. Verwende die Einstellungen aus der docker-compose.yml

## Konfiguration des Formatters und Cleanups
### Konfiguration
1. Lade das Plugin "Adapter for Eclipse Code Formatter" von folgender Seite herunter und installiere es: [Adapter for Eclipse Code Formatter](https://plugins.jetbrains.com/plugin/6546-adapter-for-eclipse-code-formatter).
2. Konfiguriere das Plugin wie folgt:
   1. Gehe in die Settings und wähle **Adapter for Eclipse Code Formatter** aus.
   2. Wähle die Option **Use Eclipse's Code Formatter**.
   3. Wähle in **Supported file types** die Option **Enable Java**.
   4. Wähle in **Java formatter version** die Option **Bundled Eclipse [...]**.
   5. Wähle in **Eclipse formatter config** die Option **Eclipse workspace/project folder or config file** und trage dort den Pfad zur Datei `config/eclipse/Eclipse_formatter.xml` ein.
   6. Wähle als **Profile** "SVWS-Server" aus.
   7. Stelle sicher, dass die Option **Optimize Imports [...]** nicht ausgewählt ist.

3. Zusätzlich müssen noch die IntelliJ spezifischen Profile für den Formatter und das Cleanup importiert werden. Dies geschieht automatisch, sobald Gradle Tasks geladen oder das Projekt gebaut wird.
   - **Wichtig:** Dies erfordert bei der ersten Konfiguration oder bei Änderungen dieser beiden Profile (`conig/intellij/IntelliJ_Formatter.xml` und `conig/intellij/IntelliJ_Formatter.xml`) nach dem Bauen bzw. laden der Gradle Tasks einen Neustart der IDE, da sonst die Änderungen noch nicht angewendet werden.
   - Das Automatisierte Laden der beiden Profile hat zur Folge, das Änderungen am Formatter (unter `Code Styles`) und am Cleanup überschrieben werden.
   - Änderungen an den Profilen, die für alle gültig sein sollen, können nach folgender Anleitung vorgenommen werden: TODO: Anleitung verlinken
4. **Wichtig:** Es gibt in IntelliJ die Möglichkeit, den Formatter und das Cleanup als `Actions on Save` zu aktivieren, sodass sie beim Speichern einer Datei automatisch durchgeführt werden. Das ist für den Formatter (Option `Reformat Code`) auch in Ordnung, darf aber für das Cleanup (Option `Run code cleanup`) nicht gesetzt sein! Diese Option verwendet das falsche Profil und sie wird zudem nach dem Formatter ausgeführt, sodass nicht nur falsche cleanups gemacht werden, sondern auch falsche Formatierungen eingeführt werden. Das Cleanup muss daher händisch erfolgen.

### Anwendung
1. Formatter
    - In aktueller Datei: STRG + ALT + L
    - Weitere Scopes: Rechtsklick auf Datei/Directory in der Projektstruktur > Reformat Code (**OHNE** Cleanup. Dieses verwendet das falsche Profil!)
2. Cleanup
    - Code > Code Cleanup > Custom Scope auswählen, als Insepcation Profile `SVWS-Server-Cleanup` auswählen > Analyze
    - **Wichtig:** Nach einem Cleanup muss noch mal formatiert werden, da anderfalls einige Formatierungen falsch sind
    - Wendet ein Cleanup am besten einmalig kurz vor dem Commit einer Datei an
    - Man kann auch einen Shotcut definieren unter Settings > Keymap: Stelle Shortcuts für `Main Menu > Code > Inspect Code Actions > Code Cleanup...` und `Main Menu > Code > Analyze Code > Silent Code Cleanup` ein
    - Alternativ: Code > Analyze Code > Silent Code Cleanup - das macht dasselbe wie das Code Cleanup mit den Einstellungen, die man im Code Cleanup kofniguriert habt. Das heißt man spart sich den Dialog, wenn man immer dasselbe macht (z.B. Cleanup auf `Current File` mit dem eingstellten Profil)

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
