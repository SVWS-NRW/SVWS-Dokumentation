# **SVWS-Core**

Im Teilprojekt SVWS-Core werden grundlegende Kern-Komponenten gebündelt. Hierbei ist zu unterscheiden zwischen Teilen, die nur im Server zur Verfügung (Java-Package `de.svws_nrw.base`, im Folgenden kurz: *Base*) stehen und welche, die von Java nach Typescript transpiliert werden und sowohl im Server (Java-Package `de.svws_nrw.core`, im Folgenden kurt: *Core*) als auch im Client zur Verfügung stehen.


## **Base**

In diesem Package ist Java-spezifischer Code enthalten, welcher nicht für eine Nutzung im Client transpiliert wird. 

Dies sind u.a.
- Hilfs-Klassen, wie z.B. `FileUtils.java`, welche in anderen Java-Teilprojekten genutzt werden, aber im Client in Typescript nicht benötigt werden.
- Implementierungen von Klassen, welche durch den Transpiler eine Schittstellen-kompatible Typescript-spezifische Implementierung erhalten und daher selbst nicht transpiliert werden müssen. Dies betrifft z.B.
	- die Implementierung der Klassen zur *Kompression* (`de.svws_nrw.base.compression`) und 
	- zur *AES-Verschlüsselung* (`de.svws_nrw.base.crypto`).


## **Core**

Der *Core* besteht aus Java-Code, welcher nach Typescript transpiliert wird und somit sowohl im Server als auch in Clients zur Verfügung steht. Er kann grob in die folgenden Kategorien unterteilt werden:
- Abstrakte Datenstrukturen (Java-Package `de.svws_nrw.core.adt`)
- Algorithmen (kurz: *Core-Algorithmen* unterschiedliche Java-Packages)
- Daten-Transfer-Objekte (kurz: *Core-DTO*, Java-Package `de.svws_nrw.core.data`)
- Typen in Form von Aufzählungen (kurz: *Core-Types*, Java-Package `de.svws_nrw.core.types`)
- Hilfs-Klassen für die Handhabung von Core-DTOs (kurz: *Core-Utils* bzw. *Core-Manager*, Java-Package `de.svws_nrw.core.utils`)


### **Abstrakte Datenstrukturen**

In diesem Package werden Projekt-spezifische, transpilierbare Klassen für Datenstrukturen zur Verfügung gestellt. Dies sind u.a.

- Lineare Datenstrukturen:
	- * LinkedCollection *: Eine einfache, unsortierte Collection, implementiert als doppelt verkettete Liste, welche keine null-Werte, jedoch Duplikate akzeptiert. Sie implementiert das Java-Interface `java.util.Collection`.
- Baumstrukturen:
	- * ArrayMap *: Eine für das Arbeiten mit Werten aus Arrays und Enumerations spezialisierte Map, welche das Java-Interface `java.util.NavigableMap` implementiert
	- * AVLMap *: Eine Implementierung des AVL-Baums als Map. Sie implementiert das Java-Interface `java.util.NavigableMap`.
	- **: Diese Klasse ist eine Implementierung eines Minimum-Heaps. Die Wurzel eines Teilbaumes enthält immer das kleinste Element des Teilbaums. Duplikate sind zugelassen. Sie implementiert das Java-Interface `java.util.Queue`
- Mengen:
	- * AVLSet *: Eine Implementierung des Java-Interfaces `java.util.NavigableSet`. Sie dient zum Speichern eindeutiger Schlüssel-Werte und delegiert alle Anfragen an die Klasse {@link AVLMap} delegiert, indem ein Mapping auf einen Dummy-Wert erfolgt. NULL-Werte sind in dem Set nicht erlaubt.
- Sonstige:
	- * HashMap2D *: Eine Klasse, welche die Zuordnung eines Wertes zu zwei Schlüsselwerten erlaubt. Intern arbeitet die Datenstruktur mit geschachtelten Hash-Maps (siehe auch: `java.util.HashMap`)
	- * HashMap3D *: Eine Klasse, welche die Zuordnung eines Wertes zu drei Schlüsselwerten erlaubt. Intern arbeitet die Datenstruktur mit geschachtelten Hash-Maps (siehe auch: `java.util.HashMap`)


### **Core-Algorithmen**

Es werden zahlreiche - auch komplexere - Algorithmen zu schulfachlichen Aspekten zur Verfügung gestellt. Dies betrifft u.a.
- Abschluss-Algorithmen
- Belegprüfungs-Algorithmen
- Blockungs-Algorithmen
	- zur Blockung von Kursen in Schienen
	- zur Blockung von Klausurterminen
- Stundenplan-Algorithmen


### **Core-DTOs**

Die *Core-DTOs* sind grundlegende Datenobjekte für den Transfer von Daten. Sie werden auch in anderen Teilprojekten des SVWS-Serves verwendet. Sie dienen u.a.
- der Nutzung in Core-Algorithmen
- werden mit Daten aus einem SVWS-Datenbankschema befüllt (Teilprojekt SVWS-DB-Utils)
- dem Austausch von Daten über die Open-API-Schnittstelle des Servers (Teilprojekt SVWS-OpenApi)

Wichtig: *Core-DTOs* enthalten selber keinen Code und dienen nur dem Austausch von Daten. Zugehöriger Code ist oft in den *Core-Util-* und *Core-Manager-Klassen*, aber auch in den *Core-Types*, zu finden.

Beispiele für Core-DTOs:
- SchuelerListeEintrag: Informationen zu einem Schüler zugeschnitten auf die Verwendung in Listen
- SchuelerStammdaten: Informationen zu den Stammdaten eines Schülers, welche Detailinformationen zu dem Schüler darstellen, die nur in speziellen Fällen benötigt werden
- Sprachbelegung: Informationen zu der Belegung von Fremdsprachen eines Schülers
- SchulabschlussAllgemeinbildendKatalogEintrag: Information zu einer Art eines allgemeinbildenden Schulabschlusses, welcher in der amtlichen Schulstatistik verwendet wird. (hier wird in **generischer** Form die Struktur von Informationen zu allgemeinbildenden Schulabschlüssen festgelegt)


### **Core-Types**

Während in den *Core-DTOs* die Struktur von Informationen zum Schulsystem festgelegt wird, stellen die *Core-Types* als Aufzählungen die konkreten, typisierten und damit **speziellen** Informationen zum Schulsystem dar.
Diese typisierte Information ist insbesondere für die *Core-Algorithmen* von Interesse. Diese bilden z.B. Prüfungsordnungen ab, die sich auf die einzelnen Aufzählungswerte beziehen. So haben u.a. die Fächer Deutsch und Mathematik oft eine besondere Bedeutung für die Belegprüfung oder die Abschlussberechnung, wodurch diese im Algorithmus konkret verwendet werden müssen. Einfache Überprüfungen/Validierungen können direkt im Code des *Core-Type* umgesetzt werden.

*Core-Types* legen den Katalog von gültigen Aufzählungswerten zu den einzelnen Aufzählungen fest. Neben der reinen Aufzählung beinhalten sie auch
Code, welche u.a. den Bezug zu *Core-DTOs* herstellen oder auch Zusammenhänge zwischen *Core-Types* abbilden.

Ein Beispiel für einen einfachen *Core-Type* ist das Geschlecht:

``` Java
/**
 * Der Core-Type für die in der Statistik zulässigen Arten des Geschlechts.
 */
public enum Geschlecht {

	/** Männlich mit Statistikcode 3 */
	M(3, "m", "männlich", "männlich"),

	/** weiblich mit Statistikcode 4 */
	W(4, "w", "weiblich", "weiblich"),

	/** divers mit Statistikcode 5 */
	D(5, "d", "divers", "divers"),

	/** ohne Angabe mit Statistikcode 6 */
	X(6, "x", "ohne Angabe", "ohne Angabe im Geburtenregister");

...

```

Die Verknüpfung der "speziellen" Informationen der *Core-Types* mit den "generischen" Informationen der *Core-DTOs* erfolgt oft im Code der *Core-Types*. Die ist insbesondere für die "allgemeine" Schulstatistik von Interesse, da hier die Typsisierung von untergeordnetem Interesse ist und allgemeine Zuordnungsinformationen daraus mit eingeschränktem Aufwand generiert werden können. Diese Verknüpfung kann durch Festlegung im Java-Code bei der Aufzählung erfolgen. Ein Einlesen der Daten z.B. aus JSON-Dateien ist prinzipiell auch möglich, derzeit aber noch nicht umgesetzt. 

Im Folgenden ein Beispiel für die Verknüpfung bei den allgemeinbildenden Schulabschlüssen. Im Programmcode kann hier typisiert auf den Schulabschluss `SchulabschlussAllgemeinbildend.HA9` zugegriffen werden. Diese Bezeichnung ist Programm-intern und muss nicht zwingend angepasst werden, wenn die Berechnung des Abschlusses gleich bleibt, sich aber nur die Bezeichnung des Abschlusses ändert. In diesem Beispiel wurde die Bezeichnung "Hauptschulabschluss nach Klasse 9" bis zum Schuljahr 2021/2022 verwendet und dann ab dem Schuljahr 2022/23 die Bezeichnung "Erster Schulabschluss". Diese Umbenennung mit der Zuordnung zu den Schuljahren findet sich in den zugeordneten Objekten des *Core-DTO* vom Typ `SchulabschlussAllgemeinbildendKatalogEintrag` wieder.

```
/**
 * Ein Core-Type für die Arten von allgemeinbildenden Schulabschlüssen.
 */
public enum SchulabschlussAllgemeinbildend {

	/** Es liegt kein Abschluss vor */
	OA(new SchulabschlussAllgemeinbildendKatalogEintrag[] {
		new SchulabschlussAllgemeinbildendKatalogEintrag(0, "OA", "Ohne Abschluss", "A", null, null)
	}),

	/** Hauptschulabschluss nach Klasse 9 (ohne Berechtigung zum Besuch der Klasse 10 Typ B) */
	HA9A(new SchulabschlussAllgemeinbildendKatalogEintrag[] {
		new SchulabschlussAllgemeinbildendKatalogEintrag(1000, "HA9A", "Hauptschulabschluss nach Klasse 9 (ohne Berechtigung zum Besuch der Klasse 10 Typ B)", "B", null, 2021),
        new SchulabschlussAllgemeinbildendKatalogEintrag(1001, "ESAA", "Erster Schulabschluss (ohne Berechtigung zum Besuch der Klasse 10 Typ B)", "B", 2022, null)
	}),

	/** Hauptschulabschluss nach Klasse 9 (mit Berechtigung zum Besuch der Klasse 10 Typ B) */
	HA9(new SchulabschlussAllgemeinbildendKatalogEintrag[] {
		new SchulabschlussAllgemeinbildendKatalogEintrag(2000, "HA9", "Hauptschulabschluss nach Klasse 9 (mit Berechtigung zum Besuch der Klasse 10 Typ B)", "C", null, 2021),
        new SchulabschlussAllgemeinbildendKatalogEintrag(2001, "ESA", "Erster Schulabschluss (mit Berechtigung zum Besuch der Klasse 10 Typ B)", "C", 2022, null)
	}),
	
	....
```
	

### **Core-Utils**  und **Core-Manager**

Das Java-Package `de.svws_nrw.core.utils` stellt im Wesentlichen zwei Arten von Klassen zur Verfügung: Die *Core-Utils* und die *Core-Manager*. 

Die *Core-Utils* sind eine Sammlung von statischen Hilfs-Methoden, welche an anderen Stellen wiederverwendet werden können. Oft werden dabei *Core-DTOs* und *Core-Types* verwendet.

Die *Core-Manager* sind meist komplexere Klassen, die den Umgang mit größeren Datenmengen in einem Kontext "managen" sollen. Ein Beispiel hierfür ist der Stundenplan-Manager, welche mit den Daten eines Stundenplans (siehe *Core-DTO* StundenplanKomplett) initialisiert wird und anschließend der Handhabung des Stundenplans in der Anwendung dient. Hierbei stellt er 
- optimierte Zugriffmöglichkeiten auf die einzelnen Daten des Stundeplans zur Verfügung und 
- ermöglicht auch die Manipulation des Stundenplans im Manager 
- (eine Kommunikation der Daten zur Datenbank des SVWS-Server ist nicht Aufgabe des Manager und wird an anderer Stelle getrennt gehandhabt).

Andere *Core-Manager* arbeiten nach einem ähnlichen Prinzip.

