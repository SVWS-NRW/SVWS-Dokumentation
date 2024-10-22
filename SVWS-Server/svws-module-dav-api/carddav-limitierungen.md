# CardDAV API - Limitierungen

## Technische Limitierungen

Die (Card-)DAV-Spezifikation gemäß der RFCs
(<https://www.rfc-editor.org/rfc/rfc4918.html>,
<https://www.rfc-editor.org/rfc/rfc6352.html>) wurde nur in Teilen
umgesetzt. Der Fokus der bisherigen Entwicklung lag auf der
grundsätzlichen Nutzbarkeit von Adressdaten des SVWS-Servers in
Standard-Programmen wie Thunderbird und Outlook.
Folgende Einschränkungen gibt es:

**ReadOnly, keine schreibenden Zugriffe auf Adressdaten unterstützt**

- Für Adressbücher wird derzeit nur ein lesender Zugriff ermöglicht
  (PROPFIND, REPORT). 

- Es besteht keine Möglichkeit Kontakte von generierten Adressbüchern
  über die Schnittstelle am SVWS-Server …
  - ... zu ändern (PUT),
  - ... zu löschen (DELETE)
  - ... neu anzulegen (PUT)
  - ... zu sperren, entsperren (LOCK, UNLOCK)
  - ... zu verschieben oder kopieren (COPY, MOVE)

- Es besteht keine Möglichkeit Eigenschaften von Adressbüchern oder
  Kontakten zu verändern (PROPPATCH, z.B. Displayname).

- Es besteht keine Möglichkeit neue Adressbücher über die Schnittstelle
  anzulegen (MKCOL-Methode).

- Es besteht keine Möglichkeit in Adressbüchern zu suchen
  „CARDDAV:addressbook-query“ REPORT

**Keine Ermittlung von Differenzdaten bei der Synchronisation möglich**

Nach dem initialen Import von Adressdaten in einen CardDAV-Client 
können diese "one-way" synchronisiert werden (Differenzdaten herunterladen,
"sync-collection"-Request). Jedoch werden mit jedem derartigen Request
_immer alle_ Kontakte zurückgeliefert. Auch diejenigen, die seit
dem letzten Abruf unverändert geblieben sind. Dabei werden also mehr
Daten übertragen als notwendig wäre (Prinzip Datensparsamkeit!,
Performance!).

Der Grund hierfür ist, dass im SWVS-Datenmodell eine Änderungshistorie
fehlt, anhand derer die Veränderungen von Adressdaten nachvollzogen
werden kann.

VCard: Version 4.0 unterstützt, jedoch nicht alle Eigenschaften einer
VCard, nur diejenigen, die im SVWS-Datenmodell vorliegen. Kompatibilität
mit Version 3.0 (abwärts) ist in den meisten Fällen (Clients) gegeben.
Ausnahmen: KIND-Property (v4, Werte: Member, Groups; Telefonnummern als
URI).

 
**Kompatibilität mit CardDAV-Clients mobiler Plattformen bisher nicht nachgewiesen**

Kompatibilität folgender Clients getestet (Readonly, generiere
Adressbücher)

- Erfolgreich: Thunderbird built-in Adressbuch
- Erfolgreich: Thunderbird Addon "Cardbook"
- Erfolgreich: Outlook Extension "CalDAV Synchronizer" (Mit Anpassung der
Options-Response in SVWSAuthenticator-Klasse)
- Nicht erfolgreich: Thunderbird Addon TbSync mit Addon Provider für
CalDAV & CardDAV
- (Fehler bei Authentifizierung bzw. Initialisierung der Verbindung)
- Nicht erfolgreich: iOS (Einstellungen Kontakte Accounts Account
hinzufügen Andere CardDAV-Account hinzufügen)

(Fehler bei Authentifizierung bzw. Initialisierung der Verbindung,
selbstsignierte Zertifikate werden nicht akzeptiert, hat über HTTP aber
auch nicht funktioniert: bei Versuch über HTTP zuzugreifen, wird kein
Benutzername/Kennwort (Basic Auth) mitgesendet)

```log
Logeintrag bei Test gegen Baikal: 172.18.0.1 \[25/Aug/2022:08:21:31
+0000\] "PROPFIND /dav.php/ HTTP/1.1" 401 414 "-" "iOS/15.6.1 (19G82)
accountsd/1.0" 0.013 "BODY: "\[\<?xml version=\x221.0\x22
encoding=\x22UTF-8\x22?\>\x0A\<A:propfind xmlns:A=\x22DAV:\x22\>\x0A
\<A:prop\>\x0A \<A:current-user-principal/\>\x0A
\<A:principal-URL/\>\x0A \<A:resourcetype/\>\x0A
\</A:prop\>\x0A\</A:propfind\>\x0A\] "Accept-Header: " \[\*/\*\]
"Accept-Encoding: " \[-\] "Content-Type: " \[text/xml\]
````

Nicht erfolgreich: NextCloud (Server) Import über CardDAV ist kein
Feature von NextCloud. NextCloud App scheint nur mit NextCloud Server
kompatibel zu sein.

(<https://help.nextcloud.com/t/sync-contacts-with-existing-carddav-server/51514>)

 
## Mögliche Erweiterungen und Verbesserungen

**Differenzdatenübertragung bei Synchronisation ermöglichen**

(vgl. Limitierung „Keine Ermittlung von Differenzen bei der
Synchronisation)

Im Testezenario waren tw. Laufzeiten um die 5 sec je Sync-Request
erreicht worden. Der Benutzer merkt von der Laufzeit nichts, da die
Synchronisation i.d.R. als Hintergrundprozess im Clientprogramm abläuft.
Die Usability ist dadurch also nicht merklich betroffen.

Für den Server bedeutet das jedoch, dass bei einer steigenden Anzahl von
Clients (und abhängig von der Konfiguration der
Synchronisationsintervallen) in Summe lange Verarbeitungszeiten auf die
CardDAV-Requests anfallen können. In Hinsicht auf die Skalierbarkeit und
Ressourceneffizienz kann das zu Einbußen führen. Eine Abhilfe würde die
Implementierung einer Differenzdatenermittlung und eine Datenabfragen
mit „sync-token“ sein. Folgende Implementierungsvarianten sind denkbar:

- Variante „Änderungshistorie im SVWS-Datenmodell“

  - In den für die Adressdaten relevanten Datenbanktabellen der
    SVWS-Datenbank sind Datumswerte verfügbar, anhand derer erkannt
    werden kann, ob ein Datensatz verändert wurde (z.B. erstellt_am,
    geändert_am, geloescht_am)

- Variante „Differenzdatenabgleich über Batch-Job“

  - Ein Batch-Job läuft periodisch über die für die Adressdaten
    relevanten Datenbanktabellen der SVWS-Datenbank

  - Der Batch-Job extrahiert die Adressdaten und schreibt diese als
    Replikate (z.B. in der VCard-Repräsentation) in eine separate
    Datenbanktabelle (oder in Dateien, Verzeichnisstrukturen im
    Dateisystem)

  - Der Batch-Job reichert die Datenreplikate mit weiteren Informationen
    an, u.a. ob/wann die Adressdaten geändert wurden (z.B. Prüfsummen)

  - CardDAV API liefert Daten immer auf Basis dieser Replikate aus

- Variante „Ereignisbasierte Differenzdatenermittlung“

  - Ereignisbasiert werden Änderungsinformationen zu Adressdatensätzen
    protokolliert.

  - Z.B. DB-Trigger oder Messaging im SVWS-Server

  - Änderungsinformationen werden dann persistiert, entweder in einer
    separaten Tabelle oder – analog der vorherigen Variante – als
    VCard-Repräsentation in DB-Tabelle oder Dateisystem.

**Testautomatisierung: Automatische API-Tests in CI integrieren**

API-Tests wurden im Rahmen der Entwicklung als Insomnia-Collections
angelegt. So konnte schnell geprüft werden, welche Payloads und Header
in den unterschiedlichen Requests vom Server geliefert werden. Die
Requests sind also als wiederholbare Scripts angelegt. Eine weitere
Verbesserung wäre, diese Requests in die CI-Pipeline mit aufzunehmen.
Die Erfahrung hat gezeigt, dass geringfügige Änderungen am DAV-API je
nach DAV-Client schnell zu Inkompatibilitäten führen können (zB
bestimmter Header fehlt). Um das Fehlerrisiko zu mindern, wäre eine
kontinuierliche Prüfung des APIs mit automatisierten API-Tests sinnvoll.
Eine Alternative wäre diese Tests als Unit-Tests abzubilden, um zB
etwaige Abhängigkeiten zu Testdatenzu vermeiden.

**Persönliche und öffentliche Adressbücher ergänzen**

Die Anforderung an persönliche und öffentliche Adressbücher wurden bisher
im SVWS-Server noch nicht umgesetzt. Diese erfordern eine Erweiterung
des Datenmodells.

**Generierung von Java-Objektklassen des DAV-Protokolls aus XSD-Schemata**

Für die Serialisierung und Deserialisierung von HTTP-Payloads des 
DAV-Protokolls wurden im Modul svws-module-dav zahlreiche Java-Klassen 
erstellt (Package: de.nrw.schule.svws.davapi.model.*). Teilweise wurden 
diese aus dem Open-Source-Projekt "Sardine" kopiert (<https://github.com/lookfirst/sardine>, 
<https://github.com/lookfirst/sardine/blob/master/webdav.xsd>). Es wurde 
kein "offizielles" XSD-Schema für DAV oder gar CardDAV gefunden.
Eine Verbesserung des SVWS wäre, wenn die Java-Klassen für die Serialisierung 
der *DAV-Protokolle automatisch generiert würden und die Weiterentwicklung
der Protokoll-Compliance über das XSD-Schema erfolgt (z.B. Generierung über xjc).
