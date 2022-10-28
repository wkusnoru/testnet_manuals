#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
BLOCK=182500
VERSION=v0.1.1
echo -e "$GREEN_COLOR YOUR NODE WILL BE UPDATED TO VERSION: $VERSION ON BLOCK NUMBER: $BLOCK $NO_COLOR\n"
for((;;)); do
	height=$(hid-noded status |& jq -r ."SyncInfo"."latest_block_height")
	if ((height>=$BLOCK)); then

		sudo systemctl stop hid-noded
		cd $HOME && rm -rf core
		git clone https://github.com/hypersign-protocol/hid-node.git
		cd hid-node
		git checkout $VERSION
		make install
		sudo systemctl restart hid-noded && journalctl -fu hid-noded -o cat

		for (( timer=60; timer>0; timer-- )); do
			printf "* second restart after sleep for ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
			sleep 1
		done
		height=$(hid-noded status |& jq -r ."SyncInfo"."latest_block_height")
		if ((height>$BLOCK)); then
			echo -e "$GREEN_COLOR YOUR NODE WAS SUCCESFULLY UPDATED TO VERSION: $VERSION $NO_COLOR\n"
		fi
		hid-noded version --long | head
		break
	else
		echo -e "${GREEN_COLOR}$height${NO_COLOR} ($(( BLOCK - height  )) blocks left)"
	fi
	sleep 5
done
