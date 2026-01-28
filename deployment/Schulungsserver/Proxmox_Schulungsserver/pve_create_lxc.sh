#!/bin/bash
###############################################################
### Das Skript Erstellt einen LXC auf einer Proxmox PVE Node ###
###############################################################

# Variablen der Proxmoxungebung
NODE=$(hostname)
LXC_TEMPLATE="local:vztmpl/debian-13-standard_13.1-1_amd64.tar.zst"
GATEWAY="10.0.0.1"
VSWITCH="vmbr1"
STORAGE="local"

# Variablen initialisieren
ROOTPW=""
SNR=""
IP=""
FQDN=""

# Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p) ROOTPW="$2"; shift 2 ;;
        -nr) SNR="$2"; shift 2 ;;
        -ip) IP="$2"; shift 2 ;;
        -dn) FQDN="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-p PASSWORD] -nr SNR [-ip IP] [-dn FQDN]"
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

# Fallback für FQDN & IP
[[ -z "$FQDN" ]] && FQDN="$SNR"
if [[ -n "$IP" ]]; then
    IPSNM="${IP}/16"
else
    IPSNM="dhcp"
fi

echo "--- Konfiguration ---"
echo "ID/SNR   : $SNR"
echo "FQDN     : $FQDN"
echo "IP       : $IPSNM"
[[ "$PW_GENERATED" = true ]] && echo "Passwort : (wird automatisch generiert)" || echo "Passwort : (manuell gesetzt)"
echo "---------------------"

### LXC erstellen #############################################

pct create $SNR \
$LXC_TEMPLATE \
--hostname "$FQDN" \
--memory 4096 \
--swap 0 \
--cores 2 \
--net0 name=eth0,bridge=$VSWITCH,firewall=1,gw=$GATEWAY,ip=$IPSNM \
--storage $STORAGE \
--rootfs ${STORAGE}:8 \
--unprivileged 1 \
--ignore-unpack-errors  \
--ostype debian \
--password="${ROOTPW}" \
--features nesting=1 \
--start 1

# Beschreibung setzen
DESCRIPTION=$(echo -e "# $FQDN\n  Passwort: $ROOTPW  \nErstellt am $(date +%F)")
pct set $SNR --description "$DESCRIPTION"

echo "Container $SNR wurde erfolgreich erstellt."
if [[ "$PW_GENERATED" = true ]]; then
    echo "🔑 Generiertes Root-Passwort: $ROOTPW"
    echo "Das Passwort wurde auch in die Container-Notes (Beschreibung) geschrieben."
fi