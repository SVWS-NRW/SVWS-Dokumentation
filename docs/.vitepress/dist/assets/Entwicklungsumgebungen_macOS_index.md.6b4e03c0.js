import{_ as n,y as s,x as e,W as t}from"./plugin-vue_export-helper.68280688.js";const q='{"title":"macOS","description":"","frontmatter":{},"relativePath":"Entwicklungsumgebungen/macOS/index.md","lastUpdated":1649311654589}',a={},o=t(`<h1 id="macos" tabindex="-1">macOS <a class="header-anchor" href="#macos" aria-hidden="true">#</a></h1><p>F\xFCr die Entwicklung auf macOS ist der Einsatz von homebrew und Docker vorteilhaft. Dies gilt sowohl f\xFCr Rechner mit Intel CPU als auch mit M1.</p><p>Homebrew (<a href="http://brew.sh" target="_blank" rel="noopener noreferrer">brew.sh</a>) wird genutzt, um ben\xF6tigte Software vom Terminal aus zu installieren, Docker ist f\xFCr den Einsatz der MariaDB zu empfehlen.</p><p>Das Script nutzt noch die GitHub-Token. Wenn es jemand auf diesem Weg ausprobiert, bitte die Doku an den entsprechenden Stellen anpassen.</p><div class="language-bash"><pre><code><span class="token comment"># Installiere Homebrew:</span>
/bin/bash -c <span class="token string">&quot;<span class="token variable"><span class="token variable">$(</span><span class="token function">curl</span> -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh<span class="token variable">)</span></span>&quot;</span>

<span class="token comment"># nun die ben\xF6tigten Programme:</span>
brew <span class="token function">install</span> <span class="token function">node</span> <span class="token function">git</span> openjdk@11

<span class="token comment"># Java f\xFCr den Server einrichten</span>
<span class="token function">sudo</span> <span class="token function">ln</span> -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

<span class="token comment"># den Docker Desktop:</span>
brew <span class="token function">install</span> --cask <span class="token function">docker</span>

<span class="token comment"># wer mag, den VS Code</span>
brew <span class="token function">install</span> visual-studio-code

<span class="token comment"># Erstelle zwei Umgebungsvariablen f\xFCr Zugriff auf die privaten Repos</span>
<span class="token builtin class-name">export</span> <span class="token assign-left variable">GITHUB_ACTOR</span><span class="token operator">=</span><span class="token string">&quot;Dein_GH_User&quot;</span>
<span class="token builtin class-name">export</span> <span class="token assign-left variable">GITHUB_TOKEN</span><span class="token operator">=</span><span class="token string">&quot;Dein_GH_Token&quot;</span>
<span class="token comment"># Diese k\xF6nnen auch in der .zshrc abgelegt werden</span>

<span class="token comment"># UI-Framework einrichten:</span>
<span class="token function">git</span> clone git@github.com:SVWS-NRW/SVWS-UI-Framework.git
<span class="token builtin class-name">cd</span> SVWS-UI-Framework
<span class="token function">git</span> checkout dev
<span class="token function">npm</span> <span class="token function">install</span>
<span class="token function">npm</span> build
<span class="token function">npm</span> <span class="token function">link</span>
<span class="token builtin class-name">cd</span> <span class="token punctuation">..</span>

<span class="token function">git</span> clone git@github.com:FPfotenhauer/SVWS-Server.git
<span class="token builtin class-name">cd</span> SVWS-Server
<span class="token function">git</span> checkout dev
./gradlew assemble

<span class="token comment"># Bitte den Pfad unten anpassen:</span>
<span class="token function">tee</span> svws-server-app/svwsconfig.json <span class="token operator">&lt;&lt;</span><span class="token string">EOF
{
  &quot;EnableClientProtection&quot; : null,
  &quot;DisableDBRootAccess&quot; : false,
  &quot;DisableAutoUpdates&quot; : null,
  &quot;UseHTTPDefaultv11&quot; : false,
  &quot;PortHTTPS&quot; : 443,
  &quot;UseCORSHeader&quot; : true,
  &quot;TempPath&quot; : &quot;tmp&quot;,
  &quot;TLSKeyAlias&quot; : null,
  &quot;TLSKeystorePath&quot; : &quot;.&quot;,
  &quot;TLSKeystorePassword&quot; : &quot;svwskeystore&quot;,
  &quot;ClientPath&quot; : &quot;PFAD_ZUM_/SVWS-Client/build/output&quot;,
  &quot;LoggingEnabled&quot; : true,
  &quot;LoggingPath&quot; : &quot;logs&quot;,
  &quot;DBKonfiguration&quot; : {
    &quot;dbms&quot; : &quot;MARIA_DB&quot;,
    &quot;location&quot; : &quot;127.0.0.1&quot;,
    &quot;defaultschema&quot; : null,
    &quot;SchemaKonfiguration&quot; : [ {
      &quot;name&quot; : &quot;svwsschema&quot;,
      &quot;svwslogin&quot; : false,
      &quot;username&quot; : &quot;svwsadmin&quot;,
      &quot;password&quot; : &quot;svwsadmin&quot;
    } ]
  }
}
EOF</span>

<span class="token builtin class-name">cd</span> <span class="token punctuation">..</span>

<span class="token comment"># und nun der Client:</span>
<span class="token function">git</span> clone git@github.com:FPfotenhauer/SVWS-Client.git
<span class="token builtin class-name">cd</span> SVWS-Client
<span class="token function">git</span> checkout integration
<span class="token function">npm</span> <span class="token function">install</span>
<span class="token function">npm</span> <span class="token function">link</span> @svws-nrw/svws-ui @svws-nrw/svws-openapi-ts @svws-nrw/svws-core-ts

<span class="token comment"># alle Komponenten sind nun vorbereitet und k\xF6nnen gestartet werden</span>
<span class="token comment"># Dazu den Server starten, am besten in einem eigenen Terminal, z.B. dem von code:</span>
<span class="token builtin class-name">cd</span> SVWS-Server/svws-server-app
./run_server.sh

<span class="token comment"># nun l\xE4uft der Server. Entweder direkt mit dem Client \xFCber https://localhost verbinden</span>
<span class="token comment"># oder den dev-Server starten des Clients:</span>

<span class="token builtin class-name">cd</span> SVWS-Client
<span class="token function">npm</span> run dev

<span class="token comment"># nun l\xE4uft auf http://localhost:3000 der dev-Server</span>
</code></pre></div>`,5),c=[o];function p(i,l,u,r,m,d){return e(),s("div",null,c)}var f=n(a,[["render",p]]);export{q as __pageData,f as default};
