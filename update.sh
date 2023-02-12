#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
rm -rf backup
mkdir backup
cp /mnt/data/massa/massa-node/config/node_privkey.key /mnt/data/backup/node_privkey.key
cp /mnt/data/massa/massa-client/wallet.dat /mnt/data/backup/wallet.dat
systemctl stop massad
rm -rf massa
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.19.3/massa_TEST.19.3_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x /mnt/data/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
read -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ passwd=/d" $HOME/.bash_profile
echo "export passwd=\"${passwd}\"" >> $HOME/.bash_profile
cp /mnt/data/backup/node_privkey.key /mnt/data/massa/massa-node/config/node_privkey.key
cp /mnt/data/backup/wallet.dat /mnt/data/massa/massa-client/wallet.dat
sudo systemctl daemon-reload
sudo systemctl enable massad
sudo systemctl restart massad
sleep 10
cd massa/massa-client
./massa-client -p $passwd node_get_staking_addresses
