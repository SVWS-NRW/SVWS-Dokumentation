## Anmeldung

* Öffnen Sie die Web-Adresse des WeNoM-Servers.
* Zum Anmleden gilt die *dienstliche Emailadresse* als **Benutzername** .
* Als Kenntowrt ist das **Initialkenntwort** zu verwenden, welches den **Lehrkräften** von der Schule mitgeteilt wurde.

![Das Anmeldefenster zum WebNotenManager](graphics/WenomAnmeldung.png "Loggen Sie sich mit Ihrer dienstlichen Emailadresse und dem erhlatenen Passwort beim WeNoM ein.")

Nach dem Login öffnet sich der Leistungsdatenreiter mit der vorausgewählten ersten Lerngruppe der Lehrkraft. 

Je nach Rolle der Lehrkraft kann die Ansicht variieren. Es wird zwischen den folgenden Möglichkeiten unterschieden:
* Fachlehrkraft
* Klassenleitung
* Schulleitung bzw. Abteilungsleitung

### Grundsätzliche Tabelleneinstellungen

**GRAFIK TODO**

In dieser Ansicht können Lerngruppen in die Tabellenübersicht aufgenommen beziehungsweise abgewählt werden. Am rechten Rand der Tabelle können Spalten ein- und ausgeblendet werden. Je nach Benutzer können bis zu drei verschiedene Tabellen aufgerufen werden. 

+ Leistungsdaten
+ Teilleistungen
+ Klassenleitung

## Eintragungen der Fachlehrkraft


### Leistungsdaten

![Übersichtstabelle der Leistungsdaten](graphics/WenomLeistungsdaten.png "Geben Sie Noten, Mahnungen und Fehlstunden ein.")


#### Noten eintragen

Die **Fachlehrkraft** kann die Noten für ihren eigenen Unterricht in den Leistungsdaten eingeben. Hierbei ist die **Note** die Zeugnisnote. Es kann ebenfalls eine **Quartalsnote** vergeben werden.

Sofern **Teilleistungen** definiert sind, werden diese hier ebenfalls eingetragen.

Es lassen sich ganze Noten (1, 2, 3, …) und Noten mit Tendenzen eingeben (3+, 3, 3-, …).

::: tip Pfeiltasten verwenden
Nutzen Sie bei Verwendung einer Tastatur die Coursertasten, um zwischen den Feldern und Spalten zu wechseln. Noten lassen sich gut mit dem Ziffernblock eintippen.
:::

#### Mahnungen setzen

Unter den Leistungsdaten können Mahnungen neu gesetzt oder bereits ausgesprochene Mahnungen von der Lehrkraft nachgesehen werden. 

Ist die Checkbox mit einem Haken versehen und inaktiv - also nicht mehr veränderbar - dann handelt es sich um eine *ältere Mahnung*, die dem Schüler zum Beispiel im letzten Halbjahr durch die Vergabe eines Defizits ausgesprochen wurde.

Mit dem entsprechenden Schüler ausgewählte Mahnungen sind am gesetzten Haken und die rote Färbung erkennbar. Diese Mahnungen können weiterhin bearbeitet werden.

::: info Update des Mahnungs-Status
Werden die Noten und Mahnungen aus WeNoM in den SVWS-Webclient übertragen und dort verarbeitet, wird der Zustand der Mahnung auf *ausgesprochen* beziehungsweise *versendet* geändert. Dies bedeutet nach einer weiteren Synchronisation, dass die Checkbox hier im WeNoM auf *angehakt* und auch *inaktiv* wechselt.
:::


#### Fachbezogene Fehlstunden eintragen

Im Bereich **Fehlstunden** können *fachbezogene Fehlstunden* (FS) als ganze Zahl eingegeben werden. Die Anzahl der *unentschuldigten Fehlstunden* (FSU) wird in der benachbarten Spalte eingetragen. 

#### Eintragungen fachbezogene Bemerkungen (FB)

Durch Klicken auf **Fachbezogene Bemerkungen** öffnet sich ein Eingabefenster. Es ist nun der zuvor ausgewählte Schüler ausgewählt, es können können auch alle weiteren Schüler der entsprechenden Lehrgruppe auf der linken Seite zusätzlich ausgewählt werden.

Im unteren Bereich können **vorformulierte Floskeln** entweder durch Eingabe des Kürzels oder durch Anklicken übernommen und beim Schüler eingetragen werden. Hierbei werden Platzhalter wie *$Vorname$* automatisch ausgefüllt.

![Auswahlliste der fachbezogenen Floskeln](graphics/WenomFachbezBem.png "Auswahlliste der fachbezogenen Floskeln.")


### Teilleistungen
![Übersicht der Teilleistungen zur Noteneingabe](graphics/WenomTeilleistungen.png "Vergeben Sie Noten für von der Schule definierte Teilleistungen.")

Als **Teilleistungen** werden Unternoten eines Faches bezeichnet, dies sind zum Beispiel für *Sonstige Mitarbeit*, *Klausuren und Klassenarbeiten* oder *ZP10-Prüfungsleistungen*.

::: info Teilleistungen variieren je nach Schule
Die Schule kann Teilleistungen nach eigener Maßgabe definieren, daher können die Teilleistungen nach Schulform und Schule in ihrer Anzahl und in ihrer Bezeichnung variieren. Schulen verwenden eventuel keine Teilleistungen.
:::

Im Tab Teilleistungen findet man eine Übersicht über alle in dieser Lerngruppe durch den zentralen SVWS-Server vorgegebenen Teilleistungsarten. 

Alternativ zum Leistungsdatenreiter können hier auch die Quartals- und Endnoten eingetragen werden. 

## Eintragungen der Klassenleitung

![Eomtragen von Fehlstunden und Bemerkungen durch die Klassenleitungen](graphics/WenomKlassenleitung.png "Tragen Sie als Klassenleitung gesammlte Fehlstunden und unterschiedlichen Bemerkungen ein.")

### Klassenleitung: FS und FSU

Der **Tab Klassenleitung** ist nur für Klassenlehrkräfte sichtbar. Hier werden fachübergreifende Fehlstunden ("FS" für "Fehlstunden" und FSU für "Unentschuldigte Fehlstunden"), also die Gesamtfehlstunden, verwaltet, falls sich die Schule beziehungsweise die Abteilung für eine direkte Erfassung der Gesamtnoten entschieden hat. 

### ASV, AUE und ZB

Unter den Spalten
* ASV - Arbeits- und Sozialverhalten,
* AUE - Außerunterrichtliches Engagement und 
* ZB - Zeugnisbemerkung

können jeweils in diesen unterschiedlichen Kontexten Bemerkungen eingetragen werden.

Ebenso wie bei den fachbezogenen Bemerkungen kann hier auf vorformulierte Floskeln zurückgegriffen werden. Zum Bearbeiten des Textes öffnet wieder ein Fenster, in dem Floskeln ausgewählt oder manuell eingetragen werden können.
 

## Tätigkeiten der Schulleitung/Abteilungsleitung

Eine Schulleitung oder Abteilungsleitung/-koordination erhält die gleiche Ansicht wie eine Klassen- beziehungsweise die Fachlehrkraft. Es werden aber erweiternd alle Lerngruppen der Schule beziehungsweise der Abteilung zur Auswahl angezeigt.

Die hauptsächliche Tätigkeit ist hier das Sichten der Noten zu Beratungszwecken. Gegebenenfalls können Noten und Bemerkungen von erkrankten Lehrkräften nachgetragen werden.
