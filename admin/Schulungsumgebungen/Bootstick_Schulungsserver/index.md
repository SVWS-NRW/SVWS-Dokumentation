# Bootstick als Schulungsserver

Ziel ist es auf einem Bootable USB Stick einen SVWS-Server zu starten inkl. optionalen Schulungsmaterialien. Die Architektur basiert hierbei auf einem Debian Linux, das eine schmale grafische Oberfläche enthält und hierdrauf den SVWS-Server installiert hat. 

## Bootstick erstellen

Laden Sie sich [Ventoy](https://www.ventoy.net/en/download.html) runter und erstellen Sie einen Bootstick (vgl. [Installationsanleitung](https://www.ventoy.net/en/doc_start.html)).
Im Ventoy Bootstick können ISOs oder VHDs abgelegt werden und von diesen gebootet werden. 

## Erstellen eines Schulungsclients 

Mit Hilfe von Virtualbox kann eine VHD Datei erstellt werden. Dies wird unter [Schulungsserver per Virtualbox](../Virtualbox_Schulungsserver/index.md) beschrieben. Die VHD Datei findet man im Virtualbox Verzeichnis. Diese Datei ins Hauptverzeichnis des Bootsticks Kopieren.

## Starten des Schulungsclients

Stecken Sie den USB-Bootstick ein und starten Sie den Computer neu. In der Regel wird der Stick erkannt und im Bootmenue gibt es eine Auswahl, welches darauf befindliche Betriebssystem gestartet werden soll. Starten Sie den zuvor darauf kopierten  [SchulungClient](../SchulungsClient/index.md)

