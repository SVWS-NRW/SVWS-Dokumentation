
# FAQ

Hier eine Sammlung häufiger im Installationsprozess gestellter Fragen. 

## SVWS-Server / Schild3
### Was bedeuten die Begriffe SVWS-Server und SchILD-NRW 3?

Der SVWS-Server ist ein in Java geschriebener Web-Server, der eine API und einen Web-Client zur Verfügung stellt.

Der SVWS-Client, mit dem sich die Inhalte über eine Weboberfläche aufrufen lassen, hat in der Version 1.0.0 ab Oktober 2024 zunächst die Funktionalitäten von Kurs42 und Lupo übernommen, da diese Programme die neue Datenbankstruktur nicht mehr unterstützen. Nach und nach wurden und werden weitere Features hinzugefügt.

Der Server muss zuerst nur von Schulformen mit gymnasialer Oberstufe genutzt werden, wenn Blockung und Klausurterminplanung gewünscht sind.

SchILD-NRW 3 ist ein in Delphi geschriebenes Programm, welches auf Windows-Systemen betrieben werden muss. Es ist eine Clientanwendung, mit der auf den SVWS-Server und dessen Daten zugeriffen wird. SchILD-NRW 3 unterstützt viele für die Schul- und Leistungsdatenverwaltung hilfreiche Funktionen.

Das Programm benötigt in einer Übergangsphase weiterhin Zugriff auf die Datenbank. Dieser Zugriff wird sukzessive auf Zugriffe über die API umgestellt.

SchILD-NRW 3 wird in den kommenden Jahren auch weiter genutzt werden müssen.

## Browserunterstützung
### Welche Browser werden vom SVWS-Web-Client unterstützt?

Der Web-Client wird mit Firefox, Chrome, Edge und Safari getestet.

## Zugriffsberechtigungen
### Wer benötigt Zugriff auf den SVWS-Server?

Alle Personen, die auch jetzt schon mit SchILD-NRW arbeiten.



## Zertifikate
### Warum wird ein selbstsigniertes Zertifikat genutzt und kann man das ändern?

Bei der Installation wird ein selbstsigniertes Zertifikat erstellt, welches in einem internen Netzwerk verwendet werden kann.

Eigene Zertifikate können in den Keystore des SVWS-Server geladen werden. Eine Anleitung dazu wird zur Verfügung gestellt.

## Reverse Proxy
### Was ist beim Betrieb hinter einem Reverse Proxy zu beachten?

Beim Betrieb eines RevereseProxyservers als Zugangsserver sind die folgenden Einstellungen empfehlenswert: 

```bash 
    client_max_body_size 100M;
    add_header 'Content-Security-Policy' 'upgrade-insecure-requests';
    proxy_set_header X-Content-Type-Options nosniff;
    proxy_set_header X-Frame-Options "SAMEORIGIN";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_http_version 1.1;
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_send_timeout 300;
```

Ggf. können die Einstellungen in der Paketgröße und den Timeouts je nach Größe der Schule und Geschwindigkeit der Internetverbindung noch angepasst werden. 

## Systemvoraussetzungen 
### Welche Systemvoraussetzungen müssen erfüllt werden?

Dies muss noch umfassender getestet werden. In einer virtuellen Testumgebung wird der SVWS-Server mit 2 Cores und 8 GB RAM betrieben.


## Serveranzahl
### Wird pro Schule ein eigener virtueller Server benötigt?

Nein. Ein Server kann so konfiguriert werden, dass er von mehreren Schulen datenschutzsicher genutzt werden kann.
Abhängig von den lokalen Gegebenheiten, kann das sinnvoll sein.

## Datenbanken
### Liegt die Datenbank auf einem seperaten Server?

Das kann individuell konfiguriert werden. Beide Varianten sind möglich.


## MariaDB-Cluster
### Was ist beim Betrieb mit einer MariaDB-Cluster zu beachten?

Bei einem MariaDB-Cluster müssen die Nodes entsprechende Rechte für das Anlegen von Triggern haben.
Das ist nicht in der Default Konfiguration der MariaDB.

Der aktivierte BINLOG führte dazu, dass der Server sich weigert, dass u.A. trigger angelegt werden.  
siehe auch: [https://dev.mysql.com/doc/refman/8.0/en/stored-programs-logging.html](https://github.com/SVWS-NRW/SVWS-Server/issues/url)

Nach Anpassen der Option in der Config  
```bash
\--log\_bin\_trust\_function\_creators=ON
```
lassen sich dann auch neuen Schemas fehlerfrei anlegen.

## Internetzugriff 
### Benötigt der SVWS-Server eine Internetverbindung?

Momentan nicht. Jedoch werden in Zukunft viele Prozesse dazu kommen, die eine Internetverbindung benötigen, etwa ein Web-Notenmanager, Schnittstellen für SchülerOnline, digitales Zeugnisse, Updates oder Ähnliches.

## Containerbetrieb

### 1. Zielsetzung des Containereinsatzes

Welcher Zweck steht im Vordergrund (z. B. Skalierung, Verfügbarkeit, Sicherheit, CI/CD, sonstiges)?

Der Containereinsatz ist optional und kann in großen Systemen eine Unterstützung zur Automatisierten Bereitstellung leisten.
Hier kann mit Hilfe von erstellten Scripten eine flexible und skalierbare Umgebung geschaffen werden.
Mit dem Einsatz von Containern kann optional auch die Trennung der Daten von Schulen untereinander verbessert werden.
Dies kann eine Alternative zu Virtuellen-Maschinen darstellen, um in großen Systemen kosteneffizienter zu arbeiten.

### 2. Verwendung sicherer Images:

Wird die im Image enthaltene Software regelmäßig auf Sicherheitsprobleme geprüft?
    
Die Images werden täglich mit Trivy auf aktuelle CVE-Sicherheitslücken geprüft.

Werden gefundene Sicherheitsprobleme behoben und dokumentiert?

Alle gemeldeten CVEs mit der Einstufung "high" und höher werden sofort behoben, wenn die Hersteller dafür eine Lösung bieten.

Ist das verwendete Basis-Image aktuell (nicht „deprecated“)?

Es wird ein aktuelles Ubuntu LTS-Image verwendet.

Wird das Basis-Image bei Aktualisierungen mit aktualisiert?

Das Basis-Image wird bei jedem Release mit den aktuellen Sicherheitspatches versorgt.

Sind die Images mit eindeutigen Versionsnummern versehen?

Die Release-Images sind mit dreistelligen Versionsnummern versehen.
Major.Minor.Patch-Update

### 3. Sichere Speicherung von Zugangsdaten:

Werden Zugangsdaten in der Anwendung gespeichert?

Benutzerzugänge mit Benutzernamen und Passwort für den SVWS-Client werden in der Datenbank gespeichert.
Zugangsdaten des Servers werden pro Schule in einer Konfigurationsdatei außerhalb der Anwendung gespeichert.
Eine optionale Speicherung in Umgebungsvariablen ist in Planung.

Ist eine Verwaltung dieser Zugangsdaten notwendig?

Eine Verwaltung der Zugangsdaten ist für das Rechtemanagement und für den Zugriff der Schild-NRW3-Anwenung erforderlich.

Wenn ja, wie sollen sie gespeichert werden?

Passwörter für Benutzerzugänge für den SVWS-Client werden in Form von BCrypt-Hashes in der Datenbank gespeichert.

### 4. Eignung für Containerbetrieb:

Ist die Anwendung für den Containerbetrieb geeignet?

Grundsätzlich ist ein Betrieb unter Containern möglich und muss vom IT-Dienstleister individuell umgesetzt werden.
Beispiele für den Betrieb unter Docker finden Sie im Bereich "Deployment".
Hier werden auch exemplarisch Docker-Compose.yml Dateien zur Verfügung gestellt, die auf den eigenen Bedarf angepasst werden müssen.

Wird nur ein Dienst pro Container betrieben?

Die Anwendung benötigt eine Java-Laufzeitumgebung und kann optional mit einem MariaDB-Service in einem Container betrieben werden.
Der Datenbank-Service ist aber optional und kann auch getrennt vom Container betrieben werden, so dass ein Betrieb mit nur einem Dienst möglich ist.

### 5. Ressourcenlimitierung pro Container:

Unterstützt die Anwendung Ressourcenlimits (CPU, RAM, Speicher, Netzbandbreite)?

API-Endpunkte für sogenannte Health-Checks sind in Planung.

Gibt es eine Dokumentation zum Verhalten der Anwendung bei Limitüberschreitungen?

Ist bisher nicht geplant.

### 6. Administrativer Fernzugriff:

Haben die Container Fernwartungszugänge?

Dies muss vom Betreiber der Container-Umgebung umgesetzt werden, wenn erforderlich.
