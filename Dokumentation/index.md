# Dokumentation

Ziel dieser Dokumentation ist es die Funktionsweise, verwendete Software, Verabredete Arbeitsweisen u.v.m. neuen Entwicklerung zur verfügung zu stellen. 

Die Dokumentation erfolgt im MarkDownformat (.md) und beginnt in jedem Unterordner, abweichend vom klassischen Git-Vorgehen, als [index.md]() File. 

Die Files als index.md werden automatisch beim einchecken per git und dem anschließendem build verlinkt und eine entsprechende sidebar erzeugt. 
Dies geschieht über das Einbinden von [VitePress](https://vitepress.vuejs.org/)

## Darstellung der Dokumentation

### Firefox plugin

Es gibt mehrere Firefox plugins zur Darstellung der .md Files im likalen Browser

### Gitlab

Die Dokumentation kann im klassischen Stil unter Giltlab angesehen werden. 

### VitePress 

#### Erstellung der Webseiten 


		apt update 
		apt upgrade
		apt install -y ssh nmap curl git zip net-tools dnsutils software-properties-common dirmngr nginx


node 18 installieren

		curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
		apt install nodejs -y
		echo "prefix=~/.npm" > ~/.npmrc
 
Dokumentation ins entsprechende Verzeichnis laden

cd /var/www/

git clone https://git.svws-nrw.de/svws/svws-dokumentation/

cd svws-dokumentation/

npm install 

npm run build

die Quelle im nginx eintragen: 

		nano /etc/nginx/sites-enabled/default
 
 in dieser Datein einfach das root Verzeichnis setzen 
 
  root /var/www/svws-dokumentation/.vitepress/dist;

Und den nginx neustarten: 

		nginx -t
		nginx -s reload



im dist/ inst die index.html