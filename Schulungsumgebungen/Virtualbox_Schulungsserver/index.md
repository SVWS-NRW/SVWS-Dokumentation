# Schulungsserver per Virtualbox

In diesem Szenario stehen den Schulungsteilnehmer lokal vernetzte Windowsrechner zu Verfügung. Ein Server mit mehrere virtuellen Maschinen kann in diesem Netzwerk die Verteilung der SchiLD3 Software übernehmen.

Das Szenario wurde getestet mit einem Ubuntu Mate und Virtualbox.
Die VHD Festplatt der Virtualbox Maschine kann dabei einfach unter den Dozenten ausgetauscht, gewartet und idividualisiert werden. Hier reicht in der Regel ein Stick oder die Fachberatercloud als Austauschplattform der VHD-Datei.


Um einen Schulungsserver zu erstellen, laden Sie sich z.B. die aktuelle [Ubuntu Mate](https://ubuntu-mate.org/download/) für Ihre Architektur herunter. I.d.R. ist dies die 64-Bit PCs Version. 

## Bootstick erstellen

Laden Sie sich [Ventoy](https://www.ventoy.net/en/download.html) runter und erstellen Sie einen Bootstick. (siehe auch [Installationsanleitung](https://www.ventoy.net/en/doc_start.html))
Im Ventoy Bootstick können Isos oder VHDs abgelegt werden und von diesen gebootet werden. 

Speichern Sie die .iso von Ubuntu Mate in das Hauptverzeichnis des Sticks.

## Ubuntu Mate installieren

Beim Booten des Schulungsservers muss noch sicher gestellt sein, dass die Bios Einstellungen auf Legacy Boot stehen und der Stick vom Bios erkannt wird. 

Installieren Sie Ubuntu Mate. 

## Vitualbox installieren

Installieren Sie virtualbox auf dem Schulungsserver: Bitte ein Terminal öffen (Strg + Alt + t) und die folgenden Befehle  ausführen:

```bash
sudo apt update && apt upgrade -y
sudo apt install virtualbox
```

## bestehende SVWS-Server VM einbinden

Als Fachberatung für Schulen können unter https://storage.svws-nrw.de/ oder ggf. auch über die FachberaterCloud eine fertige VM herunterladen. Diese liegt im VHD format vor und hat neben dem SVWS-Server, der Maria DB, einen Webserver mit Schulungsinformationen auch noch Schild 3 und Schild 2 in einer Dateifreigabe vorliegen.  

Entpacken Sie die virtuelle Maschine (VM) ins neue virtualbox Verzeichnis herunter, öffnen Sie virtualbox und importieren Sie die VM in virtualbox. Überprüfen Sie hier, unter "Ändern" - "Netzwerk", ob die Netzwerkschnittstelle als Netzwerkbrücke eingestellt ist. Falls Ihr Server mehrere Schnittstellen hat, müssen Sie entsprechend Ihre aktiven Schnittstelle auswählen, z.B. die Wlan-Karte. Nur so erhält auch der virtuelle Server ein aktives Netzwerk. Starten Sie den Server und lesen Sie die Informationen unter http://NAME_IHRES_SERVERS/ oder http://IP_IHRES_SERVERS/

## VM personalisieren und klonen

Sie können unter /netzlaufwerk (bzw. smb://netzlaufwerk/ unter Linux oder \\NAME_IHRES_SERVERS\netzlaufwerk\) zusätzliche Schulungsinhalte bzw. Übungsdatenbanken für Ihre Schulungsteilnehmer hinterlegen. Ebenso können Sie Ihre Übungsdatenbanken migrieren bevor Sie klonen.

Wenn Sie die Schulungsplattform nach Ihren wünschen verändert haben, können Sie unter virtualbox mit dem Klonen-Button den Schulungsserver klonen. Bitte beachten Sie dass hierbei *unbedingt*, dass neue MacAdressen generiert werden müssen und der Servername neu gesetzt werden muss. Die neue generierung der Macadressen kann im Klone-Dialog unter virtualbox ausgewählt werden. Um den Servernamen zu ändern, fahren Sie bitte *einzeln* die vituellen Machinen hoch und führen in der virtuellen Maschine als root-User das skrip ```change_servername.sh  ``` aus:

```bash
su -
bash change_servername.sh NEUER_SERVERNAME
```

## VM updaten

Um die VM auf den neusten Stand zu heben kann für die jeweiligen Komponenten ein update ausgeführt werden. loggen Sie sich mit root rechten in die VM ein und führen Sie die folgenden Befehle durch für das Update des Basissystems: 

```bash
su -
apt update && apt upgrade -y
```
Für das update des SVWS-Servers laden Sie sich das aktuelle Linux Skript unter [github.com/SVWS-NRW/SVWS-Server/releases](https://github.com/SVWS-NRW/SVWS-Server/releases) herunter unte führen Sie das update durch. Hier ein Beispiel für das update auf Version 0.7.0:

```bash 
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.7.0/install-0.7.0.sh
bash install.sh --update
```
Bitte beachten Sie, dass die in der Schulungsumgebung hinterlegte SchILD3 Version kompatibel sein muss mit dem installierten SVWS-Server. Informationen dazu finden Sie auf den Release Seiten des SVBWS-Servers, den Seiten von SchILD3 oder im Zweifel beim Start von SchILD3.  
Laden Sie die SchILD3 Dateien herunter und entpacken Sie diese in das Netzlaufwerksfolder, wo schon die vorherige Version lag: 

```bash
wget https://github.com/SVWS-NRW/Schild3-BetaTest/releases/download/v3.0.73/Setup_SchILD3_v3.0.73.zip
unzip Setup_SchILD3_v3.0.73.zip -d /netzlaufwerk/Schild3/
```

Bei SVWS-Versionen unterhalb von 0.7 muss ggf die Schulungsdatenbank noch einmal neu migriert werden. Ab 7.0 sollen bei Updateprozessen die Datenbanken automatisch mit geändert werden. Falls es hier zu problemem kommen, so melden Sie das bitte in der Community unter github. Z.B. als Issue https://github.com/SVWS-NRW/SVWS-Server/issues oder direkt per mail. 