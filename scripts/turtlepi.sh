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
sudo apt install -y build-essential python-dev cron gcc g++ git cmake libboost-all-dev curl nano nginx unzip screen
# Installation of Nodejs and NPM
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
#install php 7.2 for the web wallet
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt-get install -y ca-certificates apt-transport-https
sudo apt update
sudo apt-get install -y composer php7.2 php-fpm php-mcrypt php-cli php-gd php-imagick php-recode php-tidy php-xmlrpc
# Grab the latest release of TurtleCoin from github and extract it
wget https://github.com/turtlecoin/turtlecoin/releases/download/v0.8.3/turtlecoin-v0.8.3-aarch64.tar.gz
tar xvf turtlecoin-v0.8.3-aarch64.tar.gz
cd turtlecoin-v0.8.3
mv zedwallet turtle-service /home/pi/
# Now set up the web wallet
cd /home/pi
git clone https://github.com/crappyrules/turtlecoin-php-rpc-wallet.git
cd turtlecoin-php-rpc-wallet
composer require chillerlan/php-qrcode turtlecoin/turtlecoin-walletd-rpc-php
sudo rm -rf /var/www/html
sudo ln -s /home/pi/turtlecoin-php-rpc-wallet /var/www/html
cd /home/pi
#setup nginx for usage with php
sudo rm -rf /etc/nginx/sites-available/default
wget https://github.com/turtlecoin/turtlepi/raw/master/scripts/sites-available/default
sudo mv default /etc/nginx/sites-available
sudo service nginx restart
./turtle-service -g -w mywallet -p changeme
screen -d -m -S turtlewallet bash -c './turtle-service -w mywallet -p changeme --rpc-password test --bind-port 8070 --bind-address 0.0.0.0 --daemon-address shitfunnel.shitcoin.works --daemon-port 11898'
wget https://github.com/turtlecoin/turtlepi/raw/master/scripts/crontabs/pi
crontab -u pi pi
rm pi turtlepi.sh
wget https://github.com/turtlecoin/turtlepi/raw/master/scripts/turtlepi2.sh
chmod +x /home/pi/turtlepi2.sh
echo "TurtleCoin is now installed and ready!  Open a browser and navigate to the IP address of this device to use your wallet!"
