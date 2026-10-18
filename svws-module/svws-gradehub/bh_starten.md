# Benutzerhandbuch SVWS-GradeHub

::: tip Handbuch für Benutzer
Sie befinden sich im Bereich für die Benutzer - also die Lehrkräfte, die Noten eintragen - von SVWS-GradeHub.
:::

## SVWS-GradeHub installieren und starten

Um das Externe SVWS Notenmodul SVWS-GradeHub zu starten, müssen Sie es aufrufen.

Liegt das Modul schon vor, etwa weil die Schule Ihnen einen Link oder eine Internetadresse hat zukommen lassen oder weil das Modul schon auf den Lehrerzimmer-Rechnern liegt, brauchen Sie keinen Download und Sie können die Datei direkt starten. Eventuell hat die IT einen Link auf dem Desktop der Computer abgelegt.

>[!TIP] Tipp für die IT
>Wenn Sie die IT der Schule sind, legen Sie einen Link auf den Desktops an.

Liegt das Modul noch nicht vor, laden Modul herunter und installieren Sie es. Ihre Schule wird Ihnen hierfür einen Link zur Verfügung stellen.

* Entpacken Sie die Datei. Unter MS-Windows ist mit der `rechten Maustaste` auf die Datei zu klicken, dann wählen Sie `Alle extrahieren...`.
* Wählen Sie einen Speicherort für die Dateien.
* Navigieren Sie zu diesem Speicherort und starten Sie die Datei `index.html`.

>[!TIP] MS Windows blendet Dateiendungen aus
>MS Windows blendet per Standard die Dateiendungen aus. Damit wäre die die startende Datei nur die `index`.

Unter Umständen stellt Ihnen Ihre Schule einen Link zur Verfügung, mit dem sich SVWS-GradeHub direkt und ohne Installation über einen Browser aufrufen lässt.

Diese Möglichkeiten, SVWS-GradeHub zu nutzen, könnten für Sie zutreffen:

```mermaid
flowchart LR
  subgraph SVWS-GradeHub bereistellen
    I(Ist schon installiert,<br>von früher oder in der Schule) --Okay!--> ND>Notendatei<br>öffnen]
    style I fill:#008000,stroke:#808080,stroke-width:4px
    style ND fill:#008000,stroke:#808080,stroke-width:4px
    ZI(Noch nicht vorhanden,<br>z.B. zu Hause) --Installieren--> I
    style ZI fill:#800080,stroke:#808080,stroke-width:4px
    W(Aufruf aus dem Netz per Link<br>der Schule) --Okay!--> ND
    style W fill:#008000,stroke:#808080,stroke-width:4px

  end
  ND --> NE>Noteneintrag]
  style NE fill:#008000,stroke:#808080,stroke-width:4px
  subgraph Notendateien der Schule bereitstellen
  NE --> A[Abschicken der<br>Notendatei]
  NE --> LZ[Notendatei im<br>Lehrerzimmer ablegen]
  end

```

Die Administration kümmert sich um das Bereitstellen von Notendateien und des Passworts.

## Lehrernoten-Datei laden & Login

![Login für die Lehrkräfte](./graphics/svws_gradehub_lehrkraft-login.png "Wählen Sie die Lehrkraft-Notendatei und klicken Sie auf 'Lehrerdatei laden'.")

Sie haben eine Lehrkraft-Notendatei erhalten oder diese liegt auf einem der für die Noteneingabe vorgesehen Computer.

Klicken Sie `Datei auswählen` an und navigieren Sie zu Ihrer Lehrkraft-Datei. Wählen Sie diese aus.

![Eine Lehrkraftdatei wurde ausgewählt](./graphics/svws_gradehub_lehrkraft-login_beispiel.png "Es wurde eine gültige .json-Lehrkraftnotendatei ausgewählt.")

Klicken Sie dann auf `Lehrerdatei laden`.

>[!TIP]Administrationsmenü
>Unter Umständen kann es sein, dass Sie den Administrations-Bereich oberhalb des Logins sehen. Dies ist auch der Fall, wenn Sie die Windows-Exe gestartet haben. Ignorieren Sie diesen Teil und nutzen Sie den normalen Login über die Lehrkraft-Notendatei darunter.

Geben Sie bei Bedarf Ihr *Initialkennwort* ein, das Sie von der Schule erhalten haben oder Ihr *Kennwort* ein, dass Sie nach einem vorherigen Login selbst erzeugt hatten.

Unter Umständen ist kein Kennwort notwendig.

Im Anschluss öffnet sich die Maske zur Eingabe von Noten, Fehlstunden und weiterer Daten.

Nutzen Sie hierzu das [Benutzerhandbuch des Externen SVWS Notenmoduls SVWS-GradeHub](/svws-module/svws-gradehub/bh_gradehub_verwenden.md), das links im Inhaltsverzeichnis aufgeführt ist oder folgen Sie dem Link.