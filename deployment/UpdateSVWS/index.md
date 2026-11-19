# Update des SVWS-Servers

Die Updatemethoden sind Abhängig von der Art der Installation. Siehe dazu: 

+ [SVWS-Server Update unter Linux](../Linux-Installer/index.md#update)
+ [SVWS-Server Update unter Docker](../Docker/index.md#update)
+ [SVWS-Server Update unter Windows](../Windows-Installer/index.md#update)

::: tip SchILD-NRW 3
Denken Sie bei der Verwendung von SchILD-NRW-3 daran, auch dort auf neue Versionen zu prüfen und gegebenfalls ein Update durchzuführen.
:::
## Best Practice: Update des SVWS-Servers

Die folgende Anleitung beschreibt ein bewährtes Vorgehen für das Update eines SVWS-Servers, der unter Windows mit MariaDB in einer virtuellen Maschine (VM) läuft. Ziel ist, dass jederzeit ein sauberer Weg zurück zum vorherigen Stand besteht.

Betreuen Sie mehrere Server, arbeiten Sie die Schritte **für jeden Server einzeln und nacheinander** ab, niemals parallel.

### Vorbereitung

- Lesen Sie die Release Notes der neuen Version, insbesondere die Hinweise zur passenden SchILD-3-Version.
- Legen Sie vor dem Update fest, **ab wann zurückgerollt wird**, z. B. wenn die Schema-Migration fehlschlägt oder sich SchILD 3 nicht verbinden kann. So muss diese Entscheidung nicht unter Zeitdruck getroffen werden.
- Planen Sie das Update des SVWS-Servers **getrennt vom Windows-Betriebssystem-Update**. Führen Sie nie beides im selben Wartungsfenster durch, sonst ist im Fehlerfall nicht erkennbar, woran es lag.

### 1. Datenbank sichern

1. Erstellen Sie den MariaDB-Dump bei **laufendem** Dienst, zum Beispiel:

   ```bash
   mysqldump -u root -p --single-transaction --routines --triggers --databases <schemaname> > svws_<schemaname>_<datum>.sql
   ```

2. Legen Sie den Dump **außerhalb der VM** ab. Ein Dump, der nur auf der VM liegt, hilft nicht, wenn die VM selbst beschädigt ist.
3. Prüfen Sie kurz, ob die Datei vollständig ist: Die Dateigröße ist plausibel, und am Ende der Datei steht die Zeile `-- Dump completed`.
4. Alternativ oder zusätzlich erstellen Sie über den Admin-Client einen **SQLite-Export** des Schemas. Dieser lässt sich unabhängig von MariaDB wieder einspielen, auch auf einem anderen SVWS-Server.

### 2. Dienste stoppen und Snapshot erstellen

1. Halten Sie die Dienste `SVWS-Server` und `MariaDB` an.
2. Erstellen Sie einen Snapshot der VM.
3. Löschen Sie den Snapshot nach erfolgreicher Prüfung (siehe Schritt 4) nach einigen Tagen wieder. Lange Snapshot-Ketten kosten Performance und Speicherplatz.

### 3. Update installieren

1. Führen Sie den Windows-Installer der neuen SVWS-Server-Version aus.
2. Stellen Sie die passende SchILD-3-Version in der Freigabe für die Clients bereit.

### 4. Prüfen, ob der Server sauber läuft

Arbeiten Sie nach jedem Update dieselbe Checkliste ab:

- Der Dienst `Mariadb` läuft
- Der Dienst `SVWS-Server` läuft, und im Server-Log stehen beim Start keine Fehler oder Exceptions.
- Der Admin-Client zeigt alle Schemata auf der aktuellen Revision.
- Die Anmeldung im Web-Client funktioniert.
- SchILD 3 verbindet sich und kann einen Schülerdatensatz öffnen.
- Falls genutzt: WeNoM und andere Anbindungen funktionieren.

Schlägt ein Punkt fehl und ist das vorher festgelegte Rückroll-Kriterium erreicht, stellen Sie den Snapshot aus Schritt 2 wieder her.

### 5. Nächsten Server aktualisieren

- Beginnen Sie mit der Testinstanz bzw. dem unkritischsten Server und lassen Sie ihn möglichst einen Tag laufen, bevor der nächste Server an der Reihe ist.
- Arbeiten Sie danach die weiteren Server **der Reihe nach** mit den Schritten 1 bis 4 ab.
