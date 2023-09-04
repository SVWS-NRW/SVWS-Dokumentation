# **SVWS-Core**

Der SVWS-Core stellt einige Kernkomponenten zur Verfügung. Die wichtigsten Elemente sind hier die core-data-Elemente, die core-types und auch die core-abschluss-Elemente.

In den CoreTypes werden meist in Ennumerations der wichtigsten Kataloge in typisiserter Form überreicht.

Beispiel für die Statistik (gültige Konfessionen):

```
/**
 * Ein Core-Type für die für die amtliche Schulstatistik erhobenen Religionen.
 */
public enum Religion {

	/** Religion: alevitisch */
	AR(new ReligionKatalogEintrag[] {
		new ReligionKatalogEintrag(1000, "AR", "alevitisch", null, null)
	}),

	/** Religion: evangelisch */
	ER(new ReligionKatalogEintrag[] {
		new ReligionKatalogEintrag(2000, "ER", "evangelisch", null, null)
	}),
	
	....
```
	
CoreTypes werden später nach Typescript transpiliert und stehen dadurch auch im Webclient zur Verfügung.
Solche CoreTypes können am Ende auch mit Funktionen gefüllt werden, die z.B. Daten prüfen können.

In den CoreData-Elementen werden die DataTransferObjects definiert, die den Austausch zwischen Datenbank und API regeln. Auch hier kann später auf Korrektheit der Daten geprüft werden.


Ähnlich verhält es sich mit den Core-Elementen im Bereich Abschluss.
Hier werden alle Abschlussberechungen aller Schulformen gesammelt. (Work in progress!)
Diese stehen dann als Java-Klassen und nach dem Transpilieren auch in Typescript zur Verfügung.
Sie können dann im Webclient verwendet werden.
	