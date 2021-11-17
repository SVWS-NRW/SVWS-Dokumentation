
# Funktionsumfang Schild-NRW

Grundsätzlich soll das Ziel des Projekts sein, den gesamten Funktionsumfang von Schild-NRW sukzessive nachzubilden. Dabei sollen historisch bedingte Fehler und umständliche Benutzerführung abgestellt werden.
Die Umsetzung aller Funktionalitäten wird einige Zeit in Anspruch nehmen, so dass die Umsetzung modular erfolgen soll. Es werden zunächst die Grundfunktionen umgesetzt und dann nach und nach spezielle Verwaltungsaufgaben, die auch schulformspezifisch sein können.

In der Zwischenzeit dient Schild-NRW3.0 weiterhin als Schulverwaltungsprogramm.

## Schülerdatenverwaltung ##

Hier werden alle Individualdaten der Schüler verwaltet. Ziel ist es hier, die modernen Platzverhältnisse von heutigen Bildschirmen in der Browserdarstellung zu unterstützen und auszunutzen.
Es sollen Bereiche zusammengefasst und besser strukturiert werden.
Die Darstellung soll sich an die Bedürfnisse des Users anpassen und soll daher individuell skalierbar sein.
Eingabefehler sollen direkt bei der Eingabe geprüft werden. (Fehler in Emailadresse, Statistikfehler)
Grundsätzlich müssen aber alle Eingabemasken nachgebildet werden.

## Lehrerdatenverwaltung ##

Die Lehrer-Individualdaten-Verwaltung soll der der Schüler angeglichen werden und dem gleichen Konzept mit dem Container und den Gruppenprozessen folgen.
Lehrerdaten sollen so aufgeteilt werden, dass Berechtigungen nach Schulleitung und Abteilungsleitung und Sekretariat sinnvoll aufgeteilt werden können und Datenschutzregelungen eingehalten werden können.

Die Verwaltung der Unterrichtsdaten soll bei den Lehrkräften mehr Gewicht bekommen, so dass eine Übersicht über den Unterricht eines Lehrers jederzeit visualisiert werden kann und hier auch Eintragungen gemacht werden können, die sich dann auf die Schülerdaten auswirken.

## Gruppenprozesse ##

Das Prinzip der Gruppenprozesse, das es ermöglicht, Arbeiten für große Schülergruppen zu erledigen, soll erhalten bleiben und in einer Form ausgebaut werden, dass die Benutzerführung an typische Use-Cases angepasst und optimiert wird.

## Auswahl und Filterung ##

Die Filterung von Schülerdatensätzen auf bestimmte Merkmale soll erhalten bleiben und optimiert werden. Dabei soll der Filter I als Hauptwerkzeug in seiner Benutzerführung ggf. so gestaltet werden, dass andere Filter (z.B. Filter auf leere Einträge) überflüssig werden. Vereinfachung der Programm-Bedienung.

## Statistikbereitstellung ##

Alle Daten sollen statistikkonform gespeichert werden.
Notwendige Schlüsseltabellen werden in dem Datenbankschema gespeichert und müssen aktualisierbar sein.
Eine Plausibilitätsprüfung soll von IT.NRW auf diese Tabellen durchgeführt werden können.

Wünschenswert wäre es, wenn das Datenbanksystem dazu genutzt werden könnte, dass Statistiktabellen im laufenden Betrieb aktuell gehalten werden und eine Prüfung der Daten zu jeder Zeit angestoßen werden können.

Das aktuelle Schnittstellenformat von ASDPC32 muss dabei unterstützt werden.

## Reporting ##

Der gesamte Bereich der Reporting muss überführt und überarbeitet werden. Dabei sollte ein Konzept erstellt werden, wie in Zukunft mit dem gesamten Dokumentenmanagement umgegangen werden soll.
Zur Diskussion steht z.B. ob ein Reporting, in der die User selber programmieren können, so wie es momentan in Schild-NRW ist, behalten sollen. Oder ob eine Kombination von fest vorgegebenen Reports durch das MSB und eine variable Reporting für die User existieren soll.

Dieser Punkt befindet sich noch sehr stark in der Konzeptphase.

### Zeugnisdruck ###

In Anlehnung an den Punkt Reporting muss geklärt werden, wie der Zeugnisdruck standardisiert werden kann.

## Datenaustausch ##

Der flexible Datenaustausch soll weiterhin erhalten bleiben.
Dabei sind zwei unterschiedliche Grundmodi zu beachten:

1. Individueller Datenaustausch durch den User

Hier wird eine Schnittstelle benötigt, die den Text-/Excel-Export unterstützt.
Außerdem wird es wichtig sein, auch ein Import-Schema zur Verfügung zu stellen.
Die Ein- und Ausgabe soll ich an den Funktionen von Schild-NRW orientieren.
Der Benutzer soll hier in der Weiterarbeit mit anderen offenen Systemen (Office) unterstützt werden.

2. maschineller Datenaustausch

Es wird eine standardisierte Schnittstelle benötigt, die den Datenaustausch zwischen verschiedenen Systemen ermöglicht. Dabei ist eine Json-Struktur wünschenswert, die je nach benötigter Datenmenge skalierbar ist und auch den Austausch über gesicherte Services ermöglicht.
Das Design dieser Schnittstelle sollte mit anderen Anbietern diskutiert werden.

## Dokumentenverwaltung ##

Die Funktionalität Dokumente zu verwalten muss erhalten bleiben.
Dabei ist aber zu bedenken, dass ggf. moderne System angeschlossen werden können.
Wünschenswert wäre, wenn der SVWS-Server über ein active Directory eine OpenSource-Lösung ansteuern könnte.
Ein Beispiel hierfür wäre eine angeschlossene Next-Cloud, die in gesicherter Form die Ablage der Dokumente verwaltet.

## Kommunikation über E-Mail ##

Schild-NRW kommuniziert auf zwei Wegen über E-Mail.
Zum einen wird der Windows-Standard-Mail-Client aufgerufen oder
es wird über einen hinterlegten SMTP-Server gesendet.

Der SVWS-Server sollte nur noch über einen hinterlegten SMPT-Server mit benutzerspezifischen Accounts E-Mails senden.

## Abschlussberechnungen ##

Sämtliche Abschluss- und Versetzungsberechnungen müssen im SVWS-Server-Core hinterlegt werden. Dafür sollten die Services schulformspezifisch unterteilt werden.
Am Berufskolleg sollten zusätzlich die Anlagen für die Berechnungsalgorithmen unterteilt werden.

Services können dann über GET-Befehle die Leistungsdaten der Schüler im Json-Format erhalten und als POST-Befehl in den jeweiligen Abschluss-Service geben.

Auslaufende Prüfungsordnungen können so als veraltete Services erhalten bleiben. Diese müssen über die Prüfungsordnung der Schüler angesteuert werden können.

Es muss geprüft werden, ob eine Technologie zur Verfügung steht, die es erlaubt, die Berechnugen auch an den WebClient weiterreichen zu können, da die Berechnungen teilweise sehr viel Performance in Anspruch nehmen.

Diese Services sollen auch schon Schild-NRW3.0 zur Verfügung stehen.

# Skalierbarkeit #

Der SVWS-Server muss in einer Programmiersprache entwickelt werden, die ein maximale Skalierbarkeit erlaubt.
Dabei werden folgende Varianten unbedingt benötigt:

1) Einzelplatzinstallation

Es muss für den Übergang einen Windows-Installer geben, der alle benötigten Teile installiert, die Datenbank einrichtet und die Dienste unter Windows startet.
Dieser Server muss ggf. nur von einem anderen Client erreichbar sein, so das auch entsprechende Ports geöffnet werden müssen.

2) Serverinstallation in der Schule

Es muss ein Installer vorhanden sein, der es erlaubt, den SVWS-Server auf einem Windows-Server zu installieren.
Optional muss ein Datenbankserver installiert werden oder ein bestehender Datenbankserver eingebunden werden. Der Server muss auf den entsprechenden Ports für alle gewünschten Clients in der Schule erreichbar sein.
Auf gleiche Weise müssen für Linux und MacOS Installationswege bereitstehen.

3) Kommunaler Server

Für IT-Dienstleister und Kommunen müssen spezielle Installationspakte bereitstehen, die es erlauben mehrere Schulen und auf verschiedenen Betriebssystemen den SVWS-Server zu betreiben. Dieses System muss die Mandantenfähigkeit auf Datenbank- oder sogar Containerebene realisieren. Eine applikationsseitige Trennung der Daten ist hier nicht mehr erwünscht.

# Plattformübergreifende Lösung #

Der SVWS-Server muss in einer Sprache entwickelt werden, die plattformübergreifend einsetzbar ist.
Dabei ist unbedingt wünschenswert, dass die Server in der Schule und in Kommunalen Rechenzentren unter Linux betrieben werden können, damit den Schulträgern an dieser Stelle Kosten erspart bleiben können.

Auf der Clientseite muss eine Webapplikation dafür sorgen, dass unabhängig von gängigen Browsern und Endgeräte der SVWS-Client betrieben werden kann.

# OpenSource Lizenz #

Durch die Entwicklungszeit, die durchaus mehrere Jahre in Anspruch nehmen kann, ist es zwingend notwendig, dass der SVWS-Server unter einer OpenSource-Lizenz entwickelt wird.

Die aktuellen Gesellschaftlichen Entwicklungen zeigen, dass es in den kommenden Jahren eine Entwicklung geben kann, die es vorschreibt, dass Softwareprojekt, die mit öffentlichen Geldern finanziert werden auch unter quelloffenen Lizenzen verbreitet werden müssen.

Damit der SVWS-Server solche Rahmenbedingungen direkt erfüllt, sollte von dieser Strategie nicht abgewichen werden.

Das Projekt muss ein automatisiertes Testverfahren beinhalten, dass alle verwendeten Bibliotheken auf deren Kompatibilität zur verwendeten Lizenz überprüft.

Es sollte ein Fachanwalt gefunden werden, der das Mandat für diese Überprüfung übernimmt.

# IT-Grundsicherheit #

Alle Elemente des SVWS-Servers müssen die Richtlinien der IT-Sicherheit nach den IT-Grundschutz-Vorgaben des Bundesamt für Sicherheit in der Informationstechnik (BSI) erfüllen.

Danach sollten die Bausteine des Grundschutz überprüft werden und ein Gremium geschaffen werden, das den Quellcode regelmäßig prüft.

# Barriere Konzept nach BITV #

Der SVWS-Client muss die Vorgaben nach dem BITV-Konzept für barrierearme Software erfüllen und schrittweise die bisherige Software ablösen, um einen verbesserten Zugang zu den Programmen des MSB zu schaffen.

# Clean Code #

Das Befolgen eines Kodex um grundsätzlich sauberen und besser lesbaren Quellcode zu erzeugen, soll im Projekt durchgängig beachtet werden.
Es ist wünschenswert, dass Ressourcen geschaffen werden, die die Einhaltung im Projekt überwachen.
