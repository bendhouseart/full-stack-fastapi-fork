#!/usr/bin/env bash
logfile=/home/ubuntu/did_user_data_run.txt
sudo apt-get update -y >>$logfile 2>&1
# get an install docker and curl
sudo apt-get install curl lvm2 >>$logfile 2>&1
# installing docker.io separately is it failed when included in the above command.
echo "installing docker using apt install docker.io"
sudo apt install docker.io -y >>$logfile 2>&1
# start docker service
sudo systemctl start docker >>$logfile 2>&1
sudo systemctl enable docker >>$logfile 2>&1

# install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >>$logfile 2>&1
sudo chmod +x /usr/local/bin/docker-compose >>$logfile 2>&1
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose  >>$logfile 2>&1

echo "User data ran." >> $logfile 2>&1
pushd "/home/ubuntu/deployments/base-project"
docker-compose up



