

@Node1

besu --data-path=data --genesis-file=../genesis.json --permissions-nodes-config-file-enabled --permissions-accounts-config-file-enabled --rpc-http-enabled --rpc-http-api=ADMIN,ETH,NET,PERM,IBFT --rpc-http-host=0.0.0.0 --rpc-http-port=8545 --host-allowlist="*" --rpc-http-cors-origins="*" --profile=ENTERPRISE

@Node 2 

besu --data-path=data --genesis-file=../genesis.json --permissions-nodes-config-file-enabled --permissions-accounts-config-file-enabled --rpc-http-enabled --rpc-http-api=ADMIN,ETH,NET,PERM,IBFT --host-allowlist="*" --rpc-http-cors-origins="*" --p2p-port=30304 --rpc-http-port=8546 --profile=ENTERPRISE


@Node3
besu --data-path=data --genesis-file=../genesis.json --permissions-nodes-config-file-enabled --permissions-accounts-config-file-enabled --rpc-http-enabled --rpc-http-api=ADMIN,ETH,NET,PERM,IBFT --host-allowlist="*" --rpc-http-cors-origins="*" --p2p-port=30305 --rpc-http-port=8547 --profile=ENTERPRISE



@Node4
besu --data-path=data --genesis-file=../genesis.json --permissions-nodes-config-file-enabled --permissions-accounts-config-file-enabled --rpc-http-enabled --rpc-http-api=ADMIN,ETH,NET,PERM,IBFT --host-allowlist="*" --rpc-http-cors-origins="*" --p2p-port=30306 --rpc-http-port=8548 --profile=ENTERPRISE



Adding peer nodes 

@Node1

curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["enode://39324ce53375bd38c8097375cc0504b09f7bb1fbd039f29dea16cc2e12e05cc98d5d5bfcb70004b0324fd9a1c9d4af6c71de216999deb4482cb97af119f22acc@127.0.0.1:30303"],"id":1}' http://127.0.0.1:8546


@Node3

curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["enode://39324ce53375bd38c8097375cc0504b09f7bb1fbd039f29dea16cc2e12e05cc98d5d5bfcb70004b0324fd9a1c9d4af6c71de216999deb4482cb97af119f22acc@127.0.0.1:30303"],"id":1}' http://127.0.0.1:8547

curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["enode://9e316c7015626a7d0c60d7c5f6b5e87d099f59e359b0f6c023419b1ecda961a141baabf39b63a25f83fe03ee08336b02bb78261c525a1264bcb46a9dab54fef1@127.0.0.1:30304"],"id":1}' http://127.0.0.1:8547



@Node 4 
curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["enode://39324ce53375bd38c8097375cc0504b09f7bb1fbd039f29dea16cc2e12e05cc98d5d5bfcb70004b0324fd9a1c9d4af6c71de216999deb4482cb97af119f22acc@127.0.0.1:30303"],"id":1}' http://127.0.0.1:8548

curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["enode://9e316c7015626a7d0c60d7c5f6b5e87d099f59e359b0f6c023419b1ecda961a141baabf39b63a25f83fe03ee08336b02bb78261c525a1264bcb46a9dab54fef1@127.0.0.1:30304"],"id":1}' http://127.0.0.1:8548

 curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["enode://23abe9c2880872e554d9cf2808d5835bfcf5f63b807f73a2871c8c87652ba2991247e11c3af924eaba9c4317708a9cfada5d5f6207acdf0ddd2e1cda352d578a@127.0.0.1:30305"],"id":1}' http://127.0.0.1:8548







enode 1 : enode://39324ce53375bd38c8097375cc0504b09f7bb1fbd039f29dea16cc2e12e05cc98d5d5bfcb70004b0324fd9a1c9d4af6c71de216999deb4482cb97af119f22acc@127.0.0.1:30303

enode 2 : 

enode://9e316c7015626a7d0c60d7c5f6b5e87d099f59e359b0f6c023419b1ecda961a141baabf39b63a25f83fe03ee08336b02bb78261c525a1264bcb46a9dab54fef1@127.0.0.1:30304


enode 3 :
enode://23abe9c2880872e554d9cf2808d5835bfcf5f63b807f73a2871c8c87652ba2991247e11c3af924eaba9c4317708a9cfada5d5f6207acdf0ddd2e1cda352d578a@127.0.0.1:30305
 
enode 4 :
enode://524acc9d54d8b61b42f85eaa6df0beee9c29fb4c91eb4be716d14563467ab11d4312bf48d7f4d9f1d87905b5536b053d4e64f4d9c5b71a5d5c19b662a40f349f@127.0.0.1:30306




cd blockscout 

docker compose up -d 