---
outline: 2
---
# Coding Guidlines
::: details Inhalt
- [Allgemein](#allgemein)
  - [1. Einzeilige Befehle ohne Klammern](#_1-einzeilige-befehle-ohne-klammern)
  - [2. Klammern bei gemischten Operatoren](#_2-klammern-bei-gemischten-operatoren)
  - [3. Interfaces statt konkreter Klassen](#_3-interfaces-statt-konkreter-klassen)
  - [4. Return-Statements immer in eine neue Zeile](#_4-return-statements-immer-in-eine-neue-zeile)
- [Java](#java)
  - [1. `final` für unveränderliche Variablen](#_1-final-fur-unveranderliche-variablen)
  - [2. JavaDoc formatieren](#_2-javadoc-formatieren)
- [Java - Transpiler](#java-transpiler)
  - [1. `@NotNull` und `@AllowNull` korrekt platzieren](#_1-notnull-und-allownull-korrekt-platzieren)
  - [2. Keine Streams verwenden](#_2-keine-streams-verwenden)
  - [3. `switch-Statements` und `switch-Expressions`](#_3-switch-statements-und-switch-expressions)
- [TypeScript](#typescript)
  - [1. Explizite Null- und Undefined-Überprüfungen](#_1-explizite-null-und-undefined-uberprufungen)
  - [2. `const` für unveränderliche Variablen](#_2-const-fur-unveranderliche-variablen)
  - [3. `for of`-Schleifen bevorzugen](#_3-for-of-schleifen-bevorzugen)
  - [4. Keine High-Level-Funktionen wie `map`, `filter`, `reduce`, `forEach`](#_4-keine-high-level-funktionen-wie-map-filter-reduce-foreach)
- [Vue](#vue)
  - [1. Aufbau einer Single File Component](#_1-aufbau-einer-single-file-component)
  - [2. Formatierung in Tags](#_2-formatierung-in-tags)
  - [3. `v-if`, `v-else`, `v-show` und `v-for` immer nach Tagnamen](#_3-v-if-v-else-v-show-und-v-for-immer-nach-tagnamen)
  - [4. Kurzschreibweise für gleichnamige Props verwenden](#_4-kurzschreibweise-fur-gleichnamige-props-verwenden)
  - [5. Direkte Callback-Zuweisung statt Inline-Funktionen](#_5-direkte-callback-zuweisung-statt-inline-funktionen)
  - [6. `watch` durch `computed` ersetzen](#_6-watch-durch-computed-ersetzen)
  - [7. Keine Änderungen an globalen UI-Komponenten](#_7-keine-anderungen-an-globalen-ui-komponenten)
  - [8. Funktionen auslagern, statt sie inline zu verwenden](#_8-funktionen-auslagern-statt-sie-inline-zu-verwenden)
  - [9. Tailwind-Klassen statt benutzerdefiniertem CSS](#_9-tailwind-klassen-statt-benutzerdefiniertem-css)
  - [10. Inline-CSS für einzelne Attribute](#_10-inline-css-fur-einzelne-attribute)
  - [11. Funktionsdefinition mit `function`](#_11-funktionsdefinition-mit-function)
  - [12. Strukturierung des Script-Bereichs in Vue-Komponenten](#_12-strukturierung-des-script-bereichs-in-vue-komponenten)
  - [13. Immer Semikolon verwenden](#_13-immer-semikolon-verwenden)
  - [14. Verzichte auf Vue-Typendefinitionen](#_14-verzichte-auf-vue-typendefinitionen)
  - [15. `Iterable<T>` statt spezifischer Container-Typen](#_15-iterable-t-statt-spezifischer-container-typen)
  - [16. Arrow-Functions für komplexe Objekte und verschachtelte Komponenten](#_16-arrow-functions-fur-komplexe-objekte-und-verschachtelte-komponenten)
  - [17. Arrow-Functions in Routen](#_17-arrow-functions-in-routen)
  - [18. `DeveloperNotificationException` bei Programmierfehlern](#_18-developernotificationexception-bei-programmierfehlern)
  - [19. `UserNotificationException` bei Benutzerfehlern](#_19-usernotificationexception-bei-benutzerfehlern)
  - [20. ESLint statt Prettier](#_20-eslint-statt-prettier)
- [Vue - Transpiler](#vue---transpiler)
  - [1. `shallowRef` statt `ref` für transpilierte Java-Objekte](#_1-shallowref-statt-ref-für-transpilierte-java-objekte)
  - [2. Getter für reaktive Props verwenden](#_2-getter-für-reaktive-props-verwenden)

:::
## Allgemein

### 1. Einzeilige Befehle ohne Klammern
Verzichte auf geschweifte Klammern bei einzeiligen Anweisungen. Schreibe die Anweisung aber dennoch in eine neue Zeile.

**Richtig:**
```java
if (condition)
  doSomething();

for (int i = 0; i < 10; i++)
  doSomething();
```

**Falsch:**
```java
if (condition) {
  doSomething();
}

for (int i = 0; i < 10; i++) {
  doSomething();
}

if (condition) doSomething();

for (int i = 0; i < 10; i+) doSomething();
```
---

### 2. Klammern bei gemischten Operatoren
Wenn mehrere Operatoren in einem Ausdruck verwendet werden, setze Klammern, um die Priorität klar zu definieren und Missverständnisse zu vermeiden.

**Richtig:**
```java
// Klar definierte Reihenfolge durch Klammern:
if ((a && b) || c) 
  return;

// Deutliche Priorität zwischen instanceof und Vergleich:
boolean result = (x instanceof String) && (y > 5);  
```

**Falsch:**
```java
// Unklare Reihenfolge, da && eine höhere Priorität als || hat:
if (a && b || c)
  return;

// Ohne Klammern unklar, was zuerst ausgewertet wird:
boolean result = x instanceof String && y > 5;  
```
---
### 3. Interfaces statt konkreter Klassen
Beim Design von Software sollte die Verwendung von Interfaces gegenüber konkreten Klassen bevorzugt werden, um Flexibilität, Erweiterbarkeit und Testbarkeit zu erhöhen. Durch die Nutzung von Interfaces wird die Abhängigkeit von bestimmten Implementierungen reduziert und es wird einfacher, den Code zu erweitern oder auszutauschen, ohne andere Teile des Systems zu verändern.

**Empfohlene Interfaces für Sammlungen in Java**

- **`List<E>`** statt **`ArrayList<E>`** oder **`LinkedList<E>`**
- **`Set<E>`** statt **`HashSet<E>`** oder **`TreeSet<E>`**
- **`Map<K, V>`** statt **`HashMap<K, V>`** oder **`TreeMap<K, V>`**
- **`Queue<E>`** statt **`PriorityQueue<E>`**

**Richtig:**

```java
import java.util.List;

public class DataProcessor {
	public void processData(List<Integer> data) {
		for (Integer number : data)
			System.out.println(number);
	}
}
```

**Falsch:**

```java
import java.util.ArrayList;

public class DataProcessor {
	public void processData(ArrayList<Integer> data) {
		for (Integer number : data)
			System.out.println(number);
	}
}
```

---

### 4. Return-Statements immer in eine neue Zeile  
Return-Statements sollten immer in einer eigenen Zeile stehen. Das gilt auch für switches.

**Richtig:**  

```java
if (x > 0)
  return true;
```

**Falsch:**  

```java
if (x > 0) return true;
```
---

## Java

### 1. `final` für unveränderliche Variablen
Nutze das Schlüsselwort `final`, um Variablen unveränderlich zu machen. Dadurch wird der Code klarer und verhindert unbeabsichtigte Änderungen an Werten, was zu sichereren Programmen führt.

**Richtig:**
```java
public class Example {
  public void method() {
    final int x = 10; // x bleibt unverändert
  }
}
```

**Falsch:**
```java
public class Example {
  public void method() {
    int x = 10;  // könnte verändert werden, auch wenn es nicht notwendig ist
  }
}
```
---

### 2. JavaDoc formatieren
JavaDoc-Kommentare dienen dazu, den Code für andere Entwickler verständlicher zu machen, indem sie die Funktion und den Zweck einer Methode oder Klasse klar und strukturiert beschreiben. Sie müssen grundsätzlich für alle Methoden gesetzt werden, unabhängig von den Access Modifiers `public`, `private` etc.\
Ein gut formatierter JavaDoc-Kommentar besteht aus einer kurzen Beschreibung der Methode, gefolgt von sogenannten "Tags" (z.B. `@param`, `@return`, `@throws`).\
Zwischen der Methoden-/Klassenbeschreibung und den Tags muss immer eine leere Zeile stehen. Auch muss zwischen verschiedenen Arten von Tags eine Leerzeile sein. \
In Javadoc-Kommentaren werden bestimmte Tags, die eine zusätzliche Beschreibung enthalten, nach folgenden Regeln formatiert:

- Die Beschreibung wird immer kleingeschrieben.
- Zwischen dem Tag-Namen und der Beschreibung wird ein Abstand von genau drei Leerzeichen zum längsten Tag-Namen eingefügt.

So entsteht eine saubere und übersichtliche Struktur der Kommentare, die die Lesbarkeit verbessert.

**Richtig:**

```java
/**
 * Berechnet die Summe zweier Ganzzahlen.
 *
 * @param shortName      die erste Zahl, die addiert wird
 * @param someLongName   die zweite Zahl, die addiert wird
 * 
 * @return die Summe der beiden Zahlen
 * 
 * @throws ArithmeticException   wenn eine Überlaufbedingung auftritt
 */
public int sum(int shortName, int someLongName) throws ArithmeticException {
  return shortName + someLongName;
}
```

**Falsch:**

```java
/**
 * Berechnet die Summe zweier Ganzzahlen.
 * @param shortName Die erste Zahl, die addiert wird
 * @param someLongName Die zweite Zahl, die addiert wird
 * @return Die Summe der beiden Zahlen
 * @throws ArithmeticException Wenn eine Überlaufbedingung auftritt
 */
public int sum(int shortName, int someLongName) throws ArithmeticException {
  return shortName + someLongName;
}
```
---

## Java - Transpiler
Java-Code, der transpiliert wird, muss einige Sonderregeln beachten. Dies betrifft folgende Unterprojekte: `svws-schulen`, `svws-asd`, `svws-core`

### 1. `@NotNull` und `@AllowNull` korrekt platzieren
Die `@NotNull`- und `@AllowNull`-Annotation gehört direkt vor den Typ des Parameters oder der Variablen, um Klarheit zu gewährleisten und Missverständnisse zu vermeiden. Die Platzierung dieser Annotationen ist notwendig, damit korrekter TypeScript Code generiert werden kann.

**Richtig:**
```java
public void setName(final @NotNull String name) {
  this.name = name;
}
```

**Falsch:**
```java
public void setName(@NotNull final String name) {
  this.name = name;
}

public void setName(final String name) {
  this.name = name;
}
```

---

### 2. Keine Streams verwenden
Streams müssen vermieden werden, da sie nicht transpiliert werden können. Nutze stattdessen klassische Schleifen.

**Richtig:**
```java
for (String item : list) 
  process(item);
```

**Falsch:**
```java
list.stream().forEach(item -> process(item));
```

---

### 3. `switch-Statements` und `switch-Expressions` 

Grundsätzlich ist die Verwendung von `switch-Expressions` zu bevorzugen. Da diese aber nicht vollständig vom Transpiler unterstützt werden, kann auch die Verwendung von `switch-Statements` notwendig sein.

**switch-Expression (bevorzugt):**
```java
public String getDay(int day) {
  return switch (day) {
    case 1 -> "Monday";
    case 2 -> "Tuesday";
    default -> "Unknown";
  };
}
```

**switch-Statement (falls nicht transpilierbar):**
```java
public String getDay(int day) {
  switch (day) {
    case 1: 
      return "Monday";
    case 2: 
      return "Tuesday";
    default: 
      return "Unknown";
  }
}
```
---

## TypeScript

### 1. Explizite Null- und Undefined-Überprüfungen
Vermeide den Einsatz von `!!value`, um auf `null` oder `undefined` zu prüfen. Nutze stattdessen explizite Vergleiche, um potenzielle Fehlerquellen auszuschließen.

**Richtig:**
```typescript
if ((value !== null) && (value !== undefined)) 
  // handle value

```

**Falsch:**
```typescript
if (!!value) 
  // handle value

```

---

### 2. `const` für unveränderliche Variablen
Nutze `const`, um Variablen zu definieren, die nicht neu zugewiesen werden, und so versehentliche Änderungen zu verhindern.

**Richtig:**
```typescript
const name = "John";
```

**Falsch:**
```typescript
let name = "John";
```
---

### 3. `for of`-Schleifen bevorzugen
Verwende `for of`-Schleifen, um über Arrays und Iterable-Objekte zu iterieren.

**Richtig:**
```typescript
for (const item of array)
  // handle item
```

**Falsch:**
```typescript
for (let i = 0; i < array.length; i++)
  const item = array[i];
  // handle item

array.forEach(item => {
  // handle item
});
```
---

### 4. Keine High-Level-Funktionen wie `map`, `filter`, `reduce`, `forEach`
Vermeide High-Level-Funktionen und nutze klassische `for of`-Schleifen.

**Richtig:**
```typescript
for (const element of array) 
  process(element);

```

**Falsch:**
```typescript
array.forEach(item => process(item));
```
---

## Vue

### 1. Aufbau einer Single File Component
Verwende in einer SFC stets die Reihenfolge `<template>`, `<script>`, `<style>`.

**Richtig:**
```vue
<template>
  <!-- Do something -->
</template>

<script setup lang="ts">

  // Do Something

</script>

<style lang="postcss">

  /*
  Some styles
  */

</style>
```

**Falsch:**
```vue
<script setup lang="ts">

  // Do Something

</script>

<style>

  /*
  Some styles
  */

</style>

<template>
  <!-- Do something -->
</template>
```

---

### 2. Formatierung in Tags
Innerhalb der Vue Tags `<template>`, `<script>` und `<style>` soll der Code eingerückt sein. Außerdem soll sich zwischen den Tags `<script>` und `<style>` und deren Inhalt eine Leerzeile befinden. Dies gilt nicht für `<template>` (wird von ESLint sonst kritisiert).

**Richtig:**
```vue
<template>
  <span>Text</span>
</template>

<script setup lang="ts">

  import { computed, ref } from 'vue';

  const firstName = ref('John');
  const lastName = ref('Doe');

  const fullName = computed(() => firstName.value + ' ' + lastName.value);

</script>

<style lang="postcss">

  .my-class {
    @apply flex;
  }

</style>
```

**Falsch:**
```vue
<template>

  <span>Text</span>

</template>

<script setup lang="ts">
import { computed, ref } from 'vue';

const firstName = ref('John');
const lastName = ref('Doe');

const fullName = computed(() => firstName.value + ' ' + lastName.value);
</script>

<style lang="postcss">
.my-class {
  @apply flex;
}
</style>
```

---

### 3. `v-if`, `v-else`, `v-show` und `v-for` immer nach Tagnamen
Die Direktiven `v-if`, `v-else`, `v-show` und `v-for` müssen immer am Anfang des Elements stehen, um bedingte Anzeigen oder Schleifen sofort erkennen zu können.

**Richtig:**  
```vue
<template>
  <div v-if="isVisible" class="my-class">v-if</div>
  <div v-else class="my-class">v-else</div>
  <div v-show="isVisible" class="my-class">v-show</div>
  <li v-for="item in items" :key="item.id">{{ item.name }}</li>
</template>
```

**Falsch:**  
```vue
<template>
  <div class="my-class" v-if="isVisible">v-if</div>
  <div class="my-class" v-else>v-else</div>
  <div class="my-class" v-show="isVisible">v-show</div>
  <li :key="item.id" v-for="item in items">{{ item.name }}</li>
</template>
```

---

### 4. Kurzschreibweise für gleichnamige Props verwenden
Wenn der Propertyname und der Wert denselben Namen haben, verwende die Kurzschreibweise.

**Richtig:**
```vue
<template>
  <!-- Kurzschreibweise, da Property- und Wertname "title" übereinstimmen -->
  <card-component :title />
</template>
```

**Falsch:**
```vue
<template>
  <!-- Hier ist die explizite Bindung redundant -->
  <card-component :title="title" />
</template>
```
---

### 5. Direkte Callback-Zuweisung statt Inline-Funktionen
Verwende direkte Callback-Zuweisungen anstelle von Inline-Funktionen.

**Richtig:**
```vue
<template>
  <button @click="click">Click me</button>
</template>
```

**Falsch:**
```vue
<template>
  <button @click="(value) => click(value)">Click me</button>
</template>
```

---

### 6. `watch` durch `computed` ersetzen
Vermeide `watch`-Anweisungen, wenn dieselbe Funktionalität durch `computed`-Properties abgedeckt werden kann.

**Richtig:**
```vue
<script setup lang="ts">

  import { computed, ref } from 'vue';

  const firstName = ref('John');
  const lastName = ref('Doe');

  const fullName = computed(() => firstName.value + ' ' + lastName.value);

</script>
```

**Falsch:**
```vue
<script setup lang="ts">

  import { ref, watch } from 'vue';

  const firstName = ref('John');
  const lastName = ref('Doe');
  let fullName = ref(firstName.value + ' ' + lastName.value);

  watch(firstName, (newVal) => {
    fullName.value = newVal + ' ' + lastName.value;
  });

</script>
```
---

### 7. Keine Änderungen an globalen UI-Komponenten
Vermeide Anpassungen an globalen UI-Komponenten (aus `SVWS-Server\svws-webclient\ui`), da diese Auswirkungen auf andere Projekte haben können. Notwendige Änderungen müssen abgesprochen werden.

---

### 8. Funktionen auslagern, statt sie inline zu verwenden
Keine Logik inline verwenden, sondern diese beispielsweise in ein `computed` auslagern. Ternaries sind allerdings in Ordnung. 

**Richtig:**
```vue
<template>
  <div v-if="isVisible">Visible</div> <!-- Logik in Funktion ausgelagert -->
  <card-component :title="noMaintenance ? 'Please log in' : 'Maintenance'" /> <!-- Inline Ternary ist erlaubt-->
</template>

<script setup lang="ts">

  import { computed, ref } from 'vue';

  const noMaintenance = ref(true);
  const userRole = ref('admin');

  const isVisible = computed(() => {
    if (noMaintenance.value)
      if (userRole.value === 'admin') 
        return true;
    return false;
  });

</script>
```

**Falsch:**
```vue
<template>
  <!-- Theoretisch möglich, aber unübersichtlich, daher auslagern -->
  <div v-if="noMaintenance && userRole === 'admin'">Visible</div>
</template>

<script setup lang="ts">

  import { computed, ref } from 'vue';

  const noMaintenance = ref(true);
  const userRole = ref('admin');

</script>
```

---

### 9. Tailwind-Klassen statt benutzerdefiniertem CSS
Bevor eigenes CSS geschrieben wird, muss geprüft werden, ob [Tailwind](https://tailwindcss.com/)-Klassen existieren, die denselben Effekt haben, um Redundanz zu vermeiden. Soll eine Klasse mehrere Tailwind-Klassen anwenden, ist das wie folgt möglich:

```vue
<style lang="postcss">

  .my-class {
    @apply flex flex-col justify-between;
  }

</style>
```

In Tailwind gibt es neben den fest definierten CSS Klassen auch Klassen, die sich noch weiter individualisieren lassen. Ein Beispiel hierfür ist die Klasse zum Setzen der 'background-color'. Hier gibt es die Möglichkeit direkt einen Farbwert im Hex-Format mitzugeben:
```vue
<style lang="postcss">

  .my-class {
    @apply bg-[#50d71e];
  }

</style>
```

---

### 10. Inline-CSS für einzelne Attribute
Sollte für ein bestimmtes Styling keine Tailwind-Klasse zur Verfügung stehen, muss CSS verwendet werden. Wenn es sich dabei außerdem nur um ein einzelnes CSS Attribut handelt, dann soll dieses nicht in eine Klasse ausgelagert, sondern inline definiert werden.\
Für das CSS-Attribut `scrollbar-width` existiert keine Tailwind-Klasse, daher wird dieses im folgenden Beispiel aufgegriffen:

**Richtig:**
```vue
<template>
  <div :style="{ scrollbar-width: 'thin' }">Text</div>
</template>
```

**Falsch:**
```vue
<template>
  <div class="scrollbar">Text</div>
</template>

<style lang="postcss">

  .scrollbar {
    scrollbar-width: thin;
  }

</style>
```

---

### 11. Funktionsdefinition mit `function`
Verwende named Functions, um diese von `computed` unterscheiden zu können, die mit Arrow-Funktionen definiert werden. Nur als anonyme Funktion, in Vue Lifecycle Hooks und in `routeData` dürfen sie verwendet werden, wenn sie als Props an die Komponenten weitergereicht werden.

**Richtig:**
```vue
<script setup lang="ts">

  function sum(a: number, b: number): number {
    return a + b;
  }

</script>
```

**Falsch:**
```vue
<script setup lang="ts">

  const sum = (a: number, b: number) => {
    return a + b;
  };

</script>
```
---

### 12. Strukturierung des Script-Bereichs in Vue-Komponenten
Um die Lesbarkeit und Wartbarkeit von Vue-Komponenten zu verbessern, ist es wichtig, eine einheitliche Struktur im Script-Bereich zu wahren. Die folgende Reihenfolge sollte eingehalten werden: **`(shallow)ref`**, **`computed`**, **`functions`**. In größeren Komponenten ist eine thematisches Clustering aber dennoch möglich.

**Richtig:**
```vue

<script setup lang="ts">

  import { ref, computed } from "vue";
  const username = ref("Admin");
  const password = ref("");

  const info = computed(() => props.info());

  function connect() {
    // connecting
  }

</script>
```

**Falsch:**
```vue
<script setup lang="ts">

  import { ref, computed } from "vue";
  function connect() {
    // connecting
  }
  const username = ref("Admin");
  const info = computed(() => props.info());
  const password = ref("");

</script>
```
---

### 13. Immer Semikolon verwenden

Um die Konsistenz und Lesbarkeit des Codes zu gewährleisten, sollte in allen Dateien das Semikolon am Ende jeder Anweisung verwendet werden. Dies hilft, potenzielle Fehler zu vermeiden und die Codebasis einheitlich zu halten.

**Richtig:**

```vue
<script setup lang="ts">

  const name = 'Alice';
  console.log(name);

</script>
```

**Falsch:**

```vue
<script setup lang="ts">

  const name = 'Alice'
  console.log(name)

</script>
```
---

### 14. Verzichte auf Vue-Typendefinitionen 
Nutze keine Typendefinitionen aus Vue wie zum Beispiel `Ref`, `Computed` oder `WriteableComputed`.

**Richtig:**
```vue
<script setup lang="ts">

  const foo = ref<boolean>(false);

</script>
```

**Falsch:**
```vue
<script setup lang="ts">

  const foo: Ref<boolean> = ref(false);

</script>
```
---
### 15. `Iterable<T>` statt spezifischer Container-Typen
Wenn Funktionen als Props übergeben werden und Parameter wie Listen oder Arrays erwarten, sollte nach Möglichkeit `Iterable<T>` anstelle von `Array<T>`, `List<T>`, etc. verwendet werden. Dadurch wird der Code flexibler und universeller, da `Iterable<T>` sowohl Arrays als auch andere iterierbare Strukturen akzeptiert. Dies ermöglicht es, mit unterschiedlichen Datenstrukturen zu arbeiten, ohne die Funktion anpassen zu müssen. 

**Richtig**

```vue
<script setup lang="ts">

	const props = defineProps<{
		processData: (data: Iterable<number>) => void;
	}>();

	// Props innerhalb einer Funktion verwenden, um die Reaktivität sicherzustellen:
	function handleProcess() {
		props.processData([1, 2, 3]);   // Array
		props.processData(new Set([4, 5, 6]));   // Set
	}

	handleProcess();

</script>
```
**Falsch**

```vue
<script setup lang="ts">

	const props = defineProps<{
		processData: (data: Array<number>) => void;
	}>();

	// Props innerhalb einer Funktion verwenden, um die Reaktivität sicherzustellen:
	function handleProcess() {
		props.processData([1, 2, 3]);   // Array
	}

	handleProcess();
</script>
```
---

### 16. Arrow-Functions für komplexe Objekte und verschachtelte Komponenten
Die Kommunikation von Child-Komponenten zu Parents geschieht in der Regel über emits. Dies ist erlaubt, wenn dabei nur einfache Typen übergeben werden (`boolean`, `number`, `string`) und kein Event Bubbling über verschachtelte Komponenten stattfindet. Andernfalls müssen Arrow-Functions als Props verwendet werden. Diese stellen auch die Reaktivität für komplexe Objekte sicher.

#### Direkte Beziehung
::: details Richtig
Parent.vue
```vue
<template>
  <child isVisible :benutzer="() => ({ name: 'Max Mustermann', id: 42 })" @update:isVisible="console.log("sichtbar")" />
</template>
```

Child.vue
```vue
<template>
	<p>{{ benutzer().name }}</p>
	<button @click="emit("update:isVisible", !props.isVisible)">Toggle Visibility</button>
</template>

<script lang="ts" setup>

	import { defineProps, defineEmits } from 'vue';

	const props = defineProps({
		isVisible: boolean,
		benutzer: Function,
	});

  // Da keine Verschachtelung vorliegt, darf das boolean emittet werden:
	const emit = defineEmits<{"update:isOpen": [isOpen: boolean]}>();

</script>
```

:::

::: details Falsch
Parent.vue
```vue
<template>
  <!-- Benutzer wird nicht als Arrow-Function weitergegeben und Veränderungen von emits abgehört -->
  <child :benutzer="{ name: 'Max Mustermann', id: 42 }" @update:benutzer="(benutzer) => console.log(benutzer)" />
</template>
```

Child.vue
```vue
<template>
	<p>{{ benutzer.name }}</p>
	<button @click="emit("update:benutzer", benutzer)">Benutzer</button>
</template>

<script lang="ts" setup>

	import { defineProps, defineEmits } from 'vue';

	const props = defineProps<{ benutzer: Benutzer }>();

  // Hier wird ein komplexes Objekt emittet
	const emit = defineEmits<{ "update:benutzer": (benutzer: Benutzer) => void }>();

</script>
```

Benutzerinterface
```vue
interface Benutzer {
  name: string;
  id: number;
}
```

:::

#### Verschachtelte Beziehung
::: details Richtig

Parent-Komponente\
Gibt die Funktion `handleAlert` als Arrow-Function Prop an die Intermediate-Komponente, damit diese aufgerufen werden kann, sobald sie gebraucht wird (in diesem Fall im Child). 
```vue
<template>
	<intermediate :on-log="(message: string) => console.log(message)" />
</template>

<script setup lang="ts">

	import Intermediate from './Intermediate.vue';

</script>
```

Intermediate-Komponente\
Gibt die Funktion `handleAlert` als Arrow-Function Prop an die Child-Komponente weiter
```vue
<template>
	<child :on-log />
</template>

<script setup lang="ts">

	import Child from './Child.vue';

	const props = defineProps<{
		onLog: (message: string) => void;
	}>();

</script>
```

Child-Komponente\
Führt die `handleAlert` Funktion im Parent-Kontext aus, ohne emits ausführen zu müssen
```vue
<template>
	<button @click="onLog('Hello!')">Hello!</button>
</template>

<script setup lang="ts">

	const props = defineProps<{
		onLog: (message: string) => void;
	}>();

</script>
```
:::

::: details Falsch
Parent-Komponente\
Hört auf das Event `@on-log` und führt die Funktion selbst aus
```vue
<template>
	<intermediate @on-log="(message: string) => console.log(message)" />
</template>

<script setup lang="ts">

	import Intermediate from './Intermediate.vue';

</script>

```

Intermediate-Komponente\
Reicht das `emit` des Childs weiter an den Parent durch
```vue
<template>
	<child @on-child-log="(message: string) => emit('onLog', message)" />
</template>

<script setup lang="ts">

	import Child from './Child.vue';

	const emit = defineEmits<{
		(e: 'onLog', message: string): void;
	}>();

</script>

```

Child-Komponente\
Führt ein `emit` aus, wenn der Button geklickt ist.
```vue
<template>
	<button @click="emit('onChildLog', 'Hello!')">Hello!</button>
</template>

<script setup lang="ts">

	const emit = defineEmits<{
		(e: 'onChildLog', message: string): void;
	}>();

</script>

```

:::


---

### 17. Arrow-Functions in Routen
Api-Aufrufe müssen in den Routen statt in den Komponenten durchgeführt werden, sodass die Komponenten unabhängig von den Routen und den zu verwaltenden Daten definiert werden können. Zu diesem Zweck werden Arrow-Functions statt Emits verwendet, die ihren eigenen Kontext behalten. Außerdem müssen auch komplexe Objekte über eine Arrow-Function übergeben werden, damit diese ihre Reaktivität behalten.

::: details Beispiel für Routing
SBenutzerprofilAppProps.ts
```typescript
export interface BenutzerprofilAppProps {
  // Komplexes Objekt als Arrow-Function:
  benutzer: () => BenutzerDaten;
  // Funktion als Arrow-Function prop statt emit:
  patchBenutzerEMailDaten: (data: Partial<BenutzerEMailDaten>) => Promise<void>;
}
```
RouteBenutzerprofil.ts
```typescript
public getProps(to: RouteLocationNormalized): BenutzerprofilAppProps {
  return {
    benutzer: () => this.data.benutzer,
    patchBenutzerEMailDaten: this.data.patchBenutzerEMailDaten,
  };
}
```
RouteDataBenutzerprofil.ts
```typescript
public patchBenutzerEMailDaten = async (data: Partial<BenutzerEMailDaten>) => {
  await api.server.patchBenutzerEmailDaten(data, api.schema);
}

public get benutzer(): BenutzerDaten {
  return api.benutzerdaten;
}
```
SBenutzerprofilApp.vue
```vue
<template>
  <svws-ui-text-input @change="usernameSMTP => patchBenutzerEMailDaten({name: name ?? undefined})" />
</template>
```

:::
---

### 18. `DeveloperNotificationException` bei Programmierfehlern
Mögliche Programmierfehler müssen abgefangen werden und es muss die spezielle Exception `DeveloperNotificationException` geworfen werden.

**Richtig**
```vue
<script lang="ts" setup>

  function add() {
		const daten = getDaten();
		if (daten === null)
			throw new DeveloperNotificationException("Die add-Methode darf nur aufgerufen werden, wenn ein gültiger Wert ausgewählt wurde.");
  }

</script>
```

**Falsch**
```vue
<script lang="ts" setup>

  function add() {
		const daten = getDaten();
		if (daten === null)
			throw new Exception("Die add-Methode darf nur aufgerufen werden, wenn ein gültiger Wert ausgewählt wurde.");
  }

</script>
```

---

### 19. `UserNotificationException` bei Benutzerfehlern
Mögliche Benutzerfehler müssen abgefangen werden. Im besten Fall geschieht dies bereits durch eine Inputvalidierung. Sollte dies zum Beispiel durch hohe Komplexität nicht möglich sein, muss stattdessen bei Fehlern die spezielle Exception `UserNotificationException` geworfen werden.

**Richtig**
```vue
<script lang="ts" setup>

 addRaum = async (raum: Partial<StundenplanRaum>) => {
		const id = this._state.value.auswahl?.id;
		if ((raum.kuerzel === undefined) || raumExistsByKuerzel(raum.kuerzel))
			throw new UserNotificationException('Ein Raum mit diesem Kürzel existiert bereits');
	}

</script>
```

**Falsch**
```vue
<script lang="ts" setup>

 addRaum = async (raum: Partial<StundenplanRaum>) => {
		const id = this._state.value.auswahl?.id;
		if ((raum.kuerzel === undefined) || raumExistsByKuerzel(raum.kuerzel))
			throw new Error('Ein Raum mit diesem Kürzel existiert bereits');
	}

</script>
```

---

### 20. ESLint statt Prettier
Verwende für die Formatierung des Codes keinen Prettier, sondern stattdessen die Korrekturen von ESLint.

---

## Vue - Transpiler
Die folgenden Regelungen beziehen sich ausschließlich auf transpilierte Java-Objekte.


### 1. `shallowRef` statt `ref` für transpilierte Java-Objekte
Verwende `shallowRef` anstelle von `ref` für transpilierte Java-Objekte, um Probleme mit JavaScript-Proxies zu vermeiden. Gib außerdem auch immer den Typ des `shallowRef` an.

**Richtig:**
```vue
<script setup lang="ts">
  
  const javaObject = shallowRef<Typ>(transpiledJavaObject);

</script>
```

**Falsch:**
```vue
<script setup lang="ts">
  
  const javaObject = ref(transpiledJavaObject);

</script>
```
---
### 2. Getter für reaktive Props verwenden
Um sicherzustellen, dass Props reaktiv bleiben, sollten sie über Getter übergeben werden. Dies betrifft ausschließlich transpilierte Java-Objekte, die aus Routen kommen.

**Richtig:**
```vue
<template>
  <child-component :title="someManger.getTitle()"></child-component>
</template>
```

**Falsch:**
```vue
<template>
  <child-component :title="titleAusParent"></child-component>
</template>
```
---

