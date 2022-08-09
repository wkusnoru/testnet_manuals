<p style="font-size:14px" align="right">
<a href="https://t.me/kjnotes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/fRVzvPBh" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
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
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/177323789-e6be59ae-0dfa-4e86-b3a8-028a4f0c465c.png">
</p>

# Index all projects from projects list (200 points)
1. To finish this task you will have to index Avalanche and Juno projects following same steps that we did with Polkadot here: [Fully index a project from projects list](https://github.com/kj89/testnet_manuals/blob/main/subquery/tasks/Fully_index_a_project_from_projects_list.md)

2. Before you start please make sure you have updated `subql-coordinator` to version `v0.3.6`
Check current `subql-coordinator` version
```
docker ps -f name=coordinator_service | awk '{ print $2 }'
```

![image](https://user-images.githubusercontent.com/50621007/177731886-10b555c6-531a-4ee6-ba34-ffada0da9cf9.png)

If service version is not `v0.3.6` please update it using commands:
- If you are using `docker-compose`
```
curl https://raw.githubusercontent.com/subquery/indexer-services/main/docker-compose.yml -o $HOME/subquery-indexer/docker-compose.yml
cd $HOME/subquery-indexer && docker rm -f coordinator_service && docker-compose up -d
```

- If you are using `docker compose`
```
curl https://raw.githubusercontent.com/subquery/indexer-services/main/docker-compose.yml -o $HOME/subquery-indexer/docker-compose.yml
cd $HOME/subquery-indexer && docker rm -f coordinator_service && docker compose up -d
```

## Juno Project
- DeploymentID: `QmPZrgnpCrhU3bBXvNQG8qX3VBQTyNVj7agx1hiav14imM`
- Network Endpoint: `https://rpc.juno-1.api.onfinality.io`
- Dictionary Endpoint: `https://api.subquery.network/sq/subquery/cosmos-juno-dictionary`

## Avalanche Project
- DeploymentID: `QmTXSopHWTDhei9ukMAJ1huy83jM9KnGsNEkBcpQkZUCVP`
- Network Endpoint: `http://avalanche.api.onfinality.io:9650`
- Dictionary Endpoint: `https://api.subquery.network/sq/subquery/avalanche-dictionary`

# Task Finished!

![image](https://user-images.githubusercontent.com/50621007/177988217-d5c2e51d-6035-47a8-a7d4-632e55560ba6.png)

Check progress of your tasks and points earned at [Missions Dashboard](https://frontier.subquery.network/missions/my-missions)
