# Single-Node Besu Network

This folder provides a separate 1-validator Besu network that can run alongside the existing 4-node network.

## Topology

- Consensus: `ibft2`
- Validators: `1`
- Chain ID: `123457`
- RPC: `http://localhost:8555`
- P2P: `30403`
- Container: `besu-single-node1`

## Isolation From The 4-Node Network

This setup is intentionally isolated from `Permissioned-Network/`:

- different chain ID
- different Docker network: `besu-single-net`
- different RPC port: `8555`
- different P2P port: `30403`
- separate data directory: `Single-Node-Network/Node-1/data`

It reuses the Node 1 validator key from the 4-node network so the single node can validate blocks immediately, but it does not share chain data.

## Files

- `docker-compose.yml`: single-node Besu service
- `genesis.json`: single-validator IBFT genesis
- `Node-1/data/key`: validator private key used by the node
- `Node-1/data/key.pub`: validator public key

## Start

From the repository root:

```bash
docker compose -f Single-Node-Network/docker-compose.yml up -d
```

Check status:

```bash
docker compose -f Single-Node-Network/docker-compose.yml ps
```

## Verify Block Production

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8555
```

Run it twice a few seconds apart. The block number should increase.

## Verify The Validator Set

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"ibft_getValidatorsByBlockNumber","params":["latest"],"id":1}' \
  http://localhost:8555
```

Expected validator address:

- `0x5e144ae9b12bbeb0645f21247814dc6ea3272136`

## Stop

```bash
docker compose -f Single-Node-Network/docker-compose.yml down
```
