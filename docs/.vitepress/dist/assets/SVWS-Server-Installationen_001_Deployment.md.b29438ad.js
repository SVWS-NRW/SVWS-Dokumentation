import{_ as e,y as n,x as r,W as i}from"./plugin-vue_export-helper.68280688.js";var t="/assets/Einzelplatzinstallation_einfach.cd9ea47d.png",a="/assets/Serverinstallation_Schule_ohne_VPN_einfach.3bad0513.png",s="/assets/Serverinstallation_Rechenzentrum_einfach.5afa5d3f.png";const _='{"title":"Deployment-Szenarien","description":"","frontmatter":{},"relativePath":"SVWS-Server-Installationen/001_Deployment.md","lastUpdated":1649312336299}',l={},d=i('<h1 id="svws-deployment" tabindex="-1"><em><strong>SVWS - Deployment</strong></em> <a class="header-anchor" href="#svws-deployment" aria-hidden="true">#</a></h1><h1 id="deployment-szenarien" tabindex="-1">Deployment-Szenarien <a class="header-anchor" href="#deployment-szenarien" aria-hidden="true">#</a></h1><p>Der SVSW-Server ist grunds\xE4tzlich so ausgelegt, dass er in quasi allen schulischen Umfeldern eingesetzt werden kann. Wichtige Grundlage ist dabei weiterhin der dezentrale Ansatz, der im Land NRW vertreten wird: Kleine Grundschulen haben die Schulverwaltungssoftware ggf. auf einem Rechner installiert, gr\xF6\xDFere Schulen besitzen unter Umst\xE4nden einen oder mehrere Server. Andere Schulen haben IT-Dienstleister, die sie mit Serverinstallationen unterst\xFCtzen. Denkbar ist ebenso der zentrale Einsatz in Rechenzentren.</p><h1 id="einzelplatz-rechner" tabindex="-1">Einzelplatz-Rechner <a class="header-anchor" href="#einzelplatz-rechner" aria-hidden="true">#</a></h1><p>Grunds\xE4tzlich kann der SVWS-Server und die Schild3.0-Installation auf einem Windows-10-64Bit-Client ausgef\xFChrt werden. Der SVWS-Server \xF6ffnet dabei den Port 443, so dass der SVWS-Client auch von anderen Computern im Netzwerk erreicht werden kann. Ein echter Server-Betrieb ist hier allerdings nicht gew\xE4hrleistet, da der Einzelplatzrechner ja unter Umst\xE4nden herunter gefahren wird. Diese Installationsvariante ist f\xFCr sehr kleine Schulen ohne weitere IT-Umgebung bzw. IT-Unterst\xFCtzung vorgesehen.</p><p><img src="'+t+'" alt="Einzelplatzinstallation_einfach.png"></p><h1 id="eigener-server-im-verwaltungsnetz-der-schule" tabindex="-1">Eigener Server im Verwaltungsnetz der Schule <a class="header-anchor" href="#eigener-server-im-verwaltungsnetz-der-schule" aria-hidden="true">#</a></h1><p>Die Variante, einen eigenen Server in der Schule zu betreiben, der im Verwaltungsnetzwerk abgekoppelt vom p\xE4dagogischen Netzwerk betrieben wird, ist die h\xE4ufigste Installations-Art. Auch hier wird der Port 443 intern ge\xF6ffnet, so das der Client den SVWS-Client mit einem Webbrowser erreichen k\xF6nnen sollte. Der SVWS-Server kann dabei auf Basis eines Windows- oder auf Linuxbetriebssystems betrieben werden.</p><p>Dabei kann der SVWS-Installer auf einem Windows-10-64Bit-Server mit dem Windows-Installer installiert werden. Das Zertifikat, welches bei der Installation erstellt wurde, sollte dann an die Clients per Gruppenrichtlinie oder manuell verteilt werden, damit der Browser die Verbindung auch als sicher einstuft.</p><p>Mittelfristiges Ziel soll es auch sein, den SVWS-Server auch f\xFCr Linux zur Verf\xFCgung zu stellen. Es ist geplant, daf\xFCr ein eigenes NPM-Reposotories aufzubauen. Dies soll zum einen die Abh\xE4ngigkeit von Windows reduzieren, da der SVWS-Client ja grunds\xE4tzlich in jedem Browser angezeigt werden kann. Zum anderen soll es den Schulen helfen, Lizenzkosten zu sparen.</p><p><img src="'+a+'" alt="Serverinstallation_Schule_ohne_VPN_einfach.png"></p><h1 id="kommunaler-server-im-rechenzentrum" tabindex="-1">Kommunaler Server im Rechenzentrum <a class="header-anchor" href="#kommunaler-server-im-rechenzentrum" aria-hidden="true">#</a></h1><p>In gro\xDFeren Umgebungen sind verschiedene Varianten der Installation denkbar. Der SVWS-Server soll perspektivisch nat\xFCrlich auch die Funktionalit\xE4t von Schild-Zentral \xFCbernehmen k\xF6nnen. Die Trennung der Schemata ist hier eine wichtige Datenschutz-Ma\xDFnahme. Aber auch die Aufteilung in verschiedene Container wird hier in Betracht gezogen. In Rechenzentren macht es aus Lizenzgr\xFCnden Sinn auf Linux-Systeme zu setzen.</p><p><img src="'+s+'" alt="Serverinstallation_Schule_ohne_VPN_einfach.png"></p><hr>',15),h=[d];function o(c,u,m,p,g,S){return r(),n("div",null,h)}var f=e(l,[["render",o]]);export{_ as __pageData,f as default};
