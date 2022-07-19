#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELAY=300 #Delay time in seconds
for (( ;; )); do
        JAIL=$(teritorid q staking validator $(teritorid keys show ${WALLET} --bech val -a) | grep jailed:);
        if [[ ${JAIL} == *"false"* ]]; then
            echo -e "${GREEN}${JAIL} \n"
        else
            echo -e "${GREEN}${JAIL} \n"
            echo -e $(teritorid tx slashing unjail --chain-id ${TERITORI_CHAIN_ID} --from ${WALLET} --gas=auto --fees=1000$utori -y) \n;
            sleep 1
        fi
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
