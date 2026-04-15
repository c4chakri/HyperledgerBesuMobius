# Permissioned Besu Network With Blockscout

This repository contains:

- a 4-node Hyperledger Besu permissioned network in `Permissioned-Network/`
- a Blockscout explorer stack in `blockscout/docker-compose/`



## Topology

- Consensus: `ibft2`
- Chain ID: `123456`
- Besu nodes: `besu-node1` to `besu-node4`
- Explorer: Blockscout behind Nginx proxy on port `80`

## Prerequisites

- Docker Engine installed and running
- Docker Compose v2 available as `docker compose`
- Host ports available:
  - `80`, `8080`, `8081`
  - `8545` to `8548`
  - `30303` to `30306`
  - `7432`, `7433`

Check Docker:

```bash
docker --version
docker compose version
```

## Repository Layout

- [Permissioned-Network/docker-compose.yml](/home/gaian/Gaian/BaaS/QBFT-PERMISSIONED-NETWORK/Permissioned-Network/docker-compose.yml): Besu network
- [Permissioned-Network/genesis.json](/home/gaian/Gaian/BaaS/QBFT-PERMISSIONED-NETWORK/Permissioned-Network/genesis.json): chain genesis
- [Permissioned-Network/permissions_config.toml](/home/gaian/Gaian/BaaS/QBFT-PERMISSIONED-NETWORK/Permissioned-Network/permissions_config.toml): node/account allowlist
- [blockscout/docker-compose/docker-compose.yml](/home/gaian/Gaian/BaaS/QBFT-PERMISSIONED-NETWORK/blockscout/docker-compose/docker-compose.yml): Blockscout stack

## Start Order

Bring the Besu network up first, then start Blockscout.

### 1. Start Besu

From the repository root:

```bash
docker compose -f Permissioned-Network/docker-compose.yml up -d
```

Check status:

```bash
docker compose -f Permissioned-Network/docker-compose.yml ps
```

Expected result:

- `besu-node1` to `besu-node4` are `Up`
- health eventually becomes `healthy`

### 2. Start Blockscout

From the repository root:

```bash
docker compose -f blockscout/docker-compose/docker-compose.yml up -d
```

Check status:

```bash
docker compose -f blockscout/docker-compose/docker-compose.yml ps
```

Expected result:

- `proxy`, `backend`, `frontend`, `db`, `stats`, `stats-db`, `sig-provider`, `visualizer`, `redis-db` are `Up`
- `user-ops-indexer` may restart in this setup; this does not block the main explorer UI

## Access URLs

### Besu RPC

- Node 1: `http://localhost:8545`
- Node 2: `http://localhost:8546`
- Node 3: `http://localhost:8547`
- Node 4: `http://localhost:8548`

Recommended default RPC for internal tools:

- `http://localhost:8545`

### Blockscout

- Local: `http://localhost/`
- LAN example: `http://<host-ip>/`

If the host LAN IP is `172.168.28.161`, the explorer URL is:

- `http://172.168.28.161/`

## Verification

### Verify Besu containers

```bash
docker compose -f Permissioned-Network/docker-compose.yml ps
```

### Verify block production

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8545
```

Run it twice a few seconds apart. The block number should increase.

### Verify peer count

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' \
  http://localhost:8545
```

### Verify explorer proxy

```bash
docker compose -f blockscout/docker-compose/docker-compose.yml logs proxy --tail 50
```

You should see successful `200` responses for explorer API paths such as `/api/v2/main-page/indexing-status`.

## Stop Commands

### Stop Blockscout

```bash
docker compose -f blockscout/docker-compose/docker-compose.yml down
```

### Stop Besu

```bash
docker compose -f Permissioned-Network/docker-compose.yml down
```

If you are doing a full shutdown, stop Blockscout first and Besu second.

## Logs

### Besu

```bash
docker compose -f Permissioned-Network/docker-compose.yml logs besu-node1 --tail 100
docker compose -f Permissioned-Network/docker-compose.yml logs besu-node2 --tail 100
docker compose -f Permissioned-Network/docker-compose.yml logs besu-node3 --tail 100
docker compose -f Permissioned-Network/docker-compose.yml logs besu-node4 --tail 100
```

### Blockscout

```bash
docker compose -f blockscout/docker-compose/docker-compose.yml logs proxy --tail 100
docker compose -f blockscout/docker-compose/docker-compose.yml logs backend --tail 100
docker compose -f blockscout/docker-compose/docker-compose.yml logs frontend --tail 100
```

## Operational Notes

- The Besu compose file creates and uses the Docker network `permissioned-network_besu-net`.
- The Besu nodes use the shared top-level permissioning config from `Permissioned-Network/permissions_config.toml`.
- The current node data directories already contain chain state and keys.
- Blockscout is configured to connect to the Besu RPC on host port `8545`.
- In the current setup, `user-ops-indexer` may keep restarting with an RPC compatibility issue. The main explorer still works.

## Common Issues

### Besu nodes exit immediately

Check:

```bash
docker compose -f Permissioned-Network/docker-compose.yml logs besu-node1 --tail 100
```

Typical causes:

- stale `static-nodes.json`
- permissioning allowlist mismatch
- port conflicts

### Explorer opens but data looks empty

Check:

- Besu block number is increasing
- Blockscout backend is running
- proxy logs return `200` on API endpoints


