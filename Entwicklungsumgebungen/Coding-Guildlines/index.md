# Coding Guidelines

Diese Richtlinien dienen der Einhaltung eines konsistenten und wartbaren Codes in allen Projekten. Bitte beachtet sie sorgfältig.

## Inhaltsverzeichnis
1. [Allgemeine Regeln](#allgemeine-regeln)
2. [Variablen und Konstanten](#variablen-und-konstanten)
3. [Kontrollstrukturen](#kontrollstrukturen)
4. [Annotationen](#annotationen)

---

## Allgemeine Regeln

### 1. Code Lesbarkeit

Code sollte in erster Linie lesbar und verständlich sein. Ein Code, der schwer zu verstehen ist, führt zu Fehlern und erhöht den Wartungsaufwand.

- Schreibe aussagekräftige Variablennamen.
- Vermeide zu lange Methoden oder Klassen; sie sollten jeweils nur eine Aufgabe erfüllen.

---

## Variablen und Konstanten

### 1. Verwendung von `final`

Variablen, deren Wert nach der Initialisierung nicht mehr geändert wird, müssen als `final` deklariert werden.

**Beispiel (korrekt):**
```java
final String name = "John";
```

**Beispiel (falsch):**
```java
String name = "John";
```

### 2. Konventionen für Variablenbenennung

- Variablen- und Methodennamen müssen im CamelCase-Stil geschrieben werden (`camelCase`).
- Konstanten müssen in Großbuchstaben geschrieben und durch Unterstriche getrennt werden (`CONSTANT_VALUE`).

**Beispiel (korrekt):**
```java
int customerId;
final int MAX_COUNT = 100;
```

**Beispiel (falsch):**
```java
int CustomerID;
final int MaxCount = 100;
```

### 3. Klassenvariablen zuerst, lokale Variablen danach

Deklariere erst alle Instanz- und Klassenvariablen oben in der Klasse, bevor lokale Variablen innerhalb von Methoden deklariert werden.

---

## Kontrollstrukturen

### 1. If-Abfragen und for-Schleifen ohne geschweifte Klammern

Für einfache If-Abfragen und for-Schleifen mit nur einer Zeile sollen keine geschweiften Klammern verwendet werden.

**Beispiel (korrekt):**
```java
if (condition) 
    doSomething();
```

**Beispiel (falsch):**
```java
if (condition) {
    doSomething();
}
```

### 2. Vermeide tiefe Verschachtelungen

Tiefe Verschachtelungen von Kontrollstrukturen (z.B. mehrere `if` oder `for`-Schleifen ineinander) sollten vermieden werden, um den Code lesbar zu halten.

**Beispiel (falsch):**
```java
if (a) {
    if (b) {
        for (int i = 0; i < 10; i++) {
            // ...
        }
    }
}
```

**Beispiel (korrekt):**
```java
if (!a || !b) return;

for (int i = 0; i < 10; i++) {
    // ...
}
```

### 3. Switch-Statements

Wenn möglich, verwende `switch`-Statements anstelle langer `if-else` Ketten.

**Beispiel:**
```java
switch (status) {
    case "ACTIVE":
        handleActive();
        break;
    case "INACTIVE":
        handleInactive();
        break;
    default:
        handleUnknown();
}
```

---

## Annotationen

### 1. Platzierung von Annotationen wie `@NotNull`

Annotationen wie`@NotNull` müss immer direkt vor dem Typ deklariert werden und nicht zwischen Typ und Modifikatoren wie `final`.

**Beispiel (korrekt):**
```java
public void processData(final @NotNull String data) {
    // ...
}
```

**Beispiel (falsch):**
```java
public void processData(@NotNull final String data) {
    // ...
}
```

### 2. `@Override` Annotation immer verwenden

Bei überschriebenen Methoden aus einer Superklasse oder einem Interface sollte immer die `@Override` Annotation verwendet werden.

**Beispiel (korrekt):**
```java
@Override
public String toString() {
    return "Example";
}
```
Mit diesen umfassenden Richtlinien sollte der Code in euren Projekten klar, lesbar und wartbar bleiben.
