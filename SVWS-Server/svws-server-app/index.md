# svws-server-app

Die Klasse "Main" ist die Hauptklasse der Java-Kommandozeilenanwendung des SVWS-Servers. Die Klasse enthält die "main" Methode, die den Einstiegspunkt für die Anwendung darstellt. 
Die Methode lädt zunächst die SVWS-Konfiguration und die Ressourcen des SVWS-Clients, die über die OpenAPI-Schnittstelle bereitgestellt werden. 
Anschließend wird der Jetty-Embedded Http-Server mit der OpenAPI-Schnittstellen-Web-Applikation gestartet.

Die Klasse importiert mehrere Klassen aus verschiedenen Paketen, darunter die Klasse *OpenAPIApplication* aus dem `de.svws_nrw.api` Paket, die Klassen *DBConfig* und *DBEntityManager* aus dem `de.svws_nrw.db` Paket und die Klassen *Logger* und *LogConsumerConsole* aus dem `de.svws_nrw.core.logger` Paket.

Die Methode *main* initialisiert eine Instanz von *Logger* und gibt einige Statusinformationen aus, bevor der Server gestartet wird. *main* verwendet auch die Klasse *Runtime*, um Informationen über den verfügbaren Heap-Speicher zu sammeln.