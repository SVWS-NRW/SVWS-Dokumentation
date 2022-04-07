__Achtung, hier sind noch die Angaben für GitHub. Bitte für Gitlab anpassen.__

[Multipass](https://multipass.run) ist ein sehr einfaches Tool zur Erstellung von virtuellen Testumgebungen. Es wird die jeweilige vom Betriebssystem zur Verfügung gestellte Virtualisierungsumgebung genutzt. Für eine SVWS-Testumgebung ideal.

Je nach Betriebssystem muss multipass zumindest installiert werden, der Rest wird virtualisiert:

z.B. unter macOS (momentan nur für Intel CPU) kann man mit Hilfe von [Homebrew](https://brew.sh) so vorgehen:

```bash
brew install multipass
```

Anschließend wird die VM eingerichtet:

```bash
multipass launch -m 4GB -n alpha
multipass transfer init.sh alpha:
multipass GymAbi.mdb alpha:
multipass shell alpha
```

Hier nenne ich meine VM `alpha` und erstelle sie mit 4GB Hauptspeicher. Die Standardvorgabe von 1GB reicht nicht aus für den SVWS-Server.
anschließend übertrage ich das Init-Skript und eine Testdatenbank (hier die GymAbi.mdb) und starte ancschließend die Shell.

In der alpha vm weiter:

```bash
chmod +x init.sh
./init.sh
```

Das Skript wird als ausführbar markiert und gestartet.

Beim Durchlaufen des Skripts passieren folgende Dinge:

```bash
# siehe unten init.sh

```

Sobald das Skript durchgelaufen ist, sollte die VM den Server/Client mit vollständiger Testumgebung zur Verfügung stellen und ist auch von außen erreichbar.

Um die IP der VM festzustellen frage sie per `multipass ls` ab. Die `alpha` VM wird dann mit IP angezeigt.

Als root-Passwort für die MariaDB ist für weitere Aktionen `svwsadmin` gesetzt, für die neu erstelle Datenbank aus dem GyAbi.mdb-Import wurde der Benutzer `Admin` ohne Passwort gesetzt.

Damit das Skript erfolgreich laufen kann, muss noch ein Github-Token erstellt werden, ein Zugriff auf die Github-Repos der SVWS-NRW Organisation vorausgesetzt. Dazu in Github anmelden und dann unter der Adresse [https://github.com/settings/tokens](https://github.com/settings/tokens) einen Token mit den Voreinstellungen erstellen. Diesen Token speichern, da er nicht wieder angezeigt wird. In das oben angegebene Skript eintragen und vollständig als `init.sh` abspeichern.

Da der Server mit diesem Script automatisch gestartet wird, kann er auch über die IP erreicht werden, entweder als `https://ip_des_servers` in der `build`-Version oder anschließend, wenn man möchte, auch als `development`-Version über den Port 3000 und `http`. Zuvor sollte der client dann per `npm run dev` gestartet werden.

Theoretisch kann mit dieser VM auch gearbeitet werden, alle Voraussetzungen dafür sind gegeben. Da sich jedoch alles in der VM abspielt, ist es sinnvoll z.B. VS Code mit der Remote SSH Erweiterung zu verwenden.
