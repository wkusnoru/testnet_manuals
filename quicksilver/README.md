<p style="font-size:14px" align="right">
Join our telegram <a href="https://t.me/kjnotes" target="_blank"><img src="https://user-images.githubusercontent.com/50621007/168689534-796f181e-3e4c-43a5-8183-9888fc92cfa7.png" width="30"/></a>
Visit our website <a href="https://kjnodes.com/" target="_blank"><img src="https://user-images.githubusercontent.com/50621007/168689709-7e537ca6-b6b8-4adc-9bd0-186ea4ea4aed.png" width="30"/></a>
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166148846-93575afe-e3ce-4ca5-a3f7-a21e8a8609cb.png">
</p>

# Quicksilver node setup for Testnet — rhapsody-5 (v0.3.0)

Official documentation:
> [Validator setup instructions](https://github.com/ingenuity-build/testnets)

## Usefull tools I have created for quicksilver
> To generate gentx for killerqueen-1 testnet please navigate to [Generate gentx for killerqueen-1 testnet](https://github.com/kj89/testnet_manuals/blob/main/quicksilver/gentx/README.md)
>
> To set up monitoring for your validator node navigate to [Set up monitoring and alerting for quicksilver validator](https://github.com/kj89/testnet_manuals/blob/main/quicksilver/monitoring/README.md)
>
> To migrate your valitorator to another machine read [Migrate your validator to another machine](https://github.com/kj89/testnet_manuals/blob/main/quicksilver/migrate_validator.md)

## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 40GB Disk (we are using statesync, so disk requirements are low)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your quicksilver fullnode
### Option 1 (automatic)
You can setup your quicksilver fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O quicksilver_testnet.sh https://raw.githubusercontent.com/kj89/testnet_manuals/main/quicksilver/quicksilver_testnet.sh && chmod +x quicksilver_testnet.sh && ./quicksilver_testnet.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/kj89/testnet_manuals/blob/main/quicksilver/manual_install.md) if you better prefer setting up node manually

### Post installation
When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
quicksilverd status 2>&1 | jq .SyncInfo
```

To check logs
```
journalctl -u quicksilverd -f -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
quicksilverd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
quicksilverd keys add $WALLET --recover
```

To get current list of wallets
```
quicksilverd keys list
```

### Save wallet info
Add wallet address
```
WALLET_ADDRESS=$(quicksilverd keys show $WALLET -a)
```

Add valoper address
```
VALOPER_ADDRESS=$(quicksilverd keys show $WALLET --bech val -a)
```

Load variables into system
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
To top up your wallet join Quicksilver discord server to access the faucets for QCK and ATOM. Make sure you are in the appropriate channel
- **#qck-tap** for QCK tokens
- **#atom-tap** for ATOM tokens

To check the faucet address:
```
$<YOUR_WALLET_ADDRESS> rhapsody
```

To check your balance:
```
$balance <YOUR_WALLET_ADDRESS> rhapsody
```

To request a faucet grant:
```
$request <YOUR_WALLET_ADDRESS> rhapsody
```

### Create validator
Before creating validator please make sure that you have at least 1 qck (1 qck is equal to 1000000 uqck) and your node is synchronized

To check your wallet balance:
```
quicksilverd query bank balances $WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
quicksilverd tx staking create-validator \
  --amount 5000000uqck \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $CHAIN_ID
```

### Get list of validators
```
quicksilverd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Get currently connected peer list with ids
```
curl -sS http://localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Security
To protect you keys please make sure you follow basic security rules

### Set up ssh keys for authentication
Good tutorial on how to set up ssh keys for authentication to your server can be found [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Basic Firewall security
Start by checking the status of ufw.
```
sudo ufw status
```

Sets the default to allow outgoing connections, deny all incoming except ssh and 26656. Limit SSH login attempts
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 26656,26660/tcp
sudo ufw enable
```

## Monitoring
To monitor and get alerted about your validator health status you can use my guide on [Set up monitoring and alerting for quicksilver validator](https://github.com/kj89/testnet_manuals/blob/main/quicksilver/monitoring/README.md)

## Usefull commands
### Service management
Check logs
```
journalctl -fu quicksilverd -o cat
```

Start service
```
systemctl start quicksilverd
```

Stop service
```
systemctl stop quicksilverd
```

Restart service
```
systemctl restart quicksilverd
```

### Node info
Synchronization info
```
quicksilverd status 2>&1 | jq .SyncInfo
```

Validator info
```
quicksilverd status 2>&1 | jq .ValidatorInfo
```

Node info
```
quicksilverd status 2>&1 | jq .NodeInfo
```

Show node id
```
quicksilverd tendermint show-node-id
```

### Wallet operations
List of wallets
```
quicksilverd keys list
```

Recover wallet
```
quicksilverd keys add $WALLET --recover
```

Delete wallet
```
quicksilverd keys delete $WALLET
```

Get wallet balance
```
quicksilverd query bank balances $WALLET_ADDRESS
```

Transfer funds
```
quicksilverd tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uqck
```

### Staking, Delegation and Rewards
Delegate stake
```
quicksilverd tx staking delegate $VALOPER_ADDRESS 10000000uqck --from=$WALLET --chain-id=$CHAIN_ID --gas=auto --gas-adjustment 1.4
```

Redelegate stake from validator to another validator
```
quicksilverd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uqck --from=$WALLET --chain-id=$CHAIN_ID --gas=auto --gas-adjustment 1.4
```

Withdraw all rewards
```
quicksilverd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto --gas-adjustment 1.4
```

Withdraw rewards with commision
```
quicksilverd tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
```

### Validator management
Edit validator
```
quicksilverd tx staking edit-validator \
--moniker=$NODENAME \
--identity=1C5ACD2EEF363C3A \
--website="http://kjnodes.com" \
--details="Providing professional staking services with high performance and availability. Find me at Discord: kjnodes#8455 and Telegram: @kjnodes" \
--chain-id=$CHAIN_ID \
--from=$WALLET
```

Unjail validator
```
quicksilverd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto --gas-adjustment 1.4
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
systemctl stop quicksilverd
systemctl disable quicksilverd
rm /etc/systemd/system/quicksilver* -rf
rm $(which quicksilverd) -rf
rm $HOME/.quicksilver* -rf
rm $HOME/quicksilver -rf
```
