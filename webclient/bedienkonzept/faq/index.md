# FAQ - Häufig gestellte Fragen

## Wo finde ich die gesuchte Dokumenation?

Diese Webseite teilt sich in drei große Teile:

* Unter **Benutzerhandbücher** finden Sie alles, was für Nutzer der Schulverwaltungssoftware relevant ist. 
    * Die Dokumentation des *SVWS-Webclients* selbst, vom Aufbau bis zu konkreten Anleitungen
    * Die Beschreibung des *SVWS-Adminclients*, mit dem SVWS-Administratoren in der Schule selbst Datenbank-Backups ablegen können oder mit dem mehrere Datenbanken parallel aufgesetzt werden können. Auch eine Migration lässt sich über den Adminclient starten.
    * Es finden sich Hinweise zur Laufbahnplanung mit *WebLuPO* aus Sicht eines Anwenders.
* **Administration**
    * Unter dem Punkt *SVWS-Installation* finden sich die Information für SVWS-Admins in der Schule oder IT-Dienstleister, mit denen sich die SVWS-Umgebung installieren lässt und eine Migration angestoßen wird.
    * Unter *Einwicklung, Projekte, Schulungen* finden sich weitergehende Informatione für Interessierte, die in die Softwareenticklung einsteigen möchten. Dieser Bereich ist für Anwender in Schule und IT nicht relevant.
* **Entwicklung** für technische Informationen für Entwickler und zur SVWS-UMgebung gehörende weitergehende Projekte. Für Anwender und Administratoren der Umgebung sind hier keine Informationen hinterlegt. Weiterhin sind für Entwickler über die Kopfzeile noch Links zur *UI-Bibliothek* und der *Java-API des SVWS-Servers* erreichbar. 

## Wie ist das Support-System rund um die Schulverwaltungssoftware NRW aufgebaut?

* Im ersten Schritt nutzen Sie diese Dokumentation zur Anwendung des SVWS-Webclients und die oben verlinkte technische Dokumentation.
* Nutzen Sie ebenso das **Forum** auf der Seite des [MSB für Schulverwaltungssoftware](https://svws.nrw.de). Dieses ist in viele Unterbereiche eingeteilt und oftmals sind aktuelle Fragestellungen schon behandelt, hierbei hilft auch die *Suchfunktion* des Forums.
* Sollte sich das Thema im Forum nicht finden lassen, melden Sie sich an und schildern Sie im passenden Bereich die Problemstellung.
* Über den Bereich **Service** auf der Website ist weiterhin die **Fachberatersuche** zu erreichen. Geben Sie in das Feld Ihre *Schulnummer* ein, um die Kontaktdaten der zugeordneten Fachberatung zu erhalten.

## Was ist der Unterschied zwischen dem Datenbank-root, dem Datenbank-Admin und SVWS-Benutzer?

* Der **Root-Benutzer** der MariaDB ist ein Super-Administrator-Zugang auf den MariaDB-Server an sich. Er hat Zugriffsrechte auf alle Datenbanken auf dem Server und kann diese anlegen und löschen. Er kann beliebige weitere Datenbank-Administratoren anlegen. Im täglichen Betrieb wird dieser Nutzer nicht benötigt. Geht das Root-Kennwort für die MariaDB verloren, kann dieses Passwort nicht mehr angezeigt oder verändert werden und neue Schemata können nicht mehr angelegt werden.

* Ein **Schema-Benutzer** ist ein Administrator-Zugang mit vollen Zugriffsrechten auf ein bestimmtes Schema, das heißt eine einzelne "Datenbank". In den Beispielen hier wird dieser oft *svws_admin* oder *svwsadmin* genannt. Ein Datenbank-Benutzer kann auch mit gleichem Namen und Passwort für mehrere Schemata/Datenbanken gelten. Er kann diese Datenbank nicht löschen, aber jede Veränderung innerhalb des Schemas/der Datenbank vornehmen. Zum Beispiel nutzt ein Client wie SchILD-NRW 3 diese Zugangsdaten, um auf die Datenbank zuzugreifen.

* Ein **normaler Nutzer** ist (meistens) eine reale Person mit individuellen Zugriffsrechten. Rechte regeln individuell für jeden Nutzer, welche Operationen auf der Datenbank erlaubt sind. Dies sind die Benutzer, über die mit den Daten gearbeitet wird. Einem solchen Benutzer können je nach verwendeten Client, etwa SchILD NRW 3, "Administratorrechte" zugewiesen werden, um zum Beispiel die Datenbank zu sichern und wiederherzustellen. 