# SVWS-Tools

Der SVWS-Server kann neben dem SVWS-Client weitere Web-Anwendungen ausliefern, die **SVWS-Tools**. Das sind einfache HTML/TypeScript-Anwendungen (z. B. SVWS-Konferenz, SVWS-Prognos oder SVWS-WebLupo). Sie werden direkt über den Webserver des SVWS-Servers bereitgestellt, also ohne eigenen Webserver und unter derselben Adresse wie der SVWS-Server.

Nach der Einrichtung sind die Tools so erreichbar:

```
https://Mein_SVWS-Server:8443/app/<toolname>
```

Unter `/app/start` gibt es eine Startseite, die alle installierten Tools verlinkt.

::: tip Kurz gesagt
1. Paket herunterladen
2. In ein Apps-Verzeichnis entpacken
3. Das Verzeichnis in der `svwsconfig.json` als `"AppsPath"` eintragen
4. SVWS-Server neu starten
:::

---

## Installationsanleitung

### Paket herunterladen

[svws-tools-1.5.1.zip](https://github.com/SVWS-NRW/SVWS-Tools/releases/download/v1.5.1/svws-tools-1.5.1.zip) von [GitHub SVWS-Tools](https://github.com/SVWS-NRW/SVWS-Tools/releases). Prüfen Sie dort, ob es eine neuere Version gibt.

### Entpacken

   - unter Windows nach `C:\ProgramData\SVWS-Server\apps`
   - unter Linux nach `/opt/app/svws/apps`

### `svwsconfig.json` anpassen


Alle Einstellungen der Datei `svwsconfig.json` sind unter [Einrichtung](../Einrichtung/) ausführlich beschrieben.

Für die SVWS-Tools brauchen Sie nur den Eintrag `"AppsPath"`. Er gibt das Verzeichnis an, in dem die Tools liegen:

Unter Linux: 

```json
"AppsPath": "/opt/app/svws/apps/"
```

Unter Windows: 
```json
"AppsPath": "C:\\ProgramData\\SVWS-Server/apps"
```

::: warning Pfade unter Windows
Verwenden Sie in der JSON-Datei doppelte Backslashes (`C:\\...`).  
Ein einfacher Backslash ist in JSON ungültig.
:::

### Aufrufen der Tools

**SVWS-Server neu starten**

Unter Linux:   
z. B. mit `systemctl restart svws`.

Unter Windows:   
z.B. unter Task-Manager -> Dienste -> Dienstname: svws_server_service -> rechte Maustaste & neu starten

**Testen** 

::: warning Startseite der Tools:
`https://Mein_SVWS-Server:8443/app/start`
:::


## Startseite anpassen

Die Startseite unter `https://Mein_SVWS-Server:8443/app/start` verlinkt alle installierten Tools. Sie können dort auch weitere Ziele verlinken, z. B.:

- SVWS-Client
- SVWS-Adminclient
- SVWS-SwaggerUI
- externe Anwendungen wie SVWS-WeNoM

Im entpackten Paket liegen zwei Dateien, mit denen Sie die Installation anpassen können:

| Datei | Zweck |
|---|---|
| `versions.json` | Versionsangaben der enthaltenen Tools |
| `start/sichtbarkeit.example.js` | Legt fest, welche Tools die Startseite anzeigt (Vorlage) Bei Verwendung bitte im Ordner eine Kopie `sichtbarkeit.js` angelen und hier die Einstellungen angeben. |

Prüfen Sie beide Dateien und passen Sie sie bei Bedarf an.


-> [Beispiel: weitere Seiten einfügen](#ein-einzelnes-tool-manuell-einrichten)

---

## Installation unter Docker

::: info Stand der Planung
Mit Version 1.6 sollen die SVWS-Tools zusammen mit dem SVWS-Server ausgerollt werden. Wie das unter Docker genau umgesetzt wird, ist noch in Planung. Bis dahin können Sie die Tools wie hier beschrieben selbst einbinden.
:::

Die folgenden Schritte gehen von einer Installation mit Docker Compose aus. Sie arbeiten im Verzeichnis mit der `docker-compose.yml`.

### 1. Container stoppen

```bash
docker compose down
```

### 2. Volume für die Apps ergänzen

```bash
nano docker-compose.yml
```

Ergänzen Sie beim Service `svws-server` unter `volumes:` die zweite Zeile für das App-Verzeichnis:

```yaml
    volumes:
      - ./volume/svws:/opt/app/svws/conf
      - ./volume/apps:/opt/app/svws/apps
```

::: warning Wichtig
Der Apps-Ordner gehört nach `volume/apps`, **nicht** nach `volume/svws/apps`. Das Verzeichnis `volume/svws` ist bereits als `conf` eingebunden.
:::

### 3. Apps-Ordner anlegen und SVWS-Tools herunterladen

```bash
mkdir volume/apps
cd volume/apps
wget https://github.com/SVWS-NRW/SVWS-Tools/releases/download/v1.5.1/svws-tools-1.5.1.zip
unzip svws-tools-1.5.1.zip
rm svws-tools-1.5.1.zip   # optional
```

### 4. Tools konfigurieren

```bash
nano versions.json
nano start/sichtbarkeit.example.js
```

Siehe [Das Tool-Paket konfigurieren](#das-tool-paket-konfigurieren).

### 5. SVWS-Konfiguration anpassen

```bash
cd ../..
nano volume/svws/svwsconfig.json
```

Tragen Sie den Pfad **innerhalb des Containers** ein:

```json
"AppsPath": "/opt/app/svws/apps"
```

### 6. Container wieder starten

```bash
docker compose up -d
```

Die Logs sehen Sie mit `docker compose logs -f svws-server`.

### 7. Aufrufen

Öffnen Sie im Browser `https://<Server-IP>:8443/app/start`. Die IP-Adresse des Servers finden Sie mit `ip a`.



## Ein einzelnes Tool manuell einrichten

Sie können statt des Gesamtpakets auch einzelne Tools einbinden bzw. ergänzen, hier am Beispiel **SVWS-Konferenz**:

1. Legen Sie unterhalb des `AppsPath` den Ordner `konferenz` an, z. B. `/opt/app/svws/apps/konferenz`.
2. Laden Sie das Paket [SVWS-Konferenz](https://svws.nrw.de/svws-tools/svws-konferenz) herunter und entpacken Sie es so in diesen Ordner, dass die `index.html` direkt darin liegt:
   ```
   /opt/app/svws/apps/konferenz/index.html
   ```
3. Starten Sie den SVWS-Server neu: `systemctl restart svws`
4. Testen Sie den Aufruf:
   ```
   https://Mein_SVWS-Server:8443/app/konferenz
   ```

Dies kann mit jeder beliebigen html Seite gemacht werden.

## Beispiel: Eigene VitePress-Projekte einbinden

Auf dieselbe Weise lassen sich weitere einfache HTML/TypeScript-Projekte in den SVWS-Server einbinden. Das Vorgehen wird hier an den **Schulungsunterlagen** gezeigt. Es funktioniert genauso für eine lokale SVWS-Dokumentation oder andere VitePress-Projekte.

**1. Projekt holen und Abhängigkeiten installieren**

```bash
git clone https://github.com/SVWS-NRW/Schulungsunterlagen
cd Schulungsunterlagen
npm i
```

**2. Basispfad anpassen**

Damit die Seite später unter `https://Mein_SVWS-Server:8443/app/schulung` erreichbar ist, ändern Sie in `.vitepress/config.ts` den Eintrag `base`:

```ts
// vorher
base: env.BASE === undefined ? '/Schulungsunterlagen/' : env.BASE,
// nachher
base: env.BASE === undefined ? '/app/schulung/' : env.BASE,
```

Der Ordnername unter dem `AppsPath` muss mit dem Pfad hinter `/app/` übereinstimmen.

**3. Bauen, kopieren, neu starten**

```bash
npm run build
mkdir -p /opt/app/svws/apps/schulung
cp -r .vitepress/dist/* /opt/app/svws/apps/schulung/
systemctl restart svws
```

## Fehlerquellen

### `app` und `AppsPath`
Im Browser lautet der Pfad `/app/...` (**ohne** „s“). In der `svwsconfig.json` heißt der Eintrag dagegen `"AppsPath"` (**mit** „s“). Diese Abweichung führt leicht zu Tippfehlern.

### Ordnerstruktur
Der SVWS-Server erwartet unterhalb des `AppsPath` für jedes Tool **genau ein Verzeichnis**. Der Name dieses Verzeichnisses ist der Name in der URL, und die `index.html` muss direkt darin liegen, nicht in einem weiteren Unterordner.

```
/opt/app/svws/apps/
├── start/
│   └── index.html
├── konferenz/
│   └── index.html
└── schulung/
    └── index.html
```

### Neustart vergessen
Der SVWS-Server liest die `svwsconfig.json` **und** die Ordnerstruktur unter dem `AppsPath` nur beim Start ein. Starten Sie ihn deshalb neu,
- nachdem Sie die `svwsconfig.json` geändert haben und
- nachdem Sie ein neues Tool hinzugefügt haben.

### Docker: falscher Mount
Wenn die Tools unter Docker nicht erscheinen, prüfen Sie Folgendes:
- Liegt der Apps-Ordner unter `volume/apps` (nicht `volume/svws/apps`)?
- Ist er in der `docker-compose.yml` nach `/opt/app/svws/apps` gemountet?
- Steht in der `svwsconfig.json` der Container-Pfad und nicht der Pfad auf dem Host?

## Verfügbare Tools

Für den SVWS-Server gibt es inzwischen zahlreiche Tools, und die Liste wächst laufend. Eine Auswahl (ohne Anspruch auf Vollständigkeit):

- SVWS-Konferenz
- SVWS-Prognos
- SVWS-WebLupo
- SVWS-GradeHub
- SVWS-Import
- SVWS-Dokumentation
- SVWS-Schulungsunterlagen
- ...

siehe GitHub: [SVWS-Tools](https://github.com/SVWS-NRW/SVWS-Tools/releases)
