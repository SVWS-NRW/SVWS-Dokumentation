Neben einem Logo allgemein für den Client wird wohl auch ein Favicon irgendwann dazukommen.

An dieser Stelle eine kleine Notiz, wie das recht unkompliziert funktionieren kann:

Die Tipps kommen von dieser Seite: https://evilmartians.com/chronicles/how-to-favicon-in-2021-six-files-that-fit-most-needs

Man nehme ein Vektorgrafikprogramm und erstelle ein Icon mit der Größe 512x512 Pixel, Fonts sollte in Pfade umgewandelt werden. Es bietet sich z.B. Inkscape für diese Aufgabe an.

Anschließend wird die Vektorgrafik als `.svg` abgespeichert, in den Client unter `/public` als `Icon.svg` abgelegt und in der `index.html´ eingebunden:

    		<link rel="icon" href="icon.svg" type="image/svg+xml">

Damit kommen heute alle Browser zurecht, die Grafik wird grundsätzlich passend skaliert und keine anderen Formate werden benötigt, da für den Client momentan nur Browser vorgesehen sind. Eine Bedienung mit dem IE fällt weg, exotische Browser aus Russland sind nicht interessant und auch iPhones oder iPads werden keine Rolle spielen müssen. Daher ist dies die optimale Lösung.
