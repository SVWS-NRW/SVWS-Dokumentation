# Mitarbeit am SVWS-Client

## GIT

Die Entwicklung des Client, wie auch des SVWS-Server, folgt dem [Gitflow-Workflow-Modell](.\Teamarbeit\workflow\).

Es folgen weitere, WebClient spezifische Hinweise:

## NPM
Nach Änderungen an den `package-lock.json` muss ein `npm i` ausgeführt werden, damit neue Abhängigkeiten installiert werden. 

## ESLint
`.eslintrc.js`, sorgt dafür, dass ESLint über den Code schaut und Fehler sowie Warnungen ausgibt. Hier bieten die meisten Editoren passende Erweiterungen an oder im Terminal kann der Linter mit `npm run lint:script` gestartet werden. Vor dem Einchecken bitte ebenfalls den neuen Code prüfen.

Teilweise gibt es auch Style-, bzw. Format-Checks mit ESLint, die berücksichtigt werden sollen. Nicht alles ist im Projekt vorgeschrieben, in der Regel existieren aber interne Absprachen.

## Editor
Für die Entwicklung bietet sich VS Code an mit den entsprechenden [Erweiterungen](../../Entwicklungsumgebungen/VS-Code/index.md).