# SVWS-Versionen veröffentlichen
SVWS-Artefakte können entweder als Snapshots (Zwischenversionen) oder als Releases veröffentlicht werden. Zielsysteme für die Veröffentlichtung sind:

* SVWS Nexus Repository Manager: Snapshots und Releases
* GitHub Packages: Nur Releases

Die Veröffentlichung ist über gradle-Tasks automatisiert.

## Voraussetzungen

### Account zu Nexus Repository Manager anlegen
Voraussetzung für die Veröffentlichung von SNAPSHOTS-Artefakten im Nexus Repository Manager sind Zugangsdaten zu einem Nexus-Account mit Schreib-Berechtigung auf dem Ziel-Repository. Diese Zugangsdaten müssen von einem Administrator individuell eingerichtet werden.

### Zugangsdaten zu Nexus Repository Manager hinterlegen
Die gradle-Tasks zum Veröffentlichen von Artefakten benötigen Zugriff auf die Zugangsdaten zum Nexus Repository Manager. Diese müssen lokal auf demjenigen Rechner hinterlegt werden, von dem aus die Veröffentlichung gestartet wird. Hierzu werden zwei Möglichkeiten unterstützt:

#### Option gradle.properties
Erstellen einer gradle.properties-Datei im root-Projekt des SVWS mit folgenden Einträgen:

gradle.properties:
```
NEXUS_ACTOR=<Benutzername des Nexus Repository Manager Accounts>
NEXUS_TOKEN=<Passwort des Nexus Repository Manager Accounts>
```

#### Option Umgebungsvariablen
Setzen zweier Umgebungsvariablen im lokalen System:
MacOS/Linux
```
export NEXUS_ACTOR=<Benutzername des Nexus Repository Manager Accounts>
export NEXUS_TOKEN=<Passwort des Nexus Repository Manager Accounts>
```
Windows
```
NEXUS_ACTOR=<Benutzername des Nexus Repository Manager Accounts>
NEXUS_TOKEN=<Passwort des Nexus Repository Manager Accounts>
```

### Zertifikat für Signierung von JARs einrichten
Bei der Veröffentlichung von RELEASE-Versionen werden die

## Versionsnummer festlegen
Die Versionsnummer des Builds bestimmt auch die Versionsnummer für die Veröffentlichung. Die Festlegung der Versionsnummer erfolgt manuell in der Datei buildconfig.json im root-Projekt des SVWS.

Beispiel für Release-Version:
```json
{
	"project": {
		"version": "0.2.27"
	}
}
```
Beispiel für Snapshot-Version:
```json
{
	"project": {
		"version": "0.2.27-SNAPSHOT"
	}
}
```

## SNAPSHOT-Versionen veröffentlichen
1. Versionsnummer festlegen. Wichtig: Versionsnummer muss das Postfix "-SNAPSHOT" enthalten
2. gradle-Task "publishSnapshot" aufrufen
```
gradlew publishSnapshot
```
SNAPSHOT-Versionen werden im Repository 'svws-maven-snapshots' des SVWS Nexus veröffentlicht:
* https://artifactory.svws-nrw.de/repository/maven-snapshots/
## RELEASE-Versionen veröffentlichen
1. Versionsnummer festlegen. Wichtig: Versionsnummer darf keinen Postfix "-SNAPSHOT" enthalten
2. gradle-Task "publishReleaseAll" aufrufen
```
gradlew publishReleaseAll
```
Release-Versionen werden im Repository 'svws-maven-releases' des SVWS Nexus und zusätzlich in github-Packages veröffentlicht:
* https://artifactory.svws-nrw.de/repository/maven-releases/
* https://maven.pkg.github.com/SVWS-NRW/SVWS-Packages
