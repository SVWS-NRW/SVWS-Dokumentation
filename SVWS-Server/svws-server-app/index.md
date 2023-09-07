# svws-server-app

Die Klasse "Main" ist die Hauptklasse der Java-Kommandozeilenanwendung des SVWS-Servers. Die Klasse enthält die "main" Methode, die den Einstiegspunkt für die Anwendung darstellt. 
Die Methode lädt zunächst die SVWS-Konfiguration und die Ressourcen des SVWS-Clients, die über die Open-API-Schnittstelle bereitgestellt werden. 
Anschließend wird der Jetty-Embedded Http-Server mit der OpenAPI-Schnittstellen-Web-Applikation gestartet.

Die Klasse importiert mehrere Klassen aus verschiedenen Paketen, darunter die "OpenAPIApplication" Klasse aus dem "de.svws_nrw.api" Paket, die "DBConfig" und "DBEntityManager" Klassen aus dem "de.svws_nrw.db" Paket und die "Logger" und "LogConsumerConsole" Klassen aus dem "de.svws_nrw.core.logger" Paket.

Die "main" Methode initialisiert einen "Logger" und gibt einige Statusinformationen aus, bevor der Server gestartet wird. Die Methode verwendet auch die "Runtime" Klasse, um Informationen über den verfügbaren Heap-Speicher zu sammeln.