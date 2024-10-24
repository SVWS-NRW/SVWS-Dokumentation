# FAQ - Häufig gestellte Fragen

## Wo finde ich die technische Dokumentation?

https://doku.svws-nrw.de

## Wie ist das Support-System rund um die Schulverwaltungssoftware NRW aufgebaut?

* Im ersten Schritt nutzen Sie diese Dokumentation zur Anwendung des SVWS-Clients und die oben verlinkte technische Dokumentation.
* Nutzen Sie ebenso das **Forum** auf der Seite des [MSB für Schulverwaltungssoftware](https://svws.nrw.de). Dieses ist in viele Unterbereiche eingeteilt und oftmals sind aktuelle Fragestellungen schon behandelt, hierbei hilft auch die *Suchfunktion* des Forums.
* Sollte sich das Thema im Forum nicht finden lassen, melden Sie sich an und schildern Sie im passenden Bereich die Problemstellung.
* Über den Bereich **Service** auf der Website ist weiterhin die **Fachberatersuche** zu erreichen. Geben Sie in das Feld Ihre *Schulnummer* ein, um die Kontaktdaten der zugeordneten Fachberatung zu erhalten.

## Was ist der Unterschied zwischen dem Datenbank-root, dem Datenbank-Admin und SVWS-Benutzer?

* Der **Root-Benutzer** der MariaDB ist ein Super-Administrator-Zugang auf den MariaDB-Server an sich. Er hat Zugriffsrechte auf alle Datenbanken auf dem Server und kann diese anlegen und löschen. Er kann beliebige weitere Datenbank-Administratoren anlegen. Im täglichen Betrieb wird dieser Nutzer nicht benötigt. Geht das Root-Kennwort für die MariaDB verloren, kann dieses Passwort nicht mehr angezeigt oder verändert werden und neue Schemata können nicht mehr angelegt werden.

* Ein **Schema-Benutzer** ist ein Administrator-Zugang mit vollen Zugriffsrechten auf ein bestimmtes Schema, d.h. eine einzelne "Datenbank". In den Beispielen hier wird dieser oft *svws_admin* oder *svwsadmin* genannt. Ein Datenbank-Benutzer kann auch mit gleichem Namen und Passwort für mehrere Schemata/Datenbanken gelten. Er kann diese Datenbank nicht löschen, aber jede Veränderung innerhalb des Schemas/der Datenbank vornehmen. Zum Beispiel nutzt ein Client wie SchILD-NRW 3 diese Zugangsdaten, um auf die Datenbank zuzugreifen.

* Ein **normaler Nutzer** ist (meistens) eine reale Person mit individuellen Zugriffsrechten. Rechte regeln individuell für jeden Nutzer, welche Operationen auf der Datenbank erlaubt sind. Dies sind die Benutzer, über die mit den Daten gearbeitet wird. Einem solchen Benutzer können je nach verwendeten Client, etwa SchILD NRW 3, "Administratorrechte" zugewiesen werden, um zum Beispiel die Datenbank zu sichern und wiederherzustellen. 