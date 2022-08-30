# Gitlab Runner

## Hardware

+ 2 cpu
+ 16 GB Ram
+ 2 GB swap
+ 250 GB HD

## Installation 

Die Anleitung findet man in dem Gitlabserver unter: 

		apt get update
		apt update
		apt install -y net-tools dnsutils curl
		curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | bash
		apt update
		apt install -y gitlab-runner
		gitlab-runner status
   
   
## Registrierung

		gitlab-runner register --url https://git.svws-nrw.de/ --registration-token XYZ....
		
Der Token kann unter Gitlab im Adminbereich -> Runners unter "Register an instance runner" kopiert werden. 