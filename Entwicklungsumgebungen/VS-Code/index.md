# Visual Studio Code als Entwicklungsumgebung

## Installation unter Ubuntu

 Vorbereitungen: 

```bash
sudo apt update && upgrade -y 

sudo apt install -y dnsutils net-tools zip curl git wget software-properties-common apt-transport-https gpg

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt update
```

vscode installieren:

```bash
sudo apt install -y temurin-21-jdk nodejs code 
```

## Hilfreiche PlugIns

Hier einige hilfreiche Tipps für VS Code im Einsatz zur Server/Client-Entwicklung.

Praktische Erweiterungen sind diese hier (mit Befehl zur Installation unter *X Systemen):

```bash
# Tailwind Intellisense (Client)
code --install-extension bradlc.vscode-tailwindcss
# PostCSS
code --install-extension cpylua.language-postcss
# ESLint für den Client
code --install-extension dbaeumer.vscode-eslint
# verschiedene Farben für die geöffneten vs Code-Fenster
code --install-extension johnpapa.vscode-peacock
# automatische Template Strings für den Client
code --install-extension meganrogge.template-string-converter
# volar für vue/Client
code --install-extension johnsoncodehk.volar
# Icons Vorschau
code --install-extension antfu.iconify
# Playwright Tests
code --install-extension ms-playwright.playwright

# gradle Paket für alle Projekte
code --install-extension richardwillis.vscode-gradle-extension-pack
# Java für vs Code. Ein Paket für alles
code --install-extension vscjava.vscode-java-pack
