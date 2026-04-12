# Die Verwendung Der SVWS-Konferenzübersicht

Dieses Kapitel beschreibt die wichtigsten Bereiche der Benutzeroberfläche und ihre Funktion.

## Klassenübersichtstabelle

Die zentrale Tabellenansicht zeigt pro Klasse die aufbereiteten Datensätze — Schülernamen, Leistungsnoten, Status und gegebenfalls Kommentarspalten.

Nutzen Sie die *Kopfzeilen zum Sortieren*, die Suchleiste für schnelles Filtern und das **Dropdown-Menü** links oben, um zwischen Klassen zu wechseln beziehungsweise nur eine einzige *Klasse oder Lerngruppe* anzuzeigen.

Einzelne Noten können direkt in der Tabellenansicht editiert werden, Klicken Sie dazu in die jeweile Zelle. Nach Änderung bestätigen Sie die Eingabe per Enter oder durch Klicken außerhalb der Zelle.

Sie können die *Noten (eventuell mit Tendenzen)* sowie die anderen gewohnten Werte wie *NB*, *E1* bis *E3* und so weiter eingeben.

Für die *Gynmasiale Oberstufe* kann zwischen **Noten** und **Punkten** bei der Eingabe umgeschaltet werden.

Klicken Sie eine Zeile an, um Details mit der *Schülerlupe* zu öffnen.

![Ansicht der Klassenübersicht](./graphics/konferenz_klassenuebersicht.png "Eine Übersicht über die Leistungsdaten der ganzen Klasse.")

Hier im Beispiel wurde auch ein *Timer* gesetzt - mehr dazu findet sich weiter unten.

## Schülerlupe (Schnellansicht)

Per Lupe-Icon oder Doppelklick auf einen Schüler öffnen Sie eine kompakte Schnellansicht: Notenübersicht, Fehlstunden und Bemerkungen für die Konferenz. 

Hier in dieser Ansicht lassen sich auch **Fehlstunden** und die Zeugnisbemerkungen eintragen.

Diese Ansicht ist dazu geeignet, um vor einer Entscheidung schnell die relevanten Informationen zu prüfen, ohne das Hauptfenster zu verlassen.

![Große Übersicht über einen Personendatensatz](./graphics/konferenz_schuelerlupe.png "In der Schülerlupe wird ein Personendatensatz im Detail angezeigt.")

## Timer / Konferenzzeitmesser

Oben rechts finden Sie einen Timer, der die verbleibende oder verstrichene Zeit der Besprechung anzeigt.

Starten, pausieren oder nullen Sie den Timer über die danebenliegenden Tasten. Der Timer dient als Orientierung für die Zeitplanung einzelner Tagesordnungspunkte.

![Anzeige eines Timers](./graphics/konferenz_timer.png "Definieren Sie einen Timer.")

 Wird der Timer auf **Repeat: an** gestellt, wird er beim Wechsel auf einen anderen Schülerdatensatz automatisch neu gestartet.

## Ansicht Kompakt/nicht Kompakt

Wechseln Sie zwischen kompakter und großer Tabellenansicht über die Ansichtsschaltfläche oberhalb der Tabelle.

Die kompakte Ansicht zeigt mehr Zeilen, die große Ansicht mehr Detailspalten.

## Änderungen exportieren

![Verarbeiten Sie die gemachten Änderungen](./graphics/konferenz_aenderungen.png "Klicken Sie oben rechts auf Änderungen (Anzahl).")

Nach der Bearbeitung klicken Sie auf **Änderungen (x)**, um eine druckerfreundliche Ansicht oder PDF-Datei zu erzeugen. Diese Datei können Sie zur Archivierung oder für die Weitergabe nutzen

![Optionen wie mit Änderungen zu verfahren ist](./graphics/konferenz_aenderungen_optionen.png "Wählen Sie, was mit den Änderungen geschehen soll.")

Über **Log drucken** öffnet sich ein Dialog, mit dem Sie einen Speicherort für für ein Logdatei als .pdf mit den Änderungen auswählen.

Die **Exportfunktion** nutzt den Weg, der bei Zugang zur App gewählt wurde, um die Daten wieder aus der SVWS-Konferenzübersicht herauszuschreiben, also entweder findet eine Online-Synchronisation mit dem SVWS-Server über API statt oder es wird wieder eine Notendatei erstellt, die sich über den SVWS-Webclient einlesen lässt.

![Export starten](./graphics/konferenz_aenderungen_export.png "Bei einem Export wird noch einmal nachgefragt. Klicken Sie auf Export starten.")

Der Export ist noch einmal zu bestätigen. Da hier im Beispiel mit einer Offline-Notendatei gearbeitet wurde, wird eine veränderte Datei erzeugt, diese heißt `enm.changed.json.gz`, die nun wieder im SVWS-Webclient eingelesen werden kann.

Arbeiten Sie im Online-Modus mit einer direkten Verbindung zum SVWS-Server, sind die Daten nach dem Export synchronisert.

Alternativ können Sie *alle!* **Änderungen verwerfen** und die SVWS-Konferenzübersicht wieder auf den Ausgangszustand zurückstellen. 

::: warning Keine automatische Synchronisierung
Es findet keine automatische Synchronisierung statt. Nicht gespeicherte/exportierte Änderungen gehen verloren.

Denken Sie daher an regelmäßige Sicherungen.
:::

## Einlesen der Daten im SVWS-Webclient

Wenn Sie im Online-Modus arbeiten, sind die Daten nach einem Export synchronisert. Arbeiten Sie im Offline-Modus mit den Im- und Exportdateien, müssen Sie im Anschluss an den Export die `enm.changed.json.gz` im SVWS-Webclient noch einmal wieder einlesen.

![Geänderte Daten im Webclient wieder importieren](./graphics/konferenz_webclient_datenImportieren.png "Wählen Sie, welche Daten importiert werden sollen.")

Gehen Sie hierzu in **App Schule ➜ Datenaustausch ➜ ENM-Notenmanager** und klicken Sie unter *Lehrkraftdaten und Konferenzdaten importieren* auf die Schalter `Datei auswählen`.

Achten Sie auch hier darauf, dass die gerade erstellte und damit korrekte Datei ausgewählt wird. Achten Sie hierbei auf Erstellungsdatum/-zeit der Datei.

![Import erfolgreich](./graphics/konferenz_webclient_datenImportieren_importErfolgreich.png "Die Datei mit den Änderungen wurde importiert.")

Ganz gleich, ob Sie im Offline- oder Onlinemodus gearbeitet haben: Die Eintragungen der SVWS-Konferenzübersicht sind nun im SVWS-Webclient über die **App Noten** und in den **Leistungsdaten** der **App Schüler** einsehbar.

