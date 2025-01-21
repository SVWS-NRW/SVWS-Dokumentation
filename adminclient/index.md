# SVWS-Adminclient

Dies ist das **Benutzerhandbuch** für auf dem Zugriff über Browser vorgesehenen Administrationsclient des SVWS-Servers.

Es lassen sich Anderem in der Datenbank vorhandene Schemata verwalten, es können Datenbank gesichert und aus SchILD-NRW-2 migriert werden.

Weiterhin sind Konfigurationsmöglichkeiten des SVWS-Servers vorgesehen. Derzeit kann hier ein https-Zertifikat des SVWS-Server exportiert werden.

Zum Zugriff benötigen Sie entweder das **Root**passwort der MariaDB. In diesem Fall stehen alle *Schemta* der MariaDB zur Verfügung und ebenso alle Apps.

Alternativ kann man sich mit einem **Schema**-Admin einloggen, um die Schemata, auf die dieser Nutzer Zurgiff hat, zu verwalten. Etwa, um Backups einzuspielen. Loggt man sich mit einem Schema-Admin ein, stehen nicht alle Apps und Optionen zur Verfügung.

::: warning Die Datenbanknutzer haben keinen Zugriff auf den Admin-Client
Ein **Datenbanknutzer**, auch einer, der als *Administrator* in der Datenbank gekennzeichnet ist, hat keinen Zugriff auf den Admin-Client.
:::