# Probleme und deren Lösungen

(Noch verteilen)

Verbindungsprobleme
„Verbindung fehlgeschlagen” beim Anmelden
Mögliche Ursachen und Lösungen:

Falsche Server-URL
Prüfen Sie, ob die URL vollständig und korrekt ist (inklusive https:// und ggf. Port).
Beispiel: https://svws.meine-schule.de oder https://10.0.0.5:8443

Falsches Schema
Das Schema ist der Datenbankname Ihrer Schule auf dem SVWS-Server. Erfragen Sie den genauen Namen bei Ihrem SVWS-Administrator.

Falsches Passwort oder falscher Benutzername
Prüfen Sie Ihre Zugangsdaten. Es sind dieselben Daten wie für den SVWS-WebClient.

SVWS-Server nicht erreichbar
Prüfen Sie, ob der Server läuft und ob Sie sich im Schulnetzwerk (oder VPN) befinden.

Firewall oder Proxy
Wenn Sie die Web-Version nutzen, könnte eine Firewall oder ein Proxy die Verbindung blockieren. Wenden Sie sich an Ihre IT-Abteilung.

SSL-Zertifikatsfehler
Falls der SVWS-Server ein selbstsigniertes Zertifikat verwendet, kann die Desktop-App (Electron) die Verbindung in bestimmten Fällen ablehnen.

Lösung (Desktop-App):
Bitten Sie Ihren SVWS-Administrator, ein gültiges SSL-Zertifikat (z. B. von Let’s Encrypt) einzurichten.

Workaround (temporär, nur für Administratoren):
In manchen Schulumgebungen wird das Zertifikat zunächst im Betriebssystem als vertrauenswürdig markiert. Bitte konsultieren Sie Ihre IT-Abteilung.

Die App zeigt keine Schüler an
Wenn nach dem Verbinden keine Klassen oder Schüler erscheinen:

Prüfen Sie, ob der richtige Schuljahresabschnitt ausgewählt ist
Stellen Sie sicher, dass Ihr SVWS-Benutzer die erforderlichen Leserechte für die entsprechenden Klassen und Jahrgänge hat
Kontaktieren Sie Ihren SVWS-Administrator und bitten Sie um Überprüfung der Berechtigungen
Fragen zur Prognoseberechnung
Die Prognose erscheint falsch / unerwartet
Die Prognose wird vollständig nach APO-SI20 berechnet. Wenn Sie ein unerwartetes Ergebnis sehen:

Öffnen Sie die Manuelle Prognose und geben Sie die Noten des Schülers manuell ein
Lesen Sie das Berechnungsprotokoll — es zeigt Schritt für Schritt, warum das Ergebnis so ist
Prüfen Sie insbesondere:
Sind alle Fächer mit der richtigen Kursart (E/G) eingetragen?
Sind Fremdsprachen als FS markiert?
Ist der richtige Jahrgang ausgewählt?
Eine Erklärung der Abschlüsse und Berechnungsregeln:
→ Schulabschlüsse verstehen

Was bedeutet „LBNW” im Protokoll?
LBNW steht für „Lernbereich Naturwissenschaften” und bezieht sich auf das Fach, das in der Berechnung als naturwissenschaftliches Leitfach gewertet wird (Biologie, Chemie oder Physik). Dieses Fach ist für die MSA-Berechnung zentral.

Warum wird ein Fach im Protokoll ignoriert?
Folgende Fächer werden von der Prognoseberechnung grundsätzlich ignoriert:

Kürzel	Fach
LBAL	Lernbereichsarbeit
AT	—
AH	—
AW	—
PK	Projektkurs
Diese Fächer fließen weder in die Fächergruppen noch in die Ausgleichsberechnung ein.

WPU-Fach wird nicht erkannt
Wenn Sie Wahlpflichtunterricht eingeben, verwenden Sie bitte das Kürzel WP1 oder WP2. Die App normiert diese intern zu WPU. Alle WP-Kürzel mit Ziffer werden gleichwertig behandelt.

