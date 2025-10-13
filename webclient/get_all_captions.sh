#!/bin/bash

# Beschreibung:
# Dieses Skript durchsucht rekursiv alle Unterverzeichnisse
# nach .md-Dateien und gibt alle Überschriften aus diesen Dateien aus.
# Jede Überschrift wird um ein '#' ergänzt.
# Der Verzeichnisname wird als Hauptüberschrift ausgegeben.

START_DIR="."

find "$START_DIR" -type f -name "*.md" | while read -r file; do
  # Verzeichnisname extrahieren (z. B. ./einstellungen/index.md -> einstellungen)
  dirname=$(basename "$(dirname "$file")")

  echo "# $dirname"

  # Nur Überschriften ausgeben, ohne Dateinamen/Zeilennummern
  # und jeweils um ein '#' erweitern
  grep -E '^#+' "$file" | sed -E 's/^(#+)(\s*)(.*)$/\1# \3/'

  echo ""
done
