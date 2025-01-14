<!-- eslint-disable-next-line markdown/no-html -->
<script setup lang="ts">
import { data } from './build.data';

const datum = (t: number) => {
  // gibt ein Datum im deutschen Format zurück
  try {
    return new Date(t).toLocaleDateString('de', {day: '2-digit', month: '2-digit', year: 'numeric', timeZone: 'Europe/Berlin'});
  } catch (e) {
    console.log(e);
    return 'Datumsfehler';
  }
}
</script>
# SVWS Dokumentation

:::info Erstellungsdatum {{ datum(data.buildDate) }}
:::

![Logo-NRW](./graphics/wappenzeichen-nrw_farbig_rgb_300.png "Das Wappen von Nordrhein-Westfalen.")

[![Users](./graphics/LandingUser.png "Icon für Benutzer.")](./webclient/)
[![Admins](./graphics/LandingAdmin.png "Icon für Admins.")](./deployment/)
[![Devs](./graphics/LandingDev.png "Icon für Developer.")](./development/)

## SVWS-Server, SVWS-Client und weitere Projekte



Auf dieser Webseite finden Sie Dokumentationen zum *SVWS-Client* und zum *SVWS-Server*. Der **SVWS-Client** ist eine Web-Applikation zur Unterstützung der Verwaltungsprozesse an den Schulen Nordrhein-Westfalens. Er schafft eine plattformübergreifende Benutzeroberfläche, die mit allen gängigen Browsern aufgerufen werden kann.

Auf dieser Webseite finden Sie Informationen zur Installation und zur Entwicklung und eine Dokumentation der API für die dezentrale Schulverwaltung in NRW. Ebenso finden sich Dokumentationen zu weiteren Projekten.

Navigieren Sie zu den übergreifenden Bereichen dieser Webseite über die **Kopfzeile**. 

Unter dem ersten Punkt **Benutzerhandbücher** finden Sie die Dokumentationen für die **Anwender** in der Schule.

Die übrigen Punkte bieten Zugang zu technischen Informationen zu Installation, Administration und Entwicklung.

* Der SVWS-Client bietet eine Datenverwaltung für Schul-, Lehrkraft-, Schüler- und Schülerinnen- und Leistungsdaten.
* **WebLuPO** dient zur  Laufbahnberatung in der gymnasialen Oberstufe.
* Der Client unterstützt die Erstellung von **Blockungen** und **Klausurplänen** und
* die Verwaltung von **Stundenplänen**.

Das Gesamtprojekt _SVWS-Server_ ist ein Open-Source-Projekt des Landes Nordrhein-Westfalen.

Die Programme, die im Rahmen der Schulverwaltung NRW vom Ministerium für Schule und Bildung des Landes NRW zur Verfügung gestellt werden, erhalten Support durch das Fachberatersystem.

Nähere Informationen erhalten Sie hier:

https://www.svws.nrw.de/

## Datenschutzhinweis aus dem Client

Nehmen Sie den im SVWS-Client hinterlegten Datenschutzhinweis zur Kenntnis und beachten Sie den gültigen Rechtsrahmen.

Sie erreichen den Datenschutzhunweis über ````Client Info```` im **App**-Menü im Reiter Datenschutz.


## Erklärung zur Barrierefreiheit

Dieses Angebot wird momentan auf Barrierefreiheit geprüft.

Die Ergebnisse werden hier veröfffentlicht.

Stand: 27. Oktober 2024

## Impressum

Ministerium für Schule und Bildung des Landes Nordrhein-Westfalen

Völklinger Straße 49, 40221 Düsseldorf

Telefon: +49 211 5867 40

https://www.schulministerium.nrw/