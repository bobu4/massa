#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
mkdir backup
cp $HOME/massa/massa-node/config/node_privkey.key /root/backup/node_privkey.key
cp $HOME/massa/massa-client/wallet.dat /root/backup/wallet.dat
systemctl stop massad
rm -rf massa
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.17.1/massa_TEST.17.1_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
read -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ passwd=/d" $HOME/.bash_profile
echo "export passwd=\"${passwd}\"" >> $HOME/.bash_profile
cp /root/backup/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key
cp /root/backup/wallet.dat $HOME/massa/massa-client/wallet.dat
sudo systemctl daemon-reload
sudo systemctl enable massad
sudo systemctl restart massad
sleep 10
cd massa/massa-client
./massa-client -p $passwd node_add_staking_secret_keys $(./massa-client -p $passwd wallet_info | grep 'Secret key' | cut -d\   -f3) ; ./massa-client -p $passwd node_get_staking_addresses
read -p 'Enter discord id, obtained in massa bot: ' discord
signature=$(./massa-client -p $passwd node_testnet_rewards_program_ownership_proof $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) $discord)
./massa-client -p $passwd buy_rolls $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) 1 0
echo $signature
