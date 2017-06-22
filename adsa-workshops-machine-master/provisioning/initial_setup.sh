#!/bin/bash

echo "Installing essentials..."
sudo apt-get update
sudo apt-get install -y make

echo "Installing docker..."

sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee --append /etc/apt/sources.list.d/docker.list
sudo apt-get update
#sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get -y install docker-engine
sudo service docker start

echo "Setting up docker user group..."
sudo groupadd docker
sudo usermod -aG docker $USER
sudo su - $USER # A hack to reload user group assignments

echo "Docker installed"
docker --version

echo "Installing docker compose..."
curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > ./docker-compose
sudo mv ./docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Docker compose installed"
docker-compose --version

echo "Setting up JupytherHub..."

cd /home/$USER
cp -R /provisioning/jupyterhub-docker jupyterhub-docker
cd jupyterhub-docker

echo "Generate self-signed certificates..."
mkdir -p secrets
openssl req -nodes -newkey rsa:2048 -keyout secrets/jupyterhub.key -out secrets/jupyterhub.csr -subj "/C=US/ST=Illinois/L=Urbana/O=ADSA/OU=/CN=workhsops.adsauiuc.com"
openssl x509 -req -days 365 -in secrets/jupyterhub.csr -signkey secrets/jupyterhub.key -out secrets/jupyterhub.crt

echo "Build docker images..."
echo "valentin admin" > userlist
make build
make notebook_image
