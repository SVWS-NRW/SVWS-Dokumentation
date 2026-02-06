# Dokumentation für den SVWS-Server und dessen Ableger

Diese Readme-Datei ist nicht Teil der veröffentlichten Doku-Seite, die im Netz veröffentlich wird und beinhaltet Hinweise zur Einrichtung und Arbeit mit diesem Repository.

Im oberen Teil wird beschrieben, wie man sich eine Entwicklungsumgebung zum lokalen Testen der Dokumentation einrichten kann, weiter unten gibt es Vorgaben zur Erstellung von Artikeln, die in die Doku aufgenommen werden sollen.

## Einrichtung einer Entwicklungsumgebung

Grundsätzlich ist es möglich, diese Doku mit einfachsten Hilfsmitteln oder auch direkt auf GitHub zu bearbeiten. Das Problem dabei ist jedoch, dass man nicht die Ausgabe prüfen kann und auch nicht auf mögliche Fehler hingewiesen wird. Für das Beheben einfacher Tippfehler ist keine Entwicklungsumgebung notwendig! Regelmäßiges Arbeiten an der Doku sollte schon aus praktischen Gründen mit einer Enwicklungsumgebung erfolgen.

[Vitepress](https://vitepress.org) ist ein statischer Seitengenerator, der [Markdown](https://www.markdownguide.org/)-formatierte Seiten in HTML umwandelt und dabei [NodeJS](https://nodejs.org) zur Generierung verwendet. Um also lokal diesen Schritt durchführen zu können und nicht erst durch GitHub eine Änderung prüfen zu lassen, muss NodeJS installiert werden.

Je nach Betriebssystem kann über die offizielle Seite von [NodeJS](https://nodejs.org) die aktuelle Version heruntergeladen und installiert werden.

Anschließend empfiehlt es sich der Anleitung dieser Doku für die Installation von VS-Code zu folgen und die Erweiterungen für ESLint und Vue zu installieren, die dort auch aufgeführt sind.

Sobald dies eingerichtet ist, müssen ein paar Schritte regelmäßig durchgeführt werden, dazu öffnet man in VS Code über das Menü das `Terminal`.

Nach jedem `Pull` mit Git, um das lokale Repository zu aktualisieren, muss nun ein Update der lokalen NodeJS-Module erfolgen:

```bash
# im Terminal diesen Befehl ausführen
npm install
```

dadurch wird Vitepress auf die aktuelle Version gebracht, ebenso die verwendeten Bibliotheken, die bei der Entwicklung unterstützen.

Beim allerersten Mal sollte man bei VS Code nun einmal das Fenster der Doku schließen und neu öffnen, damit alles funktioniert.

Funktionieren bedeutet, dass Fehler in der `config.ts`, wo die Menüstruktur u.a. eingerichtet wird, rot unterschlängelt werden bzw. Warnungen gelb unterschlängelt werden. Das betrifft v.a. das Fehlen von Kommas, falsche Leerzeichen oder zu wenig/zu viele Tabs. Geht man mit dem Mauszeiger über den unterschlängelten Fehler, wird einem angezeigt, was falsch ist.

Viele Fehler können dann per F1 und dem Befehl `ESLint: Fix all auto-fixable Problems` automatisch behoben werden.

Auch Fehler in den Markdown-Dateien werden angezeigt.

Die Regeln, auf denen die angezeigten Fehler beruhen gehen auf die verwendeten Einstellungen in der `eslint.config.js`-Datei zurück, die für die Prüfung aller Daten zuständig ist. Gleiches gilt für Typescript-Fehler, die ebenfalls über die vue-Erweiterung geprüft werden.

## Vorschau und Prüfung

Um während des Schreibens eine Vorschau für die Doku sehen zu können, kann man im Terminal folgenden Befehl eingeben:

```bash
npm run dev
```

Damit wird ein lokaler Webserver gestartet und man kann auf die angegebene Seite im Browser zugreifen. Die dargestellte Dokumentation aktualisiert sich selbständig mit jedem Speichern im Editor. Dadurch hat man die möglichkeit der Live-Vorschau, wie die Seite nach dem Hochladen aussieht.

Um die Vorschau zu beenden, drückt man im Terminal `strg+c`.

Bevor man einen Push zu Github macht, sollte zur Sicherheit ein Build durchgeführt werden, was auch auf Github durchgeführt wird. Ein Build ist die endgültige Erstellung der Seite, die auch prüft, ob tote Links vorhanden sind:

```bash
npm run build
```


## Writing Guide für die Hilfeseiten

Diese Seite ist nur temporär für die Erstellung dieser Dokumentation. Auf ihr werden Absprachen gesammelt, wie Objekte/Bereiche hier in der Dokumentation und im SVWS-Client heißen.

### Alles

* Der Plural von "Schema" ist "Schemata".
* Neutrale Bezeichnungen, wo es möglich ist. "Schüler" bleiben so, wie sie sind; ggf. "Schülerinnen" ebenfalls nutzen; im stringenten Wechsel sieht auch doof aus.
* Sollen Pfeile verwendet werden, sollte ein echter Pfeil ➜ genutzt werden, keine Bastelllösungen wie > oder ->.
* Die Laufbahnplanung in der Oberstufe heißt "Laufbahnplanung Oberstufe".
* Bei Screenshots ist STRENG darauf zu achten, dass nur anoymisierte Daten verwendet werden.

### SVWS-Client

* Links im vertikalen Menü sind die **Apps**.
* Das DataTable mit den eigentlichen Menüpunkten heißt **Auswahlliste**
* Im rechten Datenbereich heißen die "Reiter" **Tabs**.
* Unter den Tabs sind die **Untertabs**.
* In manchen Bereichen steht noch eine **graue Schaltflächenleiste** (Bezeichnung Todo) zur Verfügung.

### Schreibweisen und Groß- und Kleinschreibung
SVVWS-Webclient, AdminClient, SchILD-NRW, WeNoM, GOSt, WebLuPO, ...

### Web-Dokumentationen

Die Beschreibung der einzelnen Funktionen selbst sollte ohne lange Prozessbeschreibungen nur darlegen, was da ist und wie man es benutzt.

Tatsächliche Anleitungen, Tutorials und Prozessbeschreibungen (ZP10) und vor allem auch Dinge, die mit aktuellen Vorgaben (Prüfungsordnungen usw.) zu tun haben, sollen soweit wie möglich in sinnvoll gegliederte  **Anleitungen** (usw.?) ausgelagert werden.

#### Grafiken, Schaubilder und Links

* Grafiken werden als .png (Logos, einheitliche Farbflächen, Schaubilder, UI usw.) gespeichert.
* Schaubilder/Schemas sind GraphML-Dateien und werden miT *yEd* erstellt. Die GraphML-Dateien werden ebenfalls in /graphics/ abgelegt.
* Ältere Versionen von Grafiken und Schaubildern bleiben in der Regel in /graphics/ erhalten.
* Alle Grafiken sollten direkt mit sinnvollen "Alternativtexten" und Mausover-Texten versehen werden.
* In **Anleitungen** sollte wirklich *jeder* Schritt erwähnt und mit einem Screenshot versehen werden. Wir schreiben für nicht-technisch versierte Nutzer.
* Bei Grafiken und Links sind wenn möglich *relative* Links und keine absoluten Pfade zu verwenden!
* Grafiken werden im normalen Light-Mode (weißer Hintergrund) aufgenommen.

### Technische Umsetzung
Die Dokumentation wird aus vielen [Markdown](https://de.wikipedia.org/wiki/Markdown)-Dokumenten erzeugt, die ähnlich wie Wikipedia ein spezielles Formatierungsformat verwendet. Diese Dateien werden mit Hilfe von [vitepress](https://vitepress.dev/) und der Konfigurationsdatei zu einer HTML-Seite gebaut, die dann mit dem Browser angezeigt werden kann.

Die Sammlung dieser Markdown-Dokumente werden in einem [Git](https://git-scm.com/)-Repository auf [GitHub](https://github.com) vorgehalten und können beliebig eingesehen, bearbeitet und verändert werden. Eine ausführliche Anleitung zu Git findet sich [hier](https://docs.github.com/de/get-started/using-git/about-git).

### Hervorherhebungen

Hervorhebungen in **fett** und *kursiv* sollten spärlich eingesetzt werden.

Bislang werden *real vorhandende Funktionen* in **fett** markiert. Ebenso der Hauptgegenstand des Artikels (einmalig). Also etwa **Stunde löschen** oder **Nutzer hinzufügen**. Es sollten nur diese nutzbaren Funktionen hervorgehoben werden.

Andere Hervorhebungen können in *kursiv* gesetzt werden (siehe oben). Ebenso werden Feldinhalte in kursiv gesetzt. Also würde man etwa schreiben: "Tragen Sie in die **Kursart** den Wert *PUK* für *Pflichtunterricht im Klassenverband* ein.

Bei **Anleitungen** empfhielt es sich, die Funktionen, die im Zuge der Anleitung tatsächlich bedient zu werden, als `Code`zu markieren. Also wäre alles, was tatsächlich anzuklicken ist, als Code hervorgehoben. Alternativen wären dann fett. Hier würde man schreiben: "Klicken Sie nun auf `Weiter`, mit **Abbrechen** kehren Sie ohne Änderungen vorzunehmen zum vorherigen Fenster zurück."

Wichtiger als das Einhalten eines globalen Schemas ist aber eher der spärliche Einsatz von Hervorhebungen und Konsistenz innerhalb des Artikels oder der thematischen Artieklreihe. 

#### Farbboxen

```md
::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning ACHTUNG
This is a warning.
:::

::: danger SUPER ACHTUNG
This is a dangerous warning.
:::

::: details
This is a details block.
:::
```


::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning ACHTUNG
This is a warning.
:::

::: danger SUPER ACHTUNG
This is a dangerous warning.
:::

::: details
This is a details block.
:::
