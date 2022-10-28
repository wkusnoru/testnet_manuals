<p style="font-size:14px" align="right">
<a href="https://t.me/kjnotes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/JqQNcwff2e" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://kjnodes.com/" target="_blank">Visit our website <img src="https://user-images.githubusercontent.com/50621007/168689709-7e537ca6-b6b8-4adc-9bd0-186ea4ea4aed.png" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://hetzner.cloud/?ref=y8pQKS2nNy7i" target="_blank">Deploy your VPS using our referral link to get 20€ bonus <img src="https://user-images.githubusercontent.com/50621007/174612278-11716b2a-d662-487e-8085-3686278dd869.png" width="30"/></a>
</p>
<p style="font-size:14px" align="right">
<a href="https://m.do.co/c/17b61545ca3a" target="_blank">Deploy your VPS using our referral link to get 100$ free bonus for 60 days <img src="https://user-images.githubusercontent.com/50621007/183284313-adf81164-6db4-4284-9ea0-bcb841936350.png" width="30"/></a>
</p>
<p style="font-size:14px" align="right">
<a href="https://www.vultr.com/?ref=7418642" target="_blank">Deploy your VPS using our referral link to get 100$ free bonus <img src="https://user-images.githubusercontent.com/50621007/183284971-86057dc2-2009-4d40-a1d4-f0901637033a.png" width="30"/></a>
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/195559096-2a2b9816-31a0-40b2-8882-787e54e5d778.png">
</p>

# Peaq node setup for Agung Testnet

Official documentation:
- Official manual: https://pilab.notion.site/BIFROST-Incentivized-Testnet-30eb1cac14074303a01466973896d4bf
- Leaderboard and Tasks: https://testnet.thebifrost.io/
- Telemetry: https://telemetry.testnet.thebifrost.io/
- Explorer: https://explorer.testnet.thebifrost.io/

## Minimum Specifications
- 4 or more physical CPU cores
- 1TB of SSD disk storage
- 16GB of memory (RAM)
- 100mbps network bandwidth
- Ubuntu 22.04

## Required ports
No ports needed to be opened if you will be connecting to the node on localhost.
For RPC and WebSockets the following should be opened: `9933/TCP, 9944/TCP`

### Option 1 (automatic)
You can setup your Peaq full node in few minutes by using automated script below
```
wget -O bifrost.sh https://raw.githubusercontent.com/kj89/testnet_manuals/main/bifrost/bifrost.sh && chmod +x bifrost.sh && ./bifrost.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/kj89/testnet_manuals/blob/main/bifrost/manual_install.md) if you better prefer setting up node manually

## Check your node synchronization
If output is `false` your node is synchronized
```
curl -s -X POST http://localhost:9933 -H "Content-Type: application/json" --data '{"id":1, "jsonrpc":"2.0", "method": "system_health", "params":[]}' | jq .result.isSyncing
```

## Check connected peer count
```
curl -s -X POST http://localhost:9933 -H "Content-Type: application/json" --data '{"id":1, "jsonrpc":"2.0", "method": "system_health", "params":[]}' | jq .result.peers
```

## Register node
### Clone bifrost-node repository and install tools
```
cd $HOME
git clone https://github.com/bifrost-platform/bifrost-node.git
cd bifrost-node/
npm install
npm audit fix
```

### (OPTION 1) Register Basic Node
```
npm run join_validators -- \
  --controllerPrivate "0xYOUR_CONTROLLER_PRIVATE_KEY" \
  --stashPrivate "0xYOUR_STASH_PRIVATE_KEY" \
  --bond "50000"
```

### (OPTION 2) Register Full Node
```
npm run join_validators -- \
  --controllerPrivate "0xYOUR_CONTROLLER_PRIVATE_KEY" \
  --stashPrivate "0xYOUR_STASH_PRIVATE_KEY" \
  --bond "50000"
```

**Note** Add `0x` before every private key

## Run Relayer
### Install relayer software
```
git clone https://github.com/bifrost-platform/bifrost-relayer
cd bifrost-relayer
pip install -r requirements.txt
```

### Set up configuration
```
sudo tee configs/entity.relayer.private.json > /dev/null <<EOF
{
    "entity": {
      "secret_hex": "0xYOUR_RELAYER__PRIVATE_KEY"
    },
    "oracle_config": {
      "bitcoin_block_hash": {
          "name": "bitcoinblockhash",
          "url": "BITCOIN_MAINNET_RPC_ACCESS_URL",
          "auth_id": "AUTH_ID_FOR_BASIC_AUTH",
          "auth_password": "PASSWORD_FOR_BASIC_AUTH",
          "collection_period_sec": 120
        },
      "asset_prices": {
        "urls": {
          "Coingecko": "https://api.coingecko.com/api/v3/",
          "Upbit": "https://api.upbit.com/v1/",
          "Chainlink": "ETHEREUM_MAINNET_RPC_ACCESS_URL"
        }
      }
	  },
   "bifrost": {
        "url_with_access_key": "http://127.0.0.1:9933"
    },
    "ethereum": {
        "url_with_access_key": "GOERLI_TESTNET_RPC_ACCESS_URL"
    },
    "binance": {
        "url_with_access_key": "BINANCE_TESTNET_RPC_ACCESS_URL"
    },
    "polygon": {
        "url_with_access_key": "POLYGON_TESTNET_RPC_ACCESS_URL"
    }
}
EOF
```

### Register systemd service
```
sudo tee <<EOF >/dev/null /etc/systemd/system/bifrost-relayer.service
[Unit]
Description=Bifrost relayer Daemon
After=network.target
[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/bifrost-relayer
ExecStart=$(which python3) $HOME/bifrost-relayer/relayer-launcher.py launch
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

### Run bifrost-relayer service
```
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable bifrost-relayer
sudo systemctl restart bifrost-relayer
```

### Check relayer logs
```
journalctl -fu bifrost-relayer -o cat
```


## Useful commands
Check node version
```
bifrost-node --version
```

Check node status
```
sudo service bifrostd status
```

Check node logs
```
journalctl -u bifrostd -f -o cat
```

You should see something similar in the logs:
```
Jun 28 16:40:32 paeq-01 systemd[1]: Started Peaq Node.
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 PEAQ Node
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 ✌️  version 3.0.0-polkadot-v0.9.16-6f72704-x86_64-linux-gnu
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 ❤️  by bifrost network <https://github.com/bifrostnetwork>, 2021-2022
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 📋 Chain specification: agung-network
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 🏷  Node name: ro_full_node_0
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 👤 Role: FULL
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 💾 Database: RocksDb at ./chain-data/chains/agung-substrate-testnet/db/full
Jun 28 16:40:32 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:32 ⛓  Native runtime: bifrost-node-3 (bifrost-node-1.tx1.au1)
Jun 28 16:40:36 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:36 🔨 Initializing Genesis block/state (state: 0x72d3…181f, header-hash: 0xf496…909f)
Jun 28 16:40:36 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:36 👴 Loading GRANDPA authority set from genesis on what appears to be first startup.
Jun 28 16:40:40 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:40 Using default protocol ID "sup" because none is configured in the chain specs
Jun 28 16:40:40 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:40 🏷  Local node identity is: 12D3KooWD4hyKVKe3v99KJadKVVUEXKEw1HNp5d6EXpzyVFDwQtq
Jun 28 16:40:40 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:40 📦 Highest known block at #0
Jun 28 16:40:40 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:40 〽️ Prometheus exporter started at 127.0.0.1:9615
Jun 28 16:40:40 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:40 Listening for new connections on 127.0.0.1:9944.
Jun 28 16:40:40 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:40 🔍 Discovered new external address for our node: /ip4/138.201.118.10/tcp/1033/ws/p2p/12D3KooWD4hyKVKe3v99KJadKVVUEXKEw1HNp5d6EXpzyVFDwQtq
Jun 28 16:40:45 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:45 ⚙️  Syncing, target=#1180121 (13 peers), best: #3585 (0x40f3…2548), finalized #3584 (0x292b…1fee), ⬇ 386.2kiB/s ⬆ 40.1kiB/s
Jun 28 16:40:50 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:50 ⚙️  Syncing 677.6 bps, target=#1180122 (13 peers), best: #6973 (0x6d89…9f39), finalized #6656 (0xaff8…65d9), ⬇ 192.5kiB/s ⬆ 7.8kiB/s
Jun 28 16:40:55 paeq-01 bifrost-node[27357]: 2022-06-28 16:40:55 ⚙️  Syncing 494.6 bps, target=#1180123 (13 peers), best: #9446 (0xe7e2…c2d9), finalized #9216 (0x1951…dc01), ⬇ 188.7kiB/s ⬆ 5.8kiB/s
```

To delete node
```
sudo systemctl stop bifrostd
sudo systemctl disable bifrostd
sudo rm -rf /etc/systemd/system/bifrostd*
sudo rm -rf /usr/local/bin/bifrost*
sudo rm -rf /var/lib/bifrost-data
```
