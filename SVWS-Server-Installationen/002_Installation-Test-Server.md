# Installation eines Test-Server bei 1blu auf Debian 10




# Einrichten des Servers als Dienst

Inhalt der svws.service unter /etc/systemd/systemd/

```

[Unit]
Description=SVWS Server

[Service]
User=svws
Type=simple
Environment="PATH=/usr/local/bin:/usr/bin:/bin:/opt/jdk-13/bin"
WorkingDirectory=/app/SVWS-Server
ExecStart=/bin/bash /app/SVWS-Server/start_server.sh
Restart=on-failure
RestartSec=5s
StandardOutput=journal

[Install]
WantedBy=multi-user.target

```
