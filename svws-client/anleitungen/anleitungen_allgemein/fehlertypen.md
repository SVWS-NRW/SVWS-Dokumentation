# Mögliche Fehlertypen im Datenbestand

Im Datenbestand können durch fehlerhafte Einträge Probleme erzeugt werden. Dies kann die Statistik betreffen oder zum Beispiel Abschlussalgorithmen oder die Kursplanung in der GOSt verwirren. 

Die Fehler können ihre Ursachen in alten, mit migrierten Fehleinträgen haben, selten sind sie technischer Natur, häufig wurden sie durch Benutzerfehleingaben erzeugt.

Einige aufgeführte Fehlertypen können unter Umständen vollständig verschwinden, wenn der SVWS-Server intern auf Konsistenz prüft und Fehler korrigiert oder eine neue Fehleingabe verhindert. Dennoch kann diese Liste als Denkhilfe bei einer Fehlersuche verstanden werden.

## Fächer

* Ein Fach ist als **Fach der Oberstufe** markiert, es wird gewählt, dann wird die Markierung entfernt. Eine legitime Ursache könnte sein, dass jemand die Fächer auf korrekte Einträge prüft und vollkommen legitimerweise falsch konfigurierte Fächern entfernt. Diese Einträge erzeugen Fehler in der **Laufbahnplanung**.

* Ein Fach hat eine ungültige Bezeichnung, da sich ASD-Kürzel geändert haben, etwa z.B. aktuell DFG zu DF. Damit kann die **App Noten** nicht geöffnet werden.

## Schulkonfiguration

* Fehler in der Gliederung, zum Beispiel dass eine - zur Zeit der Dokuerstellung - aktuelle Q2 läuft noch als G8. 

* Nicht ASD-konforme Jahrgangsbeichnungen. Zum Beispiel könnte eine Stufe *EF* aus historischen Gründen noch *11* heißen.

## Schülerinnen und Schüler

* Schüler mit *Status Abgang* haben noch *Kurszuweisungen*. Das ist nicht immer erkennbar. Dies sind oft Bedienereingaben, kam aber bei ungünstigen Szenarian auch schon ohne Fehler durch Benutzer vor. Dadurch scheitern Teile der Klausurplanung, möglicherweise dann auch Untisexporte, u.a.

* Zu *löschende Schüler*, die nicht an der Schule angekommen sind, werden auf einen falschen Status gesetzt (etwa *Extern*) und somit mit fehlerhaften/unvollständigen Angaben in Abijahrgängen geladen. Schüler können in solchen Fällen schadlos gelöscht werden, da sie durch Zurücksetzen der Löschmarkierung wieder aktiviert werden können.

## Allgemein und nicht technische Fehleinträge

* Tpipfehler aller Art in den Daten erzeugen mitunter keine technischen Fehler, können aber durchaus saubere Im- und Exporte mit externen Programmen verhindern.

* *Zu lange Bezeichnun*, die nicht in vorgesehene Felder - etwa auf Zeugnisformularen - passen.