#!/usr/bin/env bash

############################################
#
# Script to install Docker & Docker Compose
#
############################################

echo -e "\e[1mRunning the script to install Docker & Docker Compose"
sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt-cache policy docker-ce
sudo apt install -y docker-ce
sudo curl -L https://github.com/docker/compose/releases/download/1.27.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
sudo systemctl status docker
sudo usermod -aG docker ${USER}
echo
echo
echo -e "Installation successful, exiting the session. \e[1;4mPlease login again to use Docker & Docker Compose"
echo "Press any key to continue"
sleep 5
kill -SIGUSR1 `ps --pid $$ -oppid=`; exit
