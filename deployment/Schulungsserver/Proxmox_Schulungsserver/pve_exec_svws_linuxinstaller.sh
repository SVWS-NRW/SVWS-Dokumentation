#!/bin/bash
########################################################################################
### Das Skript erstellt einen SVWS-Server inkl. Mariadb auf dem angegebene einen LXC ###
########################################################################################
# 
# Copyright (c) $(date +%Y)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
########################################################################################

# Standard-Dateiname für Umgebungsvariablen
ENV_FILE=".env"

# 1. .env Datei robust laden
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

# 2. Parameter einlesen (Überschreibt Werte aus der .env)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p) ROOTPW="$2"; shift 2 ;;
        -nr) CONTAINER_ID="$2"; shift 2 ;;
        -v) SVWSVERSION="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [-p PASSWORD] [-nr SNR] [-v VERSION]"
            exit 0
            ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
done

# 3. Pflichtparameter prüfen
if [[ -z "$CONTAINER_ID" ]] || [[ -z "$SVWSVERSION" ]]; then
    echo "Fehler: Container-Nummer (-nr) und SVWS-Version (-v) müssen angegeben werden."
    exit 1
fi

# 4. Passwort-Logik
if [[ -z "$ROOTPW" ]]; then
    ROOTPW=$(openssl rand -base64 12)
    echo "Passwort wurde automatisch generiert."
fi

echo "Konfiguriere Container $CONTAINER_ID..."

# -----------------------------------------------------------
# Befehle im Proxmox Container ausführen
# -----------------------------------------------------------

# Download/Update des Skripts im LXC
pct exec $CONTAINER_ID -- wget -N https://github.com/SVWS-NRW/SVWS-Dokumentation/raw/refs/heads/main/deployment/Testserver/install_svws-testserver-linuxinstaller.sh -O install_svws-testserver-linuxinstaller.sh

# .env im Container sauber neu erstellen (überschreiben mit '>')
pct exec $CONTAINER_ID -- bash -c "echo 'PASSWORD=$ROOTPW' > .env"
pct exec $CONTAINER_ID -- bash -c "echo 'SVWSVERSION=$SVWSVERSION' >> .env"


# Installer ausführen
pct exec $CONTAINER_ID -- bash install_svws-testserver-linuxinstaller.sh -p "$ROOTPW" -v "$SVWSVERSION"

echo "Installation abgeschlossen."