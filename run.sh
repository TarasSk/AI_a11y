#!/bin/bash
set -e

# Load .env and pass each variable as --dart-define
if [ ! -f .env ]; then
  echo "Error: .env file not found"
  exit 1
fi

DEFINES=""
while IFS='=' read -r key value; do
  # Skip blank lines and comments
  [[ -z "$key" || "$key" == \#* ]] && continue
  DEFINES="$DEFINES --dart-define=$key=$value"
done < .env

fvm flutter run $DEFINES "$@"
