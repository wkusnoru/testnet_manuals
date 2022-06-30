<p style="font-size:14px" align="right">
<a href="https://kjnodes.com/" target="_blank">Visit our website <img src="https://user-images.githubusercontent.com/50621007/168689709-7e537ca6-b6b8-4adc-9bd0-186ea4ea4aed.png" width="30"/></a>
<a href="https://discord.gg/EY35ZzXY" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://kjnodes.com/" target="_blank">Visit our website <img src="https://user-images.githubusercontent.com/50621007/168689709-7e537ca6-b6b8-4adc-9bd0-186ea4ea4aed.png" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://hetzner.cloud/?ref=y8pQKS2nNy7i" target="_blank">Deploy your VPS using our referral link to get 20€ bonus <img src="https://user-images.githubusercontent.com/50621007/174612278-11716b2a-d662-487e-8085-3686278dd869.png" width="30"/></a>
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166148846-93575afe-e3ce-4ca5-a3f7-a21e8a8609cb.png">
</p>

# Manual node setup
If you want to setup fullnode manually follow the steps below

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
QUICKSILVER_PORT=11
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export QUICKSILVER_CHAIN_ID=rhapsody-5" >> $HOME/.bash_profile
echo "export QUICKSILVER_PORT=${QUICKSILVER_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux -y
```

## Install go
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Download and build binaries
```
cd $HOME
git clone https://github.com/ingenuity-build/quicksilver.git --branch v0.3.0
cd quicksilver
make build
sudo chmod +x ./build/quicksilverd && sudo mv ./build/quicksilverd /usr/local/bin/quicksilverd
```

## Config app
```
quicksilverd config chain-id $QUICKSILVER_CHAIN_ID
quicksilverd config keyring-backend test
quicksilverd config node tcp://localhost:${QUICKSILVER_PORT}657
```

## Init app
```
quicksilverd init $NODENAME --chain-id $QUICKSILVER_CHAIN_ID
```

## Download genesis and addrbook
```
wget -qO $HOME/.quicksilverd/config/genesis.json "https://raw.githubusercontent.com/ingenuity-build/testnets/main/rhapsody/genesis.json"
```

## Set seeds and peers
```
SEEDS="dd3460ec11f78b4a7c4336f22a356fe00805ab64@seed.rhapsody-5.quicksilver.zone:26656"
PEERS="34f41f51e38880a0b33f57cac516e4d57a96f08c@162.55.220.93:26656,9428068507466b542cbf378d59b77746c1d19a34@157.90.35.151:26657,13b082e74dd7bc69227eccb8f58b6602c116b8d6@161.35.238.227:36366,eaeb462547cf76c3588e458120097b51db732b14@194.163.155.84:26656,00bba3aad11c7d1bc8a4f1ac9a05b48edb7cf04c@144.76.67.53:2390,0e5f74c20ec3e90facdb4e4a5d20c21e01998345@65.108.204.119:26656,43bca26cb1b2e7474a8ffa560f210494023d5de4@135.181.140.225:26657,3866a02aaf84f08430f67a7e90b1a61a5f9cef00@207.154.227.78:36366,1999a4a804a1946ab10def5c71eec02415bda479@161.97.82.203:26256,4742e1b942acf17c31794cce80d199886d172c4f@135.181.133.37:31656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml
```

## Set custom ports
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${QUICKSILVER_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${QUICKSILVER_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${QUICKSILVER_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${QUICKSILVER_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${QUICKSILVER_PORT}660\"%" $HOME/.quicksilverd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${QUICKSILVER_PORT}317\"%; s%^address = \":8080\"%address = \":${QUICKSILVER_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${QUICKSILVER_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${QUICKSILVER_PORT}091\"%" $HOME/.quicksilverd/config/app.toml
```

## Disable indexing
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.quicksilverd/config/config.toml
```

## Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.quicksilverd/config/app.toml
```

## Set minimum gas price
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uqck\"/" $HOME/.quicksilverd/config/app.toml
```

## Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.quicksilverd/config/config.toml
```

## Reset chain data
```
quicksilverd tendermint unsafe-reset-all --home $HOME/.quicksilverd
```

## Create service
```
sudo tee /etc/systemd/system/quicksilverd.service > /dev/null <<EOF
[Unit]
Description=quicksilver
After=network-online.target

[Service]
User=$USER
ExecStart=$(which quicksilverd) start --home $HOME/.quicksilverd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable quicksilverd
sudo systemctl restart quicksilverd && sudo journalctl -u quicksilverd -f -o cat
```
