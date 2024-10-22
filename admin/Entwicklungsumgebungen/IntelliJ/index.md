# Installation für IntelliJ unter Windows 10

## Voraussetzungen

+ **IntelliJ IDEA Ultimate** (>=2024)
  + Es gibt eine Community Edition: https://www.jetbrains.com/de-de/idea. Das Setup wurde nur für die ULTIMATE Edition getestet.

## IntelliJ konfigurieren
1. Projekt clonen
   + Gehe zu *File → New → Project from Version Control*
   + Wähle *Git* im Dropdown-Menü aus
   + Füge den *Repository HTTPS Checkout Link* ein
   + Lege den Pfad für den lokalen Arbeitsbereich fest und klicke auf *Clone*
   + Git erfordert **Username** und einen **Access Token** (kann in IntelliJ oder GitLab/GitHub erstellt werden)
2. Java 21 installieren
   + In IntelliJ auf *File → Project Structure → Project* gehen
   + Unter SDK die Java Version temurin-21 (21.0.3) auswählen (ggf. vorher herunterladen)
3. Gradle konfigurieren
   + Gehe zu *File → Settings → Build, Execution, Deployment → Gradle* und verwende folgende Einstellungen:
     + *Build and run using*: Gradle (Default)
     + *Run Tests using*: Gradle (Default)
     + *Gradle Distribution*: Wrapper
     + *Gradle JVM*: temurin-21 (21.0.3)
4. CheckStyle:
   + Gehe zu *File → Settings → Plugins* und installiere **CheckStyle-IDEA** und starte die IDE neu
   + Gehe zu *File → Settings → Tools → CheckStyle* und füge unter *Configuration File* die Datei aus `config/checkstyle/checkstyle.xml` hinzu
   + Setze einen Haken bei **Active** für die eben importierte checkstyle File. Für alle anderen Konfigrationen entferne den Haken!
5. SonarLint:
   + Gehe zu *File → Settings → Plugins* und installiere **SonarLint** und starte die IDE neu
   + Gehe zu *File → Settings → Tools → SonarLint* und erstelle eine neue Verbindung über das + Symbol.
   + Gib der Verbindung einen Namen (zum Beispiel "SVWS SonarQube") und wähle *SonarQube* aus. Gib als URL `https://sonarqube.svws-nrw.de/` an.
   + Klicke auf *Next* und gib einen Token an, den du vorher erstellen musst.
   + Gehe zu *File → Settings → Tools → SonarLint → Project Settings* und hake *Bind project to SonarCloud/SonarQube* an
   + Wähle in Connection die eben erstellte Connection und in *Project Key* aus der Liste *svws-server* aus

## SVWS konfigurieren

1. `svws-server-app/src/main/resources/keystore.example` in `keystore` umbenennen und in `svws-server-app` ablegen
2. Die Datei `svws-server-app/src/main/resources/svwsconfig.json.example` in dasselbe Verzeichnis kopieren, in `svwsconfig.json` umbenennen und entsprechend konfigurieren:
   + Passe den Pfad für **clientPath** an: `"[PathToYourWorkspace]\\svws-webclient\\client\\build\\output"`
   + Passe den Pfad für **adminPath** an: `"[PathToYourWorkspace]\\svws-webclient\\admin\\build\\output"`
   + Unten in der Datei findest du die **DBKonfiguration**. Verwende die Einstellungen aus `deployment/docker/example/local/docker-compose.yml`

## Formatter und Inspections
Damit der Codingstil innerhalb des Projekts trotz unterschiedlicher Entwickler einheitlich bleibt, wird ein Formatter verwendet. Dieser kann in allen Dateien angewendet werden, um den Code an die Richtlinien anzupassen. \
Aktuell sind im Projekt nur Formatierungsregeln für Java konfiguriert. Die Formatierung anderer Dateiformate können daher abweichen und sollten aktuell unterlassen werden. \
Inspections dienen in IntelliJ dazu, im Code Warnungen und Errors anzuzeigen, um die Codequalität zu verbessern.

### Eclipse Formatter Adapter
Es ist nicht möglich, dass die Eclipse Formatter Einstellungen 1 zu 1 auf IntelliJ übertragen werden. Aus diesem Grund wird ein Plugin benötigt, das die Einstellungen aus Eclipse in IntelliJ anwendet.

1. Lade das Plugin **Adapter for Eclipse Code Formatter** unter *File → Settings → Plugins* herunter und installiere es. Starte die IDE neu. Eine Konfiguration des Plugins ist nicht erforderlich, da dies später durch die Gradle Taske **initIntellij** automatisch passiert.

### Formatter und Inspections Profile
Neben dem Eclipse Adapter wird zusätzlich noch ein IntelliJ Formatter Profil benötigt, welches den Eclipse Formatter ergänzt. Selbiges gilt für das Inspections Profil. Beide Profile befinden sich unter `config/intelliJ` und werden automatisch in die projektspezifischen Einstellungen von IntelliJ geladen. Führe hierfür **einen** der folgenden Schritte aus:
+ starte die Gradle Task **build**
+ starte die Gradle Task **ide → initIntelliJ**
+ führe **Reload all Gradle Projects** aus

:::danger **Wichtig!**
+ Jedes Mal, wenn sich die Profile `IntelliJ_Formatter.xml` oder `IntelliJ_Inspections.xml` ändern, müssen diese über einen der 3 oberen Schritte neu geladen werden. Anschließend ist ein Restart der IDE erforderlich!
+ Das automatisierte Laden der Profile hat zur Folge, dass persönliche Einstellungen überschrieben werden. Die Konfiguration eigener Profile ist zwar dennoch möglich, allerdings muss in IntelliJ dann jedes Mal dieses auch wieder ausgewählt werden.
+ Änderungen an den Profilen, die für alle gültig sein sollen, können nach folgender Anleitung vorgenommen werden: TODO: Anleitung verlinken
:::

### Shortcuts
Das Shortcut zur Formatierung innerhalb einer geöffneten Datei ist standardmäßig auf `Strg` + `Alt` + `L` festgelegt.\
Zusätzlich soll auch der Code durch einen einzelnen Shortcut analysiert und bereinigt werden, was durch die Nutzung von Macros mit Hilfe von Shortcuts vereinfacht werden kann. Die dafür vorgesehenen Macros können importiert werden.

:::danger **Wichtig!**
 Der Import der Macros überschreibt alle bereits existenten Macros IDE weit und nicht nur projektspezifisch! Solltest du bereits Macros haben, die du behalten möchtest, musst du händisch eine ZIP vorbereiten, die alle Macros enthält. Gehe wie folgt vor:
 + Wähle *File → Manage IDE Settings > Export Settings...*
 + Wähle ausschließlich die **Macros** und speichere die ZIP 
 + öffne in dieser ZIP die Datei `options/macros.xml`\
 Aus dieser Datei müssen alle gewünschten `<macro>...</macro>` Tags in die zu importierende ZIP kopiert werden:
 + Entpacke die Datei `config/intelliJ/macros.zip` aus dem Projekt und öffne darin `options/macros.xml`
 + Füge in der Liste der Macros die kopierte Liste aus deiner eigenen Konfiguration hinzu
 + Füge die Dateistruktur wieder einem Archiv hinzu\
 Verwende im Folgenden die neu erstellte ZIP für den Import der Macros. Deine ZIP muss nun folgende Struktur haben:
 ``` shell
 macros.zip
 |-- options
       |-- macros.xml
 |-- IntelliJ IDEA Global Settings 
 ```
:::

Importiere die Macros und konfiguriere die Shortcuts wie folgt:
+ Wähle *File → Manage IDE Settings > Import Settings...* und importiere die Macros aus `config/intelliJ/macros.zip` oder deine selbst erstellte ZIP, falls du deine eigenen Macros nicht überschreiben möchtest.
+ Gehe zu *File → Settings → Keymap*
+ Unter *Macros* findest du die beiden Macros **CleanupAndReformat** und **FullCheckAndClean**
+ Rechtsklick auf das jeweilige Macro und dann **Add Keyboard Shortcut**
+ Teile nun den Macros einen Shortcut zu z.B. `STRG` + `ALT` + `Ö` für **CleanupAndReformat** und `STRG` + `ALT` + `Ä` für **FullCheckAndClean**.\
Folgende Aktionen werden bei diesen Macros durchgeführt:

**CleanupAndReformat** 
+ Silent Code Cleanup 
+ Formatierung
+ Speichern

**FullCheckAndClean**
+ Silent Code Cleanup 
+ Formatierung
+ Sonarlint
+ Checkstyle
+ Speichern

:::danger **Wichtig!**
+ Diese Shortcuts dürfen ausschließlich in Java-Dateien angewendet werden!
+ Diese Shortcuts dürfen nur angewendet werden, wenn alle Konfigurationen für CheckStyle, Sonarlint und die Formatter/Inspections Profile wie oben geschrieben, vorgenommen wurden!
:::


### Neustart der IDE
Nach allen Konfigurationen muss die IDE neugestartet werden, damit alle Einstellungen übernommen werden.

### Anwendung
Wird gerade eine Java-Datei bearbeitet, dann muss zum Abschluss diese formatiert und gereinigt werden, bevor sie eingechekt werden darf. Hierfür reicht es den eingestellten Shortcut `STRG` + `ALT` + `Ö` bzw. + `Ä` auszuführen.

> **Hinweis**\
> Falls es Codestellen gibt, die durch eine solche Bereinigung verändert werden würden, dann werden diese in einem auffälligen Pink hinterlegt. Dies ist ein deutlicher Hinweis, dass `STRG` + `ALT` + `Ö` bzw. + `Ä` ausgeführt werden muss.

:::danger **Wichtig!**
Die Macros dürfen niemals auf andere Dateien als Java-Dateien ausgeführt werden!\
Außerdem, da das Code Cleanup Formatierungen kaputt machen kann:
+ Es darf keine *Actions on Save* für *Run code cleanup* gesetzt werden!
+ Wenn das (Silent) Code Cleanup nicht über die Macros ausgeführt wird, ist zu beachten, dass im Anschluss unbedingt noch eine Formatierung der betroffenen Datei durchgeführen werden muss!
:::

## Run Configuration

1. Führe den Gradle Task `Tasks/build/build` aus.
2. Run main() in `svws-Server\svws-server-app` Es ist sehr wichtig dass, `main()` innerhalb von `svws-server-app` ausgeführt wird.
