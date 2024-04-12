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

Die Entwicklung findet grundsätzlich im `dev`-Branch statt und kann während der Entwicklungsphase für kleinere Änderungen genutzt werden, die keine neuen _Features_ hinzufügen. In der Regel handelt es sich also nur um kleine Bugfixes oder Tippfehler, die keinen großen Test erfordern. Auch der `dev`-Branch soll bis zum offiziellen 1.0.0-Release an Stabilität gewinnen. 

![Gitflow-Workflow-1](./graphics/Gitflow-Workflow-1.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizens](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)


## Workflow im Feature-Branch

![Gitflow-Workflow-2](./graphics/Gitflow-Workflow-2.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizenz](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

Größere Änderungen, z.B. weitere Tabs oder Cards, die auch die Bedienung des Clients ändern, werden über Feature-Branches eingebracht.

Beim Anlegen eines neuen Feature-Branch gilt die Verabredung, den Branch mit dem verwendeten git-Kürzel/Benutzernamen zu versehen und das Feature zu nennen, z.B. `hmt/kaoa-card`. Alternativ können auch die von der jeweiligen Git-Plattform angebotenen Feature-Branch-Hilfen verwendet werden, die bei der Erstellung von Issues angezeigt werden.

Feature- und andere Branches werden als Fast-Forward Merger gemergt, um den dev-Branch nicht unnötig mit Merge-Commits zu belasten. Falls sinnvoll, werden mehrere Commits auch als Squash-Commit vereint.

Wenn in einem Feature-Branch oder am dev-Branch gearbeitet wird, ist es notwendig, vor dem Merge ein *rebase* durchzuführen, um unnötige Merge-Commits zu vermeiden. Bitte stellen Sie sicher, dass keine Merges erforderlich sind, bevor Sie eigene Änderungen hochladen.

Bei größeren Änderungen in einem Merge-Request sollte darauf geachtet werden, dass nur notwendige Änderungen im Diff entstehen und keine Veränderungen an nicht beteiligten Zeilen entstehen, z.B. durch Neuformatierung. Ein Merge Request sollte immer für die Reviewer nachvollziehbar sein und nicht mehr als ein Feature enthalten. Es ist besser, mehrere kleine Merge-Requests zu erstellen, anstatt wenige große, deren Auswirkungen nicht mehr abgeschätzt werden können.

Arbeiten mehrere Entwickler an einem Feature-Branch, ist eine enge Absprache notwendig, vor allem wenn zwischenzeitlich aus dem dev-Branch ein Rebase gemacht wird. Dann weichen die jeweiligen lokalen und entfernten Branches voneinander ab und müssen erst wieder zusammengeführt werden.

## Workflow im Release-Branch

![Gitflow-Workflow-3](./graphics/Gitflow-Workflow-3.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizenz](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

Sobald ein Release ansteht, wird ein `release/*`-Branch erstellt, der keine neuen Features mehr erhält, sondern ausschließlich für das Bugfixing und für den Feinschliff zur Verfügung steht.

Dieser wird vom aktuellen Development-Branch abgeleitet und so lange bearbeitet, bis ein Merge mit dem Master möglich ist. Sind die Arbeiten abgeschlossen, wird der Release-Branch obsolet und alle seit dem Fork eingespielten Änderungen werden in den dev-Branch überführt.

Während der Release-Phase kann so am Development-Branch weiter entwickelt und neue Features hinzugefügt werden, die für das aktuelle Release jedoch noch nicht relevant sind.

## Workflow Hotfix-Branches

![Gitflow-Workflow-4](./graphics/Gitflow-Workflow-4.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizenz](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

Sollte es einmal zu einer Situation kommen, wo ein Fehler in einem stabilen Release des Master-Branches kommt, dann muss ein Hotfix eingespielt werden. Dazu wird ebenfalls ein Branch angelegt, jedoch als Fork des master-Branches, der dann den Fehler behebt.

Dieser Hotfix-Branch muss anschließend wieder mit dem Master-Branch gemergt werden, der Master bekommt ein neues Minor-Release und ebenfalls muss der Hotfix in den Development-Branch eingespielt werden, damit auch dort der Fehler beseitigt wird.

## Workflow Merge/Rebase

Da das Arbeiten mit den unterschiedlichen Branches immer wieder Konflikte in Git erzeugen wird, werden Merge-Requests ausschließlich von den Release-Managern in die jeweiligen Branches überführt, um Merge-Commits zu verhindern und Merge-Konflikte zu beseitigen.