# Bereich zum Testen von Mermaid-Diagrammen

Basic Syntax

Wird nicht im Inhalt verlinkt

Kurzes HowTo:

* Pfeile
* Formen
* ...

* "Flowchart" und "Graph" machen das Gleiche.
* "o" und "x" nach Pfeilen sind besonders: Leerzeichen! "A---xB" -> "A--- xB", sonst gibt es Formen.
* Unicode-Text kommt "ABC UNICODE"

Einfach von links nach rechts

```mermaid
flowchart LR
  Start --> Stop
```

Und von oben nach unten (Mermaid kann TD (down) und TB (bottom), dann BT, RL und LR)

```mermaid
flowchart TD
  Anfangen --> Runterfallen
```

Mit Animation und auch dickem Pfeil!
```mermaid
flowchart LR
  A e1@==> B
  e1@{ animation: slow }
  B e2@--> A
  e2@{animation: fast}
```

Guck mal, die tollen Formen:

```mermaid
graph LR
    A[Eckige Klammern!] -- Mein Link --> B((Doppelklammer))
    B --> M
    M(((Dppelkreis mit drei Klammern)))
    A --> C(Einfachklammern)
    B --> D{Geschweift!}
    C --> D
    E --> F[[Doppelte Eckklammern]]
    G[(Datenbank)] --> H>Coole Banner!]
    I[/Schräge Box/] --> J[\und andersrum\]
    K[/Wahnsinn\] --> L[\Wahnsinn 2/]
```

Mehr tolle Formen lassen sich direkt mit A@{ shape: rect } generieren. Shape-namen finden sich unter dem Link oben. Vorschlag: Wir nutzen die Namen?

Guck mal, ein paar Pfeile:

```mermaid
graph LR
A--xB
A--oB
A-->B
A<-->B
B-->B
```

```mermaid
pie title SchILD-NRW 3 vs. SVWS-Client vs. Excel
  "SVWS-Client" : 95
  "ScHILD-NRW 3" : 85
  "Andere" : 20
  "Excel" : 15
```

```mermaid
gantt
    title Eine Zeitliniensammlung
    dateFormat YYYY-MM-DD
    section Bereich 1
        Meine Aufgabe       :a1, 2026-02-01, 30d
        Meine 2. Aufgabe    :after a1, 20d
        Deine Aufgabe       :a2, 2026-02-10, 20d
    section Bereich 2
        Task in Bereich 2 :2026-02-12, 12d
        Das muss noch!    :14d
```

Boxen gehen mit "Subgraph", die Reihenfolge, wie was erzeugt wird und was am Ende passiert, ist etwas frickelig

```mermaid
flowchart TB
    A-->B
    B<-->C
    subgraph Eins
    C-->D
    D-->A
    end
    subgraph Zwei
    E-->F
    end
```

"Flowchart" kann Pfeile von Subgraphen ausgehen lassen.

Pfeileformen:

```mermaid
flowchart LR
    A e1@==>B
    A e2@-->C
    e1@{ curve: linear }
    e2@{ curve: natural }
```

Boxgrafik verändern:

```mermaid
flowchart LR
    A(Start)-->B(Stop)
    style A fill:#f9f,stroke:#333,stroke-width:4px
    style B fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
```

Es können auch Klassen definiert werden.