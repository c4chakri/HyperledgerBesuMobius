#!/bin/sh
set -e

ENODE1="enode://39324ce53375bd38c8097375cc0504b09f7bb1fbd039f29dea16cc2e12e05cc98d5d5bfcb70004b0324fd9a1c9d4af6c71de216999deb4482cb97af119f22acc@besu-node1:30303"
ENODE2="enode://9e316c7015626a7d0c60d7c5f6b5e87d099f59e359b0f6c023419b1ecda961a141baabf39b63a25f83fe03ee08336b02bb78261c525a1264bcb46a9dab54fef1@besu-node2:30304"
ENODE3="enode://23abe9c2880872e554d9cf2808d5835bfcf5f63b807f73a2871c8c87652ba2991247e11c3af924eaba9c4317708a9cfada5d5f6207acdf0ddd2e1cda352d578a@besu-node3:30305"
ENODE4="enode://524acc9d54d8b61b42f85eaa6df0beee9c29fb4c91eb4be716d14563467ab11d4312bf48d7f4d9f1d87905b5536b053d4e64f4d9c5b71a5d5c19b662a40f349f@besu-node4:30306"

add_peer() {
  NODE_URL=$1
  ENODE=$2
  echo "Adding peer to $NODE_URL"
  curl -s -X POST \
    -H "Content-Type: application/json" \
    --data "{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"$ENODE\"],\"id\":1}" \
    "$NODE_URL"
  echo ""
}

echo "==> Wiring up peers..."

add_peer "http://besu-node2:8546" "$ENODE1"

add_peer "http://besu-node3:8547" "$ENODE1"
add_peer "http://besu-node3:8547" "$ENODE2"

add_peer "http://besu-node4:8548" "$ENODE1"
add_peer "http://besu-node4:8548" "$ENODE2"
add_peer "http://besu-node4:8548" "$ENODE3"

echo "==> Done. All peers connected."