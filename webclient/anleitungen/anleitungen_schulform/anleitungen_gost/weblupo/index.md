# Der Beratungsprozesses mit WebLuPO

## Kurze Funktionsbeschreibung

Schülerinnen und Schüler erhalten eine Lupo-Datei mit der Endung ````.lp```` zur Erfassung ihrer Fachwahlen und Laufbahnplanung in der gymnasialen Oberstufe. Diese Datei enthält die grundlegenden Rahmenbedingungen für Wahlmöglichkeiten und Kurskombinationen, die von der Schule festgelegt wurden, sowie die erforderlichen individuellen Daten (Name, E-Mail und so weiter).

Die Datei kann über eine Webseite entschlüsselt und geöffnet werden. Ein Testserver ist unter [weblupo.svws-nrw.de](https://weblupo.svws-nrw.de) verfügbar.

Nach erfolgreicher Bearbeitung kann die Datei durch Drücken des ````Exportieren````-Buttons wieder verschlüsselt auf dem Client-Endgerät gespeichert und von den Oberstufenkoordinatoren eingesammelt werden.

Informationen zur Installation des WebLuPO-Servers und weitere technische Hintergrundinformationen finden Sie auf dieser Webseite im Bereich der technischen Dokumentationen unter *Administration/Entwicklung* und dann im Bereich der *Projekte*.

::: info Weitere Informationen
Informationen mit allen Details und Anmerkungen finden sich im jeweiligen Artikel der **Tabs** in der **App Oberstufe**.

Beachten Sie, dass das neue Dateiformat **nicht** mit den alten Dateien des Programms "LuPO" für MS Windows  kompatibel ist.
:::

Installieren Sie bei Bedarf [WebLuPO](../../../../../weblupo/index.md) beziehungsweise installieren Sie eine geupdatete Version.

## Erzeugen der Laufbahnplanungsdateien

Eine ausführliche Beschreibung aller möglichen Einstellungen finden sich in der Client-Dokumentation unter der App **Oberstufe**. Hier wird eine Übersicht über die Vorbereitung des Beratungsprozesses in WebLuPO gegeben. 

Im zweiten Halbjahr der Jahrgangsstufe 10 (G9) müssen im SVWS-Webclient die *Fächer der Oberstufe* auf Korrektheit kontrolliert werden. Hierzu sind unter der **App Schule** ➜ *Fächer* alle Fächer der Oberstufe als solche über den entsprechenden Haken zu markieren. Dies ist nach der Ersteinrichtung in der Regel schon korrekt.

### Tab Fächer

Dann finden sich diese Fächer in der **App Oberstufe** eben diese Fächer. Hier lässt sich nun anwählen, welche Fächer in der EF und der Q-Phase grundsätzlich anwählbar sind. Über die Spalte *Abitur* lässt sich einstellen, ob der Kurs als *GK* oder *LK* angewählt werden kann.

Ebenso sind *Unzulässige Kombinationen* anzulegen, etwa, wenn sich bestimmte Kurse an Ihrer Schule gegenseitig ausschließend. Ähnlich sind *Geforderte Kombinationen* zu konfigurieren, wenn diese etwa durch Profile vorgeschrieben werden.

Hierbei ist zu beachten: Konfigurieren Sie so wenig wie möglich, die allgemeinen Rahmenbedingungen, die durch die APO-GoST vorgebene werden, sind schon im Webclient hinterlegt.

Nachdem diese **Allgemeine Vorlage** erzeugt wurde, lassen sich links in der Auswahlliste die darauf basierenden Vorgaben für einen konkreten Abitur-Jahrgang festlegen. Erzeugen Sie einen neuen Abitur-Jahrgang mit einem Klick auf das **+**, dann ändern Sie die Vorlage gegebenfalls ab oder lassen Sie diese wie sie ist.

### Tab Beratung

Unter dem **Tab Beratung** kann die Vorlage für WebLuPO definiert werden, in der schon Wahlen ausgefüllt. Zum Beispiel belegen alle Schüler Sport mit einem mündlichen Kurs oder Deutsch mit einem schriftlichen.

### Exportieren der LuPO-Dateien für WebLuPO

Wechseln Sie auf den **Tab Laufbahn**, hier steht der *Schalter* ````Export für alle```` zur Verfügung, über den die WebLuPO-Dateien erzeugt werden können.

:::info Einzelene Schüler exportieren
Möchten Sie zu einem späteren Zeitpunkt nur einzelene Schüler nach-exportieren, gehen Sie in der **App Oberstufe** zum **Tab Laufbahnen** und wählen dort den oder die zu exportierende Person an, dann ändert sich *Export für alle* zu ````Exportiere Auswahl````.  
:::

Es wird eine gepackte .zip-Datei erzeugt, in der die WebLuPO-Dateien enthalten sind. Diese ist zu entpacken und die einzelnen Dateien sind je nach Schulorganisation an Schüler bringen.

Lassen Sie die Schüler wählen und führen Sie die Beratungen entsprechend Ihrer Arbeitsprozesse durch.

Hierzu müssen diese Dateien entsprechend des Wahl- und Beratungsprozesses an Ihrer Schule nun in WebLuPO eingelesen werden.

Installieren Sie bei Bedarf [WebLuPO](../../../../../weblupo/index.md) beziehungsweise installieren Sie eine geupdatete Version.

Navigieren Sie zur Beratung zu WebLuPO. Hier finden Sie die [Erläuterungen zur Bedienung von WebLuPo](../../../../../weblupo/weblupo_handbuch.md).

Bei der Wahl beziehungsweise fallen wieder WebLuPO-Dateien an, die dort exportiert werden und dann wieder im SVWS-Webclient eingelesen werden. 

## Weitereinlesen der WebLuPO-Dateien im SVWS-Webclient

Gehen Sie wieder in der **App Oberstufe** in den **Tab Laufbahnen** und wählen Sie den betreffenden *Abitur-Jahrgang* an. 

Klicken Sie nun auf ````Importieren...```` und wählen Sie im sich öffnenden Auswahlfenster die zu importierneden ````.lp````-Dateien aus.

:::tip Mehrere Dateien anwählen
Um alle Dateien auszuwählen, drücken Sie ````Strg + A````, um mehrere Dateien zu selektieren, klicken Sie die Dateien mit gedrückter ````Strg````-Taste an. Um Dateien *von* einem Schüler *bis* zu einem anderen anzuwählen, klicken Sie die oberste Datei an, dann klicken Sie mit gedrückter ````Shift````-Taste die untere Datei an. 
:::

Dann klicken Sie auf ````Öffnen```` und die Dateien werden wieder importiert. Die Wahlen stehen nun zur Verfügung.

:::tip Springen Sie zu einer konkreten Person
Wenn Sie auf das Link-Symbol vor einem Schüler klicken, springt die Ansicht direkt in die zugehörige Laufbahnplanung.
:::