# Code Styles
Im Projekt werden spezielle Code Styles vorgegeben, die für Eclipse, IntelliJ und VSCode aneinander angepasst wurden. Die Konfigurationen werden automatisch in die Entwicklungsumgebungen beim Laden der Gradle Projekte oder durch ein Build geladen und können nur bedingt von den Developern angepasst werden.
Die vorgegebenen Code Styles unterteilen sich in die Formatierung des Codes und in einige Code Cleanup Regeln. Grundsätzlich verwenden alle drei IDEs die Formatierungsregeln aus Eclipse und erzwingen so gleiche Formatierungen. Cleanups können jedoch nicht zu 100% in allen IDEs gleich eingestellt werden, da IntelliJ wesentlich mehr Optionen bietet als Eclipse und VSCode. Daher sollten neben den Cleanups auch immer die Coding Guidlines (TODO: verlinken) zusätzlich beachtet werden. 

# Code Styles für alle Developer anpassen
Innerhalb der IDEs können die Developer zwar Anpassungen an den Code Styles vornehmen, welche aber beim nächsten Laden der Gradle Projekte oder bei einem Build ggf. überschrieben werden. Inwieweit sie überschrieben werden, hängt von der IDE ab. Um Anpassungen für alle verbindlich zu machen, müssen die Konfigurationen in Ordner `config` angepasst werden. Es ist zu beachten, dass es für jedes Modul im Projekt die Möglichkeit gibt, unterschiedliche Konfigurationen zu hinterlegen. Nach aktuellem Stand erhalten jedoch alle Module dieselben Konfigurationen.

## Eclipse
In Eclipse werden alle Formatter und Cleanup Einstellungen vorgegeben. Sollte ein Developer in seinem Workspace eigene Anpassungen vornehmen, so werden diese vom Reload der Gradle Projekte oder einem Build wieder überschrieben.

### Formatter
Bevor das Formatter-Profil bearbeitet werden kann, muss dieses zunächst in Eclipse importiert werden.
* Gehe zu `Window → Preferences → Java → Code Style → Formatter` und klicke auf **Import...**
* Importiere die Datei `config/eclipse/Eclipse_Formatter.xml` aus dem Projekt. 
Dieses Profil kann nun wie gewünscht angepasst werden.
> **Wichtig!**
> Da für jedes Modul eine eigene Konfiguration angelegt wird, haben die Änderungen am Formatter innerhalb der Eclipse Einstellungen keine Auswirkungen auf die Formatierung im Code. Um diese testen zu können, muss zunächst über `Configure Project Specific Settings...` die projektspezifische Konfiguration für das Modul, in welchem die Formatierung gerade getestet wird, ausgeschaltet werden.

Wurde der Formatter wie gewünscht konfiguriert, kann dieser über **Export** nach `config/eclipse/Eclipse_Formatter.xml` exportiert und dann comittet werden.\
Nun werden die neuen Einstellungen bei allen Developern automatisch bei einem Gradle Reload oder Build in ihre IDEs geladen.

### Cleanup
Die Cleanups können auf dieselbe Weise wie der Formatter unter `Window → Preferences → Java → Code Style → Clean Up` angepasst und in `config/eclipse/Eclipse_Cleanup.xml` exportiert werden. Auch hier müssen projektspezifische Einstellungen ausgeschaltet werden, um die Änderungen testen zu können.

## IntelliJ
In IntelliJ sind die Einstellungen etwas anders, als in Eclipse.
### Formatter
Formatter Einstellungen werden grundsätzlich vorgegeben und können von Developern innerhalb ihres Workspaces nicht dauerhaft angepasst werden. Sie müssen stattdessen für alle einheitlich konifguriert werden.\
Grundsätzlich verwendet IntelliJ durch ein Plugin die Formatter Einstellungen von Eclipse. Es gibt allerdings ein paar wenige zusätzliche Einstellungen, die getroffen werden müssen, damit die Formatierungen auch wirklich gleich bleiben (zum Beispiel **Keep when reformatting → Line Breaks**). Aus diesem Grund existiert die Datei `config/intellij/IntelliJ_Formatter.xml`, die diese wenigen Optionen definiert.\
Der IntelliJ Formatter kann unter `Settings → Editor → Code Style → Java` angepasst werden.
> **Wichtig!** Die meisten hier getroffenen Einstellungen beeinflussen die Formatierung nicht, da diese vom Elcipse Formatter bestimmt werden. Es gibt nur wenige Ausnahmen - wie zum Beispiel die oben beschriebenen **Line Breaks**. Aus diesem Grund sollten Einstellungen des IntelliJ Formatters nur bearbeitet werden, wenn der Formatter andere Ergebnisse liefert als der Formatter in Eclipse selbst! Zusätzlich werden die Formatter Konfigurationen auch von `.editorconfig` beeinflusst.

Der neu konfigurierte Formatter kann dann nach `config/intellij/IntelliJ_Formatter.xml` exportiert und comittet werden. Andernfalls sind die neuen Einstellungen nicht dauerhaft, sondern werden überschrieben. \
Nun werden die neuen Einstellungen bei allen Developern automatisch bei einem Gradle Reload oder Build in ihre IDEs geladen.

### Cleanup
Das Cleanup in IntelliJ ist anders aufgebaut als in Eclipse, wodurch die Konfiguration komplexer ist, aber auch einige eigene Einstellungen zulässt. \
Kleiner Exkurs: In IntelliJ wird unter `Settings → Editor → Inspections` festgelegt, vor welchen Fehlern im Code gewarnt werden soll und welche Relevanz (Severity) dieser Fehler hat. Es ist sogar einstellbar, in welchen Farben ein Fehler dargestellt wird. Das Code Cleanup ist in IntelliJ mit diesen Inspections verknüpft. Es gibt einige Inspections, die bei einem Cleanup berücksichtigt werden, wenn sie aktiviert sind. Welche das sind kann eingesehen werden, indem man im Inspections Fenster den Filter **Show only cleanup Inspections** setzt. Grundsätzlich gilt, dass jede dieser Inspection Regeln, wenn sie gesetzt ist und ein anderes Level als *Consideration* oder *No Highlighting* besitzt, bei einem Cleanup zu Code Veränderungen führt. \
Da dies jedoch nicht gewollt ist, wurde die spezielle Severity *Cleanup* definiert. Alle Inspections mit dieser Severity werden gecleaned und können vom Developer, außer in der Farbgebung, nicht verändert werden. Alle anderen Cleanup Inspections werden im Code zwar noch wie im Default eingestellt angezeigt, haben aber die Severity *Cosideration* erhalten, um bei einem Cleanup nichts ungewollt zu verändern. \
Diese Verknüpfung zwischen Inspections und Cleanups führt zu einer komplexen Überschreibungslogik der Workspace Einstellungen durch die Datei `config/intellij/IntelliJ_Inspections.xml`, die im folgenden Diagramm dargestellt wird. 
Grundsätzlich gilt, dass **IntelliJ_Inspections.xml** alle Cleanup relevanten Inspections für **Java** enthält.
<details>
<summary>InstelliJ Inspections Merge Ablauf</summary>
<img src="./graphics/IntelliJinspectionsMerge.svg" />
</details>

Durch diese Überschreibungslogik sind für den Developer folgende eigene Einstellungen noch möglich:
* Farbgebung aller Servities sowie neue Severities
* Freie Einstellung aller Inspections, die für ein Cleanup **nicht** relevant sind
* Eingeschränkte Einstellung aller Inspections, die für ein Cleanup relevant sind (Serverity nur auf *Consideration* oder *No Highlighting* setzbar, Editor Highlighting aber frei wählbar)

Sollen nun aber die Regeln für die Cleanups für alle Developer angepasst werden, muss wie folgt vorgegangen werden:
* Unter `Settings → Editor → Inspections` den Filter **Show only cleanup Inspections** setzen
* Die gewünschte Inspections Regel aktiviern und die Servity *Cleanup* setzen, wenn sie bei einem Cleanup korrigiert werden soll oder die Severity auf *Consideration* bzw. *No Highlighting* setzen, falls sie **nicht** korrigiert werden soll.
* Anchließend das Profil nach `config/intellij/IntelliJ_Inspections.xml` exportieren.

Nun werden die neuen Einstellungen bei allen Developern automatisch bei einem Gradle Reload oder Build in ihre IDEs geladen.

## VSCode
In VSCode sind grundsätzlich keine Anpassungen von Developern innerhalb ihres eigenen Workspaces gewünscht. Sollen die Einstellungen für alle angepasst werden, ist wie folgt vorzugehen:

### Formatter
VSCode ist so konfiguriert, dass es keinen eigenen Formatter verwendet, sondern nur den von Eclipse (`/config/eclipse/Eclipse_Formatter.xml`). Daher sind hier keine weiteren Einstellungen möglich/notwendig.

### Cleanup
VSCode bietet nur eine sehr kleine Menge an [Cleanup Optionen](https://github.com/redhat-developer/vscode-java/blob/master/document/_java.learnMoreAboutCleanUps.md), die in den Einstellungen oder in `settings.json` unter `java.cleanup.actions` definiert werden. Die Developer haben nicht die Möglichkeit, die Optionen für sich selbst anzupassen. Sie werden automatisch überschrieben. \
Wenn die gesetzten Cleanup Optionen für alle angepasst werden sollen, müssen diese Änderungen in `config/vcode/settings.json` angepasst werden. Dabei ist zu beachten, dass `"java.saveActions.cleanup": true` gesetzt ist, damit das Speichern einer Java Datei ein Cleanup triggert. Nun werden die neuen Einstellungen bei allen Developern automatisch bei einem Gradle Reload oder Build in ihre IDEs geladen.\
> **Wichtig!** Beim Setzen der Cleanup Optionen ist darauf zu achten, dass diese auch mit dem Transpiler kompatibel sind.
