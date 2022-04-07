import{_ as e,y as n,x as i,W as r}from"./plugin-vue_export-helper.68280688.js";var t="/assets/BK_Konzept.10598fdf.png",a="/assets/BK_ModulA.bef89778.png",s="/assets/BK_EinfachesModal.d084f39a.png",d="/assets/BK_GrossesModal.70c29c5d.png",l="/assets/BK_KomplexesModal.a69038e7.png",h="/assets/BK_Beispiel.c63dd691.png",o="/assets/BK_Neuaufnahme.6103a37f.png";const _='{"title":"SVWS Bedienkonzept","description":"","frontmatter":{},"headers":[{"level":2,"title":"Navigation","slug":"navigation"},{"level":2,"title":"Sidebar","slug":"sidebar"},{"level":2,"title":"Content","slug":"content"},{"level":2,"title":"Der Main-Frame","slug":"der-main-frame"},{"level":2,"title":"Weitere Navigations-Ebenen","slug":"weitere-navigations-ebenen"},{"level":2,"title":"Modale Fenster","slug":"modale-fenster"},{"level":3,"title":"Einfaches Modales Fenster","slug":"einfaches-modales-fenster"},{"level":3,"title":"Gro\xDFes Modales Fenster","slug":"grosses-modales-fenster"},{"level":3,"title":"komplexes Modales Fenster","slug":"komplexes-modales-fenster"},{"level":3,"title":"Beispiel der Hauptanwendung","slug":"beispiel-der-hauptanwendung"},{"level":3,"title":"Use-Case Neuaufnahme","slug":"use-case-neuaufnahme"}],"relativePath":"SVWS-UI-Framework/Bedienkonzept.md","lastUpdated":1649313054068}',u={},c=r('<h1 id="svws-bedienkonzept" tabindex="-1">SVWS Bedienkonzept <a class="header-anchor" href="#svws-bedienkonzept" aria-hidden="true">#</a></h1><p>In diesem Artikel soll das grundlegende Bedienkonzept, das f\xFCr die Web-Applikationen erstellt wurde, vorgestellt werden. Dieses Bedienkonzept beruht auf einigen strategischen \xDCberlegungen und soll in allen vom MSB beauftragen WebApps umgesetzt werden. Es beschreibt die Men\xFCf\xFChrung, die Art der Objekte und die Bereiche, die bei der Bedienung vorkommen d\xFCrfen. Von diesem Konzept darf bei der Umsetzung grafischer Oberfl\xE4chen dann nicht mehr abgewichen werden, um eine einheitliche Bedienf\xFChrung in allen Komponenten zu gew\xE4hrleisten.</p><p><a href="https://xd.adobe.com/view/4fa6739c-7cb9-444e-b62f-bf5ef48a2b4b-1af5/?fullscreen" target="_blank" rel="noopener noreferrer">WireFrame-Modell</a></p><p>Die neue Oberfl\xE4che ist in drei Bereiche unterteilt: Navigation, Sidebar und Content.</p><p>Generell soll bei der gesamten Bedienoberfl\xE4che auf Modale verzichtet werden. In den meisten F\xE4llen kann alles in der Sidebar und dem Content-Bereich stehen. Beispiele f\xFCr den Einsatz eines Modals sind Erweiterte Filter und die Druck-Vorschau.</p><p><img src="'+t+'" alt=""></p><h2 id="navigation" tabindex="-1">Navigation <a class="header-anchor" href="#navigation" aria-hidden="true">#</a></h2><p>Um den Platz auf dem Bildschirm bestm\xF6glich zu nutzen, ist die Navigation am linken Rand positioniert und kann verkleinert werden. In diesem Fall sind dort nur die Icons einzelner Module bzw. Perspektiven sichtbar. Mit einem Tooltip beim Hover wird die Bezeichnung eingeblendet. Oben Links ist das Logo und der Titel der Software sichtbar. Am unteren Rand der Navigation stehen der Username und ein Button zu den allgemeinen Software-Einstellungen (User Management, Rollenzuweisung usw.).</p><h2 id="sidebar" tabindex="-1">Sidebar <a class="header-anchor" href="#sidebar" aria-hidden="true">#</a></h2><p>Die Sidebar kann unterschiedliche Zwecke erf\xFCllen. Zum einen kann dort eine Tabelle mit Datens\xE4tzen eingesetzt werden oder aber eine Subnavigation eines einzelnen Moduls. In der Sidebar wie auch im Content-Bereich kann die Navigation auf mehreren Ebenen realisiert werden. In diesem Fall erscheint neben dem Titel der aktuellen Ebene ein Pfeil, um eine Ebene zur\xFCck zu navigieren. Filterung und Suche von Datens\xE4tzen steht immer zugeh\xF6rig zur entsprechenden Tabelle. Je nach Kontext k\xF6nnen hier verschiedene Filter zur Verf\xFCgung stehen. Um einzelne Datens\xE4tze zu bearbeiten steht in der jeweiligen Zeile ein Icon f\xFCr das &quot;Rechtsklick-Men\xFC&quot;. Technisch sind Aktionen durch einen Rechtsklick zus\xE4tzlich umsetzbar \u2013 hier sollte aber immer auch eine M\xF6glichkeit f\xFCr einen einfachen Klick gegeben werden. Erstellen und L\xF6schen eines Datensatzes ist immer direkt an der unteren Kante einer Tabelle m\xF6glich (Dieser Bereich bleibt immer im Viewport stehen. L\xE4ngere Listen sind dahinter scrollbar). Um einen oder mehrere Datens\xE4tze zu markieren gibt es in jeder Reihe eine Checkbox. Im feststehenden Bereich k\xF6nnen durch eine Checkbox alle Eintr\xE4ge markiert werden. Im leeren Feld einer Tabelle (oben links) kann ein Indikator platziert werden, ob und wie die aktuelle Ausgabe gefiltert ist.</p><h2 id="content" tabindex="-1">Content <a class="header-anchor" href="#content" aria-hidden="true">#</a></h2><p>In der gesamten Oberfl\xE4che sollte alles Wichtige auf einen Blick erkennbar sein und nicht zu sehr mit Informationen \xFCberladen werden. Detaillierte Informationen k\xF6nnen mit einem Tooltip angezeigt werden (z. B. &quot;Letzte \xC4nderung: 1.12.2020&quot;, der Tooltip zeigt dann erg\xE4nzend die genaue Uhrzeit und den User). Der Content-Bereich kann alle m\xF6glichen Ansichten darstellen. Oben angefangen steht dort der Titel \u2013 wenn m\xF6glich mit einem entsprechenden Icon davor. Vor dem Titel kann eine kontextabh\xE4ngige Navigation platziert werden, z. B. einen Datensatz vor/zur\xFCck oder eine Ebene zur\xFCck. Auf der rechten Seite des Headers k\xF6nnen Aktionen zur aktuellen Ansicht stehen \u2013 Drucken, Datenaustausch usw. Um \xDCbersichtlichkeit zu schaffen sind Sektionen im Content-Bereich in verschiedene Tabs unterteilt. Diese Navigation kann beliebig lang sein und kann horizontal gescrollt werden. Je nach Bildschirmbreite k\xF6nnen Input-Felder im Content-Bereich auf 1\u20133 Spalten verteilt werden. Bei einer Mehrfachauswahl wird der Content-Bereich automatisch in eine Navigation verwandelt, die verschiedene Aktionen \xFCbersichtlich darstellt und einfach erreichbar macht. Auch hier k\xF6nnen mehrere Navigationsebenen verschachtelt werden. Hinter dem Titel gibt es die M\xF6glichkeit, in diesem Beispiel die Anzahl der ausgew\xE4hlten Datens\xE4tze anzuzeigen \u2013 hier k\xF6nnten auch andere sinnvolle Informationen zu einer Ansicht stehen.</p><h2 id="der-main-frame" tabindex="-1">Der Main-Frame <a class="header-anchor" href="#der-main-frame" aria-hidden="true">#</a></h2><p>Das Hauptfenster mit den Daten orientiert sich an der bisherigen Nutzerf\xFChrung von Schild-NRW, jedoch bettet sich dieses Fenster in das Konzept mit der Side bar ein, so dass der User ohne gro\xDFen Platzverlust auch an die anderen Perspektiven (Einstellungen, andere Modul) gelangen kann. Visuelle Elemente verdeutlichen dem User, wo Funktionen hinterlegt werden und werden auch \xFCber Tool-Tips angezeigt, so dass Funktionalit\xE4ten nicht &quot;undokumentiert&quot; sind. Die Vielzahl der Daten wird in den Tabs dargestellt. Im Oberen Bereich werden wichtige Informatioenen und Hinweise dazu eingeblendet, an welcher Stelle im Programm man sich befindet. Passende Iconsets m\xFCssen hierf\xFCr dann gefunden werden.</p><p><img src="'+a+'" alt=""></p><h2 id="weitere-navigations-ebenen" tabindex="-1">Weitere Navigations-Ebenen <a class="header-anchor" href="#weitere-navigations-ebenen" aria-hidden="true">#</a></h2><p>Weitere Ebenen k\xF6nnen f\xFCr die Aufgaben verwendet werden, die z.B. nicht an das Daten-Panel gebunden sind. Hier k\xF6nnen bestimmte Gruppenprozesse, Einstellungen, Import/Export-Funktionen hinterlegt sein. Der User hat immer eine \xDCbersicht, auf welcher Navigations-Ebene er sich befindet, kann aber \xFCber die Sidebar auch sehr schnelle wieder auf die Hauptebene zur\xFCck kehren.</p><h2 id="modale-fenster" tabindex="-1">Modale Fenster <a class="header-anchor" href="#modale-fenster" aria-hidden="true">#</a></h2><p>Modale Fenster sind in diesem Konzept eher vermieden worden. An einigen Stellen wird man aber um solche Abfragen nicht herum kommen. Dazu sind drei Arten von Modalen Fenstern freigegeben worden, die folgende Funktionen nutzen.</p><h3 id="einfaches-modales-fenster" tabindex="-1">Einfaches Modales Fenster <a class="header-anchor" href="#einfaches-modales-fenster" aria-hidden="true">#</a></h3><p>F\xFCr schnelle Optionale Entscheidungen, die der User w\xE4hrend eines Use-Case zu treffen hat.</p><p><img src="'+s+'" alt=""></p><h3 id="grosses-modales-fenster" tabindex="-1">Gro\xDFes Modales Fenster <a class="header-anchor" href="#grosses-modales-fenster" aria-hidden="true">#</a></h3><p>F\xFCr komplexere Abfragen, wie zum Beispiel den Filter I, der aus dem Hauptfenster aufgerufen werden kann.</p><p><img src="'+d+'" alt=""></p><h3 id="komplexes-modales-fenster" tabindex="-1">komplexes Modales Fenster <a class="header-anchor" href="#komplexes-modales-fenster" aria-hidden="true">#</a></h3><p>Datenintensive Use-Cases, wie das Reporting mit Vorschau oder die Einstellungen f\xFCr die Import und Exporte k\xF6nnen mit dieser Variante umgestezt werden.</p><p><img src="'+l+'" alt=""></p><h3 id="beispiel-der-hauptanwendung" tabindex="-1">Beispiel der Hauptanwendung <a class="header-anchor" href="#beispiel-der-hauptanwendung" aria-hidden="true">#</a></h3><p><img src="'+h+'" alt=""></p><h3 id="use-case-neuaufnahme" tabindex="-1">Use-Case Neuaufnahme <a class="header-anchor" href="#use-case-neuaufnahme" aria-hidden="true">#</a></h3><p><img src="'+o+'" alt=""></p>',32),m=[c];function g(p,b,f,k,z,v){return i(),n("div",null,m)}var B=e(u,[["render",g]]);export{_ as __pageData,B as default};
