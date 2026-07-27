# Linux Installer

## Debian-basierte Systeme:

Download unter: https://github.com/SVWS-NRW/SVWS-Server/releases

Dieses Skript ist für die Installation des SVWS-Servers auf einem Debian-basierten System gedacht.

Bisher getestet unter:

- Debian 12
- Debian 13
- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

## Redhat-basierte Systeme

Die Installation unter RedHat-basierten Systemen kann hier nachgelesen werden:

[Installation Redhat (RHL)](RedHat-Linux.md)

Bisher getestet unter:

- RedHat 9
- Rocky-Linux 9

## Wichtige Hinweise

- Verwendung der Skripte geschieht auf eigene Gefahr.
- Führen Sie das Skript nur auf einem Testsystem durch, bevor Sie es auf einem Produktivsystem verwenden.
- Stellen Sie sicher, dass alle Konfigurationen und Passwörter sicher gespeichert und aufbewahrt werden.
- Beachten Sie, dass das Skript eine Internetverbindung benötigt, um bestimmte Pakete herunterzuladen und zu
installieren.


## Voraussetzungen

- Ein Debian-basiertes Betriebssystem
- Zugriff mit root-Rechten

## Installation DEB

- Laden Sie das Skript auf den Zielcomputer herunter.
- Öffnen Sie die Terminalanwendung und navigieren Sie zum Verzeichnis, in dem sich das Skript befindet.
- Geben Sie den Befehl `chmod +x /install-0.x.x.sh` ein und drücken Sie die Eingabetaste, um es ausführbar zu machen.
- Geben Sie den Befehl `./install-0.x.x.sh`  zur Ausführung ein und drücken Sie die Eingabetaste.
- Folgen Sie den Anweisungen im Skript.

Nach dem Durchlauf des Skripts haben Sie einen aktiv laufenden SVWS-Server!

## Update der Linux-Installation

- Laden Sie das Skript auf den Zielcomputer herunter.
- Öffnen Sie die Terminalanwendung und navigieren Sie zum Verzeichnis, in dem sich das Skript befindet.
- Geben Sie den Befehl `chmod +x /install-0.x.x.sh` ein und drücken Sie die Eingabetaste, um es ausfürbar zu machen.
- Achten Sie darauf, dass die Datei `.env` aus der Installation neben dem Install-Skript liegt.
- Geben Sie den Befehl `./install-0.x.x.sh --update` zur Ausführung ein und drücken Sie die Eingabetaste.
- Danach sollte der SVWS-Server in der aktuellen Version laufen.

## Installationseinstellungen

Das Skript bietet verschiedene Installationsoptionen, die im Folgenden erläutert werden. Um die Installation zu vereinfachen, werden für alle Optionen sinnvolle Standardwerte vorgeschlagen. Bei Bedarf können diese jedoch individuell angepasst werden.

Die gewählten Parameter werden in der Datei .env gespeichert. Während der Installation werden die erforderlichen Werte aus dieser Datei ausgelesen. Auch bei einem Update dient sie zur Ermittlung der Installationspfade.

Existiert die Datei .env bereits, werden die Installationsoptionen nicht erneut abgefragt und die Installation startet unmittelbar. Dadurch lässt sich die Installation auch vollständig skriptgesteuert bzw. automatisiert durchführen.

Folgende Konfigurationen können vorgenommen werden:

- MariaDB-Konfiguration
- Installationspfade
- Erstellung eines Keystores für TLS

Hier finden Sie einen beispielhaften Dialog:

```bash
MariaDB-Konfiguration:
Möchten Sie MariaDB installieren? (j/N): j
MARIADB_ROOT_PASSWORD (default: 'abcd1234'): abcd1234
MARIADB_DATABASE (default: 'svwsdb'): svwsdb
MARIADB_HOST (default: 'localhost'): localhost
MARIADB_USER (default: 'svwsadmin'): svwsadmin
MARIADB_PASSWORD (default: 'abcd1234'): abcd1234
Installationspfade:
APP_PATH (default: '/opt/app/svws'): /opt/app/svws
CONF_PATH (default: '/etc/app/svws/conf'): /etc/app/svws/conf
APP_PORT (default: 8443): 8443
Möchten Sie einen Keystore erstellen? (j/N): j
Keystore für TLS:
SVWS_TLS_KEYSTORE_PATH (default: '/etc/app/svws/conf/keystore'): /etc/app/svws/conf/keystore
SVWS_TLS_KEYSTORE_PASSWORD (default: 'abcd1234'): abcd1234
SVWS_TLS_KEY_ALIAS (default: ''): ''
```

Die Passwortvorschläge werden vom Skript generiert. Bitte sichern Sie unbedingt die verwendeten Passwörter. **Diese Daten werden vom Skript nicht gespeichert!**

Erläuterungen zu den einzelnen Punkten:

| Variable | Erläuterung |
|-------------|---------------|
| MARIADB_ROOT_PASSWORD | Das Datenbank Passwort der Datenbankadministratoren |
| MARIADB_DATABASE | Name der Datenbank |
| MARIADB_HOST | Bei kleinen Installationen wird die Mariadb i.d.R. auf dem lokalen System (localhost) liegen. Ggf. kann hier auch die URL zu einem separaten MariaDB-Server eingetragen werden.|
| MARIADB_USER | Benutzer mit Vollzugriff auf die o.g. Datenbank |
| MARIADB_PASSWORD | Das Datenbank Passwort für MARIADB_USER |
| APP_PATH | Installationsverzeichnis des SVWS-Servers|
| CONF_PATH | Hier finden Sie die Konfigurationsdatei des SVWS-Servers|
| APP_PORT | Auf diesem Port ist der SVWS-Server erreichbar. i.d.R. ist dies einer der höheren Ports z.B. 8443, da für diese keine root-Rechte benötigt werden. Hier muss ggf. ein Reverse-Proxy oder eine Portumleitung eingerichtet werden, wenn man eine einfache URL verwenden möchte. |
| SVWS_TLS_KEYSTORE_PATH | Der Pfad des angelegten Keystores, um dort Daten zu speichern |
| SVWS_TLS_KEY_ALIAS | Alias des zu verwendenden Keys im Keystore |

## optional: eigener Keystore mit Zertifikat

```bash
keytool -genkey -noprompt -alias alias1 -dname "CN=test, OU=test, O=test, L=test, S=test, C=test" -ext "SAN=DNS:localhost,IP:127.0.0.1,IP:10.1.0.1,DNS:meinserver,DNS:meinserver.mydomain.de" -keystore /etc/app/svws/conf/keystore -storepass test123 -keypass test123  -keyalg RSA

keytool -export -keystore /etc/app/svws/conf/keystore -alias alias1 -file ./SVWS.cer -storepass test123
```

Mit diesen Befehlen kann ein eigener Keystore mit einem Zertifikat erstellt werden. Der zweite Befehl exportiert das Zertifikat, welches dann unter den Windows-Client installiert werden kann, so dass die Warnmeldungen im Browser verschwinden.

## Portumleitung

Eine Möglichkeit den SVWS-Server unter einer "normalen" URL erreichen zu können und somit auf das Appendix der Ports verzichten zu können, wäre eine Portumleitung. Der bessere Weg, vor allem in größeren Netzwerken, wäre der Einsatz eines Reverse-Proxies.

In beiden Fällen könnte man statt zum Beispiel `https://meineServeradresse:8443/` dann unter `https://meineServeradresse/` den SVWS-Server direkt erreichen.

Umleiten des Ports 443 auf Port 8443 unter Ubuntu 22.04 mit `iptables`:

```bash
iptables -A PREROUTING -t nat -p tcp --dport 443 -j REDIRECT --to-port 8443
```

## Reverse-Proxy einrichten

Alternativ zur Portumleitung kann der nginx Webserver als Reverse-Proxy eingesetzt werden.


## UFW als Firewall einrichten

Für die Linuxmaschine im Livebetrieb empfiehlt sich eine Firewall einzurichten. Dazu ist bei vielen Distributionen die `ufw`-Firewall vorinstalliert.
