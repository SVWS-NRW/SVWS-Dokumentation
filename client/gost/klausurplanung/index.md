# Klausurplanung

## HINWEIS
Es ist dringend zu empfehlen, zuvor die **Stundenplanung** der jeweiligen Jahrgangsstufe einzutragen.  
Ebenso sollte eine vollständige **Raumliste** hinterlegt sein.

## Vorgaben erstellen
Es können für beide Quartale für jedes Fach und Kursart Vorgaben der jeweiligen Klausur eingestellt werden.  
Im System ist bereits einen Standard-Vorlage eingestellt, die aufgerufen und individuell bearbeiet werden kann.  
![gost_klausurplanung_vorlage_1](.\graphics\gost_klausurplanung_vorlage_1.png)    

Zusätzliche Fächer könen mit + ergänzt werden.  
Verändert werden können diese Parameter:  
![gost_klausurplanung_vorlage_2](.\graphics\gost_klausurplanung_vorlage_2.png)  


## Vorlagen an Jahrgangsstufen zuweisen  
Mit "Vorlage importieren" kann nun für jedes Halbjahr die Vorlage importiert werden. Hier können von der Vorlage abweichende Einstellungen vorgenommen werden.  

## Klausurtermine blocken
Im Reiter "Schienen" findet sich die Auflistung der im gewählten Abschnitt anzusetzenden Klausuren. 
 ### Termin manuell setzen 
 Mit **"+ Termin"** werden Terminlagen ergänzt, Klausuren werden per Drag&Drop in die Termine gesetzt.  
 Es wird auf Kollisionen hingewiesen, wenn zwei KLausuren in einen Termin gesetzt werden, in denen Schüler gleichzeitig eine Klausur schreiben (Facharbeiten werden nicht berücksichtigt.)  

 ### Termine automatisch blocken (ist zu bevorzugen)
Die Termine können nach Schienen oder nach Fächern geblockt werden. Der Algorithmus sucht immer nach möglichst wenigen Terminen.  
![gost_klausurplanung_autoblocken](.\graphics\gost_klausurplanung_autoblocken.png)
* Klausurtermine können **alle nach Schienen** geblockt werden.  
Nach der Berechnung können einzelne Kurse in andere Schienen verschoben werden. Schülerkollisionen werden automatisch angezeigt.  

* Es ist in der Q-Phase auch möglich, diese Vorgaben **nach Grund- und Leistungskursen zu trennen**.  
So können beispielsweise zunächst die LKs schienenweise geblockt werden.  
Durch "Weiterblocken" und Ändern der Einstellung auf "GK + Fächerweise", werden dann die Grundkurse nach Fächern geblockt.  
* Es können auch **alle Kurse gemeinsam nach Fächern** geblockt werden.  

Durch Anklicken des jeweiligen Kurses wird die Liste der Klausurschreibenden angezeigt. Über den hinter den Namen stehenden Button können **Klausurversäumnisse** eingetragen werden. 

## Klausurtermine im Kalender festlegen
Im Kalender können die geblockten Termine per Drag&Drop gesetzt werden. Hierbei kann die Funktion **Jahrgangsübergreifend** genutzt werden, um bereits gesetzte Termine in anderen Jahrgangsstufen zu berücksichtigen.  
Sobald ein Termin "geschoben" wird, werden im Kalender die Stundenplanlagen der in der Klausurschiene geblockten Kurse angezeigt.  
Zu beachten ist das rechte **Hinweisfenster**: Hier werden Terminkollisionen, aber auch Warnungen bei drei und mehr Klausuren pro Woche von Schülern angezeigt.

## Räume und Startzeiten festlegen

Nach Auswahl eines der Termine (Ansicht "In Planung") wird für den ausgewählten Termin über **"+ Klausurraum anlegen"** ein oder mehrere Klausurräume angelegt.  
Jedem der angelegten Räume kann per Drag&Drop ein oder mehrere der Klausuren des ausgewählten Termins zugewiesen.  
![gost_klausurplanung_raeume_1](.\graphics\gost_klausurplanung_raeume_1.png)

## Schnellansicht Detailplan

Im **Detailplan** erfolgt eine chronologische Ansicht aller Termine. Optional kann die Ansicht für das ganze Halbjahr oder nur 1. oder 2. Quartal eingestellt werden.  
Hinweis: Eine jahrgangsübergreifende Ansicht ist hier nicht möglich.

## Fehler und Hinweise
Es werden z.B. Terminkollisionen, mehr als drei Klausurbelegungen pro Woche, fehlende Raumeinträge angezeigt.

## Drucken/Export

1. Oben rechts befinden sich verschiedene Formulare zur Darstellung der Klausurplanung.
2. Export der GPU017.txt für Untis ist geplant.

## Klausurversäumnis/Nachschreiber 

### Erfassung von Versäumnissen

#### 1. Möglichkeit: Über die Klausurplanung:  
* im Reiter **Schienen** in der Terminauswahl wird durch Anklicken der betroffenen KLausur eine Schülerliste angezeigt. 
* Hinter jedem Namen kann über den angezeigten Button das Versäumnis erfasst werden, bei Bedarf (Beachtung DSGVO) auch ein Grund eingeragen werden. 

* Bestätigung durch **"Nachschreibtermin erstellen"** übernimmt den Schüler in die Liste der Nachschreiber.  

 ![gost_klausurplanung_nt_klausurplanung](.\graphics\gost_klausurplanung_nt_klausurplanung.png)

#### 2. Möglichkeit: Über Schüler:  
* Auswahl des Schülers (linke Leiste) -> Lernabschnitte -> Klausuren 
* Die zu schreibenden Klausuren werden angezeigt, über den Button hinter der versäumten Klausur erfolgt die Erfassung.  
 
 ![gost_klausurplanung_nt_schueler](.\graphics\gost_klausurplanung_nt_schueler.png)

### Festlegung Nachschreibtermin

Unter Nachschreiber können die Schüler mit Versäumnissen Nachschreibterminen zugewiesen werden.  
Dazu wird zunächst ein Termin angelegt. Das kann
* ein neu angelegter Termin sein (**+ Neuer Nachschreibtermin**)  
oder  
* einer der bestehenden Haupttermine sein (**Haupttermin zulassen**)

Sind mögliche Nachschreibtermine angelegt, können die betroffenen Schüler per Drag&Drop passenden Terminen zugewiesen werden.  
Hinweis: Nicht passende Termine (Schüler schriebt zu diesem Termin schon eine Klausur) werden unmittelbar angezeigt und können nicht ausgewählt werden. 
