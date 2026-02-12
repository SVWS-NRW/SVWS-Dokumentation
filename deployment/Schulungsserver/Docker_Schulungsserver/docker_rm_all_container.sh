#!/bin/bash

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