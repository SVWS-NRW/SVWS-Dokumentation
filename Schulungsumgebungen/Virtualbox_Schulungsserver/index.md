# Schulungsserver mit Virtualbox

In diesem Szenario stehen den Schulungsteilnehmern lokal vernetzte Windowsrechner zu Verfügung. Ein Server mit mehreren virtuellen Maschinen kann in diesem Netzwerk die Verteilung der SchILD-NRW 3.0 Software übernehmen.

Das Szenario wurde getestet mit einem Ubuntu Mate und Virtualbox.
Die VHD Festplatte der Virtualbox Maschine kann dabei einfach unter den Dozenten ausgetauscht, gewartet und individualisiert werden. 

Um einen Schulungsserver zu erstellen, laden Sie sich z.B. die aktuelle [Ubuntu Mate](https://ubuntu-mate.org/download/) für Ihre Architektur herunter. I.d.R. ist dies die 64-Bit PCs Version. 

## Vitualbox installieren

Installieren Sie virtualbox auf dem Schulungsserver:  
Bitte ein Terminal öffnen (Strg + Alt + t) und die folgenden Befehle ausführen:

```bash
sudo apt update && apt upgrade -y
sudo apt install virtualbox
```

## SVWS-SchulungsServer als VM

Als Fachberatung für Schulen können unter https://storage.svws-nrw.de/ oder ggf. auch über die Fachberater-Cloud eine fertige VM herunterladen. Diese liegt im VHD Format vor und hat neben dem SVWS-Server, der MariaDB, auch einen Web-Server mit Schulungsinformationen. Ebenso liegt auch noch SchILD-NRW 3.0 und SchILD-NRW 2.0 in einer Dateifreigabe vor.  

Entpacken Sie die virtuelle Maschine (VM) ins neue virtualbox Verzeichnis, öffnen Sie virtualbox und importieren Sie die VM in virtualbox. Überprüfen Sie hier, unter Ändern->Netzwerk_, ob die Netzwerkschnittstelle als Netzwerkbrücke eingestellt ist. Falls Ihr Server mehrere Schnittstellen hat, müssen Sie entsprechend Ihre aktive Schnittstelle auswählen, z.B. die Wlan-Karte. Nur so erhält auch der virtuelle Server ein aktives Netzwerk. Starten Sie den Server und lesen Sie die Informationen unter http://NAME_IHRES_SERVERS/ oder http://IP_IHRES_SERVERS/

## VM selber erstellen

siehe dazu die Dokumentation des Schulungsproxmox. Ein analoges Vorgehen wird hier beschrieben:    https://doku.svws-nrw.de/Schulungsumgebungen/Proxmox_Schulungsserver/



## VM personalisieren und klonen

Sie können unter /netzlaufwerk oder der gleichnamigen Dateifreigabe zusätzliche Schulungsinhalte bzw. Übungsdatenbanken für Ihre Schulungsteilnehmer hinterlegen. Ebenso können Sie Ihre Übungsdatenbanken migrieren bevor Sie klonen.

Wenn Sie die Schulungsplattform nach Ihren Wünschen verändert haben, können Sie unter virtualbox mit dem Klonen-Button den Schulungsserver klonen. Bitte beachten Sie hierbei *unbedingt*, dass neue MAC-Adressen generiert werden müssen und der Servername neu gesetzt werden muss. Die neue Generierung der MAC-Adressen kann im Klone-Dialog unter virtualbox ausgewählt werden. Um den Servernamen zu ändern, fahren Sie bitte *einzeln* die virtuellen Machinen hoch und führen in der virtuellen Maschine als root-User das folgende Skript aus:

```bash
su -
bash change_servername.sh NEUER_SERVERNAME
```

## VM updaten

Um die VM auf den neusten Stand zu heben kann für die jeweiligen Komponenten ein update ausgeführt werden. Loggen Sie sich mit root-Rechten in die VM ein und führen Sie für das Update des Basissystems die folgenden Befehle durch : 

```bash
su -
apt update && apt upgrade -y
```
Für das Update des SVWS-Servers laden Sie sich das aktuelle Linux Skript unter [github.com/SVWS-NRW/SVWS-Server/releases](https://github.com/SVWS-NRW/SVWS-Server/releases) herunter und führen Sie das Update aus. Hier ein Beispiel für das Update auf Version 0.7.0:

```bash 
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.7.0/install-0.7.0.sh
bash install.sh --update
```
Bitte beachten Sie, dass die in der Schulungsumgebung hinterlegte SchILD-NRW 3.0 Version kompatibel sein muss mit dem installierten SVWS-Server. Informationen dazu finden Sie auf den Release Seiten des SVWS-Servers, den Seiten von SchILD-NRW 3.0 oder spätenstens beim Start von SchILD-NRW 3.0.  
Laden Sie die SchILD-NRW 3.0 Dateien herunter und entpacken Sie diese in den Netzlaufwerkordner, in dem schon die vorherige SchILD-NRW 3.0-Version lag: 

```bash
wget https://github.com/SVWS-NRW/Schild3-BetaTest/releases/download/v3.0.73/Setup_SchILD3_v3.0.73.zip
unzip Setup_SchILD3_v3.0.73.zip -d /netzlaufwerk/Schild3/
```

Bei SVWS-Versionen unterhalb von 0.7.0 muss ggf. die Schulungsdatenbank noch einmal neu migriert werden. Ab 0.7.0 sollen bei Updateprozessen die Datenbanken automatisch geändert werden, so dass eine Migration entfällt. Falls es hier zu Konflikten kommt, melden Sie das bitte in der Community z.B. als Issue unter https://github.com/SVWS-NRW/SVWS-Server/issues oder direkt per mail. 