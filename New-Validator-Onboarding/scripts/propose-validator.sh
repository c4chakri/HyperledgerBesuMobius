#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <rpc-url> <validator-address> <true|false>"
  exit 1
fi

RPC_URL="$1"
VALIDATOR_ADDRESS="$2"
VOTE="$3"

curl -s -X POST \
  -H "Content-Type: application/json" \
  --data "{\"jsonrpc\":\"2.0\",\"method\":\"ibft_proposeValidatorVote\",\"params\":[\"${VALIDATOR_ADDRESS}\",${VOTE}],\"id\":1}" \
  "${RPC_URL}"
echo
