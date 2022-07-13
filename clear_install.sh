#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.12.0/massa_TEST.12.0_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
reap -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ massa_password=/d" $HOME/.bash_profile
echo 'export massa_password="$passwd"' >> $HOME/.bash_profile
