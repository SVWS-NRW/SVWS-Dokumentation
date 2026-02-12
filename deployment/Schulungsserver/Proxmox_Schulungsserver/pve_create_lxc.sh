#!/bin/bash
################################################################
### Das Skript Erstellt einen LXC auf einer Proxmox PVE Node ###
################################################################

# Pfad zur .env Datei
ENV_FILE="$(dirname "$0")/.env"

# 1. Standardwerte definieren (Fallback)
NODE=$(hostname)
LXC_TEMPLATE="local:vztmpl/debian-13-standard_13.1-1_amd64.tar.zst"
GATEWAY="10.0.0.1"
VSWITCH="vmbr1"
STORAGE="local"

# 2. .env Datei robust laden
if [[ -f "$ENV_FILE" ]]; then
    echo "Lade Konfiguration aus $ENV_FILE..."
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        value=$(echo "$value" | cut -d'#' -f1 | xargs)
        export "$key=$value"
    done < "$ENV_FILE"
fi

# Variablen initialisieren
ROOTPW=${ROOTPW:-""}

# 3. Parameter einlesen
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p) ROOTPW="$2"; shift 2 ;;
        -nr) CONTAINER_ID="$2"; shift 2 ;;
        -ip) IP="$2"; shift 2 ;;
        -dn) FQDN="$2"; shift 2 ;;
        -mac) MAC_ADDR="$2"; shift 2 ;; 
        -h|--help)
            echo "Usage: $0 [-p PASSWORD] -nr CONTAINER_ID [-ip IP] [-dn FQDN] [-mac MAC_ADDRESS]"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# Pflichtparameter prüfen
if [[ -z "$CONTAINER_ID" ]]; then
    echo "Fehler: Die Containernummer muss gesetzt werden - Beispiel: $0 -nr 1020"
    exit 1
fi

# Passwort-Logik
PW_GENERATED=false
if [[ -z "$ROOTPW" ]]; then
    ROOTPW=$(openssl rand -base64 12)
    PW_GENERATED=true
fi

# Fallback für FQDN & IP
[[ -z "$FQDN" ]] && FQDN="$CONTAINER_ID"
if [[ -n "$IP" ]]; then
    IPSNM="${IP}/16"
else
    IPSNM="dhcp"
fi

# Netzwerk-String zusammenbauen (fügt hwaddr nur hinzu, wenn definiert)
NET_CONFIG="name=eth0,bridge=$VSWITCH,firewall=1,gw=$GATEWAY,ip=$IPSNM"
if [[ -n "$MAC_ADDR" ]]; then
    NET_CONFIG="$NET_CONFIG,hwaddr=$MAC_ADDR"
fi

echo "--- Konfiguration ---"
echo "CONTAINER_ID  : $CONTAINER_ID"
echo "FQDN          : $FQDN"
echo "IP            : $IPSNM"
echo "MAC           : ${MAC_ADDR:-Auto-generiert}"
echo "Template      : $LXC_TEMPLATE"
[[ "$PW_GENERATED" = true ]] && echo "Passwort : (wird automatisch generiert)" || echo "Passwort : (manuell gesetzt)"
echo "---------------------"

### LXC erstellen #############################################

pct create $CONTAINER_ID \
$LXC_TEMPLATE \
--hostname "$FQDN" \
--memory 4096 \
--swap 0 \
--cores 2 \
--net0 "$NET_CONFIG" \
--storage $STORAGE \
--rootfs ${STORAGE}:8 \
--unprivileged 1 \
--ignore-unpack-errors  \
--ostype debian \
--password="${ROOTPW}" \
--features nesting=1 \
--start 1

# Beschreibung setzen
DESCRIPTION=$(echo -e "# $FQDN  \nPasswort: $ROOTPW    \nMAC: ${MAC_ADDR:-Standard} \nErstellt am $(date +%F)")
pct set $CONTAINER_ID --description "$DESCRIPTION"

echo "Container $CONTAINER_ID wurde erfolgreich erstellt."
if [[ "$PW_GENERATED" = true ]]; then
    echo "Generiertes Root-Passwort: $ROOTPW"
fi