# Frontend

## Unit- und Integrationstests
[vitest](https://vitest.dev/) wird für die Unit-Tests verwenden, um isolierte Funktionalität unseres Codes zu überprüfen. Das geht dann teilweise über in Integrationstests, die das Zusammenspiel der Klassen testen. Coverage, also die Übersicht, wie viel des geschriebenen Codes getestet wurde, wird mit vitest geliefert.

## e2e-Tests
Darüberhinaus soll [Playwright](https://playwright.dev) e2e testen, also das, was der Benutzer am Ende im Browser sieht. Damit können wir eine gesamte Benutzersitzung durch Automatisierung nachahmen, um z.b. festzustellen, dass die Oberfläche durchgehend funktioniert. So kann man z.B. testen, dass die Laufbahnplanung bei bestimmten Klickreihenfolgen immer die gleichen Fehlermeldungen in der Laufbahninfo angibt etc.

## Stories
Dann sollte noch [histoire](https://histoire.dev/) als Storybookersatz genutzt werden, um die Funktionalität der einzelnen Komponenten zu beleuchten und sicherzustellen. Es lassen sich damit alle vorgesehenen Funktionen einer Komponente nachahmen in einer Art Testumgebung, wobei das nicht automatisiert ist.

## TODO
Einrichtung einer Testdatenbank, die im CI eingespielt wird. Anschließend muss der Server starten, damit Playwright seinen Dienst tun kann.