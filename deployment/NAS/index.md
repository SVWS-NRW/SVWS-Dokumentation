# Installation auf modernen NAS-Systemen

## Aktivierung des SSD-Caches

Wenn vorhanden, dann sollten SSDs mit dem internen Cache verwendet werden.
Dadurch werden Datenbankzugriffe deutlich beschleunigt.

Dazu im Speichermanager die SSD zu einem Raid1-Cache aktivieren.

Achtung! Schreib-/Lese-Cache kann bei Strom- oder Netzwerkausfall zu Datenverlust führen.

## Installation benötigter Pakete

+ mariaDB
+ phpmyadmin (webstation, php8.0)
+ VirtualMaschine-Manager


## MariaDB konfigurieren

In der Einstellung des MariaDB-Pakets TCP freigeben.

![MariaDB.png](./graphics/MariaDB.png)

PHPmyAdmin aufrufen und den User root mit identischen Rechten duplizieren (Beispiel remote) aber mit Zugriff host=%.

![phpMyAdmin.png](./graphics/phpMyAdmin.png)

## VirtualMaschine-Manager

Zunächst muss auf der NAS noch das Paket virtualMaschine Manager installiert werden. 
Im VM-Manager dann eine Debian-ISO-Image oder ein Ubuntu-Live-Server-Image herunterladen und eine VM mit dem gewünschten Image installieren:

+ Die Grafikkarte von vmvga auf vga einstellen
+ S-ATA-Treiber bei der Verwendung der Festplatte einstellen.
+ Einstellung mit UEFI Bios booten. 

Hier wurden beispielsweise zwei CPUs mit 8 GByte RAM gewählt.


## Installation des SVWS-Server mit dem Linux-installieren

Mit wget das [aktuellen install-x.x.x.sh](https://github.com/SVWS-NRW/SVWS-Server/releases/latest) von Github laden.


``` bash
    wget https://github.com/SVWS-NRW/SVWS-Server/releases/latest
    chmod +x install-x.x.x.sh
    ./install-x-x-x.sh
```

Dabei die Installationsschritte, wie unter [Linux-Installer](../Linux-Installer/) beachten. Der Aufruf des AdminClients ist nun möglich. Darin kann eine [Migration](../Datenmigration/) oder ein [Backup](../Datensicherung/) durchgeführt werden.

## Schild-NRW 3 Freigabe

Einen neuen Netzwerkfreigabe-Ordner anlegen. 

Darin zwei Unterordner für Schild-NRW3 und das SVWS-Arbeitsverzeichnis anlegen.

![Schild3-Ordner1.png](./graphics/Schild3-Ordner1.png)

Das Schild-NRW3-ZIP-Paket herunterladen und im Schild-NRW3-Ordner entpacken.
Dort eine Admin.ini als Textdatei anlegen und bei GroupDir= die Url zum Arbeitsverzeichis eintragen.

![Schild3-Ordner2.png](./graphics/Schild3-Ordner2.png)

+ Im SVWS-Arbeitsverzeichnis einen Ordner Connection-Files und einen Ordner Schild-Reports anlegen.

+ Die [Basisreportsammlung](https://github.com/SVWS-NRW/Schild-NRW-Reports/releases) herunterladen und im Report-Ordner entpacken.

+ Im Ordner Schild-NRW3 das Programm Schild_DBConfig.exe starten und die CON-Datei nach Eintragung aller Parameter in den Ordner Connection-Files speichern. Vlg. hierzu auch [Schild-NRW3](../Schild-NRW3/)


