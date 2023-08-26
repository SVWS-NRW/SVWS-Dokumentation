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

## SVWS-Server VHD einbinden

Laden Sie die VHD ins neue virtualbox Verzeichnis herunter, öffenen Sie virtual box und importieren Sie die virtuelle Maschine in virtualbox. Überprüfen Sie hier, unter "Ändern" - "Netzwerk", ob die Netzwerkschnittstelle als Netzwerkbrücke eingestellt ist. Falls Ihr Server mehrere Schnittstellen hat, müssen Sie entsprechend z.B. Ihren aktiven Wlan Adapter auswählen. Nur so erhällt auch der virtuelle Server ein aktives Netzwerk. 

## VHD personalisieren und klonen

Sie können nun die VHD in virtualbox starten. Unter https://SVWS-Server1/ finden Sie eine Oberfläche mit den nötigen Informationen zu den Zugängen zur virtuellen Maschine. Sie können unter /netzlaufwerk zusätzliche Inhalte bzw. Übungsdatenbanken für Ihre Schulungsteilnehmer hinterlegen. Ebenso können Sie Ihre Übungsdatenbanken migrieren bevor Sie klonen.

Nun können Sie unter virtualbox mit dem Klonen-Button den Schulungsserver klonen. Bitte beachten Sie dass hierbei neue MacAdressen generiert werden müssen und der Servername neu gesetzt werden muss. Um den Servernamen zu ändern, fahren Sie bitte einzeln die vituellen Machinen hoch und führen in der virtuellen Maschine als root-User das change_servername.sh skript aufrufen:

```bash
su -
bash change_servername.sh NEUER_SERVERNAME

```


