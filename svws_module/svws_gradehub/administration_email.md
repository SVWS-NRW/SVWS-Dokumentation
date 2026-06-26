
## E-Mail-Server einrichten

Klicken Sie auf E-Mail-Server konfigurieren.
Tragen Sie die SMTP-Zugangsdaten ein (Host, Port, Benutzername, Passwort, Absenderadresse).
Aktivieren Sie TLS verwenden, wenn Ihr SMTP-Server eine verschlüsselte Verbindung erfordert.
Klicken Sie auf Verbindung testen, um die Erreichbarkeit des Mail-Servers zu prüfen.
Klicken Sie auf Übernehmen, um die Konfiguration zu speichern.
Die SMTP-Konfiguration wird verschlüsselt in der GradeHub-Konfigurationsdatei (.ghb) gespeichert, wenn Sie die Konfiguration sichern.

Dateien versenden
Wählen Sie die gewünschten Lehrkräfte aus.
Klicken Sie auf Dateien versenden.
Die App erzeugt für jede Lehrkraft die verschlüsselte Notendatei und sendet sie an die im SVWS-Server hinterlegte dienstliche E-Mail-Adresse.
Ein Fortschrittsdialog zeigt an, welche Versendungen erfolgreich waren und bei welchen ein Fehler aufgetreten ist.
Voraussetzungen für den Versand:

Alle ausgewählten Lehrkräfte müssen ein Notenpasswort haben.
Alle ausgewählten Lehrkräfte müssen eine dienstliche E-Mail-Adresse im SVWS-Server hinterlegt haben.
Der E-Mail-Server muss konfiguriert und erreichbar sein.
6. Ausgefüllte Notendateien importieren
Nachdem Lehrkräfte ihre Noten eingetragen und die Notendatei exportiert haben, können Sie diese Dateien im Adminbereich wieder einsammeln und an den SVWS-Server übermitteln.

Klicken Sie auf Dateien importieren:

Dateien hinzufügen
Dateien auswählen — Wählen Sie eine oder mehrere Dateien aus (.enc.json, .json, .gz).
Ordner auswählen — Wählen Sie einen Ordner; alle darin enthaltenen Notendateien werden automatisch eingelesen (nur in Browsern mit Ordner-Auswahl-Unterstützung).
Dateien entschlüsseln
Verschlüsselte Dateien (.enc.json) werden automatisch anhand des Lehrerkürzels und des gespeicherten Notenpassworts entschlüsselt.
Wird kein Passwort gefunden (Status Kennwort fehlt), können Sie das Kürzel korrigieren oder das Kennwort manuell eingeben und auf Erneut verarbeiten klicken.
Noten an SVWS-Server senden
Klicken Sie bei einem einzelnen Eintrag (Status Bereit) auf An SVWS senden.
Klicken Sie auf Alle senden, um alle erfolgreich entschlüsselten Dateien auf einmal zu übertragen.
Die App überträgt die ENM-Daten über den Endpunkt POST /db/{schema}/enm/v2/import an den SVWS-Server.
Der Status wechselt auf Gesendet bei Erfolg bzw. Sendefehler bei einem Problem.
7. Konfiguration speichern und wieder laden
Die Konfiguration enthält alle Notenpasswörter, das RSA-Schlüsselpaar und die SMTP-Einstellungen. Sie wird stets mit AES-256-GCM und einem selbst gewählten Kennwort verschlüsselt — unabhängig davon, wo sie gespeichert wird.

Auf dem SVWS-Server speichern (empfohlen)
Klicken Sie auf Speichern und dann auf Auf Server speichern. Die verschlüsselten Daten werden über den Endpunkt PUT /db/{schema}/client/config/gradehub/user/data auf dem SVWS-Server abgelegt.

Die Konfiguration ist an den angemeldeten Benutzer gebunden und steht von jedem Gerät aus zur Verfügung.
Beim nächsten Öffnen des Adminbereichs erkennt die App automatisch, dass Daten auf dem Server vorhanden sind, und fordert das Kennwort an.
Als Datei herunterladen (Sicherungskopie)
Klicken Sie auf Speichern und dann auf Als Datei herunterladen. Die Konfiguration wird als gradehub-config.ghb heruntergeladen und kann als Backup oder zur Übertragung auf ein anderes Gerät verwendet werden.

Konfiguration laden
Klicken Sie auf Laden:

Vom Server laden — Ruft die auf dem SVWS-Server gespeicherte Konfiguration ab und entschlüsselt sie mit dem eingegebenen Kennwort. Diese Schaltfläche erscheint nur, wenn ein SVWS-Server verbunden ist.
Aus Datei laden — Lädt eine lokal gespeicherte .ghb-Datei und entschlüsselt sie mit dem eingegebenen Kennwort.
Empfehlung: Speichern Sie die Konfiguration nach jeder Änderung (neue Passwörter, neues Schlüsselpaar, geänderte SMTP-Daten) auf dem Server, damit Sie beim nächsten Sitzungsstart nahtlos weitermachen können. Erstellen Sie zusätzlich regelmäßig eine lokale Sicherungskopie als .ghb-Datei.

Sicherheitshinweise
Bewahren Sie den privaten Schlüssel geheim auf — er wird nur im Adminbereich benötigt.
Geben Sie die Konfigurationsdatei (.ghb) und den privaten Schlüssel nicht unbefugt weiter.
Verwenden Sie für die Konfiguration ein starkes Kennwort mit mindestens 8 Zeichen — sowohl für die Server-Speicherung als auch für die lokale Datei.
Die auf dem SVWS-Server gespeicherte Konfiguration ist benutzergebunden und verschlüsselt; der Server sieht zu keinem Zeitpunkt das Klartext-Kennwort.
Die SMTP-Zugangsdaten werden nur verschlüsselt gespeichert; im Arbeitsspeicher existieren sie nur während der aktuellen Sitzung.
Stellen Sie sicher, dass die Lehrerdateien nur mit dem jeweils zugehörigen Notenpasswort geöffnet werden können.

Programm über Schule verteilen!