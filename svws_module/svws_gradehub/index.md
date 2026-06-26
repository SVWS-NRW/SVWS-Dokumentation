# Das externe Notenmodul SVWS GradeHub

Mit dem externen **SVWS Notenmodul für Lehrkräfte GradeHub** lassen sich Noten über Lehrkraftdateien einsammeln und anschließend wieder über den SVWS-Client einlesen.

Das Notenmodul läuft entweder für sich vollständig isoliert auf einem lokalen Rechner und verfügt über keine direkte Verbindung zum SVWS-Server, der Datenaustausch findet ausschließlich über Dateien statt.

Es gibt einen alternativen SVWS-Server-Modus, mit dem sich *Administratoren* direkt mit dem SVWS-Server verbinden können, über den Administratoren Notendateien erzeugen oder einen Emailversand nutzen können.

Im Gegensatz zum *WebNotenManager WeNoM* ist die Komplexität geringer. Es muss für GradeHub kein Webserver aufgesetzt werden und die Verbindung zum und vom SVWS-Server muss nicht konfiguriert oder synchronisiert werden. Jedoch fehlt auch die Möglichkeit zum automatischen Austausch über die Server, so dass mit GradeHub eine Datei von einer Lehrkraft eigenständig ausgefüllt und wieder in der Schule zur Verfügung gestellt werden kann.

Im *Bediener-Modus*: Der Notenmanager dient Lehrkräften dazu, Ihre Noten einzutragen und wieder als Lehrkraft-Notendatei zu speichern.

Im *Admin-Modus* kann der Notenmanager weiterhin
* Passwörter für Notendateien generieren
* Notendateien erzeugen
* Notendateien importieren

>[!TIP]GradeHub ist als Übergangslösung vorgesehen
>Für Schulen, die den WeNoM noch nicht im Einsatz haben, stellen wir eine Übergangslösung für die Noteneingabe zur Verfügung. Diese Lösung wird vorübergehend bereitgestellt und ermöglicht es, die Noteneingabe auch vor der Einführung des WeNoM weiterhin zuverlässig durchzuführen. Sie dient als temporäre Unterstützung, bis der WeNoM flächendeckend verfügbar ist.

>[!CAUTION] Nicht kompatiel mit ENM
>GradeHub und die Notendateien des SVWS-Clients sind nicht kompatibel mit dem ENM2 von SchILD-NRW2 und ebenso nicht kompatibel mit dem SchILD-NRW-3 ENM3m das mit .nm3-Dateien arbeitet. Sofern Sie Noten mit dem ENM3 und SchILD-NRW-3 verarbeiten wollen, ist dies weiterhin möglich.
>Für das Externe SVWS Notenmodul GradeHub erstellen Sie die Notendateien bitte mit dem SVWS-Client oder mit GradeHub selbst.