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

Auf dieser Webseite finden Sie Dokumentationen zum *SVWS-Client* und zum *SVWS-Sever*, zur Installation und zur Entwicklung dieser und eine Dokumentation der API für die dezentrale Schulverwaltung in NRW. Ebenso finden sich Dokumentationen zu weiteren Projekten.

Navigieren Sie zu den übergreifenden Bereichen dieser Webseite über die Kopfzeile. 

Unter dem ersten Punkt **Benuzterhandbücher** finden Sie die Dokumentationen für die **Anwender** in der Schule.

Die übrigen Punkte bieten Zugang zu technischen Informationen zu Installation, Administration und Entwicklung.

## Impressum

Ministerium für Schule und Bildung des Landes Nordrhein-Westfalen

Völklinger Straße 49, 40221 Düsseldorf

Telefon: +49 211 5867 40

## Datenschutzhinweis aus dem Client

Nehmen Sie den im SVWS-Client hinterlegten Datenschutzhinweis zur Kenntnis und beachten Sie den gültigen Rechtsrahmen.

Sie erreichen den Datenschutzhunweis über ````Client Info```` im **App**-Menü im Reiter Datenschutz.
