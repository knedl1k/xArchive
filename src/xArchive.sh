#!/usr/bin/env bash

#GNU General Public License v3.0
#knedl1k 2023

usage(){
  echo "Usage: $0 [--delete]"
  exit 1
}

DELETE=false
if [ "$1" == "--delete" ]; then
  DELETE=true
elif [ ! -z "$1" ]; then
  usage
fi

ARCHIVE_DIR="."

unzip_archive(){
  local ARCHIVE=$1
  local ARCHIVE_NAME=$2
  local COMMAND=$3
  local EXTRACTION_DIR="$ARCHIVE_DIR/$ARCHIVE_NAME"
  
  mkdir -p "$EXTRACTION_DIR"
  eval "$COMMAND" "$ARCHIVE" -d "$EXTRACTION_DIR"
  
  if $DELETE; then
    rm "$ARCHIVE"
  fi
}

for ARCHIVE in "$ARCHIVE_DIR"/*.zip; do
  [ -e "$ARCHIVE" ] || continue
  ARCHIVE_NAME=$(basename "$ARCHIVE" .zip)
  unzip_archive "$ARCHIVE" "$ARCHIVE_NAME" "unzip -o"
done

for ARCHIVE in "$ARCHIVE_DIR"/*.tar.gz; do
  [ -e "$ARCHIVE" ] || continue
  ARCHIVE_NAME=$(basename "$ARCHIVE" .tar.gz)
  unzip_archive "$ARCHIVE" "$ARCHIVE_NAME" "tar -xzvf"
done

for ARCHIVE in "$ARCHIVE_DIR"/*.tar.bz2; do
  [ -e "$ARCHIVE" ] || continue
  ARCHIVE_NAME=$(basename "$ARCHIVE" .tar.bz2)
  unzip_archive "$ARCHIVE" "$ARCHIVE_NAME" "tar -xjvf"
done

for ARCHIVE in "$ARCHIVE_DIR"/*.gz; do
  [[ "$ARCHIVE" == *.tar.gz ]] && continue
  [ -e "$ARCHIVE" ] || continue
  ARCHIVE_NAME=$(basename "$ARCHIVE" .gz)
  unzip_archive "$ARCHIVE" "$ARCHIVE_NAME" "gunzip -c"
done

for ARCHIVE in "$ARCHIVE_DIR"/*.bz2; do
  [[ "$ARCHIVE" == *.tar.bz2 ]] && continue
  [ -e "$ARCHIVE" ] || continue
  ARCHIVE_NAME=$(basename "$ARCHIVE" .bz2)
  unzip_archive "$ARCHIVE" "$ARCHIVE_NAME" "bunzip2 -c"
done

echo "All archives have been extracted."
