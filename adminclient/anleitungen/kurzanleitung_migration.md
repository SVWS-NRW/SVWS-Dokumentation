# Kurzanleitung Migration

Der *AdminClient* bietet eine Web-Applikation, die die Verwaltung von Datenbank-Schemata innerhalb eines grafischen Frontends ermöglicht.

Folgende Prozesse werden vom Admin-Client unterstützt:

- Anlegen von neuen (leeren) Schemata
- Löschen von Schemata
- Migration einer Schild-NRW 2-Datenbank in ein neues oder bestehendes Schema
- Erstellen eines Backups aus einem bestehenden Schema (SQLite-Format)
- Einspielen eines Backups in ein bestehendes oder ein neues Schema
- Setzen eines Schemas in die `svwsconfig.json`

Die Anmeldung am AdminClient erfolgt mit Benutzername und Passwort eines MariaDB-Benutzers.

Dabei muss nicht zwingend der Root-Benutzer genommen werden. Der Benutzer sieht die Datenbank-Schemata, auf die er entsprechende Rechte hat.

### Symbole unter der Schemaliste (nur für root)

Entsprechend der Beschreibung, die als Tooltip erscheinen, können Schemata wie o.a. erstellt, verändert oder entfernt werden.

Für diese Aktionen, die unter der Schemataliste dargestellt werden, werden grundsätzlich Datenbankserver-root-Rechte benötigt. Die Symbole zum Verwalten der Schemata an sich werden auch nur dem root-Benutzer angezeigt.

#### Migration in ein neues Schema

Hier wird automatisch ein neues Schema angelegt und mit den erforderlichen Tabellen befüllt.

Es öffnet sich ein Dialog, in dem die erforderlichen Angaben zur Migration abgefragt werden.

Es kann aus folgenden Datenbankformaten importiert werden:

- Access
- MySQL
- MariaDB
- SQL-Server (MSSQL)

**1. Access:**

**Quelldatenbank:**

Wählen Sie hier eine Schild-NRW 2 Access-Datenbank (Endung .mdb) aus. Es gibt vereinzelt noch Datenbanken im Access98-Format. Diese können nicht migriert werden. Kontaktieren Sie Ihren Fachberater!

**Zieldatenbank**

**Schema**

Name des neuen Schemas im SVWS-Server.

**Name des Schema-Datenbanknutzers**

Schema-Datenbankbenutzer in der MariaDB des SVWS-Servers. Dieser kann für jedes Schema anders gewählt werden. Somit kann man schon auf Datenbankebene verhindern, dass Schulen auf die Daten von anderen Schulen zugreifen können. Es können auch mehrere Schulen mit dem gleichen Schema-Admin etwa durch IT-Dienstleister verwaltet werden.

Wenn man einen bestehenden Schema-Datenbankbenutzer noch einmal verwenden möchte, muss natürlich das korrekte Passwort verwendet werden.

Wenn der Datenbankbenutzer noch nicht existiert, wird er vor der Migration angelegt.

**Passwort des Schema-Datenbankbenutzers**

Das Passwort des Schema-Datenbankbenutzers.

**2. Alle anderen DBMS:**

**Angabe einer Schulnummer**

Diese Funktion ist für die Migration aus *Schild-Zentral* geschaffen worden.

Durch die Angabe der Schulnummer werden nur die Daten dieser Schule in das neue Schema migriert. Der SVWS-Server unterstützt die Haltung von mehreren Schulen in einem Schema aus Datenschutzgründen nicht mehr.

**Quelldatenbank:**

**Datenbankhost**

Name oder IP-Adresse unter der der Datenbankserver erreichbar ist. (hostname:port oder IP:port)

Bei SQL-Server (MSSQL) muss das TCP-Protokoll aktiviert und freigegeben sein.

**Datenbank-Schema**

Name des Quellschemas auf dem Datenbankserver, der als Quelle dient.

**Name des Datenbankbenutzers**

Name des Benutzers auf dem Datenbankserver, der als Quelle dient.

**Passwort des Datenbankbenutzers**

Passwort des Benutzers auf dem Datenbankserver, der als Quelle dient.

**Zieldatenbank**

**Schema**

Name des neuen Schemas im SVWS-Server. Dieses Schema wird automatisch erstellt.

**Name des Datenbanknutzers**

Datenbankbenutzer in der MariaDB des SVWS-Servers. Dieser kann für jedes Schema anders gewählt werden. Somit kann man schon auf Datenbankebene verhindern, dass Schulen auf die Daten von anderen Schulen zugreifen können. Wenn man einen bestehenden Datenbankbenutzer noch einmal verwenden möchte, so muss natürlich das korrekte Passwort verwendet werden.

Wenn der Datenbankbenutzer noch nicht existiert, so wird er vor der Migration angelegt.

**Passwort des Datenbankbenutzers**

Das Passwort des Datenbankbenutzers.

#### SQLite Schema importieren

Ein aus einer anderen Datenbank erzeugtes SQLite-Backup kann hier in ein neu angelegtes Schema importiert werden.

#### Schema duplizieren

Erzeugt eine Kopie eines Schemas in einem neuen Schema. Diese Funktion soll es erleichtern, eine Testdatenbank zu erstellen, wenn z.B. komplexere Arbeiten im Vorfeld getestet werden sollen.

#### Anlegen eines neuen SVWS-Schema

Unter der Liste der Schemata kann mit dem Plus-Symbol ein neues SVWS-Schema angelegt werden.

Das Schema wird dabei automatisch mit den erforderlichen Tabellen gefüllt und in der `svwsconfig.json` registriert.

Man erhält somit eine leere Datenbank, die man mit einer Schulnummer initialisieren kann.

## Menüpunkte im rechten Fensterbereich

Diese Menüpunkte haben die gleichen Funktionen, wie die Menüpunkte unter der Schema-Liste.

Nur werden diese Funktionen immer auf das ausgewählte und bestehende Schema ausgeführt und können somit auch von anderen Benutzern außer root verwendet werden. Diese Menüpunkte sind immer verfügbar.

**In Config setzen**

Diese Funktion setzt ein bestehendes Schema in die `svwsconfig.json`, so dass dieses Schema beim nächsten Start des SVWS-Servers mit in die Auswahlliste aufgenommen wird.

::: warning Schema initialisieren
Achtung! Dieses Schema muss initialisiert werden, also die Datenbankstruktur des SVWS-Servers haben!
:::

Sollte ein Datenbankadministrator keine Rechte besitzen, Schemata anzulegen oder zu löschen, so kann dieser dann aber so angelegte, leere Schemata verwalten.
