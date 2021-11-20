GitLab Installation am 14.11.21 auf 1blu Server mit Ubuntu 20.04
Setzen der A-Records git.svws-nrw.de und mattermost.svws-nrw.de auf Host: v13146.1blu.de (IP-Adresse: 178.254.39.56)

```
apt update
apt dist-upgrade -y
locale-gen "en_US.UTF-8"
update-locale LC_ALL="en_US.UTF-8"

sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

sudo apt-get install -y postfix
```
Postfix Internet site, external mit git.svws-nrw.de angegeben

```
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL="https://git.svws-nrw.de" apt-get install gitlab-ee
cat /etc/gitlab/initial_root_password
```

Installation nach Anleitung unter https://about.gitlab.com/install/#ubuntu



Benutzer für Gitlab: root
Passwort setzen

```
vi /etc/gitlab/gitlab.rb
# mattermost_external_url 'https://mattermost.svws-nrw.de'
```
