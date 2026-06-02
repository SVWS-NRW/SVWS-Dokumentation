# MapStruct in Eclipse – Setup-Anleitung

Diese README beschreibt, wie MapStruct im SVWS-Server-Projekt in **Eclipse**
zuverlässig zum Laufen gebracht wird. Für IntelliJ und reine CLI-Builds
(`gradlew build`) ist **keine** zusätzliche Einrichtung nötig – dort funktioniert
MapStruct out-of-the-box.

---

## Was ist MapStruct?

[MapStruct](https://mapstruct.org/) ist ein Java-Annotation-Processor, der zur
**Compile-Zeit** typsichere Mapper-Klassen zwischen DTOs, Entities und anderen
POJOs generiert. Entwickler:innen schreiben nur eine Interface- oder
abstract-Class-Definition mit `@Mapper`-Annotation; der Processor erzeugt daraus
beim Build die konkrete Implementierung (`XxxMapperImpl.java`).

---

## Problemstellung

MapStruct funktioniert über **Annotation Processing (APT)**. Während Gradle und
IntelliJ APT von sich aus korrekt aufsetzen, benötigt **Eclipse** zusätzliche
Konfiguration:

- `.settings/org.eclipse.jdt.apt.core.prefs` muss APT aktivieren und die
Output-Verzeichnisse festlegen.
- `.settings/org.eclipse.jdt.core.prefs` muss `processAnnotations=enabled`
setzen.
- `.factorypath` muss die MapStruct-Processor-JARs referenzieren.
- Die generierten Sources unter `.apt_generated/` und `.apt_generated_tests/`
müssen als Source-Folder im Classpath stehen.

Ohne diese manuelle (UI) Konfiguration **werden die Mapper-Klassen in Eclipse nicht
generiert** – der Code kompiliert aber es kommt zu Laufzeitfehlern bei Mapper-Aufrufen.

---

## Lösungsweg

Die Konfiguration übernimmt das interne `SvwsEclipsePlugin` aus `buildSrc/`
(in Kombination mit dem [com.diffplug.eclipse.apt](https://github.com/diffplug/goomph)-
Plugin). Module, die MapStruct verwenden (aktuell: `svws-db-utils`),
deklarieren das Plugin in ihrer `build.gradle`; das `SvwsEclipsePlugin`
ergänzt automatisch die Eclipse-spezifischen Prefs-Dateien und Source-Folder.

Modulnutzer:innen müssen **keine** Eclipse-Einstellungen mehr manuell setzen –
die Eclipse-Projektkonfiguration wird vollständig aus Gradle abgeleitet.

---

## Einrichtung

### Neu ausgechecktes Projekt

1. Repository klonen.
2. In Eclipse: `File → Import → Existing Gradle Project` und das
   Repo-Root-Verzeichnis auswählen.
3. Buildship synchronisiert das Projekt automatisch. Beim Sync werden die
   Tasks `eclipseJdt`, `eclipseJdtApt` und `eclipseFactorypath` mit
   ausgeführt – das ist im `SvwsEclipsePlugin` als `synchronizationTasks`
   hinterlegt und sorgt dafür, dass `.factorypath` und die APT-Prefs-
   Dateien aktuell sind.
4. Nach dem ersten Build erscheinen die generierten Mapper-Klassen unter
   `.apt_generated/` bzw. `.apt_generated_tests/`.

> **Hinweis:** `gradlew eclipse` sollte **nicht** manuell aufgerufen werden,
> wenn das Projekt mit Buildship verwaltet wird. Buildship erzeugt und
> aktualisiert die Eclipse-Projektdateien selbst über das Gradle Tooling API
> und führt die in `synchronizationTasks` registrierten Tasks bei jedem
> Refresh mit aus. Ein manueller `gradlew eclipse`-Lauf kann die `.classpath`
> und `.settings/`-Dateien in einen Zustand bringen, den Buildship beim
> nächsten Refresh nur teilweise wieder überschreibt – mit unvorhersehbarem
> Ergebnis.

### Bestehendes Projekt (nach Plugin-Update oder Branchwechsel)

Wenn sich die APT-Konfiguration geändert hat (z.B. nach Pull, Branchwechsel
oder Plugin-Update), reicht `**Refresh Gradle Project` allein nicht aus**.
Eclipse JDT cached die APT-Konfiguration im Speicher und liest externe
Änderungen an den `.settings/*.prefs`-Dateien nicht neu ein.

**Variante A:**

1. `git pull` bzw. `git checkout <branch>`
2. Rechtsklick auf Projekt(e) → `Gradle → Refresh Gradle Project`
3. Eclipse Schließen + neu öffnen + obligatorischer gradle task sync
4. Sicherstellen, dass `Project → Build Automatically` aktiviert ist.
5. `Project → Clean...` ausführen.


**Variante B:**

1. `Project Properties → Java Compiler → Annotation Processing`
2. Häkchen bei **„Enable annotation processing"** entfernen → `Apply` → full rebuild bestätigen
3. Häkchen wieder setzen → full rebuild bestätigen → `Apply and Close`
4. `Project → Clean → Build`

Hintergrund: Eclipse JDT lädt APT-Settings nur beim Projekt-Open oder beim
expliziten Toggle des Annotation-Processing-Häkchens neu. Diese Limitierung
liegt in Eclipse selbst und lässt sich aus Gradle heraus nicht umgehen.

---

## Konfiguration verifizieren

Nach erfolgreicher Einrichtung sollten folgende Dateien und Einstellungen
vorhanden sein (Beispiel `svws-db-utils/`):

### Dateien im Projekt-Root


| Datei                                      | Erwartet                                                                                             |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| `.settings/org.eclipse.jdt.apt.core.prefs` | enthält `aptEnabled=true`, `genSrcDir=.apt_generated`, `genTestSrcDir=.apt_generated_tests`, `reconcileEnabled=true`           |
| `.settings/org.eclipse.jdt.core.prefs`     | enthält `org.eclipse.jdt.core.compiler.processAnnotations=enabled`                                   |
| `.factorypath`                             | enthält Einträge für `mapstruct-processor-<version>.jar`                                             |
| `.classpath`                               | enthält `<classpathentry kind="src" path=".apt_generated"/>` und entsprechend `.apt_generated_tests` |
| `.apt_generated/`                          | nach Build mit generierten `*MapperImpl.java`-Dateien gefüllt                                        |


### Funktionaler Test

Einfachster Verifikationstest – funktioniert ohne Code-Kenntnis:

1. Im `Package Explorer` den Inhalt von `.apt_generated/` (und ggf.
   `.apt_generated_tests/`) **löschen** – nur den Inhalt, nicht die
   Verzeichnisse selbst.
2. `Project → Clean...` für das betroffene Modul ausführen (mit Option
   *„Build automatically"* aktiv) oder anschließend manuell
   `Build Project`.
3. Nach dem Build müssen unter `.apt_generated/` wieder Klassen mit Suffix
   `*MapperImpl.java` erscheinen.

Tauchen die Dateien wieder auf, ist APT in Eclipse korrekt aktiv. Bleibt
`.apt_generated/` leer, greift einer der im Troubleshooting-Abschnitt
beschriebenen Fehlerfälle.

---

## Troubleshooting

### Mapper werden nicht generiert / `*MapperImpl` nicht auflösbar

**Symptom:** Rote Marker an Stellen wie `MyMapper.INSTANCE`, Klasse
`MyMapperImpl` „cannot be resolved".

**Mögliche Ursachen &amp; Lösungen:**

1. **APT in Eclipse nicht aktiv** _(Ursache: Projekt nie korrekt APT-initialisiert / Import unvollständig)_.
   Prüfen: `Project Properties → Java Compiler → Annotation Processing`. Falls
   das Häkchen fehlt: Variante B aus der Einrichtungsanleitung anwenden.

2. **Eclipse hat veraltete APT-Settings im Cache** _(Ursache: Branchwechsel/Pull **mit geänderter APT-/Build-Konfiguration**, JDT-Cache nicht neu geladen)_.
   Lösung: Variante A (Close/Open Project) oder Variante B (Häkchen-Toggle).

3. **`.factorypath` fehlt oder verweist auf ungültige JARs** _(Ursache: Gradle-Cache gelöscht/Proxy/Offline, JARs nicht mehr vorhanden)_.
   Lösung: `gradlew eclipseFactorypath` neu ausführen, Projekt refreshen.

4. **`com.diffplug.eclipse.apt` ist im Modul nicht angewendet** _(Ursache: neues/angepasstes Modul mit MapStruct, Plugin-Deklaration vergessen)_.
   In der `build.gradle` des Moduls muss stehen:
   ```groovy
   plugins {
       id 'java'
       id 'com.diffplug.eclipse.apt'
   }
   ```

### Doppelte Klassen / „The type X is already defined"

**Symptom:** Build-Fehler über doppelt definierte Mapper-Klassen. FilerExceptions während `gradle build`

**Wann das passiert:** In einem sauber per `SvwsEclipsePlugin` konfigurierten
Projekt **nicht**. Eclipse generiert ausschließlich nach `.apt_generated/`,
Gradle CLI ausschließlich nach `build/generated/sources/annotationProcessor/...`
– und nur `.apt_generated/` ist als Source-Folder im Eclipse-Classpath
registriert. Beide Pipelines stören sich nicht.

Doppelte Klassen treten praktisch nur auf, wenn jemand manuell eingegriffen
hat, z.B.:

- `build/generated/sources/annotationProcessor/...` als zusätzlicher
  Source-Folder im Eclipse-Projekt eingetragen wurde,
- in der `build.gradle` ein zusätzlicher `srcDirs`-Eintrag auf `build/...`
  ergänzt wurde,
- ein veraltetes `.classpath` aus einem alten Setup-Versuch noch im Repo liegt
  (z.B. nach manuellem `gradlew eclipse` in der Vergangenheit).

**Lösung:**

- `.apt_generated/` und `.apt_generated_tests/` per Hand leeren.
- Manuelle Source-Folder-Einträge auf `build/generated/...` aus dem
  Eclipse-Projekt entfernen.
- `gradlew clean` ausführen, danach Eclipse-Projekt refreshen und rebuilden.

---

## Weiterführende Links

- [MapStruct Documentation](https://mapstruct.org/documentation/)
- [Eclipse JDT-APT User Guide](https://help.eclipse.org/latest/topic/org.eclipse.jdt.doc.isv/guide/jdt_apt_getting_started.htm)
- [com.diffplug.eclipse.apt Plugin](https://github.com/diffplug/goomph)


