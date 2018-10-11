#!/bin/bash
# This script will install all needed dependencies to run your Turtlepi if you did not use the precompiled image.
# Update apt
sudo apt update
# Now we set up 2gb of swap space to ensure we do not run out of memory while compiling or running the daemon under normal load.
sudo apt install -y dphys-swapfile
# Set size of swap file and setup swapfile
sudo su -c 'echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile'
sudo dphys-swapfile setup
# Then we enable the new swapfile
sudo dphys-swapfile swapon
# These are the dependencies to run the daemon, wallets and a few other necesseties thrown in for good measure
sudo apt install -y build-essential python-dev gcc g++ git cmake libboost-all-dev curl wget nano nginx
# Installation of Nodejs and NPM
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
#install php 7.2 for the web wallet
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt-get install -y ca-certificates apt-transport-https
sudo apt update
sudo apt-get install -y php-fpm php-mcrypt php-cli php-mysql php-gd php-imagick php-recode php-tidy php-xmlrpc
# Grab the latest release of TurtleCoin from github and extract it
wget https://github.com/turtlecoin/turtlecoin/releases/download/v0.8.3/turtlecoin-v0.8.3-aarch64.tar.gz
tar xvf turtlecoin-v0.8.3-aarch64.tar.gz
cd turtlecoin-v0.8.3
mv zedwallet turtle-service /home/pi/
echo "TurtleCoin is now installed and ready!"