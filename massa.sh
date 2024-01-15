#!/usr/bin/env bash

sudo apt update && sudo apt upgrade -y
sudo apt install pkg-config curl git build-essential libssl-dev libclang-dev cmake -y
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/MAIN.2.0/massa_MAIN.2.0_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
cd massa/massa-client ; ./massa-client
