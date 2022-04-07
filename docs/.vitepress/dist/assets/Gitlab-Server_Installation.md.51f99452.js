import{_ as e,y as t,x as a,W as r}from"./plugin-vue_export-helper.68280688.js";const b='{"title":"Vobereitung","description":"","frontmatter":{},"relativePath":"Gitlab-Server/Installation.md","lastUpdated":1649311654592}',n={},s=r(`<h1 id="gitlab-server-installation" tabindex="-1"><em><strong>GitLab-Server Installation</strong></em> <a class="header-anchor" href="#gitlab-server-installation" aria-hidden="true">#</a></h1><h1 id="vobereitung" tabindex="-1">Vobereitung <a class="header-anchor" href="#vobereitung" aria-hidden="true">#</a></h1><p>GitLab Installation am 14.11.21 auf 1blu Server mit Ubuntu 20.04 Setzen der A-Records <a href="http://git.svws-nrw.de" target="_blank" rel="noopener noreferrer">git.svws-nrw.de</a> und <a href="http://mattermost.svws-nrw.de" target="_blank" rel="noopener noreferrer">mattermost.svws-nrw.de</a> auf Host: <a href="http://v13146.1blu.de" target="_blank" rel="noopener noreferrer">v13146.1blu.de</a> (IP-Adresse: 178.254.39.56)</p><div class="language-"><pre><code>apt update
apt dist-upgrade -y
locale-gen &quot;en_US.UTF-8&quot;
update-locale LC_ALL=&quot;en_US.UTF-8&quot;

sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

sudo apt-get install -y postfix
</code></pre></div><p>Postfix Internet site, external mit <a href="http://git.svws-nrw.de" target="_blank" rel="noopener noreferrer">git.svws-nrw.de</a> angegeben</p><h1 id="gitlab-installation" tabindex="-1">GitLab Installation <a class="header-anchor" href="#gitlab-installation" aria-hidden="true">#</a></h1><div class="language-"><pre><code>curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL=&quot;https://git.svws-nrw.de&quot; apt-get install gitlab-ee
cat /etc/gitlab/initial_root_password
</code></pre></div><p>Installation nach Anleitung unter <a href="https://about.gitlab.com/install/#ubuntu" target="_blank" rel="noopener noreferrer">https://about.gitlab.com/install/#ubuntu</a></p><p>Benutzer f\xFCr Gitlab: root Passwort setzen</p><div class="language-"><pre><code>vi /etc/gitlab/gitlab.rb
# mattermost_external_url &#39;https://mattermost.svws-nrw.de&#39;
</code></pre></div><h1 id="backup-einrichten" tabindex="-1">Backup einrichten <a class="header-anchor" href="#backup-einrichten" aria-hidden="true">#</a></h1>`,11),i=[s];function o(l,d,p,c,u,h){return a(),t("div",null,i)}var _=e(n,[["render",o]]);export{b as __pageData,_ as default};
