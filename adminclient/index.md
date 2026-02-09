# SVWS-Adminclient

Dies ist das **Benutzerhandbuch** für auf dem Zugriff über Browser vorgesehenen Administrationsclient des SVWS-Servers.

Es lassen sich unter Anderem in der MariaDB vorhandene Schemata verwalten, es können vorhandende Schamata gesichert und aus SchILD-NRW-2 migriert werden. Ein "Schema" entspricht eine "Schuldatenank". Eine Schema-Admin-Kennung kann für mehrere Schemata gelten. 

Weiterhin sind Konfigurationsmöglichkeiten des SVWS-Servers vorgesehen. Derzeit kann hier ein *https-Zertifikat* des SVWS-Server exportiert werden.

Zum Zugriff benötigen Sie entweder das **Root**passwort der MariaDB. In diesem Fall stehen alle *Schemta* der MariaDB zur Verfügung und ebenso alle Apps.

Alternativ kann man sich mit einem **Schema**-Admin einloggen, um die Schemata zu verwalten, auf die dieser Nutzer Zugriff hat. Diese Berechtigung kann zum Beispiel verwendet werden, um Backups einzuspielen.

Loggt man sich mit einem Schema-Admin und nicht mit dem MariaDB-Root ein, stehen nicht alle Apps und Optionen zur Verfügung.

::: warning Datenbanknutzer haben keinen Zugriff auf den AdminClient
Ein reiner **Datenbanknutzer** hat keinen Zugriff auf den AdminClient. Dies gilt auch für die Datenbankbenutzer, die als *Administrator* gekennzeichnet sind. Für den AdminCliebt benötigen Sie einen Schema-Admin oder den MariaDB-Root.

*Nur-Lesende* Schema-Admins sind nicht vorgesehen.
:::