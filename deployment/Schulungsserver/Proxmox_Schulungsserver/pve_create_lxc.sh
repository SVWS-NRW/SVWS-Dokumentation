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
        # Ignoriere Kommentare und leere Zeilen
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # Entferne Inline-Kommentare und trimme Leerzeichen
        value=$(echo "$value" | cut -d'#' -f1 | xargs)
        export "$key=$value"
    done < "$ENV_FILE"
fi

# Variablen initialisieren (greift nun auf die exportierten Werte zu)
ROOTPW=${ROOTPW:-""}
SNR=${SNR:-""}
IP=${IP:-""}
FQDN=${FQDN:-""}

# 3. Parameter einlesen (überschreibt .env Werte)
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

# Pflichtparameter prüfen
if [[ -z "$CONTAINER_ID" ]]; then
    echo "Fehler: Die Containernummer muss gesetzt werden gesetzt - Beispiel: pve_create_lxc.hs -nr 1020"
    exit 1
fi

# Passwort-Logik
PW_GENERATED=false
if [[ -z "$ROOTPW" ]]; then
    ROOTPW=$(openssl rand -base64 12)
    PW_GENERATED=true
    
    # Optional: Passwort lokal in die .env speichern, wenn es dort noch nicht war
    if [[ -f "$ENV_FILE" ]] && ! grep -q "ROOTPW=" "$ENV_FILE"; then
        echo "ROOTPW=$ROOTPW" >> "$ENV_FILE"
        echo "Passwort wurde lokal in $ENV_FILE gespeichert."
    fi
fi

# Fallback für FQDN & IP
[[ -z "$FQDN" ]] && FQDN="$CONTAINER_ID"
if [[ -n "$IP" ]]; then
    IPSNM="${IP}/16"
else
    IPSNM="dhcp"
fi

echo "--- Konfiguration ---"
echo "ID/SNR   : $CONTAINER_ID"
echo "FQDN     : $FQDN"
echo "IP       : $IPSNM"
echo "Template : $LXC_TEMPLATE"
[[ "$PW_GENERATED" = true ]] && echo "Passwort : (wird automatisch generiert)" || echo "Passwort : (manuell gesetzt)"
echo "---------------------"

### LXC erstellen #############################################

pct create $CONTAINER_ID \
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
DESCRIPTION=$(echo -e "# $FQDN  \nPasswort: $ROOTPW    \nErstellt am $(date +%F)")
pct set $CONTAINER_ID --description "$DESCRIPTION"

echo "Container $CONTAINER_ID wurde erfolgreich erstellt."
if [[ "$PW_GENERATED" = true ]]; then
    echo "Generiertes Root-Passwort: $ROOTPW"
fi