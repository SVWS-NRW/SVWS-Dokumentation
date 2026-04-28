# Installationen bei konkreten Hostern

In diesem Bereich finden sich Beispiele, wie die Einrichtung des WeNoM-Servers bei spezifischen Hostern vorgenommen werden kann. Im Anschluss folgen Sie dann den Informationen für die **Schulfachliche Konfiguration des WeNoM-Servers** und des SVWS-Servers, die wieder für alle Hoster gleich sind.

::: warning Keine Hoster-Empfehlungen!
Diese Beispiele stellen keine Empfehlungen für den jeweiligen Hoster dar oder raten von anderen ab. Die hier aufgelisteten Hoster sind alphabetisch sortiert.

Bitte prüfen Sie selbst, ob der gewählte Hoster Ihren Anforderungen und Rahmenbendindungen zu Sicherheit und Datenschutz entspricht.

Ebenso kann keine Garantie für die Aktualität bezüglich von Einstellungen und Benutzeroberfläche bei den Hostern übernommen werden.
:::

## Voraussetzungen

Die Voraussetzungen für den Betrieb von WeNoM sind:

+ Sie haben einen Server im Internet, typischerweise ist dies bei einem Hoster und in vielen Fällen ist das auch schon ein konfigurierter Apache2-Webserver mit ebenfalls schon installierter php-Umgebung.
+ Sie haben einen sFTP-Zugang zum Dateisystem des Webhostings. Über diesen werden die WeNoM-Dateien hochgeladen.
+ Optional: Sie benötigen eine Subdomain z.B.: `wenom.meine-schuladresse.xyz`
+ Sie benötigen ein Zertifikat - oft dies wird von vielen Hostern (mitunter kostenfrei) zur Verfügung gestellt. Das Zertifikat ist für die verschlüsselte Verbindung `https://` notwendig.
