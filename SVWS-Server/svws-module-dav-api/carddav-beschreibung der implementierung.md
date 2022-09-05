# Beschreibung der Implementierung des CardDav Protokolls

Dieses Dokument dient als Grundlage zum technischen Verständnis der Implementierung des CardDav-Protokolls.

## Allgemeine Struktur

Für die Implementierung des CardDav Protokolls wurde ein neues Modul `svws-module-dav-api` geschaffen. Ausgangspunkt für Aufrufe in diesem Modul ist die Klasse `APIAdressbuch` im Modul svws-openapi, welche als Endpunkt dient. Das Modul selbst gliedert sich grob in 3 Teile: 
- XML-Unmarshalling und Protokollverarbeitung in sogenannten Dispatchern, 
- Zugriff auf Datenquellen über sogenannte Repositories
- und Serialisierung von VCards 

Zur Verarbeitung von Protokollanfragen werden Requests in Dispatchern analysiert. Die Dispatcher greifen für ihre Antworten auf ihnen gegebene Repositories zurück und nutzen weiterhin die VCardSerialisierung um Kontaktdaten gemäß Protokoll im VCard-Format zu übertragen.

## Dispatcher

Im Package `de.nrw.schule.svws.davapi.api`befindet sich die notwendige Implementierung für den Umgang mit dem CardDav-Protokoll. Kern sind eine Reihe von Dispatchern als Erweiterung der Klasse `DavDispatcher`, welche abhängig vom API-Endpunkt instantiiert werden und im Rahmen ihrer Methode `dispatch()` das erhaltene Request-Objekt verarbeiten und das Antwortobjekt herausgeben.

Beim Instantiieren der Dispatcher werden die benötigten Datenquellen für Adressbücher als Dependency mitgegeben. Mittels Reflection ermittelt der Dispatcher aus dem Request-Objekt die angefragten Properties und erstellt das Antwort-Objekt mit den Daten aus dem Repository.

Weiterhin befinden sich in diesem Paket die für das Protokoll notwendigen HTTP-Methoden `PROPFIND` und `REPORT` und die Utility `CardDavUriBuilder`, welche die für die Antworten notwenidgen und DB-Schemaabhängigen URLs der Adressbücher, Kontakte und Benutzer erstellt.


## Repositories

Das Package de.nrw.svws.davapi.data.repos enthält die Repositories als Datenquelle für die Dispatcher und grenzen die Logik zur Protokollimplementierung von der Logik zum Zugriff auf die Datenbank ab.

Zu Demonstrationszwecken gab es mehrere Implementierungen der Schnittstellen `IAdressbuchRepository` und `IAdressbuchKontaktRepository`, zum Beispiel Adressbücher für einzelne Gruppen von Kontakten (je Klasse, Jahrgang, Kurs, etc.) bereitzustellen. Letztlich wurde sich für Adressbücher und Kontakte entschieden, die mit dem VCard-Property CATEGORIES eine Sortierung von Kontakten im Client ermöglicht. Diese Implementierung befindet sich im Package `de.nrw.schule.svws.davapi.data.repos.bycategory` und enthält aktuell die auf die SVWS-Datenbank zugreifenden Implementierungen. 

Dabei dient das `AdressbuchWithCategoriesRepository` als Quelle für die verschiedenen Arten von Adressbüchern und hat selbst wiederum Zugriff auf die Quellen für die einzelnen Adressbücher, die jeweils in einer eigenen Klasse als Implementierung von `IAdressbuchKontaktRepository` realisiert sind.

Vorstellbar sind hier auch Implementierungen die auf andere Datenquellen zurückgreifen, bspw. andere Datenbanken, Verzeichnisdienste oder andere CardDav-Server. Ebenso würden an dieser Stelle weitere Implementierungen für Adressbücher in gleicher Form erfolgen. Weiterhin nutzen die Repositories als Rückgabetyp Klassen des Package `de.nrw.schule.svws.core.data.adressbuch` und stehen somit dem Einsatz über die vorhandene REST-API zur Verfügung.

## VCard Serialisierung
Im Package `de.nrw.schule.svws.davapi.util.vcard` befinden sich die Klassen zum Serialisieren der vCards. Die Klasse `VCard` ist im Grunde nur eine andere Darstellungsform der Klassen `AdressbuchKontakt` und `AdressbuchKontaktListe` entsprechend des [RFC 6350 vCard Format Specification für Version 4.0](https://datatracker.ietf.org/doc/html/rfc6350) bzw [RFC2426 vCard MIME Directory Profile für Version 3.0](https://datatracker.ietf.org/doc/html/rfc2426).

Properties einer VCard sind falls zur Serialisierung hilfreich als eigene Implementierung von `VCardProperty` realisiert, beispielsweise kapselt die Klasse `AddressProperty` die Logik zum Schreiben der Adresse, ähnlich wie das `NameProperty` für Namen. Eigenschaften der VCard, welche aus einem einfachen Key-Value-Pair erstellt werden, wurden mit dem `SimpleProperty` realisiert.

Wir haben uns bewusst gegen eine Implementierung eines Parsers zum De-Serialisieren entschieden, da derzeit kein Anwendungsfall existiert. Generierte Adressbücher (aus vorhandenen Daten) sind ohne Schreibberechtigung, veränderliche Adressbücher (persönliche oder globale Adressbücher) sollen bei Realisierung die vollständige VCard persistieren, wozu keine inhaltliche Auswertung der Eigenschaften der VCard notwendig ist.

## Generiertes Datenmodell Klassen

Im Package `de.nrw.svws.davapi.model.dav` befinden sich das aus einem Xml-Schema generierte Datenmodell zur Abbildung der Xml-Struktur der webdav- und carddav-Requests und Responses. Zum (De-)Serialisieren des XML-Formats dient die `XMLUnmarshallingUtil`. 

Da es sich hier um generierten Code handelt, wurde auf Kommentare und Dokumentation verzichtet. Eine Dokumentation zu den XML-Elementen findet sich in [RFC 4918  HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)](https://datatracker.ietf.org/doc/html/rfc4918#section-14), [RFC 6578 Collection Synchronization for Web Distributed Authoring and Versioning (WebDAV)](https://datatracker.ietf.org/doc/html/rfc6578), [RFC 6352 CardDAV: vCard Extensions to Web Distributed Authoring and Versioning (WebDAV)](https://datatracker.ietf.org/doc/html/rfc6352) und weiteren RFC-Dokumenten.

## Weitere Änderungen

Im Package `de.nrw.schule.svws.core.data.adressbuch` sind Klassen für Adressbücher und Kontakte eingepflegt, welche bei Bedarf dann auch über die REST-API genutzt werden können.

Die Utility `de.nrw.schule.svws.core.utils.schule.SchuljahresAbschnittsManager` wurde als einheitlicher Formatter für Schuljahresabschnitte erstellt.

Im `de.nrw.schule.svws.server.jetty.SVWSAuthenticator` wurde ein Workaround ergänzt, welches für einen HTTP-Header nötig ist. Eine langfristige Lösung steht noch zur Diskussion.

## Ergänzungen zum Berechtigungskonzept

Die derzeit implementierten Berechtigungen beschränken den Zugriff auf Adressbuchebene, nicht jedoch auf Kontakt- oder Attributebene. Dazu wurden die vorhandenen Berechtigungen `Schüler Individualdaten - ansehen` und `Lehrerdaten - ansehen` genutzt und die Berechtigung `Adressdaten - ansehen` und `Adressdaten Erzieher - ansehen` ergänzt.
Die Diskussion zur notwendigen Verfeinerung des Berechtigungskonzepts findet in SVWS-Server#578 statt.

