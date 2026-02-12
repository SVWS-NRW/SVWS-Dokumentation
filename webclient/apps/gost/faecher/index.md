## Angebotene Fächer

Unter Fächer wird als Vorlage oder individuell für jeden Jahrgang festgelegt, in welchem Abschnitt ein Fach angeboten wird und ob es als Abiturfach im GK oder LK belegbar ist.


![Beispiel für zulässige Fachwahlen](./graphics/SVWS_Oberstufe_Faecher_1.png "Alle hier gezeigten Fächer sind durch die Oberstufe belegbar, KR und ER jedoch nur als GK.")

Im Beispiel oben sind die Fächer *ER* und *KR* im gewählten *Abiturjahrgang 2025*, der im aktuellen Schuljahr der Datenbank die *Q1* ist, zwar durchgehend belegt werden, sie stehen aber nicht als LK zur Wahl.

![Beispiel für Projektkurse/Vertiefungskurse](./graphics/SVWS_Oberstufe_Faecher_1_Beispiel2.png "Im Beispiel sind Vertiefungs- und Projektkurse konfiguriert.")

Im zweiten Beispiel oben sind die *Vertiefungskurse* und *Projektkurse* zu sehen. Die Vertiefungskurse sind werden nur in der EF und der Q1 angeboten, wobei der *Vertiefungskurs Deutsch* nur in der EF belegt werden kann.

Die *Projektkurse* werden ausschließlich in der Q1.1 und der Q1.2 belegt. Hier im Beispiel wurde die Wahloption, sie von 2-stündig auf 3-stündig umzustellen von der Schule gewählt. Es wurden weiterhin *Leitfächer* zugeordnet, von denen eines zu belegen ist, damit der Projektkurs angewählt werden kann. 

## Unzulässige Kombinationen

Sind an Ihrer Schule manche Kombiniationen unzulässig, lassen sich diese unter **unzulässige Kombinationen** hinterlegen.

Es genügt, eine unzulässige Kombinationen einmal einzutragen, schließt Fach A das Fach B aus, gilt dies auch automatisch andersherum. 

Hinweis: Durch Importe wird eventuell eine Kombination doppelt eingetragen.

**Beispiel:**

```txt
KR schließt ER aus
und
ER schließt KR aus.
```

In einem solchen Fall kann eine der Eintragungen gelöscht werden.

![Oberstufe_Faecher_unzKomb_1](./graphics/SVWS_Oberstufe_Faecher_unzKomb_1.png "Hier im Beispiel schließen sich KR und ER gegenseitig aus. Ebenso werden KR und ER jeweils mit PL ausgeschlossen.") 

## Geforderte Kombinationen 

Bedingt die Wahl eines bestimmten Faches die Wahl eines anderen Faches, kann die Bedingung in der logischen Reihenfolge unter **geforderte Kombinationen** eingetragen werden.

Die Gründe für geforderte Kombinationen können eine möglichen Profilbildung, aber auch organisatorisch bedingt sein.

Zum Beispiel könnte bei einem sprachlichen Profil ein Deutsch-LK zwangsläufig an den Englisch-LK gekoppelt sein oder bei einem biochemischen Profil könnte das Belegen eines Bio-LKs erfordert auch das belegen eines Chemie-GKs.

Hier ist zu beachten, dass ein *Fach* jeweils mit einer *Kursart* anzugeben ist. Daher könnten und müssen GKs, LK, ZKs, PKs oder ähnlich getrennt verwaltet werden.

Wird die *Kursart* frei gelassen, ist die Kursart beliebig.

![Oberstufe_Faecher_gefBed_1](./graphics/SVWS_Oberstufe_Faecher_gefBed_1.png "Hier erfordert das Belegen eines Zusatzkurses in GE oder SW das belegen des jeweils anderen Faches in einer beliebigen Kursart.")

## Hinweis zur Festlegung von Kombinationen

Legen Sie nur so wenige Kombinationen fest, die gefordert beziehungsweise unzulässig sind, wie nötig.

Alle von der APO GOSt festgelegten Rahmenbedingungen sind nicht hier einzustellen, sondern sollten im System hinterlegt sein.

## Beispiele

Es wird im Bild unten eine Laufbahnwahl dargestellt, in der Fehler enthalten sind.

* *ER schließt KR aus*: Daher erhalten im Beratungsbogen beide Fächer einen Warnhinweis.

* *GE-ZK fordert SW-GK*: Daher erhält *SW* bei Wahl von *GE-ZK* einen Warnhinweis.

Anmerkung: Derzeit besteht keine Möglichkeit von **oder**-Forderungen, also beispielsweise *GE-ZK fordert SW-LK* **oder** *SW-GK*

![Oberstufe_Faecher_Bedingungen_Beispiel_1](./graphics/SVWS_Oberstufe_Faecher_Bedingungen_Beispiel_1.png "Durch rote Ausrufezeichen wird auf Fehler aufmerksam gemacht, die gegen die Kombinationseinstellungen verstoßen.")

Die **Ausrufezeichen ⓘ** machen hierbei auf Fehler aufmerksam. In diesem Beispiel wurde ein Geschichte-Zusatzkurs *ZK* belegt, ohne dass auch ein geforderter SoWi-Kurs angewählt wurde. Weiterhin wurden *KR*, *ER* und *PL* zusammen angewählt, die aber jeweils gegenseitig ausgeschlossen sind.