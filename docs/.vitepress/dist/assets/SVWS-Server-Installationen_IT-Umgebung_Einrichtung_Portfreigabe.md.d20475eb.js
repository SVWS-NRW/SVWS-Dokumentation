import{_ as e,y as r,x as i,W as a}from"./plugin-vue_export-helper.68280688.js";var t="/assets/Fritz_box_01.308fef7c.png",n="/assets/Fritz_box_02.0d22d4c2.png",s="/assets/Fritz_box_03.eafe2133.png",d="/assets/Fritz_box_04.973aaebf.png",o="/assets/Fritz_box_05.424bfe11.png";const x='{"title":"Einrichten einer Portfreigabe","description":"","frontmatter":{},"headers":[{"level":2,"title":"Einsatzszenario","slug":"einsatzszenario"},{"level":2,"title":"Beispiel Fritzbox","slug":"beispiel-fritzbox"},{"level":3,"title":"IP Adresse festlegen:","slug":"ip-adresse-festlegen"},{"level":3,"title":"Portfreigabe einrichten:","slug":"portfreigabe-einrichten"},{"level":3,"title":"Einstellungen f\xFCr eine Freigabe auf Port 58200 - nur TCP:","slug":"einstellungen-fur-eine-freigabe-auf-port-58200-nur-tcp"},{"level":2,"title":"Wireguard & Portfreigabe","slug":"wireguard-portfreigabe"},{"level":2,"title":"Reverse Proxy & Portfreigabe","slug":"reverse-proxy-portfreigabe"}],"relativePath":"SVWS-Server-Installationen/IT-Umgebung/Einrichtung_Portfreigabe.md","lastUpdated":1649313733259}',l={},h=a('<h1 id="einrichten-einer-portfreigabe" tabindex="-1">Einrichten einer Portfreigabe <a class="header-anchor" href="#einrichten-einer-portfreigabe" aria-hidden="true">#</a></h1><h2 id="einsatzszenario" tabindex="-1">Einsatzszenario <a class="header-anchor" href="#einsatzszenario" aria-hidden="true">#</a></h2><p>In unserem Einsatzszenario des SVWS-Servers kann es je nach IT-Betreuung und IT-Umfeld m\xF6glich sein \xFCber eine Portfreigabe des Routers Dienste vom Internet aus frei zu schalten. Hierbei sind die entsprechenden Datenschutzrichtilinien zu beachten. Denkbar sind hier VPN-Zug\xE4nge \xFCber einen <a href="./Installation_VPN-Server.html">VPN-Server</a> oder auch den direkten Zugang zum Server \xFCber personifizierte SSL-Zertifikate Bitte beachten Sie, dass hierbei Serverdienste direkt aus dem Internet aufrufbar sind. Grunds\xE4tzlich gilt daher:</p><p><em><strong>Sie m\xFCssen genau wissen, was Sie da konfigurieren !!!</strong></em></p><h2 id="beispiel-fritzbox" tabindex="-1">Beispiel Fritzbox <a class="header-anchor" href="#beispiel-fritzbox" aria-hidden="true">#</a></h2><h3 id="ip-adresse-festlegen" tabindex="-1">IP Adresse festlegen: <a class="header-anchor" href="#ip-adresse-festlegen" aria-hidden="true">#</a></h3><p>Es ist Vorteilhaft die Ip Adresse des Servers festzulegen bzw. dauerhaft Verkn\xFCpfen mit der MacAdresse.</p><p><img src="'+t+'" alt="FritzBox_01"></p><p><img src="'+n+'" alt="FritzBox_02"></p><h3 id="portfreigabe-einrichten" tabindex="-1">Portfreigabe einrichten: <a class="header-anchor" href="#portfreigabe-einrichten" aria-hidden="true">#</a></h3><p>Die Portfreigabe eintragen, so dass die Portanfrage auf der Fritzbox umgeleitet wird auf genau diesen Rechner mit der vorher definierten IP:</p><p><img src="'+s+'" alt="FritzBox_03"></p><h4 id="gerat-auswahlen-und-auf-neue-freigabe-klicken" tabindex="-1">Ger\xE4t ausw\xE4hlen und auf neue Freigabe klicken: <a class="header-anchor" href="#gerat-auswahlen-und-auf-neue-freigabe-klicken" aria-hidden="true">#</a></h4><p><img src="'+d+'" alt="FritzBox_04"></p><h3 id="einstellungen-fur-eine-freigabe-auf-port-58200-nur-tcp" tabindex="-1">Einstellungen f\xFCr eine Freigabe auf Port 58200 - nur TCP: <a class="header-anchor" href="#einstellungen-fur-eine-freigabe-auf-port-58200-nur-tcp" aria-hidden="true">#</a></h3><p><img src="'+o+'" alt="FritzBox_05"></p><h2 id="wireguard-portfreigabe" tabindex="-1">Wireguard &amp; Portfreigabe <a class="header-anchor" href="#wireguard-portfreigabe" aria-hidden="true">#</a></h2><p>F\xFCr das Betreiben vom <a href="./Installation_VPN-Server.html">Wireguard-VPN-Server</a> ist unbedingt die <strong>UPD und TCP</strong> Freigabe n\xF6tig. Also m\xFCssen im oben beschriebenen Beispiel der FritzBox zwei Freugaben definiert werden.</p><h2 id="reverse-proxy-portfreigabe" tabindex="-1">Reverse Proxy &amp; Portfreigabe <a class="header-anchor" href="#reverse-proxy-portfreigabe" aria-hidden="true">#</a></h2><p>in Bearbeitung: <a href="./Installation_ReverseProxy-Server.html">Reverse-Proxy-Server</a></p>',20),g=[h];function f(u,p,b,c,_,z){return i(),r("div",null,g)}var v=e(l,[["render",f]]);export{x as __pageData,v as default};
