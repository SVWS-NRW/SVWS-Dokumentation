# Anleitung für einen Publish auf npmjs.org

## Anmeldedaten für das Postfach um das OTP abzuholen
Mailpostfach

https://webmail.1blu.de/

npm@svws-nrw.de

Passwort: xxx

## Den Pfad zum Nexus aus der .npmrc herausnehmen, damit npmjs.org genommen wird
D:\git\SVWS-Server\svws-webclient\.npmrc

Das Nexus-Artifactoy auskommentiern mit #

## Zugangsdaten für npm
npm-username

svws-nrw

Passwort: xxx

## Powershell publish ui-components
```
Powershell in  /SVWS-Server/svws-webclient/src/ui-components/ts
npm login
Daten bereit halten und Einmalpasswort abholen
Daten im Terminal eingeben
npm publish --dry-run
npm publish --access public
```

## Powershell publish ts-lib
```
D:\git\SVWS-Server\svws-webclient\src\ts-lib\ts
npm login
Daten bereit halten und Einmalpasswort abholen
npm publish --dry-run
npm publish --access public
```
