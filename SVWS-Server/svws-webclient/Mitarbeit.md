# Mitarbeit am SVWS-Client

## git
Die Entwicklung am Clinet folgt dem Gitflow-Workflow-Modell. Ein Link zur SVWS-weiten Doku kommt noch.

Für den Client bedeutet dies, dass der `master`-Branch nur vom Releasemanager betreut wird, der in unregelmäßigen Abständen ein Release zusammenstellt, das anschließend zur Veröffentlichung bereitsteht.

Die Entwicklung findet grundsätzlich im `dev`-Branch statt und kann für kleinere Änderungen, die keine neuen _Features_ hinzufügen, genutzt werden. Dies betrifft also in der Regel kleine Bugfixes oder Tippfehler, die keiner großen Prüfung unterzogen werden müssen.

Größere Änderungen, z.B. weitere Tabs oder Cards, die auch die Bedienung des Clients ändern, werden über __Feature-Branches__ eingebracht und mit einem __F__ oder __feature__ gekennzeichnet. Zum Beispiel __F_Reporting__ oder __feature_reporting__. Weitere Branchbezeichnungen wären __B_xyz__ oder __bug_xyz__.

Damit der `master`- und `dev`-Branch nicht unnötig mit Merge-Commits überladen wird, sollten Feature- und andere Branches als Fast-Forward Merger gemergt werden, wenn es sich um eine sinnvolle Entwicklung der Commits handelt oder aber auch als Squash-Commit gemergt werden, wenn viele einzelne Commits genausogut als einer oder wenige Commits zusammengefasst werden können.

Wird in einem Feature-Branch gearbeitet ist ein __rebase__ vor dem Merge hilfreich, damit keine unnötigen Commits entstehen. Gleiches gilt für Arbeiten am `dev`-Branch. Bevor eigene Änderungen hochgeladen werden, bitte darauf achten, dass kein Merge nötig ist. Haben schon Änderungen im lokalen Git-Repository stattgefunden und im `origin/dev` sind ebenfalls Änderungen eingespielt worden, dann hilft ein `git pull --rebase`, das die eigenen Änderungen nach dem `pull` anhängt, statt ein Merge erforderlich zu machen.

# npm
Nach Änderungen an den `package-lock.json` muss ein `npm i` ausgeführt werden, damit neue Abhängigkeiten installiert werden. 

Momentan werden durch den Server und der UI-Bibliothek einige Module nur lokal zur Verfügung gestellt, die nicht per npm.org gefunden werden. Damit npm trotzdem funktioniert, müssen diese Abhängigkeiten lokal hergestellt werden:

    npm link @svws-nrw/svws-openapi-ts @svws-nrw/svws-core-ts @svws-nrw/svws-ui
    
Nach jedem `npm i` muss dieser Schritt wiederholt werden.

# prettier
Es gibt eine `.prettierrc.json`, die das Projekt mit der _richtigen_ Formatierung versorgt. Die meisten Editoren können über Erweiterungen diese Formatierungsvorgabe direkt ausführen, alternativ kann man im Terminal `npm run format` ausführen, dann werden automatisch alle Dateien korrigiert. Vor jedem Einchecken des Codes sollte dies ausgeführt werden.

# eslint
Ebenso gibt es eine `.eslintrc.js`, die dafür sorgt, dass ESLint über den Code schaut und Fehler sowie Warnungen ausgibt. Hier bieten ebenfalls die meisten Editoren passende Erweiterungen an oder im Terminal kann der Linter mit `npm run lint:script` gestartet werden. Vor dem Einchecken bittte ebenfalls den neuen Code prüfen.

# vue
Es gibt ein Mixin, das jede Seite mit einem individuellen Titel versorgen kann, dazu die Option `title: "Ein Titel"` verwenden.

# typescript
Der Client verwendet Typescript, daher ein paar Konventionen:

Arrays werden über den Array-Typ angegeben mit den Type-Parametern:

    Array<string>

statt

    string[]

Nach Möglichkeit sollen `any` vermieden werden und die dafür vorgesehenen Typen verwendet werden. ESLint spürt `any`s auf und meldet sie als Warnung. Wenn es nicht zu vermeiden ist, kann man Ausnahmen bezogen auf einzelne Zeilen oder auch auf Dateiebene verwenden.

In Klassen sollten alle Variablen und Funktionen nach `public` und `private` unterschieden werden. Sollen getter und setter verwendet werden, die auf private Variablen zugreifen und diese über die eingerichteten setter verändern, wird ein Unterstrich verwendet, damit man diese Variable als getter/setter-Variable zuordnen kann:

```ts
class Foo {
  private _bar: string = ""
  get bar(): string { return this._bar }
  set bar(s: string) { this._bar = s }
}
```

# Editor
Für die Entwicklung bietet sich VS Code an, die verwendeten Erweiterungen sind im Doku-Repo zu finden.

Prettier ist auf die Verwendung von Tabs eingestellt. Der Grund ist recht einfach, jeder hat Vorlieben was die Abstände der Einrückungen sind, Tabs lassen sich in der Breite variabel anzeigen. Es spielt also keine Rolle, ob man zwei oder vier Leerzeichen bevorzugt, beides lässt sich in den individuellen Editoreinstellungen festlegen, ebenso in Gitlab.

_Der vim-Modus ist besser als alle anderen Modi…_
