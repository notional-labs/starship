#!/bin/bash

ADDRESS="$1"
DENOM="$2"
FAUCET_URL="$3"

set -eu

function transfer_token() {
  status_code=$(curl --header "Content-Type: application/json" \
    --request POST --write-out %{http_code} --silent \
    --data '{"denom":"'"$DENOM"'","address":"'"$ADDRESS"'"}' \
    $FAUCET_URL)
  return $status_code
}

echo "Try to send tokens, if failed, wait for 5 seconds and try again"
max_tries=5
while [[ max_tries -gt 0 ]]
do
  status_code=$(transfer_token)
  if [[ "$status_code" -eq 200 ]]; then
    echo "Successfully sent tokens"
    exit 0
  fi
  echo "Failed to send tokens. Sleeping for 10 secs. Tries left $max_tries"
  ((max_tries--))
  sleep 5
done