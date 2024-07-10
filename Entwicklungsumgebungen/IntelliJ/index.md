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

## Konfiguration des Formatters und der Inspections
Der Formatter ist aktuell nur auf Java beschränkt, enhält allerdings auch einige Regeln, die allgemeingültig sind und Auswirkungen auf weitere Dateitypen haben können. \
Die Inspections haben zwei Aufgaben: 1. Sie warnen in der IDE vor möglichen Fehlern und schlagen Verbesserungen vor. 2. Anhand der eingestellten Severity können durch ein Cleanup automatisiert einige Fixes vorgenommen werden. **Wichtig:** Das Inspections Profil ist aktuell so eingestellt, dass im Falle von Java Datein nur spezielle Fälle durch ein Cleanup tatsächlich gefixt werden, während andere nur im Editor gehighilightet werden. Diese Differenzierung gibt es in anderen Dateitypen nicht, was bei einem Cleanup zu ungewollten Fixes führen würde. Aus diesem Grund sollte ein Cleanup ausschließlich in Java Dateien vorgenommen werden!

### Eclipse Formatter Adapter
1. Lade das Plugin "Adapter for Eclipse Code Formatter" von folgender Seite herunter und installiere es: [Adapter for Eclipse Code Formatter](https://plugins.jetbrains.com/plugin/6546-adapter-for-eclipse-code-formatter).
2. Konfiguriere das Plugin wie folgt:
   1. Gehe in die Settings und wähle **Adapter for Eclipse Code Formatter** aus.
   2. Wähle die Option **Use Eclipse's Code Formatter**.
   3. Wähle in **Supported file types** die Option **Enable Java**.
   4. Wähle in **Java formatter version** die Option **Bundled Eclipse [...]**.
   5. Wähle in **Eclipse formatter config** die Option **Eclipse workspace/project folder or config file** und trage dort den Pfad zur Datei `config/eclipse/Eclipse_formatter.xml` ein.
   6. Wähle als **Profile** "SVWS-Server" aus.
   7. Stelle sicher, dass die Option **Optimize Imports [...]** nicht ausgewählt ist.

### Laden der Profile 
Zusätzlich müssen noch die IntelliJ spezifischen Profile für den Formatter und die Inspections importiert werden. Dies geschieht automatisch, sobald Gradle Tasks geladen oder das Projekt gebaut wird.
   - **Wichtig:** Dies erfordert bei der ersten Konfiguration oder bei Änderungen dieser beiden Profile (`conig/intellij/IntelliJ_Inspections.xml` und `conig/intellij/IntelliJ_Formatter.xml`) nach dem Bauen bzw. laden der Gradle Tasks einen Neustart der IDE, da sonst die Änderungen noch nicht angewendet werden.
   - Das Automatisierte Laden der beiden Profile hat zur Folge, das Änderungen am Formatter (unter `Code Styles`) und am Cleanup/Inspections überschrieben werden und keine persönlichen Einstellungen mehr möglich sind. Es können eigene Profile erstellt werden, die jedoch bei jedem Reformat oder Cleanup gesetzt werden müssen, da per default immer die konfiguierten SVWS Profile genutzt werden!
   - Änderungen an den Profilen, die für alle gültig sein sollen, können nach folgender Anleitung vorgenommen werden: TODO: Anleitung verlinken
4. **Wichtig:** Es gibt in IntelliJ die Möglichkeit, den Formatter und das Cleanup als `Actions on Save` zu aktivieren, sodass sie beim Speichern einer Datei automatisch durchgeführt werden. Das ist für den Formatter (Option `Reformat Code`) auch in Ordnung, darf aber für das Cleanup (Option `Run code cleanup`) nicht gesetzt sein! Diese Option wird **nach** dem Formatter ausgeführt, sodass falsche Formatierungen eingeführt werden. Das Cleanup muss daher händisch erfolgen.

### Shortcuts (Empfohlen)
Das Shortcut zur Formatierung innerhalb einer geöffnet Datei ist standardmäßig auf `STRG + ALT + L` festgelegt. 
Für ein Cleanup existiert kein Shortcut, es kann aber eins gesetzt werden. Die Empfehlung an dieser Stelle ist allerdings, nicht einfach nur das Cleanup auf einen Shortcut zu legen, sondern eine Kombinatin aus Cleanup und Formatter. Das beugt vor, dass nach einem Cleanup die Formatierungen direkt korrigiert werden, ohne den Formatter explizit wieder aufrufen zu müssen.
Gehe dabei wie folgt vor:
1. Öffne eine Java-Datei
2. Gehe auf `Edit > Macros > Start Macro Recording`
3. In der geöffneten Datei gehe auf `Code > Analyze Code > Silent Code Cleanup` oder alternativ `Code > Code Cleanup` ([Was ist der Unterschied?](#anwendung))
    - Im Falle vom normalen Code Cleanup: Wähle im Dialog das `SVWS-Server-Cleanup` Profil aus und als Scope `Current File`
4. Drücke `STRG + ALT + L`, um die Datei zu formatieren
5. Drücke `STRG + S`, um die Datei zu speichern
6. Gehe auf `Edit > Macros > Stop Macro Recording`
7. Benenne das Macro
8. Gehe auf `File > Settings > Keymap` und wähle dort für Macros > [your Macro] einen Shortcut aus.
So kannst du zukünftig dein Cleanup über ein Shortcut machen und gehst dabei auch gleich sicher, dass die Formatierung sofort korrigiert wird.

### Anwendung
1. Formatter
    - In aktueller Datei: `STRG + ALT + L`
    - Weitere Scopes: Rechtsklick auf Datei/Directory in der Projektstruktur > Reformat Code. Falls du dabei **Cleanup Code** gewählt hast, führe diesen Schritt 2 Mal durch, um eventuelle Korrekturen bei der Formatierung zu beheben.
2. Code Cleanup
    - `Code > Code Cleanup` und den Custom Scope auswählen, als Insepcation Profile `SVWS-Server-Cleanup` auswählen, dann `Analyze`
    - **Wichtig:** Nach einem Cleanup muss noch mal formatiert werden, da anderfalls einige Formatierungen falsch sind. Benutze alternativ einen Shortcut mir Macro wie oben erklärt
    - Wende ein Cleanup am besten einmalig kurz vor dem Commit einer Datei an
    - **Wichtig:** Führe das Cleanup nur bei Java Dateien aus!
3. Silent Code Cleanup
Dieses Cleanup arbeitet wie das normale Code Cleanup, aber spart sich den Dialog mit Einstellungen. Es verwendet als Profil das Profil, welches in den `Settings > Inspections` festgelegt ist. Der Scope wird dadurch definiert, dass man entweder den Cursor in eine Datei setzt, um diese zu cleanen oder indem man eine Datei oder ein Directory in der Projektstruktur auswählt
    - Gehe auf `Code > Analyze Code > Silent Code Cleanup`
    - **Wichtig:** Führe das Cleanup nur bei Java Dateien aus!

## Weite Konfigurationen
+ Gehe zu `Settings -> Editor -> File encoding`
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
