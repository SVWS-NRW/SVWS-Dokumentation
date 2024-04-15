***Git Workflow***
=========================================================

Um an den Repositories mitzuarbeiten, ist [git](https://git-scm.com/) als Versionierungswerkzeug notwendig:

+ unter Linux: `apt install git`
+ unter Windows download [gitBash](https://gitforwindows.org/)
+ unter macOS in Verbindung mit [Homebrew](https://brew.sh): `brew install git`

Eine umfassende Liste der gängigsten GUI- und CLI-Clients ist hier zu finden: [https://git-scm.com/downloads](https://git-scm.com/downloads)

Alternativ kann auf entsprechende Plugins der verwendeten Entwicklungsumgebung zurückgegriffen werden.

## Git Repositories

Das SVWS-Server-Projekt wird auf einem geschlossenen GitLab-Server geführt und auf GitHub unter [SVWS-NRW/SVWS-Server](https://github.com/SVWS-NRW/SVWS-Server) gespiegelt.
Aktuell enthält das Projekt unter anderem zwei Repositories, die öffentlich zugänglich sind:

[SVWS-Server](https://github.com/SVWS-NRW/SVWS-Server)
[SVWS-Dokumentation](https://github.com/SVWS-NRW/SVWS-Dokumentation)


Hier finden Sie auch [weitere Repositories](https://github.com/SVWS-NRW/), wie zum Beispiel Test-Datenbanken u.v.m..

## Der Git-Workflow für das SVWS-Server Repository

Im den folgenden Abschnitten wird das Vorgehen und die Handhabung der verschiedenen Branches beschrieben, die bei der Mitarbeit am SVWS-Server verwendet werden.

Um einen reibungslosen Ablauf und eine erfolgreiche Mitarbeit zu ermöglichen, wird gebeten, auf diese Arbeitsweise Rücksicht zu nehmen.

## Workflow im master- und dev-Branch

![Gitflow-Workflow-1](./graphics/Gitflow-Workflow-1.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizens](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

Bei der Entwicklung des SVWS-Servers wird die Versionierung im `master`-Branch festgehalten, der ausschließlich von den Release-Managern betreut wird. In unregelmäßigen Abständen wird ein Release zusammengestellt und über [Github](https://github.com/SVWS-NRW/), [DockerHub](https://hub.docker.com/u/svwsnrw) und ggf. [npm](https://www.npmjs.com/~svws-nrw) veröffentlicht.

Die Entwicklung findet grundsätzlich im `dev`-Branch statt und erfordert das Anlegen von Feature-Branches, die im folgenden Abschnitt beschrieben werden. Bis auf wenige Ausnahmen, werden keine Commits direkt in den dev-Branch eingespielt, der auch durch einen Schreibschutz den Release-Managern vorbehalten ist.

## Workflow im Feature-Branch

![Gitflow-Workflow-2](./graphics/Gitflow-Workflow-2.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizenz](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

Änderungen, z.B. weitere Tabs oder Cards, die auch die Bedienung des Clients ändern, werden über Feature-Branches eingebracht.

Beim Anlegen eines neuen Feature-Branch gilt die Verabredung, den Branch mit dem verwendeten git-Kürzel/Benutzernamen zu versehen und das Feature zu nennen, z.B. `hmt/kaoa-card`. Alternativ können auch die von der jeweiligen Git-Plattform angebotenen Feature-Branch-Hilfen verwendet werden, die bei der Erstellung von Issues angezeigt werden.

Feature-Branches, die von den Release-Managern angelegt werden und in der Regel von mehreren Entwicklern gleichzeitig genutzt werden, verzichten auf das Kürzel und haben in der Regel die Form `feature/statistik`.

Von Entwicklern angelegte Branches werden immer als Fast-Forward Merger gemergt, um den dev-Branch nicht unnötig mit Merge-Commits zu belasten. Falls sinnvoll, werden mehrere Commits auch als Squash-Commit vereint.

Wenn ein Fast-Forward-Merge in den dev-Branch nicht mehr möglich ist, muss ein Rebase durchgefürt werden, um die zuvor eingespielten Änderungen im dev-Branch, z.B. verursacht durch andere Feature-Branches, in den eigenen Feature-Branch zu integrieren.

Dazu kann entweder die auf der Git-Plattform zur Verfügung gestellte Funktion verwendet werden oder es muss lokal ein Rebase durchgeführt werden. Es reicht nicht, lokal ein Merge durchzuführen, denn das führt zu undurchsichtigen Merge-Requests und kann nicht übernommen werden. In jedem Fall muss bei einem Rebase, ob lokal oder entfernt, die Gegenseite mit angepasst werden. Es wird daher empfohlen, auf Rebases vor einem Merge zu verzichten und dies erst mit dem Merge-Request durchzuführen.

Bei größeren Änderungen in einem Merge-Request sollte darauf geachtet werden, dass nur notwendige Änderungen im Diff entstehen und keine Veränderungen an nicht beteiligten Zeilen entstehen, z.B. durch Neuformatierung. Ein Merge-Request sollte immer für die Reviewer nachvollziehbar sein und nicht mehr als ein Feature enthalten. Es ist besser, mehrere kleine Merge-Requests zu erstellen, anstatt wenige große, deren Auswirkungen nicht mehr abgeschätzt werden können.

Arbeiten mehrere Entwickler an einem Feature-Branch, ist eine enge Absprache notwendig, vor allem wenn zwischenzeitlich aus dem dev-Branch ein Rebase gemacht wird. Dann weichen die jeweiligen lokalen und entfernten Branches voneinander ab und müssen erst wieder zusammengeführt werden.

## Workflow im Release-Branch

![Gitflow-Workflow-3](./graphics/Gitflow-Workflow-3.png)

Urheber der Grafik: [seibert-media.net](https://infos.seibert-media.net/display/Productivity/Git-Workflows+-+Der+Gitflow-Workflow) veröffentlicht unter [creative-common-lizenz](https://infos.seibert-media.net/display/seibertmedia/Inhalte+von+Seibert+Media+unter+Creative-Commons-Lizenz)

Sobald ein Release ansteht, wird ein `release/*`-Branch mit der anstehenden Versionsnummer erstellt, der keine neuen Features mehr erhält, sondern ausschließlich für das Bugfixing und für den Feinschliff zur Verfügung steht.

Die Änderungen die hier eingespielt werden, müssen unmittelbar in den Development-Branch übertragen werden, z.B. durch Cherry-Picking, damit der Development-Branch ebenfalls die Bugfixes bekommt.

Während der Release-Phase kann so am Development-Branch weiter entwickelt und neue Features hinzugefügt werden, die für das aktuelle Release jedoch noch nicht relevant sind.

## Workflow Bugfixes für Releases (Hotfixes)

Sollte es einmal zu einer Situation kommen, wo ein Fehler in einem stabilen Release des Master-Branches kommt, dann muss ein Hotfix eingespielt werden. Dazu wird der Release-Branch verwendet, der zu dem betroffenen Release gehört. Hier wird ein Bugfix eingespielt, getestet und anschließend in den Master-Branch überführt und mit einem Minor-Release getaggt. Ebenfalls wird per Cherry-Picking der Bugfix in den Development-Branch übertragen.

## Workflow im Master-Branch

Der Master-Branch enthält nur die Commits, die zu einem Release führen. Daher soll der Release-Branch für den Merge in den Master-Branch mit einem Squash-Commit zusammengefasst werden und bekommt zwischen den Releases nur einzelne Bugfix-Commits hinzugespielt. Es werden daher alle Commits im Master-Branch mit einem Tag ausgestattet, das die aktuelle Version angibt.

Da mehrere parallele Releases nicht gewünscht sind, wird es nur ein "Rolling-Release" mit einer aktuellen Version geben, keine rückwirkenden Bugfixes für bereits überholte Releases. Die mit einem neuen Release angelegten Release-Branches werden daher mit jedem neuen Release-Branch obsolet und bekommen keine zusätzlichen Commits.

## Workflow Merge/Rebase

Da das Arbeiten mit den unterschiedlichen Branches immer wieder Konflikte in Git erzeugen wird, werden Merge-Requests ausschließlich von den Release-Managern in die jeweiligen Branches überführt, um Merge-Commits zu verhindern und Merge-Konflikte zu beseitigen.