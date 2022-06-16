<p style="font-size:14px" align="right">
Join our telegram <a href="https://t.me/kjnotes" target="_blank"><img src="https://user-images.githubusercontent.com/50621007/168689534-796f181e-3e4c-43a5-8183-9888fc92cfa7.png" width="30"/></a>
Visit our website <a href="https://kjnodes.com/" target="_blank"><img src="https://user-images.githubusercontent.com/50621007/168689709-7e537ca6-b6b8-4adc-9bd0-186ea4ea4aed.png" width="30"/></a>
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/172356220-b8326ceb-9950-4226-b66e-da69099aaf6e.png">
</p>

# Migrate your validator to another machine

### 1. Run a new full node on a new machine
To setup full node you can follow my guide [kujira node setup for Testnet — harpoon-3](https://github.com/kj89/testnet_manuals/blob/main/kujira/harpoon-3/README.md)

### 2. Confirm that you have the recovery seed phrase information for the active key running on the old machine

#### To backup your key
```
kujirad keys export mykey
```
> _This prints the private key that you can then paste into the file `mykey.backup`_

#### To get list of keys
```
kujirad keys list
```

### 3. Recover the active key of the old machine on the new machine

#### This can be done with the mnemonics
```
kujirad keys add mykey --recover
```

#### Or with the backup file `mykey.backup` from the previous step
```
kujirad keys import mykey mykey.backup
```

### 4. Wait for the new full node on the new machine to finish catching-up

#### To check synchronization status
```
curl -s localhost:26657/status | jq .result.sync_info
```
> _`catching_up` should be equal to `false`_

### 5. After the new node has caught-up, stop the validator node

> _To prevent double signing, you should stop the validator node before stopping the new full node to ensure the new node is at a greater block height than the validator node_
> _If the new node is behind the old validator node, then you may double-sign blocks_

#### Stop and disable service on old machine
```
sudo systemctl stop kujirad
sudo systemctl disable kujirad
```
> _The validator should start missing blocks at this point_

### 6. Stop service on new machine
```
sudo systemctl stop kujirad
```

### 7. Move the validator's private key from the old machine to the new machine
#### Private key is located in: `~/.kujirad/config/priv_validator_key.json`

> _After being copied, the key `priv_validator_key.json` should then be removed from the old node's config directory to prevent double-signing if the node were to start back up_
```
mv ~/.kujirad/config/priv_validator_key.json ~/.kujirad/bak_priv_validator_key.json
```

### 8. Start service on a new validator node
```
sudo systemctl start kujirad
```
> _The new node should start signing blocks once caught-up_

### 9. Make sure your validator is not jailed
#### To unjail your validator
```
kujirad tx slashing unjail --chain-id harpoon-3 --from mykey --gas=auto -y
```

### 10. After you ensure your validator is producing blocks and is healthy you can shut down old validator server
