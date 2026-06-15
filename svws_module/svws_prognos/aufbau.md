Das Dashboard ist die Startseite nach dem erfolgreichen Verbinden mit dem SVWS-Server. Von hier aus erreichen Sie alle Funktionen der App.

Aufbau des Dashboards
Das Dashboard zeigt sechs Kacheln:

┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│       8         │  │       9         │  │      10         │
│  Jahrgang 8     │  │  Jahrgang 9     │  │  Jahrgang 10    │
│  Schülerprognos.│  │  Schülerprognos.│  │  Schülerprognos.│
└─────────────────┘  └─────────────────┘  └─────────────────┘

┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  ✏ Manuelle     │  │  📊 Auswertungen│  │  🏫 Schuldaten  │
│  Prognose       │  │  (folgt)        │  │  Schema: ...    │
│  JSON importier.│  │                 │  │  Server: ...    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
Jahrgangs-Kacheln (8 / 9 / 10)
Ein Klick auf eine der drei Jahrgangs-Kacheln öffnet die Schülerübersicht für diesen Jahrgang. Dort sehen Sie alle Klassen und Schülerinnen und Schüler aus Ihrem SVWS-System für den aktuellen Schuljahresabschnitt.

→ Mehr dazu: Jahrgangsprognose

Manuelle Prognose
Die Kachel „Manuelle Prognose” öffnet ein Eingabeformular, in das Sie Noten ohne Verbindung zu einem bestimmten Schüler eingeben können. Dies ist nützlich für:

Schnelle „Was-wäre-wenn”-Szenarien bei Beratungsgesprächen
Überprüfung von Notenkombinationen
Import von JSON-Testfällen
→ Mehr dazu: Manuelle Prognose

Auswertungen
Die Kachel „Auswertungen” bietet Statistiken und Übersichten über Prognosen im Jahrgang. Diese Funktion befindet sich in Entwicklung.

Schuldaten-Kachel (Info)
Die Kachel „Schuldaten” ist keine Navigation, sondern zeigt Ihnen die aktuell verbundene Instanz:

Feld	Beschreibung
Schema	Der Datenbank-Mandant (Schulname)
Server	Die URL des verbundenen SVWS-Servers
Benutzer	Ihr angemeldeter Benutzername
Abschnitt	Der aktuell gewählte Schuljahresabschnitt (z. B. „2024/25 · 2. Halbjahr”)
Hell- und Dunkelmodus
Oben rechts im Dashboard befindet sich der Theme-Umschalter. Er wechselt zwischen drei Modi:

System — übernimmt die Einstellung des Betriebssystems
Hell — heller Hintergrund
Dunkel — dunkler Hintergrund
Die Einstellung wird gespeichert und beim nächsten Start der App wiederhergestellt.

Abmelden
Über den Button „Abmelden” oben rechts trennen Sie die Verbindung zum SVWS-Server und kehren zum Verbindungsformular zurück. Alle Daten und Zugangsdaten werden aus dem Speicher gelöscht.