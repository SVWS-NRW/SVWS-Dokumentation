***Git Workflow***
=========================================================

Um an den Repositories mitzuarbeiten, ist [git](https://git-scm.com/) als Versionierungswerkzeug notwendig:

+ unter Linux: `apt install git`
+ unter Windows download [gitBash](https://gitforwindows.org/)
+ unter macOS in Verbindung mit [Homebrew](https://brew.sh): `brew install git`

Eine umfassende Liste der gängigsten GUI- und CLI-Clients ist hier zu finden: [https://git-scm.com/downloads](https://git-scm.com/downloads)

Alternative kann auf entsprechende Plugins der verwendeten Entwicklungsumgebung zurückgegriffen werden. 

## Git Repositories

Das SVWS-Server-Projekt wird auf einem geschlossenen GitLab-Server geführt und auf GitHub unter [SVWS-NRW/SVWS-Server](https://github.com/SVWS-NRW/SVWS-Server) gespiegelt.
Aktuell enthält das Projekt unter anderem zwei Repositories, die öffentlich zugänglich sind:

[SVWS-Server](https://github.com/SVWS-NRW/SVWS-Server)  
[SVWS-Dokumentation](https://github.com/SVWS-NRW/SVWS-Dokumentation)  


Hier finden Sie auch [weitere Repositories](https://github.com/SVWS-NRW/), wie zum Beispiel Test-Datenbanken u.v.m..

## Workflow master & dev

Bei der Entwicklung des SVWS-Servers wird die Versionierung im `master`-Branch festgehalten, der nur vom Release-Manager betreut wird. In unregelmäßigen Abständen wird ein Release zusammengestellt und über [Github](https://github.com/SVWS-NRW/), [DockerHub](https://hub.docker.com/u/svwsnrw) und ggf. [npm](https://www.npmjs.com/~svws-nrw) veröffentlicht.

Die Entwicklung findet grundsätzlich im `dev` Branch statt und kann während der Entwicklungsphase für kleinere Änderungen genutzt werden, die keine neuen _Features_ hinzufügen. In der Regel handelt es sich also nur um kleine Bugfixes oder Tippfehler, die keinen großen Test erfordern. Auch der `dev`-Branch soll bis zum offiziellen 1.0.0-Release an Stabilität gewinnen. 

![Gitflow-Workflow-1](./graphics/Gitflow-Workflow-1.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizens](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)


## Workflow im Development

Größere Änderungen, z.B. weitere Tabs oder Cards, die auch die Bedienung des Clients ändern, werden über Feature-Branches eingebracht.

Feature- und andere Branches werden als Fast-Forward Merger gemergt, um den master- und dev-Branch nicht unnötig mit Merge-Commits zu belasten. Falls sinnvoll, werden mehrere Commits auch als Squash-Commit vereint.

Wenn in einem Feature-Branch oder am dev-Branch gearbeitet wird, ist es notwendig, vor dem Merge ein *rebase* durchzuführen, um unnötige Merge-Commits zu vermeiden. Bitte stellen Sie sicher, dass keine Merges erforderlich sind, bevor Sie eigene Änderungen hochladen. Wenn bereits Änderungen im lokalen Git-Repository vorgenommen wurden und auch im origin/dev Änderungen vorhanden sind, kann ein `git pull --rebase` helfen. Dadurch werden die eigenen Änderungen nach dem `pull` angehängt, anstatt einen Merge durchzuführen.

Bei größeren Änderungen in einem Merge-Request sollte darauf geachtet werden, dass nur notwendige Änderungen im Diff entstehen und keine Veränderungen an nicht beteiligten Zeilen entstehen, z.B. durch Neuformatierung. Ein Merge Request sollte immer für die Reviewer nachvollziehbar sein und nicht mehr als ein Feature enthalten. Es ist besser, mehrere kleine Merge-Requests zu erstellen, anstatt wenige große, deren Auswirkungen nicht mehr abgeschätzt werden können.
		
### Erstellen eines Feature-Branch

Nachdem man die für seine Arbeit erforderlichen Repositories gecloned hat, wechselt man für die Entwicklungsarbeit zunächst auf den Developer-Branch: 

```bash
git checkout dev
```

Zur Kontrolle, auf welchen Branch man sich befindet: 

```bash
git branch
```

Ausgehend vom Develeper-Branch erstellt sich der einzelne Entwickler bzw die Kleinstgruppe einen eigenen Feature-Branch. Zum Beispiel: 

```bash
git branch my_feature
git checkout my_feature
git push -u origin my_feature
```

Es wurde verabredet die Branch-Bezeichnung in der Regel mit `gi`-user-namen/IssueNummer-Feature` zu bezeichnen
		
![Gitflow-Workflow-2](./graphics/Gitflow-Workflow-2.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizens](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

### Tägliche Arbeit im Feature-Branch

Im täglichen Ablauf wird auf dem lokal geclonten Verzeichnis der neue Code gespeichert ggf. neue Dateien abgelegt oder Dateien gelöscht. 
Alle neuen Dateien, die ins Verzeichnis gespeichert wurden, werden im lokalen Repository beigefügt durch:

```bash
git add -A
```
Alle diese Änderungen werden automatisch lokal versioniert mit:

```bash
git commit -am 'Eine Commit-Message'
```

Am Ende eines Arbeitstages möchte man gerne die durch `commit` angelegten Versionen auch auf dem Server vorhalten durch: 

```bash
git push
```

### Rückführung in den Develop-Branch

Nach mehreren Commits ist ggf. das Feature fertig bzw. auf dem Stand einer Beta-Version, die Einzug halten kann in den Develop-Branch. 
Per Pull-Requests bittet man nun die Zuständigen, das Feature in den Develop-Branch zu mergen. 
Je nach Berechtigung kann man es auch selbständig wie folgt in den lokalen Develop-Branch mergen und in das zentrale Repository pushen:

Aktualisieren und Wechseln ins Develop-Branch

```bash
git pull origin develop
git checkout develop
```

Zusammenführen und zum Git_Server pushen: 

```bash
git merge my_feature --ff
git push
```

Falls die Entwicklung des Features abgeschlossen ist kann man ggf das lokale Branch löschen mit:

```bash
git branch -d some-feature
```

### Problembehandlung

```bash
git status 
```

Gibt den Stand des lokal vorgehaltenen Repositories bzgl. des ausgewählten Branches auf dem Git-Server an.
Falls mehrere Developer auf einem Branch arbeiten ist es wichtig zunächst mit einem Pull die letzten Änderungen vom Server zum lokalen Repository zu syncronisieren. 

```bash
git pull 
```

# Workflow Releases

## Anlegen eine neuen Release-Branch

```bash
git checkout -b release-0.1 develop
```

Im Grunde wird ein Release analog zum oben beschriebenen Vorgehen bei einzelnen Features von Develop-Branch abgetrennt. 
Ziel ist dann jedoch nicht eine weiterführende Programmierung sondern ein intensieves Testen auf dem eingefrohrenen Zustand 
und eine Vorbereitung der Softwareauslieferung. 

![Gitflow-Workflow-3](./graphics/Gitflow-Workflow-3.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizens](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)


## Hotfixes im laufenden Release

Muss bei einem schon veröffentlichten Release aufgrund eines kritischen Fehlers ein Hotfix erstellt werden, so wird vom Masterbranch ausgehen ein neues Branch erstellt. 
Anschließend muss dieses Hotfix dann natürlich in zwei Branches gemerged werden: Im Masterbrach und im Developerbranch. 

![Gitflow-Workflow-4](./graphics/Gitflow-Workflow-4.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizens](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)
		
