# New Validator Onboarding


Important:

- The running chain in this repo uses `ibft2`, not `qbft`.
- Chain ID is `123456`.
- A new node can join as a peer only after its enode is allowlisted.
- A new node becomes a validator only after the existing validators vote it into the validator set.

## Files

- `docker-compose.yml`: standalone validator node template
- `genesis.json`: copied from the current network
- `.env.example`: values to customize on the new validator host
- `scripts/propose-validator.sh`: helper to send validator vote RPC calls
- `scripts/check-validator.sh`: helper to inspect validator state

The permissioning config and `static-nodes.json` are rendered automatically from `.env` when the container starts.

## What the new validator operator must do

1. Copy this folder to the new machine.
2. Copy `.env.example` to `.env`.
3. Fill in the real host/IP values in `.env`.
4. Start the validator node with Docker Compose.
5. Send the generated validator account and enode to the current network admins.

## Step 1: Prepare the new validator host

Create `.env`:

```bash
cp .env.example .env
```

Update at least these values:

- `VALIDATOR_HOST_IP`
- `VALIDATOR_ENODE_PUBKEY`
- `VALIDATOR_ADDRESS`
- `BOOTNODE1_HOST`
- `BOOTNODE2_HOST`
- `BOOTNODE3_HOST`
- `BOOTNODE4_HOST`

Notes:

- `VALIDATOR_HOST_IP` must be reachable by the existing validators on the new node's P2P port.
- `VALIDATOR_ENODE_PUBKEY` is the node public key, not the account address.
- `VALIDATOR_ADDRESS` is the validator account/address derived from the node key.

## Step 2: Generate node identity on the new machine

One easy approach is to let Besu create the key once, then inspect it:

```bash
docker compose up -d
docker compose logs -f validator-node
```

After the node starts once, inspect:

- `validator-data/key.pub` for the enode public key
- logs for the `Node address`

You can also derive the address with Besu on the host if available:

```bash
besu public-key export-address --node-private-key-file=validator-data/key
```

Then update `.env` with the discovered values and restart:

```bash
docker compose down
docker compose up -d
```

## Step 3: What current validators must add to the network

The current network admins must update the existing network's allowlist with the new validator enode:

```toml
"enode://${VALIDATOR_ENODE_PUBKEY}@${VALIDATOR_HOST_IP}:30303"
```

They must add it to the production network's permissioning config, not the copy in this directory.

## Step 4: Vote the new validator into IBFT

Each existing validator must vote for the new validator address. Example from one existing validator RPC endpoint:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"ibft_proposeValidatorVote","params":["0xNEW_VALIDATOR_ADDRESS",true],"id":1}' \
  http://EXISTING_VALIDATOR_RPC:8545
```

Use the helper script from this folder if preferred:

```bash
./scripts/propose-validator.sh http://EXISTING_VALIDATOR_RPC:8545 0xNEW_VALIDATOR_ADDRESS true
```

Enough existing validators must vote for the proposal to pass.

## Step 5: Verify onboarding

Check the validator list:

```bash
./scripts/check-validator.sh http://EXISTING_VALIDATOR_RPC:8545
```

Check peers on the new node:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' \
  http://localhost:8549
```

Check block growth:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8549
```

## Existing validator references from the current network

Current validators on the running chain:

- `0xfb688355a68c2bcc872fa051de32355715e5ab11`
- `0x9006630a20d419281c7aabf5c0561673b3be53d7`
- `0x5e144ae9b12bbeb0645f21247814dc6ea3272136`
- `0xbe208ace9f480c76c410d067d20f95eb774b1b94`

Current enode public keys:

- `39324ce53375bd38c8097375cc0504b09f7bb1fbd039f29dea16cc2e12e05cc98d5d5bfcb70004b0324fd9a1c9d4af6c71de216999deb4482cb97af119f22acc`
- `9e316c7015626a7d0c60d7c5f6b5e87d099f59e359b0f6c023419b1ecda961a141baabf39b63a25f83fe03ee08336b02bb78261c525a1264bcb46a9dab54fef1`
- `23abe9c2880872e554d9cf2808d5835bfcf5f63b807f73a2871c8c87652ba2991247e11c3af924eaba9c4317708a9cfada5d5f6207acdf0ddd2e1cda352d578a`
- `524acc9d54d8b61b42f85eaa6df0beee9c29fb4c91eb4be716d14563467ab11d4312bf48d7f4d9f1d87905b5536b053d4e64f4d9c5b71a5d5c19b662a40f349f`
