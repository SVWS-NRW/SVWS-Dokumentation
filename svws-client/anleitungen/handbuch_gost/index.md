# Das Große Handbuch Oberstufenkoordination

Dieses Handbuch richtet sich an Personen, die Aufgaben der Oberstufenkoordination oder Abteilungsleitungen der gymnasialen Oberstufe in NRW in Gänze oder Teilen wahrnehmen. Ebenso gibt es Jahrgangslehrkräfte, Beratungslehrer oder über Entlastungsstunden und/oder Beförderungsstellen unterstützenden Koordinatoren, die Teile dieses Handbuch hilfreich finden könnten. 

:::tip Keine Panik
Ob sich jemand erstmals einarbeitet, sich im neuen SVWS-Client orientiert oder etwas noch einmal nachschlagen möchte: Hier ist das Handbuch!

Dieses Handbuch wurde mit dem Stand des Releases Juli 2026 vom SVWS-Client und SchILD-NRW 3 erstellt.
:::

## Verwendete Programme

Die Daten werden mit dem **SVWS-Client** und **SchILD-NRW 3** verwaltet. Nutzen Sie SchILDzentral, sind die Prozesse analog.

````mermaid
flowchart BT
    id1[(SVWS-Server)] <--> s1(SVWS-Client)
    id1 <--> s2(SchILD-NRW 3<br>SchILDzentral)
````

Beide Programme greifen auf den gleichen Datenbestand zurück, der im Hintergrund vom SVWS-Server bereitgestellt wird. Sofern möglich wird der moderne SVWS-Client für die Arbeit verwendet Dazu ist SchILD 3 ein mächtiges Werkzeug, das Funktionen bereitstellt, die im SVWS-Client nicht oder noch nicht vorhanden sind. 

Für die Laufbahnplanung und Beratung kann das Tool zur "Laufbahnplanung in der Oberstufe" **SVWS-WebLuPO** genutzt werden. Zum Einsammeln von Leistungsdaten kann der **SVWS-WebNotenManager** verwendet werden.

Dieses Handbuch erläuterter die technischen Vorgänge, die im Laufe eines Schuljahres durchlaufen werden. Konsultieren für den Rechtsrahmen bitte die geltenden Vorschriften.

:::tip Verwendung des Handbuches im Browser
Um das Handbuch zu verwenden, orientieren Sie sich links am Inhaltsverzeichnis und nutzen Sie den `Zurück-Button` Ihres Browsers.
:::

## Weitere Unterstützung

Weiteren Unterstützung gibt es im
+ **Forum für Schulverwaltungssoftware zum Mitlesen und Fragenstellen**,
+ im **Wiki zu SchILD-NRW 3** und natürlich 
+ **in dieser Dokumentation**.
+ Nehmen Sie die exzellenten **ADV-Fortbildungsangebote Ihrer Bezirksregierung** zur Kenntnis (ADV steht für Allgemeine Datenverarbeitung).
+ Weiterhin können Sie immer die **Fachberatung Ihrer Schule** kontaktieren.

Alle diese Möglichkeiten können Sie über die [Webseite des MSB zu Schulverwaltungssoftware](https://svws.nrw.de) erreichen.

:::tip Fragen Sie die Fachberatung und im Forum!
Aus der Praxis hat sich der Rat ergeben: Bei Problemen ist es oft zeiteffektiv, die Hilfemöglichkeiten schnell in Anspruch zu nehmen, anstatt alleine viel Zeit drauf zu verwenden. Die Fachberatung hilft gerne!
:::

Dieses Handbuch ist nicht als rechtliche Beratung zum Beispiel aber nicht beschränkt auf die APO-GOSt zu verstehen.

## Das Schuljahr in der Übersicht

````mermaid
flowchart LR
    Anfang(Schüler anpassen<br>Wahlen und Umwahlen) ==> B(Blocken und<br>Kurse zuweisen) ==> C(Leistungsdaten einsammeln<br>Prüfen: Versetzung, FHR, Abitur)==> ZD(Zeugnisdruck)
    ZD ==> E(Versetzung EF ➜ Q1<br>Weiter in Q-Phase)
    ZD ==> NV(EF: Nichtversetzung<br>Q: Zu viele Defizite)
    NV ==Bei Wiederholung==> NSJ[Neues Schuljahr]
    E ==> NSJ
    NV ==> Abgang>Abgang vor dem Abitur]
    ZD ==Q2.2==> ABI_Z(Abiturzulassung)
    ABI_Z ==> ABI>Abiturprüfung]
````
