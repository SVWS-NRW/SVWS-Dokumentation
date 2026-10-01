# ASD-Statistik

## Die neue Statistik mit dem SVWS-Server

Der SVWS-Server befindet sich derzeit in der Entwicklung und wird auch für die Verwaltung der kommenden hauptamtlichen Schulstatistik im Bundesland NRW im Schuljahr 2027/28 verantwortlich sein. Die Schulstatistik ist ein wichtiges Instrument zur Verwaltung und Analyse von Schuldaten und ermöglicht es, die Entwicklung von Schulen im Laufe der Zeit zu verfolgen. Der SVWS-Server wird entwickelt, um die Schuldaten schnell und effizient zu verarbeiten und in vielen Fällen bereits bei der Eingabe zu prüfen, um eine hohe Datenqualität sicherzustellen. Die Schulstatistik wird nicht automatisch aktualisiert, sondern wird manuell von den zuständigen Stellen auf den neuesten Stand gebracht. Der SVWS-Server wird so konzipiert, dass er den Anforderungen der Schulstatistik entspricht und eine zuverlässige und effiziente Plattform für die Verwaltung von Schuldaten bietet.

## Datenprüfung

Um die Datenprüfung und die Bereitstellung von Schlüsselkatalogen und Kombinationskatalogen für die kommende hauptamtliche Schulstatistik im Bundesland NRW zu unterstützen, wird derzeit in Zusammenarbeit mit IT.NRW eine Javabibliothek entwickelt. Die Bibliothek übernimmt die Datenprüfung und stellt alle benötigten Schlüsselkataloge und Kombinationskataloge zur Verfügung. Die Bibliothek ist so konzipiert, dass sie in den SVWS-Server eingebunden werden kann, um eine nahtlose Integration zu gewährleisten. Die Bibliothek bietet eine zuverlässige und effiziente Möglichkeit, um sicherzustellen, dass die Daten der Schulstatistik korrekt und vollständig sind und den Anforderungen der zuständigen Stellen entsprechen. Die Zusammenarbeit mit IT.NRW gewährleistet, dass die Bibliothek auf dem neuesten Stand ist und geprüfte Kataloge auf dem aktuellen Stand enthält.

## technischer Unterbau

Im SVWS-Server-Projekt wurde ein eigenes Unterprojekt `svws-asd` geschaffen. In diesem Unterprojekt werden die Schlüsselkataloge von IT.NRW in versionierten JSON-Dateien abgespeichert. Die wiederum in die CoreTypes des SVWS-Servers geladen werden können und somit im WebClient zur Verfügung stehen.Sogenannte `Echtzeitvalidatoren` prüfen dann auf den Datenfeldern im WebClient auf Statistikfehler und geben dem Benutzer eine direkte Rückmeldung.

## Ausblick

Mit dem SVWS-Server-Release Ende Oktober 2026 wird der neue "Statistik"-Reiter mit Live-Daten eingeführt. Dieser neue Bereich gibt einen ersten Ausblick auf automatisch aufbereitete Statistik-Daten: Sowohl eine Gesamtübersicht als auch Details zu Schülern, Lehrern, Kursen und Klassen werden ad hoc für eine potentielle Statistiklieferung generiert und dargestellt. Erste im Hintergrund laufende Statistikprüfungen erzeugen Fehlermeldungen, falls aus dem Blickwinkel der Statistik Unplausibilitäten in den Daten vorliegen sollten. Beziehen sich Fehler auf Individualdaten, so werden diese "fehlerhaften" Datensätze unmittelbar angezeigt und können an Ort und Stelle korrigiert werden, wenn gewünscht. Somit kann im Laufe des Jahres immer wieder ganz unverbindlich die "Statistik-Brille" aufgesetzt werden, um zu entscheiden, ob bereits jetzt bestimmte statistisch noch unsaubere Daten nachgepflegt oder angepasst werden könnten. Diese neue Möglichkeit soll helfen, die spätere Hürde bei der echten Statistik-Lieferung möglichst klein zu halten.
