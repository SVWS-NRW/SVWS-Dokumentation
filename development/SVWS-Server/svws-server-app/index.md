# svws-server-app

Der SVWS-Server basiert auf einem embedded Jetty Server und ist so konzipiert, dass er die REST Services steuert und sich um die Datenbankoperationen kümmert. Der Jetty Server ist eine Lösung, die es dem SVWS-Server ermöglicht, schnell auf Anfragen zu reagieren und eine schnelle Verarbeitung der Daten zu gewährleisten. Die REST Services, die vom SVWS-Server bereitgestellt werden, ermöglichen es den Entwicklern, schnell auf die Daten zuzugreifen und sie zu manipulieren, ohne dass sie sich um die Details der Datenbankoperationen kümmern müssen. Der SVWS-Server ist so konzipiert, dass er die Datenbankoperationen effizient und sicher ausführt, um die Datenintegrität zu gewährleisten. Durch die Verwendung des SVWS-Servers können Entwickler schnell und einfach auf die Daten zugreifen, die sie benötigen, um ihre Anwendungen zu erstellen und zu pflegen.

Die Klasse "Main" ist die Hauptklasse der Java-Kommandozeilenanwendung des SVWS-Servers. Die Klasse enthält die "main" Methode, die den Einstiegspunkt für die Anwendung darstellt. 
Die Methode lädt zunächst die SVWS-Konfiguration und die Ressourcen des SVWS-Clients, die über die OpenAPI-Schnittstelle bereitgestellt werden. 
Anschließend wird der Jetty-Embedded Http-Server mit der OpenAPI-Schnittstellen-Web-Applikation gestartet.
