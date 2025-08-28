# Schulbewerbung.de


## Übersicht

Das Projekt Schulbewerbung.de wurde im Rahmen der Umsetzungen von Leistungen zum Online-Zugangs-Gesetz für den digitalen Schülerwechsel ausgewählt.

Die Möglichkeit des landesweiten digitalen Schülerwechsels soll mit dem SVWS-Server und Schulbewerbung.de umgesetzt werden.

Als Austauschformat wurde *XSchule* gewählt, da es als bundesweites Format entwickelt wird und später bei anderen Prozessen auch benötigt wird.

https://doku.svws-nrw.de/projekte/xSchule/


## Schule sendet Abgängerdaten an Schulbewerbung.de

Im SVWS-Client kann ein User mit entsprechenden Zugriffsrechten die betroffenen Schüler als zu meldende Abgänger auswählen. Wurden alle Daten kontrolliert, kann eine Authentifizierung stattfinden und die Daten können gesendet werden.

## Schule empfängt Daten für neue Schulbewerbung.de
Über die **App Schule** ➜ Datenimport ➜ Schulbewerbung.de im SVWS-Webclient empfängt der berechtigte User die Daten und bekommt eine Übersichtsliste.

Der User wählt die Datensätze aus, die importiert werden sollen. Duplikate werden mit einem Warnhinweis angezeigt!

Danach werden die Schüler in den Status "Neuaufnahme" importiert.

## Schule empfängt Aufnahmebestätigung von anderer Schule über Schulbewerbung.de
Die abgebende Schule erhält von den als abgehend gemeldeten Schülerinnen und Schülern die neue Schule und einen Bestätgungsvermerk, dass die Aufnahme an der anderen Schule erfolgt ist.


## möglicher Workflow in der Schule

### Fall 1:
Je nach Schulform verlassen nach dem Jahrgang 10 die meistens noch schulplfichtigen Schülerinnen und Schüler die Schule. Diese müssen für Schulbewerbung.de im Web-Client "markiert" werden. In der **App Schule** gibt es unter Datenaustausch den Menüpunkt **Schulbewerbung.de**, den man mit entsprechender Berechtigung aufrufen kann.

Hier wird nun die Liste der Schülerinnen und Schüler zur Kontrolle angeboten. Im Hintergrund laufen nun die folgenden Prozesse ab: 

Nach entsprechender Authentifizierung werden XSchule-XMLs erstellt und an Schulbewerbung.de übergeben. Dort wird ein Merkmal gesetzt, so dass eine zweite Übermittlung erkannt werden kann. Die Schülerinnen und Schüler beziehungsweise deren Erziehungsberechtigte bekommen dann einen Zugangscode, mit dem sie ihre Daten in Schulbewerbung.de kontrollieren können und sich eine neue Schule aussuchen können. 

### Fall 2:
Ein für Schulbewerbung.de zuständige Lehrkraft mit entsprechenden Rechten meldet sich an und klickt in der App Schule auf den Reiter Datenaustausch ➜ Schulbewerbung.de.

Nach dem Klick auf den entsprechenden Button zum Abholen der Daten erscheint eine Meldung "Wir haben neue Schülerdaten für Sie!".

Danach kann man in einer Übersichtstabelle die ankommenden Schülerdaten ansehen und kontrollieren. Es werden Duplikate mit einem Warnhinweis sehr deutlich angezeigt!

Der User kann dann die gewünschten Importdaten markieren und in die Datenbank übernehmen. Diese werden mit dem Status "Neuaufnahme" in den gewünschten Container importiert. 
