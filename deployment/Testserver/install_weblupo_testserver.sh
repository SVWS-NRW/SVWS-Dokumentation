#!/bin/bash
##################################################################################
### Das Skript installiert den SVWS-WebLuPo auf Basis des offiziellen Releases ###
##################################################################################
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
#####################################################################################


INSTALLPATH=/var/www/html

# Parameter-Abfrage mit getopts
while getopts "v:d:" opt; do
  case $opt in
    v) SVWSVERSION=$OPTARG ;;
    *) echo "Benutzung: $0 -v [SVWS-Version]" >&2
       exit 1 ;;
  esac
done

# Verpflichtende Prüfung der SVWS-Version
if [ -z "$SVWSVERSION" ]; then
    echo -e "\e[31mFehler: Die SVWS-Version (-v) muss angegeben werden!\e[0m"
    echo "Beispiel: $0 -v 1.2.2"
    exit 1
fi

DOWNLOADPATH=https://github.com/SVWS-NRW/SVWS-Server/releases/download/v${SVWSVERSION}/SVWS-Laufbahnplanung-${SVWSVERSION}.zip

echo "Starte Installation von WebLuPo $SVWSVERSION auf $INSTALLPATH..."

### Apache2 installation
apt update && apt upgrade -y
apt install -y curl zip unzip dnsutils nmap net-tools nano mc ca-certificates gnupg2 lsb-release openssl apt-transport-https gnupg apache2 

# Download und Entpacken 
echo "Download und Entpacken WebLuPo von $DOWNLOADPATH"
cd $INSTALLPATH
wget $DOWNLOADPATH
unzip -o SVWS-Laufbahnplanung-${SVWSVERSION}.zip

echo -e "\n\n################# Installation WebLuPo beendet! ####################\n"