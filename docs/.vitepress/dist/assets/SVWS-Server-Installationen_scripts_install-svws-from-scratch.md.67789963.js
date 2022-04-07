import{_ as n,y as s,x as a,W as t}from"./plugin-vue_export-helper.68280688.js";const g='{"title":"#","description":"","frontmatter":{},"relativePath":"SVWS-Server-Installationen/scripts/install-svws-from-scratch.md","lastUpdated":1649314111101}',e={},o=t(`<div class="language-bash"><pre><code><span class="token shebang important">#!/bin/bash</span>
<span class="token comment">########################################################################</span>
<span class="token comment">#</span>
<span class="token comment"># geschrieben f\xFCr LXC Container mit linux debian 11 auf einem Proxmox</span>
<span class="token comment">#</span>
<span class="token comment">#</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;#######################&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;#SVWS Installer Script#&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;#######################&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;links zum repository: &quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;https://gitlab.svws-nrw.de/&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;https://github.com/svws-nrw/&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>
	<span class="token builtin class-name">echo</span> <span class="token string">&quot;&quot;</span>

	<span class="token comment"># Vorgaben:</span>
	<span class="token assign-left variable">INST_PATH</span><span class="token operator">=</span><span class="token string">&quot;/app&quot;</span>
	<span class="token assign-left variable">SCHILD_PW</span><span class="token operator">=</span><span class="token string">&quot;DasUeblichSchildMDB-PW&quot;</span>
	<span class="token assign-left variable">SVWS_USER</span><span class="token operator">=</span><span class="token string">&quot;svws&quot;</span>
	<span class="token assign-left variable">JAVA_TOOL_OPTIONS</span><span class="token operator">=</span>-Dfile.encoding<span class="token operator">=</span>UTF-8

	<span class="token assign-left variable">SVWS_PW</span><span class="token operator">=</span><span class="token string">&quot;svwsadmin&quot;</span>
	<span class="token assign-left variable">SVWS_DB_PW</span><span class="token operator">=</span><span class="token string">&quot;svwsadmin&quot;</span>

	<span class="token comment">#Abfragen der Einstellungen:</span>
	<span class="token builtin class-name">read</span> -rp <span class="token string">&quot;Bitte GITHUB Benutzernamen angeben: &quot;</span> -e -i <span class="token string">&quot;<span class="token variable">\${GITHUB_ACTOR}</span>&quot;</span> GITHUB_ACTOR
	<span class="token builtin class-name">read</span> -rp <span class="token string">&quot;Bitte GITHUB Token angeben: &quot;</span> -e -i <span class="token string">&quot;<span class="token variable">\${GITHUB_TOKEN}</span>&quot;</span> GITHUB_TOKEN
	<span class="token builtin class-name">read</span> -rp <span class="token string">&quot;Bitte SCHILD MDB Passwort angeben: &quot;</span> -e -i <span class="token string">&quot;<span class="token variable">\${SCHILD_PW}</span>&quot;</span> SCHILD_PW
	<span class="token builtin class-name">read</span> -rp <span class="token string">&quot;Bitte das Passwort f\xFCr den Benutzer svws, unter der der Dienst l\xE4uft, angeben: &quot;</span> -e -i <span class="token string">&quot;<span class="token variable">\${SVWS_PW}</span>&quot;</span> SVWS_PW
	<span class="token builtin class-name">read</span> -rp <span class="token string">&quot;Bitte das Maria-DB root-Passwort angeben: &quot;</span> -e -i <span class="token string">&quot;<span class="token variable">\${SVWS_DB_PW}</span>&quot;</span> SVWS_DB_PW

<span class="token builtin class-name">echo</span> <span class="token string">&quot;
Installationspfad des SVWS-Servers: &#39;<span class="token variable">$INST_PATH</span>&#39;

Linux User &#39;svws&#39; 
Passwort: &#39;<span class="token variable">$SVWS_PW</span>&#39;

Maria-DB User &#39;root&#39; 
Passwort: &#39;<span class="token variable">$SVWS_DB_PW</span>&#39;

&quot;</span> <span class="token operator">&gt;</span> SVWS-Zugangsdaten.txt

<span class="token function">chmod</span> -r -w SVWS-Zugangsdaten.txt

  
<span class="token comment">#########################################################################</span>
<span class="token comment">####################### install skript ##################################</span>
<span class="token comment">#########################################################################</span>


<span class="token comment"># teste, ob das script mit rootrechten ausgef\xFChrt wird:  </span>
<span class="token keyword">if</span> <span class="token punctuation">[</span><span class="token punctuation">[</span> <span class="token environment constant">$EUID</span> <span class="token operator">=</span> <span class="token number">0</span> <span class="token operator">&amp;&amp;</span> <span class="token string">&quot;<span class="token variable"><span class="token variable">$(</span><span class="token function">ps</span> -o <span class="token assign-left variable">comm</span><span class="token operator">=</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token function">su</span> <span class="token operator">|</span> <span class="token function">sed</span> -n <span class="token string">&#39;1p&#39;</span><span class="token variable">)</span></span>&quot;</span> <span class="token operator">=</span> <span class="token string">&quot;su&quot;</span> <span class="token punctuation">]</span><span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span>
   <span class="token builtin class-name">echo</span> <span class="token string">&quot;This script must be run as root&quot;</span> 
   <span class="token builtin class-name">exit</span> <span class="token number">1</span>
<span class="token keyword">fi</span>




<span class="token comment">##########################################################</span>
<span class="token comment"># user anlegen, der nicht root ist und den Dienst betreiben soll</span>
<span class="token function">useradd</span>	-m -G <span class="token function">users</span> -s /bin/bash <span class="token variable">$SVWS_USER</span>
<span class="token builtin class-name">echo</span> -e <span class="token string">&#39;$SVWS_PW
$SVWS_PW
&#39;</span> <span class="token operator">|</span> <span class="token function">passwd</span> <span class="token variable">$SVWS_USER</span>

<span class="token comment"># kopiere die install.conf.sh in das Installationsverzeichnis f\xFCr sp\xE4teren Aufruf</span>
<span class="token comment"># lege installationsverzeichnis an </span>
<span class="token function">mkdir</span> <span class="token variable">$INST_PATH</span>
<span class="token builtin class-name">cd</span> <span class="token variable">$INST_PATH</span>


<span class="token comment">############################################</span>
<span class="token comment"># upgrade und installiere die folgenden Pakete:</span>

<span class="token function">apt</span> update -y
<span class="token function">apt</span> dist-upgrade -y

<span class="token function">apt</span> <span class="token function">install</span> <span class="token function">ssh</span> nmap <span class="token function">curl</span> <span class="token function">git</span> <span class="token function">zip</span> net-tools dnsutils software-properties-common dirmngr -y

<span class="token comment"># Maria DB (mind.) 10.6  unter debain 11 installieren: </span>
<span class="token function">wget</span> https://mariadb.org/mariadb_release_signing_key.asc
<span class="token function">chmod</span> -c <span class="token number">644</span> mariadb_release_signing_key.asc
<span class="token function">mv</span> -vi mariadb_release_signing_key.asc /etc/apt/trusted.gpg.d/

<span class="token builtin class-name">echo</span> <span class="token string">&quot;deb [arch=amd64,arm64,ppc64el] https://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.6/debian bullseye main&quot;</span> <span class="token operator">|</span> <span class="token function">tee</span> /etc/apt/sources.list.d/mariadb.list

<span class="token function">apt</span> update
<span class="token function">apt</span> <span class="token function">install</span> mariadb-server -y 

<span class="token comment"># Java (mind. 17) unter debain 11 installieren:</span>
<span class="token function">apt</span> <span class="token function">install</span> openjdk-17-jdk-headless -y

<span class="token comment"># Path setzen, aktualisieren und dauehaft verf\xFCgbar machen:</span>
<span class="token assign-left variable"><span class="token environment constant">PATH</span></span><span class="token operator">=</span>/usr/lib/jvm/java-17-openjdk-amd64/bin:<span class="token environment constant">$PATH</span>
<span class="token builtin class-name">export</span> <span class="token environment constant">PATH</span>
<span class="token builtin class-name">echo</span> <span class="token string">&quot;JAVA_HOME:/usr/lib/jvm/java-17-openjdk-amd64&quot;</span> <span class="token operator">&gt;&gt;</span> /etc/environment


<span class="token comment"># node (mind. 16) installieren</span>
<span class="token function">curl</span> -fsSL https://deb.nodesource.com/setup_16.x <span class="token operator">|</span> <span class="token function">bash</span> -

<span class="token function">apt</span> <span class="token function">install</span> nodejs -y
<span class="token comment"># npm install -g npm@7.20.5</span>



<span class="token comment">######################################################</span>
<span class="token comment"># richte die MariaDB ein und setze das root-Passwort</span>

<span class="token comment"># alte syntax: </span>
<span class="token comment"># UPDATE mysql.user SET plugin = &#39;mysql_native_password&#39;, authentication_string = PASSWORD(&#39;$SVWS_USER&#39;), Password=PASSWORD(&#39;$SVWS_PW&#39;) WHERE user = &#39;root&#39;;</span>


<span class="token builtin class-name">echo</span> <span class="token string">&quot;
ALTER USER &#39;root&#39;@&#39;localhost&#39; IDENTIFIED BY &#39;<span class="token variable">$SVWS_DB_PW</span>&#39;;
DELETE FROM mysql.user WHERE User=&#39;&#39;;
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db=&#39;test&#39; OR Db=&#39;test<span class="token entity" title="\\\\">\\\\</span>_%&#39;;
FLUSH PRIVILEGES;
&quot;</span> <span class="token operator">&gt;</span> mysql_secure_installation.sql

mysql <span class="token operator">&lt;</span> mysql_secure_installation.sql


<span class="token function">rm</span> mysql_secure_installation.sql 
<span class="token comment">#####################################################</span>
<span class="token comment"># </span>
<span class="token comment">#######################################################################</span>
<span class="token comment">############ SVWS Software abholen ####################################</span>
<span class="token comment">#######################################################################</span>
<span class="token comment"># Stelle npm so ein, dass Module auf Benutzerebene installiert werden</span>


<span class="token builtin class-name">echo</span> <span class="token string">&quot;prefix=~/.npm&quot;</span> <span class="token operator">&gt;</span> ~/.npmrc

<span class="token comment">########### git clone #################################################</span>

<span class="token builtin class-name">cd</span> <span class="token variable">$INST_PATH</span>



<span class="token comment"># TODO: git clone auf unserem Gitlab einrichten!!!!</span>
<span class="token comment"># git clone https://\${GITHUB_USER}:\${GITHUB_TOKEN}@git.svws-nrw.de/svws/SVWS-Server</span>

<span class="token function">git</span> clone https://<span class="token variable">\${GITHUB_TOKEN}</span>:x-oauth-basic@github.com//SVWS-NRW/SVWS-UI-Framework.git
<span class="token function">git</span> clone https://<span class="token variable">\${GITHUB_TOKEN}</span>:x-oauth-basic@github.com/FPfotenhauer/SVWS-Server.git
<span class="token function">git</span> clone https://<span class="token variable">\${GITHUB_TOKEN}</span>:x-oauth-basic@github.com/FPfotenhauer/SVWS-Client.git

<span class="token comment">#### token in gradle hinterlegen #############################</span>
<span class="token function">mkdir</span> ~/.gradle

<span class="token function">cat</span> <span class="token operator">&gt;</span> ~/.gradle/gradle.properties  <span class="token operator">&lt;&lt;-</span><span class="token string">EOF
github_actor=<span class="token variable">$GITHUB_ACTOR</span>
github_token=<span class="token variable">$GITHUB_TOKEN</span>
schild2_access_password=<span class="token variable">$SCHILD_PW</span>
EOF</span>



<span class="token comment">#######################################################################</span>
<span class="token comment"># Baue das UI-Framework</span>
<span class="token comment">#######################################################################</span>
<span class="token builtin class-name">cd</span> <span class="token variable">$INST_PATH</span>/SVWS-UI-Framework
<span class="token function">git</span> checkout dev
./gradlew build
<span class="token comment"># Alternative Vorgehensweise: </span>
<span class="token comment">#npm i</span>
<span class="token comment">#npm audit fix --force</span>
<span class="token comment"># ### Fehler kann ignoriert werden:</span>
<span class="token comment"># npm ERR! code ETARGET</span>
<span class="token comment"># npm ERR! notarget No matching version found for @storybook/vue3@6.1.21.</span>
<span class="token comment"># npm ERR! notarget In most cases you or one of your dependencies are requesting</span>
<span class="token comment"># npm ERR! notarget a package version that doesn&#39;t exist.</span>
<span class="token comment"># ###</span>
<span class="token comment">#npm run build</span>
<span class="token comment"># lokalen Link erstellen</span>
<span class="token comment">#npm link</span>

<span class="token comment">#</span>
<span class="token comment">#</span>
<span class="token comment">#</span>
<span class="token comment">#</span>
<span class="token comment">#</span>
<span class="token comment">#######################################################################</span>
<span class="token comment"># Baue den Server</span>
<span class="token comment">#######################################################################</span>
<span class="token builtin class-name">cd</span> <span class="token variable">$INST_PATH</span>/SVWS-Server
<span class="token function">git</span> checkout dev
./gradlew build
<span class="token comment"># falls es zu problemen kommt: kann man noch einen zweiten Durchgang machen: </span>
<span class="token comment"># ./gradlew svws-core-ts:assemble</span>
<span class="token comment"># erstelle eine svwsconfig.json f\xFCr den HTTP-Server mit Standardeinstellungen</span>


<span class="token function">cat</span> <span class="token operator">&gt;</span> <span class="token variable">$INST_PATH</span>/SVWS-Server/svwsconfig.json <span class="token operator">&lt;&lt;-</span><span class="token string">EOF
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
EOF</span>
<span class="token comment"># </span>



<span class="token comment">#########################################################################</span>
<span class="token comment"># Baue den Client</span>
<span class="token comment">#########################################################################</span>
<span class="token builtin class-name">cd</span> <span class="token variable">$INST_PATH</span>/SVWS-Client
<span class="token function">git</span> checkout dev
./gradlew build

<span class="token comment">#</span>
<span class="token comment">########################################################################</span>
<span class="token comment">#svws als Dienst einrichten:</span>


<span class="token builtin class-name">echo</span> <span class="token string">&quot;
[Unit]
Description=SVWS Server

[Service]
User=svws
Type=simple
WorkingDirectory = <span class="token variable">$INST_PATH</span>/SVWS-Server
ExecStart=/bin/bash <span class="token variable">$INST_PATH</span>/SVWS-Server/start_server.sh
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target

&quot;</span> <span class="token operator">&gt;</span> /etc/systemd/system/svws.service


<span class="token comment"># die richtigen Rechte setzten: </span>
<span class="token function">chown</span> -R svws:svws /app/


<span class="token comment">########################################################################</span>
<span class="token comment"># service starten: </span>
<span class="token comment">########################################################################</span>
systemctl <span class="token builtin class-name">enable</span> svws
systemctl start svws



<span class="token comment">################## End des Skripts ###########################</span>
<span class="token comment">##############################################################</span>
<span class="token comment">##############################################################</span>

<span class="token comment">########################################################################</span>
<span class="token comment"># N\xFCtzliche Hinweise:</span>
<span class="token comment">########################################################################</span>

<span class="token comment"># manueller Start des SVWS-Server:</span>
<span class="token comment">#</span>
<span class="token comment"># cd /$INST_PATH/SVWS-Server/</span>
<span class="token comment">#./start_server.sh &amp;</span>
<span class="token comment">#</span>

<span class="token comment"># im Journal nach Fehlermeldungen suchen: </span>
<span class="token comment">#</span>
<span class="token comment"># journalctl  -f -u svws</span>


<span class="token comment"># Testdatenbank importieren und Benutzernamen setzen:</span>
<span class="token comment">#</span>
<span class="token comment"># zuerst eine mdb &quot;irgendwoher&quot; runterladen</span>
<span class="token comment"># \xFCber die Oberfl\xE4che: localhost/debug/</span>


</code></pre></div>`,1),p=[o];function c(l,i,r,u,m,k){return a(),s("div",null,p)}var b=n(e,[["render",c]]);export{g as __pageData,b as default};
