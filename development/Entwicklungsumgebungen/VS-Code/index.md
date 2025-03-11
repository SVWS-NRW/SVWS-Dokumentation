# Visual Studio Code als Entwicklungsumgebung

## Installation unter Ubuntu

Es wird empfohlen, den Anweisungen auf der offiziellen Installationsseite von VS Code zu folgen, die hier veröffentlicht werden: https://code.visualstudio.com/docs/setup/linux

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

NODE_MAJOR=22
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
code --install-extension vue.volar
# Icons Vorschau
code --install-extension antfu.iconify
# Playwright Tests
code --install-extension ms-playwright.playwright

# gradle Paket für alle Projekte
code --install-extension richardwillis.vscode-gradle-extension-pack
# Java für vs Code. Ein Paket für alles
code --install-extension vscjava.vscode-java-pack
```

## Tipps

Für die Entwicklung der verschiedenen Unterprojekte mit Vue und Typescript empfiehlt es sich,
ein jeweils eigenes Fenster pro Unterprojekt zu öffnen.

Um zum Beispiel am Client zu arbeiten, sollte ein neues Fenster unter `svws-webclient/client`
angelegt werden, damit die Erweiterungen wie `volar` und `eslint` vernünftig funktionieren.

Sind zu viele VS Code Fenster geöffnet, empfiehlt sich die Peacock-Erweiterung, mit der
man die verschiedenen Fenster mit unterschiedlichen Farben ausstatten kann.

## lokale Settings

Diese Einstellungen werden genutzt:

```json
{
    "[java]": {
        "editor.insertSpaces": false,
        "editor.tabSize": 4
    },
    "[typescript, javascript]": {
        "editor.defaultFormatter": "dbaeumer.vscode-eslint",
        "editor.tabSize": 2
    },
    "[vue]": {
        "editor.defaultFormatter": "Vue.volar"
    },
    // AI abschalten
    "chat.commandCenter.enabled": false,
    "css.lint.unknownAtRules": "ignore",
    "css.validate": false,
    "diffEditor.ignoreTrimWhitespace": false,
    "editor.bracketPairColorization.enabled": true,
    // Vorschläge auch aus Kommentaren machen
    "editor.quickSuggestions": {
        "comments": "on",
        "other": "on",
        "strings": "on"
    },
    "editor.renderControlCharacters": true,
    "editor.renderWhitespace": "trailing",
    // drei Linien im Editor auf den jeweiligen Spalten
    "editor.rulers": [
        80,
        120,
        160
    ],
    "editor.suggest.localityBonus": true,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "on",
    "editor.tabSize": 2,
    "eslint.format.enable": true,
    "eslint.workingDirectories": [],
    // gruppierte Anzeige von Dateien, die zusammengehören
	  "explorer.fileNesting.expand": true,
    "explorer.fileNesting.patterns": {
        "*.vue": "${capture}.story.vue, ${capture}.test.ts, ${capture}.css, ${capture}.story.md, ${capture}Props.ts",
        "*.java": "${capture}.md",
        "Route*.ts": "RouteData${capture}.ts"
    },
    // ganze Verzeichnisse herausfiltern, die man nicht sehen möchte
    "files.exclude": {
        "**/.eslintcache": true,
        "**/.gradle": true,
        "**/.histoire": true,
        "**/.idea": true,
        "**/.vscode": true,
        "**/bin": true,
        "**/build": true,
        "**/coverage": true,
        "**/dist": true,
        "**/logs": true,
        "**/node_modules": true
    },
    // AI abschalten
    "gitlab.duo.enabledWithoutGitlabProject": false,
    "gitlab.duoCodeSuggestions.enabled": false,
    "gitlab.duoCodeSuggestions.openTabsContext": false,
    "gitlab.keybindingHints.enabled": false,
    "java.checkstyle.configuration": "${workspaceFolder}/config/checkstyle/checkstyle.xml",
    "java.cleanup.actions": [
        "addOverride",
        "addDeprecated",
        "invertEquals",
        "addFinalModifier",
        "lambdaExpressionFromAnonymousClass",
        "renameFileToType"
    ],
    "java.compile.nullAnalysis.mode": "automatic",
    "java.configuration.updateBuildConfiguration": "automatic",
    "java.format.settings.profile": "SVWS-Server-Formatter",
    "java.format.settings.url": "./config/eclipse/Eclipse_Formatter.xml",
    "java.saveActions.cleanup": true,
    // hier kann man aus dem Explorer heraus scripte starten, die in der package.json sind
    "npm.packageManager": "npm",
    "sonarlint.connectedMode.project": {
        "connectionId": "https-sonarqube-svws-nrw-de",
        "projectKey": "svws-server"
    },
    // Damit Tailwind funktioniert
    "tailwindCSS.experimental.configFile": "svws-webclient/ui/src/assets/styles/index.css",
    "typescript.preferences.preferTypeOnlyAutoImports": true,
    "typescript.tsdk": "node_modules/typescript/lib",
    "vue.autoInsert.dotValue": true,
    "vue.format.script.initialIndent": true,
    "vue.format.style.initialIndent": true,
    "vue.inlayHints.missingProps": true,
    "vue.inlayHints.optionsWrapper": true,
}
```

# Code Styles einrichten
Die Code Styles in VSCode werden automatisiert durch ein Gradle Project Reload oder Build in den Workspace geladen. Eigene Konfigurationen sind nicht möglich. \
Wie die Code Styles für alle Entwickler angepasst werden können, kann in der Anleitung [Code Styles](../Code-Styles/index.md) nachgelesen werden.
