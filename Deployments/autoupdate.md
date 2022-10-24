# automatische updates	

Um in der Entwicklung automatisiert updates anzustoßen, bietet es sich an das Script per cronjob täglich zu starten: 
		
		 
		crontab	-e
		
	
Dann den folgenden Eintag am Ende hinzufügen:

		
		15 1 * * * bash /root/update-svws-from-scratch.sh
		
So wird täglich um 1:15 Uhr morgens das update Script ausgeführt. 

# Überwachung per email einrichten

Gerne möchte man als developer den Tag ggf mit einer kurzen Übersicht beginnen, ob der SVWS-Server bereit ist und der nächtliche Build erfolgreich war. 

apt install ssmtp sendmail

Konfiguration ändern: 

		nano /etc/ssmpt/revaliases


und unten einfügen:

 
		root:your@mail.net:smtp.mailserver.net:587
		
weiterhin Konfiguration ändern: 		

 		
		nano /etc/ssmtp/ssmtp.conf

und die Auth eintragen: 

 
		root=your@mail.net
		mailhub=smtp.mailserver.net:587
		AuthUser=USERNAME
		AuthPass=PASSWD
		UseSTARTTLS=YES
		UseTLS=Yes


kleines script zum mail versenden: 

		nano send-mail-log.sh
````
#!/bin/bash
echo 'Subject: update-log SVWS-Server' > mail.txt
echo 'From: svws@familie-klein.net' >> mail.txt
echo 'Content: text/html; charset="utf8"' >> mail.txt
echo '' >> mail.txt
systemctl -t service | grep svws >> mail.txt
echo '' >> mail.txt
echo '' >> mail.txt

cat /root/svws-update.log >> mail.txt

ssmtp my@adress.com < mail.txt

rm mail.txt
rm /root/svws-update.log
````

anschließend noch in den Cronjob packen:
		30 1 * * * bash /root/send-mail-log.sh



# NTP 

Falls es mit den Cronjobs zu Problemen kommt, könnte es an der fehlenden Zeitsyncronisation liegen: 

		apt install ntp

