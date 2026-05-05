# WenNoM - Anleitung für Lehrkräfte

## Erste Anmeldung

+ Öffnen Sie die Web-Adresse des WeNoM-Servers, die Sie von Ihrer Schule erhalten haben.
+ Zum Anmelden gilt die **dienstliche Emailadresse** als **Benutzername**.
+ Als Kennwort ist das **Initialkennwort** zu verwenden, welches Ihnen von der schulischen Administration mitgeteilt wurde.

![Das Anmeldefenster zum WebNotenManager](graphics/WenomAnmeldung.png "Loggen Sie sich mit Ihrer dienstlichen Emailadresse und dem erhlatenen Passwort beim WeNoM ein.")

Nach der ersten Anmeldung am System verliert das Initialkennwort die Güligkeit und es wird **einmalig** das neue Passwort angezeigt.

![Erstanmeldung](./graphics/erstanmeldung.png)

Bitte nie die Passwörter im Browser speichern!

Notieren Sie sich das Passwort zum Beispiel in Ihrem Passwortmanager.

## Zwei-Faktor-Authentifizierung

### Einrichtung zweiter Faktor

Haben Sie noch keine Zwei-Faktor-Authentifizierung?

Dann finden Sie hier den Artikel: [Einrichtung Zwei-Faktor-Authentifizierung](einrichtungZweiterFaktor.md)

### Login mit aktivierter Zwei-Faktor-Authentifizierung

Ist seitens der schulfachlichen Administration der zweite Faktor verpflichtend eingeschaltet, so erscheint nach der ersten Anmeldemaske zusätzlich die Eingabemaske für den 6-stelligen, zeitlich begrenzt gültigen zweiten Faktor.

![Zweiten Faktor Eingeben](./graphics/2fa_eingeben.png)

## Grundsätzliche Tabelleneinstellungen

![Tabellenansicht](./graphics/tabellenansicht.png)

Über die links angezeigte Liste können Lerngruppen in die Tabellenübersicht aufgenommen beziehungsweise abgewählt werden. Am rechten Rand der Tabelle können Spalten ein- und ausgeblendet werden. Je nach Ihrer Rolle können bis zu drei, teils unterschiedliche Tabellen, aufgerufen werden:

+ **Leistungsdaten** - dies sind die Noten, Fehlstunden und Mahnungen bei Schülern.
+ **Teilleistungen** - werden an Ihrer Schule Teilleistungen zu Fächern erfasst, sind diese hier aufgeführt. Teilleistungen könnten Noten für Klausuren, Sonstige Mitarbeit oder ZP10-Noten sein.
+ **Klassenleitung** - als Klassenleitung können hier aufsummierte Fehlstunden oder die diversen Arten von Zeugnisbemerkungen eingegeben werden.

## Ansichten der verschiedenen Benutzergruppen

Nach dem Login öffnet sich der Leistungsdatenreiter mit der vorausgewählten ersten Lerngruppe der Lehrkraft.

Je nach Rolle der Lehrkraft kann die Ansicht variieren. Es wird zwischen den folgenden Möglichkeiten unterschieden:

+ Die **Fachlehrkraft** sieht nur die Leistungsdaten ihrer Klassenunterrichte und Kurse.
+ Die **Klassenleitung** sieht weitere Daten wie Zeugnisbemerkungen.
+ Die **Schulleitung** oder eine  **Abteilungsleitung/Stufenkoordination** sieht wie die Klassenleitung alle Daten der Schule oder Abteilung.

## Eintragungen der Fachlehrkraft

### Leistungsdaten

![Übersichtstabelle der Leistungsdaten](graphics/WenomLeistungsdaten.png "Geben Sie Noten, Mahnungen und Fehlstunden ein.")

#### Noten eintragen

Die **Fachlehrkraft** kann die Noten für ihren eigenen Unterricht in den Leistungsdaten eingeben. Hierbei ist die **Note** die Zeugnisnote. Es kann ebenfalls eine **Quartalsnote** vergeben werden.

Sofern **Teilleistungen** definiert sind, werden diese hier ebenfalls eingetragen.

Es lassen sich ganze Noten (1, 2, 3, …) und Noten mit Tendenzen eingeben (3+, 3, 3-, …). Weiterhin können je nach Bedarf Leistungsstufen E1, E2, E3 oder Codes wie NB für "Nicht beurteilbar" oder NE für "Nicht erteilt" usw. eingetragen werden.

::: tip Pfeiltasten verwenden
Nutzen Sie bei Verwendung einer Tastatur die Cursortasten, um zwischen den Feldern und Spalten zu wechseln. Noten lassen sich gut mit dem Ziffernblock eintippen.
:::

#### Mahnungen setzen

Bei den Leistungsdaten können **Mahnungen** neu gesetzt oder bereits ausgesprochene Mahnungen von der Lehrkraft nachgesehen werden. Mahnungen werden über den Haken in der Checkbox vergeben.

Ist das Feld *mit einem Haken versehen* und *inaktiv* - wird also ohne Checkbox angezeigt und ist nicht mehr veränderbar - dann handelt es sich um eine *ältere Mahnung*, die dem Schüler zum Beispiel im letzten Halbjahr durch die Vergabe eines Defizits ausgesprochen wurde.

Bei einer Schülerin neu gesetzte Mahnungen sind am gesetzten Haken und der *roten Färbung* erkennbar. Diese Mahnungen können weiterhin bearbeitet werden.

::: info Update des Mahnungs-Status
Werden die Noten und Mahnungen aus WeNoM in den SVWS-WebClient übertragen und dort verarbeitet, wird der Zustand der Mahnung auf *ausgesprochen* beziehungsweise *versendet* geändert. Dies bedeutet nach einer weiteren Rück-Synchronisation mit WeNoM, dass der Status hier auf *angehakt* und *inaktiv* wechselt.
:::

#### Fachbezogene Fehlstunden eintragen

Im Bereich **Fehlstunden** können *fachbezogene Fehlstunden* (FS) als ganze Zahl eingegeben werden. Die Anzahl der *unentschuldigten Fehlstunden* (FSU) wird in der benachbarten Spalte eingetragen und darf die Anzahl der gesamten Fehlstunden nicht übertreffen.

#### Eintragungen fachbezogene Bemerkungen (FB)

Durch Klicken auf **Fachbezogene Bemerkungen** öffnet sich ein Eingabefenster. Es ist nun der zuvor ausgewählte Schüler ausgewählt und Sie können Bemerkungen erzeugen.

Im unteren Bereich dieses Fensters können durch die Schule **vorformulierte Floskeln** entweder durch Eingabe des Kürzels oder durch Anklicken übernommen und beim Schüler eingetragen werden. Hierbei werden Platzhalter wie *$Vorname$* automatisch ausgefüllt.

Sie können im Anschluss Schüler der entsprechenden Lerngruppe auf der linken Seite durchklicken und für diese ebenfalls Bemerkungen erzeugen.

![Auswahlliste der fachbezogenen Floskeln](graphics/WenomFachbezBem.png "Auswahlliste der fachbezogenen Floskeln.")

### Teilleistungen

![Übersicht der Teilleistungen zur Noteneingabe](graphics/WenomTeilleistungen.png "Vergeben Sie Noten für von der Schule definierte Teilleistungen.")

Als **Teilleistungen** werden Unternoten eines Faches bezeichnet. Dies sind zum Beispiel Noten für *Sonstige Mitarbeit*, *Klausuren und Klassenarbeiten* oder *ZP10-Prüfungsleistungen*.

::: info Teilleistungen variieren je nach Schule
Die Schule kann Teilleistungen nach eigener Maßgabe definieren, daher können die Teilleistungen nach Schulform und Schule in ihrer Anzahl und in ihrer Bezeichnung variieren. Schulen verwenden eventuell keine Teilleistungen.
:::

Im Tab Teilleistungen findet man eine Übersicht über alle in dieser Lerngruppe durch den zentralen SVWS-Server vorgegebenen Teilleistungsarten.

Alternativ zum Leistungsdatenreiter können hier auch die Quartals- und Endnoten eingetragen werden.

## Gesperrte Lerngruppen

Seitens der schulischen Administration können einzelne Lerngruppe für die Eingaben ganz oder auch nur teilweise gesperrt werden.

![gesperrte Lerngruppen](./graphics/gesperrteLerngruppen.png)

## Eintragungen der Klassenleitung

![Eomtragen von Fehlstunden und Bemerkungen durch die Klassenleitungen](graphics/WenomKlassenleitung.png "Tragen Sie als Klassenleitung gesammlte Fehlstunden und unterschiedlichen Bemerkungen ein.")

### Klassenleitung: FS und FSU

Der **Tab Klassenleitung** ist nur für Klassenlehrkräfte sichtbar. Hier werden fachübergreifende Fehlstunden, also die Gesamtfehlstunden, verwaltet. *FS* steht für die *Summe der Fehlstunden* und *FSU* für die *Summe der Unentschuldigten Fehlstunden*.

Die Erfassung von Gesamtfehlstunden gilt für den Fall, dass sich die Schule nicht für die Erfassung der fachbezogenen Fehlstunden entschieden hat.

### ASV, AUE und ZB

Unter den Spalten

+ ASV - Arbeits- und Sozialverhalten,
+ AUE - Außerunterrichtliches Engagement und
+ ZB - Zeugnisbemerkung

können jeweils in diesen unterschiedlichen Kontexten Bemerkungen eingetragen werden.

Ebenso wie bei den fachbezogenen Bemerkungen kann hier auf vorformulierte Floskeln zurückgegriffen werden. Zum Bearbeiten des Textes öffnet sich ein Fenster, in dem Floskeln ausgewählt oder manuell eingetragen werden können.

## Tätigkeiten der Schulleitung/Abteilungsleitung

Eine Schulleitung oder Abteilungsleitung/-koordination erhält die gleiche Ansicht wie eine Klassen- beziehungsweise die Fachlehrkraft. Es werden aber erweitert alle Lerngruppen der Schule beziehungsweise der Abteilung zugeordnete Klassen/Jahrgänge zur Auswahl angezeigt.

Die hauptsächliche Tätigkeit ist hier das Sichten der Noten zu Beratungszwecken. Gegebenenfalls können Noten und Bemerkungen von erkrankten Lehrkräften nachgetragen werden.
