import{_ as e,y as n,x as t,W as s}from"./plugin-vue_export-helper.68280688.js";const b='{"title":"Installation per Script","description":"","frontmatter":{},"headers":[{"level":2,"title":"Vorbereitungen und erste Schritte","slug":"vorbereitungen-und-erste-schritte"},{"level":2,"title":"MariaDB installieren und einrichten","slug":"mariadb-installieren-und-einrichten"},{"level":2,"title":"Java installieren","slug":"java-installieren"},{"level":2,"title":"NodeJs installieren","slug":"nodejs-installieren"},{"level":2,"title":"SVWS-Server Sources herunterladen und bauen","slug":"svws-server-sources-herunterladen-und-bauen"},{"level":2,"title":"Starten des SVWS-Servers","slug":"starten-des-svws-servers"},{"level":2,"title":"Einrichten des Servers als Dienst","slug":"einrichten-des-servers-als-dienst"},{"level":2,"title":"Fehlersuche und Fehleranalyse","slug":"fehlersuche-und-fehleranalyse"},{"level":3,"title":"Neustart der Dienste","slug":"neustart-der-dienste"},{"level":3,"title":"Fehlersuche per Journal","slug":"fehlersuche-per-journal"}],"relativePath":"SVWS-Server-Installationen/002_Installation_SVWS-Server.md","lastUpdated":1649314121404}',a={},r=s(`<h1 id="installation-des-svws-servers" tabindex="-1"><em><strong>Installation des SVWS-Servers</strong></em> <a class="header-anchor" href="#installation-des-svws-servers" aria-hidden="true">#</a></h1><h1 id="installation-per-script" tabindex="-1">Installation per Script <a class="header-anchor" href="#installation-per-script" aria-hidden="true">#</a></h1><p>Dieses Installations-Script ist wurde entwickelt f\xFCr die vollst\xE4ndige Installation des SVWS-Servers auf Debian 11. Es wurde getestet in einem <a href="./IT-Umgebung/Einrichtung_Proxmox-Container.html">Proxmox-Container</a>. Es beinhaltet quasi alle Schritte, die unter dem nachfolgenden Kapitel <em>Installation from Scratch</em> aufgef\xFChrt sind, vereint in einem Script. Aktuell werden noch Token-Zug\xE4nge zum Github SVWS-Server und SVWS-Client Repository ben\xF6tigt und im Script abgefragt. Dieser Schritt* entf\xE4llt bei Ver\xF6ffnetlichung der SVWS-Servers auf Git Hub unter OpenSource-Lizens</p><ul><li>Download <a href="./scripts/install-svws-from-scratch.html">install-svws-from-scratch.sh</a></li><li>ausf\xFChrbar machen: <code>chmod -x install-svws-from-scratch.sh</code></li><li>Script starten: <code>./install-svws-from-scratch</code></li></ul><ul><li>geben Sie Ihren Github-Usernamen und das Token an*</li><li>geben Sie das MBD Passwort f\xFCr Schild an</li></ul><p>Die Angabe des Schild Passwortes ist nur n\xF6tig, wenn auch eine Schild2-Datenbank importiert werden soll. Dies kann auch im Anschluss an die Installation noch erfolgen. Das Script l\xE4uft ohne Unterbrechung durch und legt eine nur f\xFCr den Systemadmin lesbare Datei <code>SVWS-Zugangsdaten.txt</code> in das root-Hauptverzeichnis.</p><p>Nach etwa 10-15 min ist der SVWS-Server inklusive aller ben\xF6tigten Bestandteile aus dem Quellcode heraus compiliert und mit beendigung des Scripts gestartet. Der user svws wird eingerichtet und unter /app befinden sich nun die Dateien zum Betrieb des Servers. Er l\xE4uft als Service im Debian System, wird beim Start des Systems automatisch gestartet oder kann mit den folgenden Befehlen gestartet bzw. gestopt werden:</p><div class="language-bash"><pre><code>			systemctl start svws
			systemctl restart svws
			
			systemctl stop svws
</code></pre></div><p>Der SVWS-Client f\xFCr die Bedienung des SVWS-Servers kann unter https://<em>IP-oder-FQDN-des-Servers</em>/ aufgerufen werden:</p><h1 id="installation-from-scratch" tabindex="-1">Installation from Scratch <a class="header-anchor" href="#installation-from-scratch" aria-hidden="true">#</a></h1><p>Alle Schritte, die in dem vorangegangenem Kapitel in einem Script zusammengefasst ausgef\xFChrt werden, werden hier einzeln aufgef\xFChrt und beschrieben.</p><h2 id="vorbereitungen-und-erste-schritte" tabindex="-1">Vorbereitungen und erste Schritte <a class="header-anchor" href="#vorbereitungen-und-erste-schritte" aria-hidden="true">#</a></h2><p>Der SVWS-Server ben\xF6tigt <a href="https://www.debian.org/CD/http-ftp/" target="_blank" rel="noopener noreferrer">Debian 11</a> als grundlegendes Betriebssystem. Je nach Hardware kann das typische <a href="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso" target="_blank" rel="noopener noreferrer">AMD64 Netzwerk Image</a> von Debian benutzt werden.</p><p>Nach Installation wird das Betriebssystem auf den neuesten Stand gebracht, also als root die folgenden Befehle ausf\xFChren:</p><div class="language-bash"><pre><code>		<span class="token function">apt</span> update -y
		<span class="token function">apt</span> dist-upgrade -y
</code></pre></div><p>Anschlie\xDFend die n\xF6tige bzw. hilfreiche Software installieren:</p><div class="language-bash"><pre><code>		<span class="token function">apt</span> <span class="token function">install</span> <span class="token function">ssh</span> nmap <span class="token function">curl</span> <span class="token function">git</span> <span class="token function">zip</span> net-tools dnsutils software-properties-common dirmngr -y
</code></pre></div><p>Dann den user anlegen, z. B. <code>svws</code>, unter dem der Dienst betrieben wird:</p><div class="language-bash"><pre><code>		<span class="token function">useradd</span>	-m -G <span class="token function">users</span> -s /bin/bash svws
</code></pre></div><h2 id="mariadb-installieren-und-einrichten" tabindex="-1">MariaDB installieren und einrichten <a class="header-anchor" href="#mariadb-installieren-und-einrichten" aria-hidden="true">#</a></h2><p>Es wird MariaDB mindestens 10.6 ben\xF6tigt. Unter debain 11 bisher nur \xFCber die ofiziellen Sources von <a href="http://mariadb.org" target="_blank" rel="noopener noreferrer">mariadb.org</a> installierbar:</p><div class="language-bash"><pre><code>		<span class="token function">wget</span> https://mariadb.org/mariadb_release_signing_key.asc
		<span class="token function">chmod</span> -c <span class="token number">644</span> mariadb_release_signing_key.asc
		<span class="token function">mv</span> -vi mariadb_release_signing_key.asc /etc/apt/trusted.gpg.d/
		<span class="token builtin class-name">echo</span> <span class="token string">&quot;deb [arch=amd64,arm64,ppc64el] https://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.6/debian bullseye main&quot;</span> <span class="token operator">|</span> <span class="token function">tee</span> /etc/apt/sources.list.d/mariadb.list

		<span class="token function">apt</span> update
		<span class="token function">apt</span> <span class="token function">install</span> mariadb-server -y 
</code></pre></div><p>Die Datei <code>mysql_secure_installation.sql</code> anlegen, um das MariaDB-Passwort zu setzen und weitere sicherheitsrelevante Einstellung zu t\xE4tigen:</p><div class="language-bash"><pre><code>		<span class="token builtin class-name">echo</span> <span class="token string">&quot;
		ALTER USER &#39;root&#39;@&#39;localhost&#39; IDENTIFIED BY &#39;!geben_Sie_hier_Ihre_Daten_an!&#39;;
		DELETE FROM mysql.user WHERE User=&#39;&#39;;
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db=&#39;test&#39; OR Db=&#39;test<span class="token entity" title="\\\\">\\\\</span>_%&#39;;
		FLUSH PRIVILEGES;
		&quot;</span> <span class="token operator">&gt;</span> mysql_secure_installation.sql
</code></pre></div><p>Den o.g. mysql Befehl ausf\xFChren:</p><div class="language-bash"><pre><code>		mysql <span class="token operator">&lt;</span> mysql_secure_installation.sql
</code></pre></div><h2 id="java-installieren" tabindex="-1">Java installieren <a class="header-anchor" href="#java-installieren" aria-hidden="true">#</a></h2><p>Java mind. 17 unter debain 11 installieren:</p><div class="language-bash"><pre><code>		<span class="token function">apt</span> <span class="token function">install</span> openjdk-17-jdk-headless -y
</code></pre></div><p>Den Pfad setzen, aktualisieren und dauehaft verf\xFCgbar machen, unter dem Java zu finden ist:</p><div class="language-bash"><pre><code>		<span class="token assign-left variable"><span class="token environment constant">PATH</span></span><span class="token operator">=</span>/usr/lib/jvm/java-17-openjdk-amd64/bin:<span class="token environment constant">$PATH</span>
		<span class="token builtin class-name">export</span> <span class="token environment constant">PATH</span>
		<span class="token builtin class-name">echo</span> <span class="token string">&quot;JAVA_HOME:/usr/lib/jvm/java-17-openjdk-amd64&quot;</span> <span class="token operator">&gt;&gt;</span> /etc/environment
</code></pre></div><h2 id="nodejs-installieren" tabindex="-1">NodeJs installieren <a class="header-anchor" href="#nodejs-installieren" aria-hidden="true">#</a></h2><p>node.js mind. Version 16 herunterladen und installieren:</p><div class="language-bash"><pre><code>		<span class="token function">curl</span> -fsSL https://deb.nodesource.com/setup_16.x <span class="token operator">|</span> <span class="token function">bash</span> -
		<span class="token function">apt</span> <span class="token function">install</span> nodejs -y
		<span class="token builtin class-name">echo</span> <span class="token string">&quot;prefix=~/.npm&quot;</span> <span class="token operator">&gt;</span> ~/.npmrc
</code></pre></div><h2 id="svws-server-sources-herunterladen-und-bauen" tabindex="-1">SVWS-Server Sources herunterladen und bauen <a class="header-anchor" href="#svws-server-sources-herunterladen-und-bauen" aria-hidden="true">#</a></h2><p>Das Verzeichnis erstellen, unter der die Software zu finden ist:</p><div class="language-bash"><pre><code>		<span class="token function">mkdir</span> /app
		<span class="token builtin class-name">cd</span> /app
</code></pre></div><p>Git Quellen einrichten und Repositories clonen:</p><div class="language-bash"><pre><code>		<span class="token builtin class-name">export</span> <span class="token assign-left variable">GITHUB_ACTOR</span><span class="token operator">=</span>Geben_Sie_hier_ihre_Daten_an 
		<span class="token builtin class-name">export</span> <span class="token assign-left variable">GITHUB_TOKEN</span><span class="token operator">=</span>Geben_Sie_hier_ihre_Daten_an 
		<span class="token builtin class-name">export</span> <span class="token assign-left variable">SCHILD_PW</span><span class="token operator">=</span>Geben_Sie_hier_ihre_Daten_an 
		<span class="token function">git</span> clone https://<span class="token variable">\${GITHUB_TOKEN}</span>:x-oauth-basic@github.com//SVWS-NRW/SVWS-UI-Framework.git
		<span class="token function">git</span> clone https://<span class="token variable">\${GITHUB_TOKEN}</span>:x-oauth-basic@github.com/FPfotenhauer/SVWS-Server.git
		<span class="token function">git</span> clone https://<span class="token variable">\${GITHUB_TOKEN}</span>:x-oauth-basic@github.com/FPfotenhauer/SVWS-Client.git
</code></pre></div><p>F\xFCr die weitere Installation wird noch ein gradle.properties File angelegt</p><div class="language-bash"><pre><code>		<span class="token function">cat</span> <span class="token operator">&gt;</span> ~/.gradle/gradle.properties  <span class="token operator">&lt;&lt;-</span>EOF
		<span class="token assign-left variable">github_actor</span><span class="token operator">=</span><span class="token variable">$GITHUB_ACTOR</span>
		<span class="token assign-left variable">github_token</span><span class="token operator">=</span><span class="token variable">$GITHUB_TOKEN</span>
		<span class="token assign-left variable">schild2_access_password</span><span class="token operator">=</span><span class="token variable">$SCHILD_PW</span>
		EOF
</code></pre></div><p>Um den Developer branch zu w\xE4hlen muss jeweils noch <code>git checkout dev</code> vor dem Build Prozess erfolgen. Hier kann nat\xFCrlich auch (bald) ausprobiert werden und ein anderer Branch gew\xE4hlt werden. Nun wird nacheinander das UI-Framework, der Server und der Client gebaut. Bitte diese Reihenfolge einhalten:</p><div class="language-bash"><pre><code>		<span class="token builtin class-name">cd</span> /app/SVWS-UI-Framework
		<span class="token function">git</span> checkout dev
		./gradlew build

		<span class="token builtin class-name">cd</span> /app/SVWS-Server
		<span class="token function">git</span> checkout dev
		./gradlew build
		
		<span class="token builtin class-name">cd</span> /app/SVWS-Client
		<span class="token function">git</span> checkout dev
		./gradlew build
</code></pre></div><h2 id="starten-des-svws-servers" tabindex="-1">Starten des SVWS-Servers <a class="header-anchor" href="#starten-des-svws-servers" aria-hidden="true">#</a></h2><p>Es muss vor dem Starten des SVWS-Servers nun die Konfiguration des SVWS-Servers in der Datei <code>svwsconfig.json</code> gespeichert werden:</p><div class="language-bash"><pre><code>		<span class="token builtin class-name">echo</span> <span class="token string">&#39;
		{
		&quot;EnableClientProtection&quot; : null,
		&quot;DisableDBRootAccess&quot; : false,
		&quot;DisableAutoUpdates&quot; : null,
		&quot;UseHTTPDefaultv11&quot; : false,
		&quot;PortHTTPS&quot; : 443,
		&quot;UseCORSHeader&quot; : true,
		&quot;TempPath&quot; : &quot;tmp&quot;,
		&quot;TLSKeyAlias&quot; : null,
		&quot;TLSKeystorePath&quot; : &quot;svws-server-app&quot;,
		&quot;TLSKeystorePassword&quot; : &quot;svwskeystore&quot;,
		&quot;ClientPath&quot; : &quot;../SVWS-Client/build/output&quot;,
		&quot;LoggingEnabled&quot; : true,
		&quot;LoggingPath&quot; : &quot;logs&quot;,
		&quot;DBKonfiguration&quot; : {
			&quot;dbms&quot; : &quot;MARIA_DB&quot;,
			&quot;location&quot; : &quot;127.0.0.1&quot;,
			&quot;defaultschema&quot; : null,
			&quot;SchemaKonfiguration&quot; : []
			}
		}
		&#39;</span> <span class="token operator">&gt;</span> /app/SVWS-Server/svwsconfig.json 
</code></pre></div><p>Es m\xFCssen weiterhin die richtigen Rechte gesetzt werden, um den SVWS-Server nicht mit root-Rechten starten zu wollen:</p><div class="language-bash"><pre><code>		<span class="token function">chown</span> -R svws:svws /app/
</code></pre></div><p>manueller Start des SVWS-Server:</p><div class="language-bash"><pre><code>		<span class="token builtin class-name">cd</span> /app/SVWS-Server/
		./start_server.sh <span class="token operator">&amp;</span>
</code></pre></div><h2 id="einrichten-des-servers-als-dienst" tabindex="-1">Einrichten des Servers als Dienst <a class="header-anchor" href="#einrichten-des-servers-als-dienst" aria-hidden="true">#</a></h2><p>Erstelle eine Datei zur Beschreibung und Bedienung des Dienstes per systemd:</p><div class="language-bash"><pre><code>		<span class="token builtin class-name">echo</span> <span class="token string">&quot;
		[Unit]
		Description=SVWS Server
		
		[Service]
		User=svws
		Type=simple
		WorkingDirectory = /app/SVWS-Server
		ExecStart=/bin/bash /app/SVWS-Server/start_server.sh
		# Restart=on-failure 	# optional-auskommentieren, wenn gew\xFCnscht
		# RestartSec=5s 		# optional-auskommentieren, wenn gew\xFCnscht
		StandardOutput=journal 
		
		[Install]
		WantedBy=multi-user.target
		
		&quot;</span> <span class="token operator">&gt;</span> /etc/systemd/system/svws.service
</code></pre></div><p>Den Dienst nun noch fest einbinden, so dass er beim Neustart gestartet wird:</p><div class="language-bash"><pre><code>		systemctl <span class="token builtin class-name">enable</span> svws
</code></pre></div><p>Nun noch den Server folgenden Befehlen starten:</p><div class="language-bash"><pre><code>		systemctl start svws
</code></pre></div><h2 id="fehlersuche-und-fehleranalyse" tabindex="-1">Fehlersuche und Fehleranalyse <a class="header-anchor" href="#fehlersuche-und-fehleranalyse" aria-hidden="true">#</a></h2><h3 id="neustart-der-dienste" tabindex="-1">Neustart der Dienste <a class="header-anchor" href="#neustart-der-dienste" aria-hidden="true">#</a></h3><p>Zum Neustart des Servers braucht man \xFCblicherweise unter Linux nicht das gesammte System neu starten sondern kann einfach nur den Dienst neustarten oder auch ggf. stoppen:</p><div class="language-bash"><pre><code>		systemctl restart svws

		systemctl stop svws
</code></pre></div><p>Ebenso kann man nat\xFCrlich auch den mysql Dienst starten, neustarten und beenden.</p><h3 id="fehlersuche-per-journal" tabindex="-1">Fehlersuche per Journal <a class="header-anchor" href="#fehlersuche-per-journal" aria-hidden="true">#</a></h3><p>Vermutet man Abst\xFCrze des Servers, so lohnt sich ein Blick in die Log files:</p><div class="language-bash"><pre><code>		journalctl  -f -u svws
</code></pre></div><p>Zus\xE4tzlich kann man, um einen regelm\xE4\xDFigen Restart zu erm\xF6glichen, den 5 sek\xFCndigen Neustart wie oben beschrieben erzwingen. So erh\xE4lt man ggf. auch regelm\xE4\xDFige Eintr\xE4ge bzw. direkt Eintr\xE4ge nach Absturz des Servers.</p>`,66),i=[r];function l(o,c,d,p,u,h){return t(),n("div",null,i)}var v=e(a,[["render",l]]);export{b as __pageData,v as default};
