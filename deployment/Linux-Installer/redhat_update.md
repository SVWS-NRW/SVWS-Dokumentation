```bash 
#!/bin/bash

sysstemctl stop svws

wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v1.0.11/linux-installer-1.0.11.tar.gz
tar xzf ./linux-installer-*

rm -rf /opt/app/svws/app
rm -rf /opt/app/svws/client
rm -rf /opt/app/svws/adminclient


cp -r ./svws/app /opt/app/svws/
unzip -d /opt/app/svws/client  ./svws/app/SVWS-Client.zip
unzip -d /opt/app/svws/adminclient  ./svws/app/SVWS-Admin-Client.zip

chown -R svws:svws /opt/app/svws

sysstemctl start svws
sysstemctl status svws
```