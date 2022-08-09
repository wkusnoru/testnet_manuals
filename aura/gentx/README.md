<p style="font-size:14px" align="right">
<a href="https://t.me/kjnotes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/168689534-796f181e-3e4c-43a5-8183-9888fc92cfa7.png" width="30"/></a>
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
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/177979901-4ac785e2-08c3-4d61-83df-b451a2ed9e68.png">
</p>

# Generate Aura Euphoria Testnet Gentx

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=euphoria-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt-get install make build-essential gcc git jq chrony -y
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
```

## Download and install binaries
```
git clone https://github.com/aura-nw/aura && cd aura
git checkout euphoria
make install
```

## Config app
```
aurad config chain-id $CHAIN_ID
aurad config keyring-backend test
```

## Init node
```
aurad init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for Euphoria Testnet
Option 1 - generate new wallet
```
aurad keys add $WALLET
```

Option 2 - recover existing wallet
```
aurad keys add $WALLET --recover
```

## Add genesis account
```
WALLET_ADDRESS=$(aurad keys show $WALLET -a)
aurad add-genesis-account $WALLET_ADDRESS 3600000000ueaura
```

## Generate gentx
```
aurad gentx $WALLET 3600000000ueaura \
--chain-id $CHAIN_ID \
--moniker=$NODENAME \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--details="<your_validator_description>" \
--security-contact="<your_email>" \
--website="<your_website>"
```

## Things you have to backup
- `12 word mnemonic` of your generated wallet
- contents of `$HOME/.aura/config/*`

## Submit PR with Gentx
1. Copy the contents of `$HOME/.aura/config/gentx/gentx-XXXXXXXX.json`
2. Fork https://github.com/aura-nw/testnets
3. Create a file `gentx-{VALIDATOR_NAME}.json` under the `testnets/euphoria-1/gentx` folder in the forked repo, paste the copied text into the file.
4. Upload your logo file into `{VALOPER_ADDRESS}.png` under the `testnets/euphoria-1/logo` folder.
5. Create a Pull Request to the main branch of the repository

### Await further instructions!
