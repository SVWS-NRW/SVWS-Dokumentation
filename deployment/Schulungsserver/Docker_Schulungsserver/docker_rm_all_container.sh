#!/bin/bash
###############################################
### Das Skript löscht alle Docker Container ###
###############################################
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
###############################################


# Abfrage an den Benutzer
read -p "Möchten Sie wirklich ALLE Container stoppen und löschen? (ja/nein): " answer

# Prüfung der Antwort
if [[ "$answer" == "ja" || "$answer" == "j" ]]; then
    echo "##### Stop all Container #####"
    docker stop $(docker ps -a -q)

    echo "###### remove all Container #####"
    docker rm $(docker ps -a -q)
    
    echo "Done."
else
    echo "Abgebrochen. Es wurden keine Container verändert."
fi

# Status anzeigen
docker ps -a