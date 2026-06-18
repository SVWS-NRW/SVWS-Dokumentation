# Installationen bei konkreten Hostern

In diesem Bereich finden sich Beispiele, wie die Einrichtung des WeNoM-Servers bei spezifischen Hostern vorgenommen werden kann. Im Anschluss folgen Sie dann den Informationen für die **Schulfachliche Konfiguration des WeNoM-Servers** und des SVWS-Servers, die wieder für alle Hoster gleich sind.

::: warning Keine Hoster-Empfehlungen!

Die folgenden Beispiele stellen weder Empfehlungen für bestimmte Hoster dar noch sprechen sie gegen andere Anbieter. Die aufgelisteten Hoster sind ausschließlich alphabetisch sortiert.

Bitte prüfen Sie eigenständig, ob ein gewählter Hoster Ihre Anforderungen sowie die geltenden Rahmenbedingungen hinsichtlich Sicherheit und Datenschutz erfüllt.

Für die Aktualität der dargestellten Einstellungen, Abläufe und Benutzeroberflächen der Hoster kann keine Gewähr übernommen werden.

:::

## Voraussetzungen
Die Voraussetzungen für den Betrieb von WeNoM sind:

+ Sie verfügen über einen Server im Internet. Typischerweise handelt es sich dabei um ein Hosting-Angebot bei einem Hoster. In vielen Fällen steht dort bereits ein vorkonfigurierter Apache2-Webserver inklusive installierter PHP-Umgebung zur Verfügung.
+ Sie besitzen einen sFTP-Zugang zum Dateisystem des Webhostings. Über diesen werden die WeNoM-Dateien auf den Server übertragen.
Optional: Sie verwenden eine eigene Subdomain, z. B. wenom.meine-schuladresse.xyz.
+ Sie benötigen ein SSL-/TLS-Zertifikat für die verschlüsselte Verbindung über https://. Viele Hoster stellen entsprechende Zertifikate kostenfrei zur Verfügung.