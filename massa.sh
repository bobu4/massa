#!/usr/bin/env bash
function install {
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
cd path
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.20.0/massa_TEST.20.0_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $path/massa/massa-node/massa-node $path/massa/massa-client/massa-client
read -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ passwd=/d" $HOME/.bash_profile
echo "export passwd=\"${passwd}\"" >> $HOME/.bash_profile
sudo tee <<EOF >/dev/null /etc/systemd/system/massad.service
[Unit]
Description=Massa Node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable massad
sudo systemctl daemon-reload
sudo systemctl restart massad
cd massa/massa-client
sleep 10
./massa-client -p $passwd wallet_generate_secret_key
./massa-client -p $passwd node_start_staking $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) ; ./massa-client -p $passwd node_get_staking_addresses
read -p 'Enter discord id, obtained in massa bot: ' discord
signature=$(./massa-client -p $passwd node_testnet_rewards_program_ownership_proof $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) $discord)
./massa-client -p $passwd buy_rolls $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) 1 0
echo $signature
}
function update {
systemctl stop massad
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
cd path
mkdir backup
cp $path/massa/massa-node/config/node_privkey.key $path/backup/node_privkey.key
cp $path/massa/massa-client/wallet.dat $path/backup/wallet.dat
rm -rf massa
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.11.3/massa_TEST.11.3_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
cp /root/backup/node_privkey.key $HOME/massa/massa-node/config
cp /root/backup/wallet.dat $HOME/massa/massa-client
rm -rf backup
sudo systemctl start massad
cd massa/massa-client
sleep 10
#./massa-client node_add_staking_private_keys $(./massa-client wallet_info | grep 'Private key' | cut -d\    -f3) ; ./massa-client node_get_staking_addresses
#read -p 'Enter discord id, obtained in massa bot: ' discord
#signature=$(./massa-client node_testnet_rewards_program_ownership_proof $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) $discord)
#./massa-client buy_rolls $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) 1 0
./massa-client wallet_info
cd
#echo $signature
}
read -s 'Enter path to install massa: ' path
read -p 'Enter 1 for clear install with backup or 2 to update: ' choice
if [ $choice -eq "1" ]; then
install
elif [ $choice -eq "2" ]; then
update
fi
