# Schulver.mdb einlesen

# Export der Tabelle DBS aus Access

Schulver.mdb mit Access öffnen.

Rechte Maustaste > Exportieren > Textdatei auf die Tabelle DBS.

Speichertort wählen.

Im Export-Schema auf "erweitert" und auf UTF-8 ohne "" als Textrenner einstellen.

Feldnamen in erster Zeile mit einbeziehen!

Exportieren.

Dann einmal in LibreOffice öffnen.

Alles markieren.

Daten > Sortieren > Optionen "Bereich enthält Spaltenbeschriftungen" anhaken.

Dann nach SchulNr sortieren lassen.

Großes D in ArtDerTraegerschaft einbauen.

Spalten gueltigVon und gueltigBis am Ende anfügen.

Speichern unter:

svws-base > src/main/resources >schema.csv.schulver

Schulver_DBS.csv in das Repository kopieren.

Compare with Index > Kontrolle der Änderungen.

Build ausführen und danach einchecken.
