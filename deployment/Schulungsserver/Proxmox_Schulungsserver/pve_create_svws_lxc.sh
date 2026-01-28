#!/bin/bash 

# Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p) ROOTPW="$2"; shift 2 ;;
        -nr) SNR="$2"; shift 2 ;;
        -v) SVWSVERSION="$OPTARG" ;;
        -h|--help)
            echo "Usage: $0 [-p PASSWORD] -nr SNR "
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# Pflichtparameter prüfen (SNR ist zwingend)
if [[ -z "$SNR" ]]; then
    echo "Fehler: Parameter -nr (SNR) ist erforderlich."
    exit 1
fi

# Pflichtfelder prüfen
if [ -z "$SNR" ] || [ -z "$SVWSVERSION" ]; then
  echo "Fehler: LX-Container Nummer (-nr) und SVWS-Serverversion (-v) müssen angegeben werden."
  usage
fi

# -----------------------------------------------------------
# Passwort-Logik: Generieren, falls nicht angegeben
# -----------------------------------------------------------
if [[ -z "$ROOTPW" ]]; then
    # Generiert ein 16-stelliges Passwort (Alphanumerisch)
    ROOTPW=$(openssl rand -base64 12)
    PW_GENERATED=true
else
    PW_GENERATED=false
fi

wget https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Schulungsserver/Proxmox_Schulungsserver/pve_create_lxc.sh
bash pve_create_lxc -p $ROOTPW -nr $SNR

pct exec $SNR -- wget https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/install_svws-testserver-linuxinstaller.sh
pct exec $SNR -- bash install_svws-testserver-linuxinstaller.sh -p $ROOTPW -v $SVWSVERSION
