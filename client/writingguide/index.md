# Writing Guide für die Hilfeseiten

Diese Seite ist nur temporär für die Erstellung dieser Dokumentation. Auf ihr werden Absprachen gesammelt, wie Objekte/Bereiche hier in der Dokumentation und im SVWS-Client heißen.

## Alles

* Der Plural von "Schema" ist "Schemata".
* Neutrale Bezeichnungen, wo es möglich ist. "Schüler" bleiben so, wie sie sind.
* Der Schama ist der flauschige Schutzpatron aller Schemata.
* Sollen Pfeile verwendet werden, sollte ein echter Pfeil ➜ genutzt werden, keine Bastelllösungen wie > oder ->.
* Die Laufbahnplanung in der Oberstufe heißt "Laufbahnplanung Oberstufe". 

## SVWS-Client

* Links im vertikalen Menü sind die **Apps**.
* Das DataTable mit den eigentlichen Menüpunkten heißt **Auswahlliste**
* Im rechten Datenbereich heißen die "Reiter" **Tabs**.
* Unter den Tabs sind die **Untertabs**.
* In manchen Bereichen steht noch eine **graue Schaltflächenleiste** (Bezeichnung Todo) zur Verfügung.

## Web-Dokumentationen

Die Beschreibung der einzelnen Funktionen selbst sollte ohne lange Prozessbeschreibungen nur darlegen, was da ist und wie man es benutzt.

Tatsächliche Anleitungen, Tutorials und Prozessbeschreibungen (ZP10) und vor allem auch Dinge, die mit aktuellen Vorgaben (Prüfungsordnungen usw.) zu tun haben, sollen soweit wie möglich in sinnvoll gegliederte  **Anleitungen** (usw.?) ausgelagert werden.

### Grafiken und Schaubildern

* Grafiken werden als .png (Logos, einheitliche Farbflächen, Schaubilder, UI usw.) gespeichert.
* Schaubilder/Schemas sind GraphML-Dateien und werden miT *yEd* erstellt. Die GraphML-Dateien werden ebenfalls in /graphics/ abgelegt.
* Ältere Versionen von Grafiken und Schaubildern bleiben in der Regel in /graphics/ erhalten.
* Alle Grafiken sollten direkt mit sinnvollen "Alternativtexten" und Mausover-Texten versehen werden.
* In **Anleitungen** sollte wirklich *jeder* Schritt erwähnt und mit einem Screenshot versehen werden. Wir schreiben für nicht-technisch versierte Nutzer.

## Technische Umsetzung
Die Dokumentation wird aus vielen [Markdown](https://de.wikipedia.org/wiki/Markdown)-Dokumenten erzeugt, die ähnlich wie Wikipedia ein spezielles Formatierungsformat verwendet. Diese Dateien werden mit Hilfe von [vitepress](https://vitepress.dev/) und der Konfigurationsdatei zu einer HTML-Seite gebaut, die dann mit dem Browser angezeigt werden kann.

Die Sammlung dieser Markdown-Dokumente werden in einem [Git](https://git-scm.com/)-Repository auf [GitHub](https://github.com) vorgehalten und können beliebig eingesehen, bearbeitet und verändert werden. Eine ausführliche Anleitung zu Git findet sich [hier](https://docs.github.com/de/get-started/using-git/about-git).

## Hervorherhebungen

Hervorhebungen in **fett** und *kursiv* sollten spärlich eingesetzt werden.

Bislang werden *real vorhandende Funktionen* in **fett** markiert. Ebenso der Hauptgegenstand des Artikels (einmalig). Also etwa **Stunde löschen** oder **Nutzer hinzufügen**. Es sollten nur diese nutzbaren Funktionen hervorgehoben werden.

Andere Hervorhebungen können in *kursiv* gesetzt werden (siehe oben). Ebenso werden Feldinhalte in kursiv gesetzt. Also würde man etwa schreiben: "Tragen Sie in die **Kursart** den Wert *PUK* für *Pflichtunterricht im Klassenverband* ein.

Bei **Anleitungen** empfhielt es sich, die Funktionen, die im Zuge der Anleitung tatsächlich bedient zu werden, als `Code`zu markieren. Also wäre alles, was tatsächlich anzuklicken ist, als Code hervorgehoben. Alternativen wären dann fett. Hier würde man schreiben: "Klicken Sie nun auf `Weiter`, mit **Abbrechen** kehren Sie ohne Änderungen vorzunehmen zum vorherigen Fenster zurück."

Wichtiger als das Einhalten eines globalen Schemas ist aber eher der spärliche Einsatz von Hervorhebungen und Konsistenz innerhalb des Artikels oder der thematischen Artieklreihe. 

### Farbboxen

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