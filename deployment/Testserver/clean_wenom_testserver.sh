
#!/bin/bash
##########################################################################################
### Das Skript löscht die Datenbank des Wenom Testserver und veröffentlicht das Secret ###
##########################################################################################
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
######################################################################################

# ACHTUNG: Diese Skrip veröffentlicht das Secret - es ist daher nur zu Testzwecken geeignet!

#!/bin/bash
INSTALLPATH=/var/www/html

rm -rf  ${INSTALLPATH}/db/*
rm   ${INSTALLPATH}/public/secret.html

curl -k --request GET --url "https://localhost/api/setup" --header "Content-Type: application/x-www-form-urlencoded"

echo -e "\n\nDas Secret zur Synchronisation mit dem SVWS-Server ist:\n"
if [ -f "${INSTALLPATH}/db/client.sec" ]; then
    more ${INSTALLPATH}/db/client.sec
    echo "ACHTUNG: Diese Skrip veröffentlicht das Secret unter URL/secret.html - es ist daher nur zu Testzwecken geeignet !!!"
    cat ${INSTALLPATH}/db/client.sec >  ${INSTALLPATH}/public/secret.html
else
    echo "Fehler: client.sec wurde nicht erstellt."
    echo "Fehler: client.sec wurde nicht erstellt." >  ${INSTALLPATH}/public/secret.html
fi
