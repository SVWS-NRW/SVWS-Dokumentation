# svws-transpile

Der Transpiler aus dem Teilprojekt SVWS-Transpiler hat im Wesentlichen zwei Aufgaben:
- die Übersetzung von Java-Code nach Typescript
- das Generieren von Typescript-Code für einen Client-Zugriff auf eine Server-REST-API, welche im Java-Code definiert ist

Das Teilprojekt ist in weiten Teilen so aufgebaut, dass es nicht direkt vom SVWS-Server abhängig ist, sondern auf den Code von diesem angwendet wird. Der Bezug zum SVWS-Server ist über das Gradle-Build-System gegeben, welches die Kommandozeilen-Applikation `CoreTranspiler` aufruft. Dies ist so kofiguriert, dass
- der Java-Code aus dem Teil-Projekt SVWS-Core übersetzt wird
- die Client-REST-API anhand der API-Definition aus dem Teil-Projekt SVWS-OpenApi generiert wird

Das Ergebnis wird dann im npm-Modul `core` in dem Teilprojekt SVWS-WebClient abgelegt, so dass dieses Modul als npm-Artefakt zur Verfügung steht.

## Kommandozeilen-Anwendung CoreTranspiler

Die Klasse `de.svws_nrw.transpiler.app.CoreTranspiler` stellt eine Kommandozeilenanwendung zum Aufruf des Transpilers zur Verfügung. Die Angabe von Quellcode-Dateien ist hierbei notwendig.

Parameter (kurz) | Parameter (lang) | Beschreibung
---------------- | ---------------- | ------------
-j [JAVAFILES] | --java [JAVAFILES] | Eine Komma-separierte Liste der Java-Quellcode-Dateien für den Transpiler
-a [APIFILES] | --api [APIFILES] | Eine Komma-separierte Liste der Server-Rest-API-Quellcode-Dateien für das Generieren des Client-API-Codes
-jf [TEXTFILE] | --javafiles [TEXTFILE] | Eine Textdatei mit einer Komma-separierten Liste aller Java-Quellcode-Dateien für den Transpiler (nur wenn -j nicht gesetzt ist)
-af [TEXTFILE] | --apifiles [TEXTFILE] | Eine Textdatei mit einer Komma-separierten Liste aller Server-Rest-API-Quellcode-Dateien für das Generieren des Client-API-Codes (nur wenn -a nicht gesetzt ist)
-o [OUTDIR] | --output [OUTDIR] | Der Ziel-Ordner, wo der erzeugte Typescript-Code angelegt wird (Default: "build/ts")
-t [TMPDIR] | --tmpdir [TMPDIR] | Ein Ordner für temporäre Dateien, wie z.B. die class-Dateien dey Java-Compilers (Default: "build/tmp/transpiler")
-i [PRAEFIX] | --ignore [PRAEFIX] | ggf. ein Präfix des Java-Packages, welches beim Aufbau der Ziel-Verzeichnisstruktur ignoriert werden soll (Default: "")
