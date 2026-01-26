#!/bin/bash
###############################################################
### Das Skript Erstellt einen LCX auf eine Proxmox-PVE Node ###
###############################################################
#
# save as pve_create_lxc.sh
# Usage: bash pve_create_lxc.sh -p PASSWORD -n SNR -ip IP -dn FQDN
#

### Variablen der Proxmoxungebung #############################

NODE=mein.proxmox.example.com                                                       # Hostname des Proxmoxnode

LXC_TEMPLATE=local:vztmpl/debian-13-standard_13.1-1_amd64.tar.zst       # Pfad zum LCX Template auf dem o.g. Proxmox 
                                                                        # Syntax: VOLUMENAME:vztmpl/TEMPLATENAME
IPSNM=dhcp                                                              # Der Container erhält per Default per dhcp 
                                                                        # alternativ kann die IP im Scriptaufruf übergeben werden
GATEWAY=10.0.0.1                                                        # Gateway im internen Netzwerk 

VSWITCH=vmbr1                                                           # virtueller Switch im internen Netzwerk

STORAGE=local                                                           # Storage, auf dem der LXC nachher liegt. i.d.R iste es "local"

###############################################################


### Variablen aus Parametern verarbeiten ######################

# ----------------------------
# Variablen initialisieren
# ----------------------------

ROOTPW=""
SNR=""
IP=""
FQDN=""

# ----------------------------
# Parameter einlesen
# ----------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)
            ROOTPW="$2"
            shift 2
            ;;
        -nr)
            SNR="$2"
            shift 2
            ;;
        -ip)
            IP="$2"
            shift 2
            ;;
        -dn)
            FQDN="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage:"
            echo "  $0 -p PASSWORD -nr SNR [-ip IP] [-dn FQDN]"
            exit 0
            ;;
        *)
            echo "Unbekannter Parameter: $1"
            exit 1
            ;;
    esac
done

# ----------------------------
# Pflichtparameter prüfen
# ----------------------------

if [[ -z "$ROOTPW" || -z "$SNR" ]]; then
    echo "Fehler: -p (PASSWORD) und -nr (SNR) sind Pflichtparameter"
    echo ""
    echo "Usage:"
    echo "  $0 -p PASSWORD -nr SNR [-ip IP] [-dn FQDN]"
    exit 1
fi

# ----------------------------
# Ausgabe / Debug
# ----------------------------




echo "SNR      : $SNR"
echo "ROOTPW   : gesetzt"
echo "IP       : ${IP:-nicht angegeben, verwende DHCP}"
echo "FQDN     : ${FQDN:-nicht angegeben, verwende SNR}"

# ----------------------------
# fehlende Parameter ergänzen
# ----------------------------

if [[ -n "$IP" ]]; then
    IPSNM="${IP}/16"
else
    IPSNM="dhcp"
fi

if [[ -z "$FQDN" ]]; then
    FQDN="$SNR"
fi


### LXC erstellen #############################################

pct create $SNR \
$LXC_TEMPLATE \
--hostname $FQDN \
--memory 4096 \
--swap 0 \
--cores 2 \
--net0 name=eth0,bridge=$VSWITCH,firewall=1,gw=$GATEWAY,ip=$IPSNM \
--storage $STORAGE \
--rootfs ${STORAGE}:8 \
--unprivileged 1 \
--ignore-unpack-errors  \
--ostype debian \
--password=$ROOTPW \
--features nesting=1 \
--start 1
# more options:
# Es kann ein  pool angelegt werden zum Gruppieren der LXC
# --pool Schulungsumgebung \
# --ssh-public-keys /root/.ssh/authorized_keys
# --onboot 1
# --cpuunits $cpuunits
# --net name=eth0,ip4=dhcp
# Zeit einplanen, falls der DHCP oder andere Prozesse diese brauchen.