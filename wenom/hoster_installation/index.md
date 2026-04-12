# Installationen bei konkreten Hostern

In diesem Bereich finden sich Beispiele, wie der WeNoM-Servern bei spezifischen Hostern vorgenommen werden kann. Im Anschluss folgen Sie dann den Informationen für die **Schulfachliche Konfiguration des WeNoM-Servers** und des SVWS-Servers, die wieder für alle Hoster gleich sind.

::: warning Keine Hoster-Empfehlungen!
Diese Beispiele stellen keine Empfehlungen für den jeweiligen Hoster dar oder raten von anderen ab. Die hier aufgelisteten Hoster sind alphabetisch sortiert.
Bitte prüfen Sie selbst, ob der gewählte Hoster Ihren Anforderungen und Rahmenbendindungen zu Sicherheit und Datenschutz entspricht.

Ebenso kann keine Garantie für die Aktualität bezüglich von Einstellungen und UI bei den Hostern übernommen werden.
:::

## Voraussetzungen

Die Voraussetzungen für den Betrieb von WeNoM sind:

+ Sie haben einen Server im Internet, typischerweise ist dies bei einem Hoster und in vielen Fällen ist das auch schon ein konfigurierter Apache2-Webserver mit ebenfalls schon installierter php-Umgebung.
+ Sie haben einen FTP-Zugang zum Dateisystem des Webhostings. Über diesen werden die WeNoM-Dateien hochgeladen.
+ Sie benötigen eine Subdomain, typischerweise wird dies etwas sein wie wenom.meine-schuladresse.xyz
+ Sie benötigen ein Zertifikat, dies wird von vielen Hostern (mitunter kostenfrei) zur Verfügung gestellt. Das Zertifikat ist für die verschlüsselte Verbindung `https://` notwendig.

## Kurzübersicht

Entnehmen Sie den detaillierten Prozess zur Installation bitte der ausführlichen Dokumentation hier auf dieser Seite. Als kurze Orientierung gilt:
1. Es ist die Subdomain einzurichen (*wenom*.meine-beispielschule.xyz, *noten*.meine-beispielschule.xyz oder etwas Vergleichbares).
2. Verknüpfen Sie das Zertifikat mit der Subdomain.
3. Laden Sie die Dateien von WeNoM per FTP oder UI in den korrekten Ordner.
4. Setzen Sie die korrekten Ordner-Berechtigungen (und Unterordner und Dateien) für `public`und `app`zum Lesen und Schreiben:
    - `Besitzer`: `Lesen, Schreiben, Ausführen`
    - `Gruppe` und `Öffentlich`: `Lesen, ---, Ausführen`
    - Numerisch: `755`
5. Setzen Sie die Ordner-Berechtigungen für den Ordner `db` (und Unterordner und Dateien) auf 
    - `Besitzer` und `Gruppe`: `Lesen, Schreiben, Ausführen` 
    - `Öffentlich`: *NICHTS erlaubt*
    - Numerisch: `770`

Für Hoster, auf die Autoren dieser Seiten Zugriff haben, finden Sie eine bebilderte Anleitung für eben diesen Hoster.

## Installation auf dem gleichen Server wie der SVWS-Webserver

Installieren Sie WeNoM nicht auf dem gleichen Server, auf dem auch der SVWS-Server liegt. Der Grund ist, dass der SVWS-Server im Verwaltungsnetz von der Außenwelt zu isolieren ist. Installieren Sie einen Webserver darauf, öffnen Sie Risiken, die von dieser Dokumentation nicht unterstützt werden und von der abgeraten wird.

Ein derartiges Setup ist auch nicht notwendig, denn vom Verwaltungsnetz aus können Sie auf einen im Internet erreichbaren WeNoM-Server zugreifen. Weiterhin können Sie intern vom Verwaltungsnetz auch auf die App Noten im SVWS-Webserver zugreifen und diese ist bezüglich der Bediening identsich zu WeNoM.

Wollen Sie dennoch eine deratige Konfiguration aufsetzen, müssen Sie wissen was Sie tun und kontaktieren Sie ebenfalls Ihren IT-Dienstleister. Sie können die Ports des SVWS-Servers beziehungsweise des Webservers entsprechend verändern, ebenso könnten Sie einen virtuellen Server für den Webserver auf Ihrem eigentlichen Server laufen lassen. Keine derartige Konfiguration ist empfohlen oder wird supportet.