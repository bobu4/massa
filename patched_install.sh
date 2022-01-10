!#bin/bash
systemctl stop massad
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
mkdir backup
cp $HOME/massa/massa-node/config/node_privkey.key $HOME/backup/node_privkey.key
cp $HOME/massa/massa-client/wallet.dat $HOME/backup/wallet.dat
rm -rf massa
wget -qO massa.zip https://github.com/massalabs/massa/releases/download/TEST.6.5/release_linux.zip
unzip $HOME/massa.zip -d $HOME/massa/
rm -rf massa.zip
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
cp /root/backup/node_privkey.key $HOME/massa/massa-node/config
cp /root/backup/wallet.dat $HOME/massa/massa-client
rm -rf backup
sudo systemctl start massad
cd massa/massa-client
./massa-client node_add_staking_private_keys $(./massa-client wallet_info | grep 'Private key' | cut -d\    -f3) ; ./massa-client node_get_staking_addresses
read -p 'Enter discord id, obtained in massa bot: ' discord
./massa-client node_testnet_rewards_program_ownership_proof $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) $discord
./massa-client buy_rolls $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) 1 0
./massa-client wallet_info
cd
