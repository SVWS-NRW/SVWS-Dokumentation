# Tailwind 4
Tailwind CSS 4 ist ein modernes CSS-Framework, das mit einem konsequenten Utility-First-Ansatz schnelle und flexible Gestaltung von Webanwendungen ermöglicht. Es bringt Verbesserungen wie native CSS-Variablen für Farben und Spacing sowie eine optimierte Performance ohne notwendige Konfiguration. In SVWS setzen wir Tailwind 4 ein, um einheitliche, flexible und wartbare Styles effizient umzusetzen. \
Durch die Umstellung auf Tailwind 4 haben sich einige Neuerungen im Umgang mit dem Framework ergeben, die bereits in den Projekten ausgerollt wurden. Damit auch zukünftig die Arbeit mit dem Framework funktioniert, gibt es ein paar Regeln, die beachtet werden müssen. Diese werden im Folgenden aufgelistet und erklärt.

## Implementierung von Tailwind 4 im Projekt
Durch die Umstellung auf Tailwind 4 haben sich einige Neuerungen im Umgang mit dem Framework ergeben, die bereits in den Projekten ausgerollt wurden. So gibt es zum Beispiel keine `tailwind.config.ts`-Datei mehr, sondern es werden direkt Utility Klassen in CSS Dateien definiert. \
Alle CSS Dateien werden in der Datei `ui\src\assets\styles\index.css` importiert. Diese Datei dient als zentrale CSS-Datei. Weitere Utility-Klassen wurden in unterschiedlichen CSS-Dateien definiert.
* `ui\src\assets\styles\colors.css` enthält alle CSS-Variablen, die sich auf Farben beziehen. Diese wiederum nutzen Palettenfarben, die in `ui\src\assets\styles\palette.css` definiert sind. Die Farben in `colors.css` sind dabei jeweils für das light- und das dark-Theme definiert. Es wird automatisiert die Farbe geladen, je nachdem welches Theme geladen ist. Klassen wie `bg-ui dark:bg-ui-neutral` o.Ä. sind nicht mehr erforderlich.
* `ui\src\assets\styles\borders.css` enthält Utility-Klassen, die sich auf Borders beziehen.
* `ui\src\assets\styles\dimensions.css` enthält Utility-Klassen, die sich auf Dimensionen beziehen, zum Beispiel die Größen von Modalen.
* `ui\src\assets\styles\fonts.css` enthält alle Utility-Klassen, die sich auf Schriften beziehen.
* `ui\src\assets\styles\icons.css` enthält alle Utility-Klassen, die sich auf Icons beziehen wie Icon-Größen oder alle definierten Icons von [Remix Icon](https://remixicon.com/).
* `ui\src\assets\styles\screens.css` enthält Utility-Klassen, die sich auf Breakpoints von Screengrößen beziehen.

## Regeln zur Verwendung von Tailwind Klassen
### 1. Tailwind-Klassen direkt am Element verwenden
Tailwind-Utility-Klassen sollen direkt an HTML-Elemente geschrieben werden. Eine Auslagerung in eigene CSS-Klassen soll nur dann erfolgen, wenn diese Klasse global zur Verfügung stehen soll oder mehrfach verwendet wird.

**Erklärung:**  
Direktes Anwenden der Klassen erhöht Lesbarkeit, reduziert Komplexität und nutzt den Utility-First-Ansatz von Tailwind konsequent.

**Richtig:**
```vue
<button class="bg-ui-brand text-ui-onbrand rounded-lg p-2">Klick mich</button>
```

**Falsch:**
```vue
<button class="button-brand">Klick mich</button>

<style>

	.button-brand {
		@apply bg-ui-brand text-ui-onbrand rounded-lg p-2;
	}

</style>
```

---

### 2. `<style>` Parts vermeiden – stattdessen CSS-Dateien verwenden
Wenn eigene CSS-Klassen erforderlich sind, vermeide `<style>`-Abschnitte innerhalb von Vue-Komponenten.  
Stattdessen soll eine separate CSS-Datei mit **gleichem Namen** wie die Komponente verwendet werden (z.B. `Button.vue` → `Button.css`). Diese Datei liegt im selben Verzeichnis wie die dazugehörige Vuekomponente. \
Sollte dennoch ein `<style>`-Abschnitt benötigt werden, dann ist zu beachten, dass hier kein Tailwind verwendet werden kann.

**Erklärung:**  
Styles bleiben so modular und getrennt, verbessern die Lesbarkeit und fördern Wiederverwendbarkeit.

**Richtig:**
```css
/* Button.css */
.btn {
	@apply inline-flex items-center justify-center;
}
```

**Nur in Ausnahmefällen erlaubt, aber ohne Tailwind:**
```vue
<template>
	<div class="text-ui-base">Beispielinhalt</div>
</template>

<style>

	/* Kein Tailwind hier */
	.custom-grid {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
	}

</style>
```

---

### 3. Nur SVWS-Farben verwenden
Es dürfen ausschließlich SVWS-definierte Farben verwendet werden. Tailwind Farben sind nicht erlaubt. SVWS-Farben sind an dem Zusatz `-ui-` bzw. `-uistatic-`im Namen zu erkennen.

**Erklärung:**  
SVWS stellt ein konsistentes Farbsystem bereit, das einheitlich genutzt werden kann und den Kontrastrichtlinien von WCAG entspricht. Die genaue Verwendung der Farben in [SVWS UI](https://ui.svws-nrw.de/) unter `Farben` dokumentiert.

Gerne, hier ist die neue **Regel 4** passend zum Stil der anderen:

---

### 4. Tailwind-Stateklassen verwenden (`hover:`, `focus:` usw.)
Verwende die Tailwind-Modifiers wie `hover:`, `focus:`, `active:`, `disabled:` oder Childselektoren wie  `& > *` usw., um Klassen für bestimmte States zu steuern.
Eine ausführliche Dokumentation über alle States bietet [Tailwind - Hover, focus, and other states](https://tailwindcss.com/docs/hover-focus-and-other-states).

**Erklärung:**  
Tailwind stellt Modifier für alle gängigen Zustände bereit. So bleibt das Styling konsistent, schnell änderbar und vollständig im Markup sichtbar.

**Richtig:**
```vue
<button class="bg-ui-brand text-ui-onbrand hover:bg-ui-brand-hover focus:outline-none focus:ring-2 focus:ring-ui-brand p-2 rounded">
	Klick mich
</button>
```

**Falsch:**
```vue
<button class="btn-brand">Klick mich</button>

<style>
.btn-brand:hover {
	background-color: var(--text-ui-brand-hover);
}
</style>
```



