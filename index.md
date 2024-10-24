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

![Logo-NRW](./graphics/wappenzeichen-nrw_farbig_rgb_300.png)

Projekt zur Erstellung einer Schulverwaltungssoftware mit OpenAPI-Schnittstelle für die dezentrale Schulverwaltung in NRW.  


## Startseite

