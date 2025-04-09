# Datenaustausch mit Untis

In der **App Schule** können Sie über **Datenaustausch** auch Daten im Format des externen Programms *Untis* austauschen.

:::info Untis-Support
Konsultieren Sie für den konkreten Aufbau der jeweilgen .txt-Dateien das über die Webseite des Herstellers abrufbare Untis-Handbuch.
Ebenso nutzen Sie das Handbuch und den Untis-Support für den Im- und Export im Programm Untis.
:::

:::caution Beugen Sie Synchronisationsproblemen vor
Der Ausgangspunkt für den Datenaustausch ist immer der **SVWS-Webclient**. Die Bezeichnungen der Klassen, Lehrkräfte, Fächer und Kurse werden im **SVWS-Webclient** festgelegt, und die entsprechenden Bezeichnungen in **Untis** oder anderen Stundenplanprogrammen müssen sich exakt daran anpassen.
Achten Sie bitte unbedingt darauf, dass die Bezeichnungen für Kurse, Klassen, Lehrkräfte und so weiter in der SVWS-Datenbank und in Untis identisch sind. Achten Sie bitte auch darauf, dass SuS korrekt mit Vor- und Nachname und Geburtsdatum identisch angelegt sind. Tippfehler hier führen zu Problemen bei Datensynchronisationen!

Achten Sie bitte auch darauf, immer nur **aktuelle Untis-Dateien zu importieren** nicht alte oder welche, die Änderungen in Untis noch nicht behinhalten!
:::

:::danger
Es liegt in der Verantwortung der Schule, dass die importierten Daten korrekt sind. Eine sorgfältige Prüfung der Bezeichnungen und eine regelmäßige Synchronisierung zwischen dem SVWS-Webclient und Untis sind essenziell, um einen reibungslosen Importprozess zu gewährleisten.
:::


## Importe

![Importmöglichkeiten für Untis-Daten](./graphics/svws_schule_datenaustausch_untis_import.png "Importieren Sie Stundenpläne mit unterschiedlichen Daten und Ihre Räume")

In den SVWS-Server können Sie *Stundenpläne* auf drei Arten mit unterschiedlichen vielen Informationen einlesen.
+ *Stundenplan GPU001.txt*: Lesen Sie den grundlegenden Stundenplan (ohne Mehrwochenplansupport) ein. In der GPU001.txt codiert Untis den reinen Stundenplan.
+ *Stundenplan GPU001.txt und GPU002.txt*: Mehrwochenpläne werden unterstützt, sofern die Pläne schon mit der korrekten Anzahl an Wochen gerechnet wurden. In der GPU002.txt werden von Untis die Unterrichte selbst codiert.
+ *Stundenplan GPP002.txt und GPU014.txt*: Es werden Mehrwochenpläne unterstützt, achten Sie bitte auf die Ausführungen im SVWS-Client. Achtung: Die GPP002.txt ist nicht die GPU002.txt.

::: warning Blocken und Unterrichte
Wenn Sie mit dem SVWS-Server über die **App Oberstufe** eine Blockung berechnen und mit Untis arbeiten wollen, achten Sie bitte darauf, dass Sie *einmal eine GPU0002.txt im SVWS-Client importieren*. Wenn Sie dies tun, werden die Unterrichte aus der GPU0002.txt mit denen in Ihrer Datenbank synchronisert, so dass es keine Dopplungen gibt. Sie können die Datei vor oder nach dem Blocken einlesen.
:::

+ Über *Raumliste GPU005.txt* können Sie den Katalog Räume befüllen und ergänzen.

In allen Fällen beim Stundenplanimport ist anzugeben, ab wann der importierte Stundenplan gülig sein soll (**Gültig ab**) und wie der importierte Stundenplan im SVWS-Client **bezeichnet** wird. Standardmäßig werden hier Importdatum und Importzeitpunkt in der Bezeichnung hinterlegt.

Ebenso ist über die Checkbox festzulegen, ob Unterrichtseinträge mit fehlerhaften Daten ignoriert d.h. verworfen werden sollen. Sollten Sie fehlerhafte Daten feststellen, empfiehlt es sich, diese Daten vor Im- und Exporten zu bereinigen.

:::info Format der Dateien
Alle Dateien sind csv-Textdateien im Format UTF-8, mit einem Semikolon **;** als Trenner. Textinhalte werden durch führende und schließende doppele Anführungszeiten **"** ausgewiesen.
:::

## Exporte

![Exportdialog für SVWS-Daten in Untis-Dateien](./graphics/svws_schule_datenaustausch_untis_export.png "Der Exportdialog, hier müssen Sie nichts ändern.")

Sie können Ihre SVWS-Daten in Units übernehmen. Derzeit können folgende Daten exportiert werden:
+ Klassenliste (GPU003.txt)
+ Lehrerliste (GPU004.txt)
+ Fächer und Kursliste (GPU006.txt)
+ Schülerliste (GPU010.txt)
+ Fachwahlen (GPU015.txt)
+ Klausuren (GPU017.txt)
+ Schienen (GPU019.txt)
+ Blockung (bestehend aus GPU002.txt, GPU015.txt, GPU019.txt)

Wählen Sie die zu exportierende Datenart. Da Untis die eigenen Schnittstellendaten erwartet, sollten für einen Import in Untis bestimmte Dateien nicht unbenannt werden.

Möchten Sie die Daten aus einem anderen Grund exportieren, können Sie der Datei auch einen passenden Namen geben.

Klicken Sie dann auf `Speichern`, um die Datei an einem Ort Ihrer Wahl abzulegen.

### Schüler IDs

![Wahl der Art der Schüler-IDs](./graphics/svws_schule_datenaustausch_untis_export_schülerids.png "Wählen Sie, wie Schüler-IDs in Untis gespeichert werden.")

Werden Schülerdaten exportiert, legen Sie fest, welche Art der SchülerID Sie nutzen wollen. Zur Wahl stehen die
+ *SVWS-ID*
+ *Untis kurz* bestehend aus Nachname, drei Zeichen des Vornamens und des Geburtsdatums JJJJMMTT
+ *Untis lang*, wie oben, nur dass der volle Vorname verwendet wird

SVWS-IDs haben den Vorteil, dass diese unabhängig von Namensänderungen oder falschen beziehungsweise fehlerhaften Einträgen bei Name, Vorname und Geburtsdatum sind. Wird Untis bei Ihnen mit SVWS-Exporten befüllt, empfiehlt sich diese Wahl.

Schüler-ID-Arten sollten in Untis nicht gemischt werden.

### Unterrichte synchroniseren mit der GPU002.txt

![Übergeben Sie eine aktuelle GPU002.txt für manche Exporte](./graphics/svws_schule_datenaustausch_untis_export_GPU002.png "Für manche Exporte wird eine aktuelle GPU002.txt benötigt.")

Um zu verhindern, dass Unterrichts-IDs doppelt vergeben werden, muss bei manchen Exporten zuerst eine aktuelle (!) GPU002.txt aus Untis mit eingelesen werden, da in der Zwischenzeit in Untis eventuell neue Unterrichts-IDs erzeugt wurden.

Bevor Sie also einen Export aus dem SVWS-Client anstoßen, erzeugen Sie in Untis eine ganz aktuelle GPU002.txt und übergeben Sie diese dem Export-Dialog im SVWS-Client, dann speichern Sie Ihre Datei und lesen sie diese anschließend in Untis ein.

