# Storage 

# Voraussetzungen

möchte man innerhalb der virtuallen Netzes einen Container dazu benutzen eine Dateifreigabe (CIFS, NFS, WebDAV ... ) zu erstellen, 
so braucht man insbesondere für nfs bei ProxmoxContainern einen sog. priviligierten Container 

# Installation NFS

		apt install nfs-kernel-server rpcbind
		
		mkdir /var/nfs/
		
Inhalte in share einfügen zb. echo "test" >> /share/test.txt 
ggf. noch rechte anpassen 

		nano /etc/exports
		
Freigabe per IP eintragen: 
		/var/nfs/ 10.1.0.1/16 (ro)
		


		systemctl is-enabled nfs-server
		systemctl status nfs-server

ufw anpassen:  

		ufw allow from 10.1.0.1/16 to any port nfs
		
		
