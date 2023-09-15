# Mitarbeit am SVWS-Client

## git
Die Entwicklung am Clinet folgt dem Gitflow-Workflow-Modell.

Für den Client bedeutet dies, dass der `master`-Branch nur vom Releasemanager betreut wird, der in unregelmäßigen Abständen ein Release zusammenstellt, das anschließend zur Veröffentlichung bereitsteht.

Die Entwicklung findet grundsätzlich im `dev`-Branch statt und kann für kleinere Änderungen, die keine neuen _Features_ hinzufügen, genutzt werden. Dies betrifft also in der Regel kleine Bugfixes oder Tippfehler, die keiner großen Prüfung unterzogen werden müssen.

Größere Änderungen, z.B. weitere Tabs oder Cards, die auch die Bedienung des Clients ändern, werden über __Feature-Branches__ eingebracht und mit dem eigenen Kürzel versehen sowie der Featurebezeichnung, z.B.: __hmt/reporting__.

Damit der `master`- und `dev`-Branch nicht unnötig mit Merge-Commits überladen wird, werden Feature- und andere Branches als Fast-Forward Merger gemergt. Wenn es Sinn macht, werden mehrere Commits auch als __Sqash-Commit__ vereint.

Wird in einem Feature-Branch gearbeitet, ist ein __rebase__ vor dem Merge notwendig, damit keine unnötigen Merge-Commits entstehen. Gleiches gilt für Arbeiten am `dev`-Branch. Bevor eigene Änderungen hochgeladen werden, bitte darauf achten, dass kein Merge nötig ist. Haben schon Änderungen im lokalen Git-Repository stattgefunden und im `origin/dev` sind ebenfalls Änderungen eingespielt worden, dann hilft ein `git pull --rebase`, das die eigenen Änderungen nach dem `pull` anhängt, statt ein Merge erforderlich zu machen.

Werden größere Änderungen in einem Merge-Request eingebracht, sollte darauf geachtet werden, dass nur notwendige Änderungen im Diff entstehen und keine Veränderungen an nicht beteiligten Zeilen entstehen, z.B. durch Neuformatierung. Ein Merge Request muss immer für die Reviewer nachvollziehbar sein und sollte nicht mehr als ein Feature enthalten. Besser mehrere kleine Merge-Requests als viele kleine, deren Folgen nciht mehr abgeschätzt werden können.

## npm
Nach Änderungen an den `package-lock.json` muss ein `npm i` ausgeführt werden, damit neue Abhängigkeiten installiert werden. 

## eslint
`.eslintrc.js`, sorgt dafür, dass ESLint über den Code schaut und Fehler sowie Warnungen ausgibt. Hier bieten die meisten Editoren passende Erweiterungen an oder im Terminal kann der Linter mit `npm run lint:script` gestartet werden. Vor dem Einchecken bittte ebenfalls den neuen Code prüfen.

Teilweise gibt es auch Stye-, bzw. Format-Checks mit eslint, die berücksichtigt werden sollen. Nicht alles ist im Projekt vorgeschrieben, in der Regel existieren aber interne Absprachen.

## Editor
Für die Entwicklung bietet sich VS Code an, die verwendeten Erweiterungen sind [hier](../../Entwicklungsumgebungen/VS-Code/index.md) zu finden.