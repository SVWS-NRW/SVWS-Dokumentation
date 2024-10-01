# Allgemein

## 1. Einzeilige Befehle ohne Klammern
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

for (int i = 0; i < 10; i+) doSometing();
```
---

## 2. Klammern bei gemischten Operatoren
Wenn mehrere Operatoren in einem Ausdruck verwendet werden, setze Klammern, um die Priorität klar zu definieren und Missverständnisse zu vermeiden.

**Richtig:**
```java
if ((a && b) || c) 
    // Klar definierte Reihenfolge durch Klammern

boolean result = (x instanceof String) && (y > 5);  // Deutliche Priorität zwischen instanceof und Vergleich
```

**Falsch:**
```java
if (a && b || c) 
    // Unklare Reihenfolge, da && eine höhere Priorität als || hat


boolean result = x instanceof String && y > 5;  // Ohne Klammern unklar, was zuerst ausgewertet wird
```
---

# Java

## 1. `final` für unveränderliche Variablen
Nutze das Schlüsselwort `final`, um Variablen unveränderlich zu machen. Dadurch wird der Code klarer und verhindert unbeabsichtigte Änderungen an Werten, was zu sichereren Programmen führt.

**Richtig:**
```java
public class Example {
    public void method() {
        final int x = 10;
        // x bleibt unverändert
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

## 2. JavaDoc formatieren
JavaDoc-Kommentare dienen dazu, den Code für andere Entwickler verständlicher zu machen, indem sie die Funktion und den Zweck einer Methode oder Klasse klar und strukturiert beschreiben. Ein gut formatierter JavaDoc-Kommentar besteht aus einer kurzen Beschreibung der Methode, gefolgt von sogenannten "Tags" (z.B. `@param`, `@return`, `@throws`).\
Zwischen der Methoden-/Klassenbeschreibung und den Tags muss immer eine leere Zeile stehen. Auch muss zwischen verschiedenen Arten von Tags eine Leerzeile sein. \
In Javadoc-Kommentaren werden bestimmte Tags, die eine zusätzliche Beschreibung enthalten, nach folgenden Regeln formatiert:

- Die Beschreibung wird immer kleingeschrieben.
- Zwischen dem Tag-Namen und der Beschreibung wird ein Abstand von genau drei Leerzeichen zum längsten Tag-Namen eingefügt.

So entsteht eine saubere und übersichtliche Struktur der Kommentare, die die Lesbarkeit verbessert.

**Richtiges Beispiel:**

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

**Falsches Beispiel:**

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

# Java - Transpiler
Java-Code, der transpiliert wird, muss einige Sonderregeln beachten.

## 1. `@NotNull` und `@AllowNull` korrekt platzieren
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

## 2. Keine Streams verwenden
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

## 3. `switch-Statements` statt `switch-Expressions` verwenden

Da `switch-Expressions` nicht transpiliert werden können, müssen weiterhin `switch-Statements` verwendet werden. 

**Richtig:**
```java
public String getDay(int day) {
    switch (day) {
        case 1: return "Monday";
        case 2: return "Tuesday";
        default: return "Unknown";
    }
}
```

**Falsch:**
```java
public String getDay(int day) {
    return switch (day) {
        case 1 -> "Monday";
        case 2 -> "Tuesday";
        default -> "Unknown";
    };
}
```
---

# TypeScript

## 1. Explizite Null- und Undefined-Überprüfungen
Vermeide den Einsatz von `!!value`, um auf `Null` oder `Undefined` zu prüfen. Nutze stattdessen explizite Vergleiche, um potenzielle Fehlerquellen auszuschließen.

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

## 2. `const` für unveränderliche Variablen
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

## 3. `shallowRef` statt `ref` für transpilierte Java-Objekte
Verwende `shallowRef` anstelle von `ref` für transpilierte Java-Objekte, um Probleme mit JavaScript-Proxies zu vermeiden.

**Richtig:**
```typescript
const javaObject = shallowRef(transpiledJavaObject);
```

**Falsch:**
```typescript
const javaObject = ref(transpiledJavaObject);
```
---

## 4. Keine High-Level-Funktionen wie `map`, `filter`, `reduce`, `forEach`
Vermeide High-Level-Funktionen und nutze klassische `for`-Schleifen.

**Richtig:**
```typescript
for (let i = 0; i < array.length; i++) 
    process(array[i]);

```

**Falsch:**
```typescript
array.forEach(item => process(item));
```
---

# Vue

## 1. Kurzschreibweise für gleichnamige Props verwenden
Wenn der Propertyname und der Wert denselben Namen haben, verwende die Kurzschreibweise.

**Richtig:**
```typescript
<template>
  <card-component :title></card-component> <!-- Kurzschreibweise, da Property- und Wertname "title" übereinstimmen -->
</template>
```

**Falsch:**
```typescript
<template>
  <card-component :title="title"></card-component> <!-- Hier ist die explizite Bindung redundant -->
</template>
```
---

## 2. Direkte Callback-Zuweisung statt Inline-Funktionen
Verwende direkte Callback-Zuweisungen anstelle von Inline-Funktionen.

**Richtig:**
```typescript
<template>
  <button @click="click">Click me</button>
</template>
```

**Falsch:**
```typescript
<template>
  <button @click="(value) => click(value)">Click me</button>
</template>
```

---

## 3. `watch` durch `computed` ersetzen
Vermeide `watch`-Anweisungen, wenn dieselbe Funktionalität durch `computed`-Properties abgedeckt werden kann.

**Richtig:**
```typescript
<script setup>
import { computed, ref } from 'vue';

const firstName = ref('John');
const lastName = ref('Doe');

const fullName = computed(() => firstName.value + ' ' + lastName.value);
</script>
```

**Falsch:**
```typescript
<script setup>
import { ref, watch } from 'vue';

const firstName = ref('John');
const lastName =

 ref('Doe');
let fullName = ref(firstName.value + ' ' + lastName.value);

watch(firstName, (newVal) => {
  fullName.value = newVal + ' ' + lastName.value;
});
</script>
```
---

## 4. Getter für reaktive Props verwenden
Um sicherzustellen, dass Props reaktiv bleiben, sollten sie über Getter übergeben werden.

**Richtig:**
```typescript
<template>
  <child-component :prop="getProp()"></child-component>
</template>
```

**Falsch:**
```typescript
<template>
  <child-component :prop="prop"></child-component>
</template>
```
---

## 5. Keine lokalen Änderungen an globalen UI-Komponenten
Vermeide lokale Anpassungen an globalen UI-Komponenten, da diese Auswirkungen auf andere Projekte haben. Notwendige Änderungen müssen abgesprochen werden.

---

## 6. Funktionen auslagern, statt sie inline zu verwenden
Keine Logik inline verwenden, sondern diese beispielsweise in ein `computed` auslagern. Ternaries sind allerdings in Ordnung. 

**Richtig:**
```typescript
<template>
  <div v-if="isVisible">Visible</div> <!-- Logik in Funktion ausgelagert -->
  <card-component :title="noMaintenance ? 'Please log in' : 'Maintenance'" /> <!-- Inline Ternary ist erlaubt-->
</template>

<script setup>
import { computed, ref } from 'vue';

const noMaintenance = ref(true);
const userRole = ref('admin');

const isVisible = computed(() => {
  if (noMaintenance.value) {
    if (userRole.value === 'admin') 
      return true;
  }
  return false;
});
</script>
```

**Falsch:**
```typescript
<template>
  <!-- Theoretisch möglich, aber unübersichtlich -->
  <div v-if="noMaintenance && userRole === 'admin'">Visible</div>
</template>

<script setup>
import { computed, ref } from 'vue';

const noMaintenance = ref(true);
const userRole = ref('admin');

</script>
```

---

## 7. Inline-CSS für einzelne Attribute
Wenn nur ein einzelnes CSS-Attribut verwendet wird, ist Inline-Styling einfacher und effizienter als eine separate Klasse. Hinweis: Die meisten Stylings können und sollen über Tailwind-Klassen gelöst werden, so auch das folgende Beispiel.

**Richtig:**
```typescript
<template>
  <div :style="{ color: 'red' }">Text</div>
</template>
```

**Falsch:**
```typescript
<template>
  <div class="red-text">Text</div>
</template>

<style>
.red-text {
  color: red;
}
</style>
```

---

## 8. Tailwind-Klassen statt benutzerdefiniertem CSS
Bevor du eigenes CSS hinzufügst, prüfe, ob [Tailwind](https://tailwindcss.com/)-Klassen existieren, die denselben Effekt haben, um Redundanz zu vermeiden.

---

## 9. Funktionsdefinition mit `function`
Verwende named Functions, um diese von `computed` unterscheiden zu können, die mit Arrow-Funktionen definiert werden. Nur als anonyme Funktion, in Vue Lifecycle Hooks und in `routeData` dürfen sie verwendet werden, wenn sie als Props an die Komponenten weitergereicht werden.

**Richtig:**
```typescript
function sum(a: number, b: number): number {
    return a + b;
}
```

**Falsch:**
```typescript
const sum = (a: number, b: number) => {
    return a + b;
};
```
---

## 10. Strukturierung des Script-Bereichs in Vue-Komponenten
Um die Lesbarkeit und Wartbarkeit von Vue-Komponenten zu verbessern, ist es wichtig, eine einheitliche Struktur im Script-Bereich zu wahren. Die folgende Reihenfolge sollte eingehalten werden: **`(shallow)ref`**, **`computed`**, **`functions`**. In größeren Komponenten ist eine thematisches Clustering aber dennoch möglich.

**Richtig:**
```typescript
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
```typescript
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

## 11. Immer Semikolon verwenden

Um die Konsistenz und Lesbarkeit des Codes zu gewährleisten, sollte in allen Dateien das Semikolon am Ende jeder Anweisung verwendet werden. Dies hilft, potenzielle Fehler zu vermeiden und die Codebasis einheitlich zu halten.

**Richtig:**

```typescript
const name = 'Alice';
console.log(name);
```

**Falsch:**

```typescript
const name = 'Alice'
console.log(name)
```
